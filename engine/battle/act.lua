--- @class Dummy.Battle.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected enemy Dummy.Battle.Enemy
local ACT = Class("Dummy.ACT")

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName()
  return self.name
end

--- Gets the enemy the ACT is from
--- @return Dummy.Battle.Enemy
function ACT:getEnemy()
  return self.enemy
end

--- Does the ACT
function ACT:use()
  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called when the ACT is used
function ACT:onUse() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.Battle.ACT
function ACT:new(name)
  self = Class:new(ACT)
  self.name = name

  return self
end

return ACT
