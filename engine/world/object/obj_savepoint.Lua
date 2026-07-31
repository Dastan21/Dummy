--- @class WorldExample.Object.Savepoint : Dummy.Object.NPC
---
--- @field protected texts Dummy.Text.Text[]
local SavepointObject = Class(NPCObject, "WorldExample.Object.Savepoint")

--- Creates a savepoint
--- @param x number
--- @param y number
--- @param text Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
function SavepointObject:new(x, y, text, ...)
  self = Class:new(SavepointObject, { "savepoint" })

  self:setSprite({
    "world/object/savepoint_1",
    "world/object/savepoint_2"
  }, 6 / 30)
  self:setPosition(x, y)
  self:setHitbox(0, 10, 20, 10)

  self.texts = { text, ... }

  return self
end

--- Called when the savepoint is interacted by the player
function SavepointObject:onInteract()
  Soul.heal(Player.getMaxHP(), true)

  local sound = Assets.playSound("power")
  sound:setVolume(0.88)

  World.playDialogue(self.texts, function()
    World.openSaveMenu()
  end)
end

return SavepointObject
