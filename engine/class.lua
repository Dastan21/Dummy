--- @class Dummy.Class
---
--- @field private __extend Dummy.Class
--- @field private __classname string
--- @field private __address string
local Class = {}

--- Extends a class
--- @generic T : Dummy.Class
--- @param extend? T|string the class to extend
--- @param name? string the class name
--- @return T
function Class:extend(extend, name)
  assert(extend ~= nil, "Cannot extend a class with nil")
  if type(extend) == "string" then
    name = extend
    extend = nil
  end

  local c = {}
  if type(extend) == "table" then
    for k, v in pairs(extend) do c[k] = v end
  end
  c.__extend = extend
  c.__classname = name
  c.__address = tostring(c):sub(8)
  return c
end

--- Creates a new instance of a class
--- @generic T : Dummy.Class
--- @param c T the class to instantiate
--- @param p? any[] the data to pass to the parent constructor
--- @return T
function Class:new(c, p)
  local o = {}
  ---@diagnostic disable-next-line: inject-field
  c.__address = tostring(o):sub(8)
  ---@diagnostic disable-next-line: undefined-field
  if c.__extend ~= nil then o = c.__extend:new(table.unpack(p or {})) end
  for k, v in pairs(c) do o[k] = v end
  setmetatable(o, {
    __index = self,
    __tostring = function(t)
      return (t.__classname or "Dummy.Class") .. ": " .. t.__address
    end
  })
  return o
end

--- Checks wether a class is an instance of another class
--- @generic T : Dummy.Class
--- @param c T the class to check
--- @return boolean
function Class:is(c)
  local s = self
  while s ~= nil do
    ---@diagnostic disable-next-line: undefined-field
    if s.__classname == c.__classname then return true end
    s = s.__extend
  end
  return false
end

--- Gets the class name
--- @return string
function Class:getClassName()
  return self.__classname
end

setmetatable(Class, { __call = Class.extend })

return Class
