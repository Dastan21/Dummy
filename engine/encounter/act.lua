--- @class Dummy.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
local ACT = Class()

--- Gets the class name
--- @return string
function ACT:getClass()
  return "Dummy.ACT"
end

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName()
  return self.name
end

--- Called when the ACT is used
function ACT:use() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.ACT
function ACT:new(name)
  return Class:new(ACT, {
    name = name
  })
end

return ACT
