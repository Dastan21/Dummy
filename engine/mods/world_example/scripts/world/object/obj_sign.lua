--- @class Dummy.Object.Sign.Data : Dummy.Object.Data
---
--- @field texts string[]

--- @class WorldExample.Object.Sign : Dummy.Object.NPC
local SignObject = Class(NPCObject, "WorldExample.Object.NPC.Sign")

SignObject.ALLOW_EDITOR = true

SignObject.EDITOR_SPRITE = "world/object/sign"

--- Creates a sign
--- @param x number
--- @param y number
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function SignObject:new(x, y, text, ...)
  self = Class:new(SignObject, { "sign" })

  self:setSprite("world/object/sign")
  self:setPosition(x, y)
  self:setHitbox(0, 5, 20, 15)

  self.texts = { text, ... }

  return self
end

--- Initializes the sign's arguments before creating it
--- @param data Dummy.Object.Sign.Data
function SignObject.initArgs(data)
  return data.x, data.y, table.unpack(data.texts)
end

--- Gets the sign metadata
--- @return Dummy.Editor.Metadata[]
function SignObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "texts",
      label = "WORLD_OBJECT_READABLE_METADATA_DIALOGUES",
      type = "list",
      list_type = "string"
    }
  }
end

--- Called when the sign is interacted by the player
function SignObject:onInteract()
  World.playDialogue(self.texts)
end

return SignObject
