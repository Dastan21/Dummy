--- @class Dummy.Class
---
--- @field private __extend Dummy.Class
--- @field protected super Dummy.Class
local Class = {}

--- Extends a class
--- @generic T : Dummy.Class
--- @param extend? T the class to extend
--- @return T
function Class:extend(extend)
  local c = {}
  if type(extend) == "table" then
    for k, v in pairs(extend) do c[k] = v end
  end
  c.__extend = extend
  return c
end

--- Creates a new instance of a class
--- @generic T : Dummy.Class
--- @param c T the class to instantiate
--- @param d? any[] the data to pass to the constructor
--- @param p? any[] the data to pass to the parent constructor
--- @return T
function Class:new(c, d, p)
  local o = {}
  ---@diagnostic disable-next-line: undefined-field
  if c.__extend ~= nil then o = c.__extend:new(table.unpack(p or {})) end
  c.super = o
  for k, v in pairs(c) do o[k] = v end
  for k, v in pairs(d or {}) do o[k] = v end
  setmetatable(o, { __index = self })
  return o
end

setmetatable(Class, { __call = function(_) return Class:extend() end })

return Class
