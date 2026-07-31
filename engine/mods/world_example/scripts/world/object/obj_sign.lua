--- @class WorldExample.Object.Sign : Dummy.Object.NPC
local SignObject = Class(NPCObject, "WorldExample.Object.NPC.Sign")

--- Creates a sign NPC
--- @param x number
--- @param y number
function SignObject:new(x, y)
  self = Class:new(SignObject, { "sign" })

  self:setSprite("world/object/sign")
  self:setPosition(x, y)
  self:setHitbox(0, 5, 20, 15)

  return self
end

--- Called when the sign is interacted by the player
function SignObject:onInteract()
  World.playDialogue({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SIGN_TEXT_1" })
end

return SignObject
