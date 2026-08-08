--- @class WorldExample.Object.TorielNote : WorldExample.Object.Readable
local TorielNoteObject = Class(ReadableObject, "WorldExample.Object.TorielNote")

TorielNoteObject.ALLOW_EDITOR = true

TorielNoteObject.EDITOR_SPRITE = "world/object/toriel_note"

--- Creates a toriel note
--- @param x number
--- @param y number
--- @param text string
--- @param ... Dummy.Text.Text
function TorielNoteObject:new(x, y, text, ...)
  self = Class:new(TorielNoteObject, { x, y, text, ... })

  self:setSprite("world/object/toriel_note")
  self:setHitbox(2, 5, 13, 35)

  return self
end

return TorielNoteObject
