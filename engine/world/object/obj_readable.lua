--- @class Dummy.Object.Readable.Data : Dummy.Object.Data
---
--- @field texts string[]

--- @class WorldExample.Object.Readable : Dummy.Object
---
--- @field protected texts Dummy.Text.Text[]
local ReadableObject = Class(Object, "WorldExample.Object.Readable")

ReadableObject.ALLOW_EDITOR = true

--- Creates a readable
--- @param x number
--- @param y number
--- @param text string
--- @param ... Dummy.Text.Text
function ReadableObject:new(x, y, text, ...)
  self = Class:new(ReadableObject)

  self:setCanInteract(true)
  self:setPosition(x, y)
  self:setHitbox(0, 0, 20, 20)

  self.texts = { text, ... }

  return self
end

--- Initializes the readable's arguments before creating it
--- @param data Dummy.Object.Readable.Data
function ReadableObject.initArgs(data)
  return data.x, data.y, table.unpack(data.texts)
end

--- Gets the readable metadata
--- @return Dummy.Editor.Metadata[]
function ReadableObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "texts",
      label = "WORLD_OBJECT_READABLE_METADATA_DIALOGUES",
      type = "list",
      list_type = "string"
    },
  }
end

--- Called when the readable is interacted by the player
function ReadableObject:onInteract()
  World.playDialogue(self.texts)
end

--- Draws the readable for the editor
--- @param data Dummy.Object.Solid.Data
function ReadableObject.drawEditor(data)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("line", data.x + 0.5, data.y + 0.5, data.width - 1, data.height - 1)
end

return ReadableObject
