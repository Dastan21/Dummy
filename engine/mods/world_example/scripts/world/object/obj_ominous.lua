--- @class WorldExample.Object.Ominous : Dummy.Object
local OminousObject = Class(Object, "WorldExample.Object.Ominous")

OminousObject.ALLOW_EDITOR = true

--- Creates an ominous oject
--- @param x number
--- @param y number
function OminousObject:new(x, y)
  self = Class:new(OminousObject)

  self:setCanInteract(true)
  self:setPosition(x, y)
  self:setHitbox(0, 0, 20, 20)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)

  return self
end

--- Called when the readable is interacted by the player
function OminousObject:onInteract()
  Assets.playSound("ominous")

  World.playDialogue({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_OMINOUS_USE" })
end

return OminousObject
