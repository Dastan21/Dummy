--- @class WorldExample.Object.RuinsDoor : Dummy.Object
---
--- @field protected open boolean
local RuinsDoorObject = Class(Object, "WorldExample.Object.RuinsDoor")

RuinsDoorObject.ALLOW_EDITOR = true

RuinsDoorObject.EDITOR_SPRITE = "world/object/ruins_door"

--- Creates a ruins door
--- @param x number
--- @param y number
function RuinsDoorObject:new(x, y)
  self = Class:new(RuinsDoorObject)

  self:setSprite("world/object/ruins_door")
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setPosition(x, y)
  self:setHitbox(0, 40, 40, 20)

  if WorldExampleMod.flag["dummy_battle"] == 2 then
    self:remove()
    return
  end

  return self
end

return RuinsDoorObject
