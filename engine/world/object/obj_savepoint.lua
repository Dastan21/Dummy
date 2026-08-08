--- @class Dummy.Object.Savepoint.Data : Dummy.Object.Data
---
--- @field texts string[]

--- @class WorldExample.Object.Savepoint : Dummy.Object.NPC
---
--- @field protected texts Dummy.Text.Text[]
local SavepointObject = Class(NPCObject, "WorldExample.Object.Savepoint")

SavepointObject.ALLOW_EDITOR = true

-- sprite to show in the editor
SavepointObject.EDITOR_SPRITE = "world/object/savepoint_1"

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

--- Initializes the savepoint's arguments before creating it
--- @param data Dummy.Object.Savepoint.Data
function SavepointObject.initArgs(data)
  return data.x, data.y, table.unpack(data.texts)
end

--- Gets the savepoint metadata
--- @return Dummy.Editor.Metadata[]
function SavepointObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "texts",
      label = "WORLD_OBJECT_SAVEPOINT_METADATA_DIALOGUES",
      type = "list",
      list_type = "string"
    }
  }
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
