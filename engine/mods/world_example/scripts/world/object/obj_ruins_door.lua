--- @class WorldExample.Object.RuinsDoor : Dummy.Object
---
--- @field protected open boolean
local RuinsDoorObject = Class(Object, "WorldExample.Object.RuinsDoor")

--- Creates a ruins door
--- @param x number
--- @param y number
function RuinsDoorObject:new(x, y)
  self = Class:new(RuinsDoorObject)

  self:setSprite("world/object/ruins_door")
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setOrigin(0, 0)
  self:setPosition(x, y)
  self:setHitbox(0, 40, 40, 20)

  return self
end

return RuinsDoorObject
