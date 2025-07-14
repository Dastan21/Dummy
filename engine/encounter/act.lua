--- @class Dummy.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected enemy Dummy.Enemy
local ACT = Class()

--- Gets the class name
--- @return string
function ACT.getClassName()
  return "Dummy.ACT"
end

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName()
  return self.name
end

--- Gets the enemy the ACT is from
--- @return Dummy.Enemy
function ACT:getEnemy()
  return self.enemy
end

--- Does the ACT
function ACT:use()
  self:onUse()
end

--- Called when the ACT is used
function ACT:onUse() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.ACT
function ACT:new(name)
  self = Class:new(ACT)
  self.name = name

  return self
end

return ACT
