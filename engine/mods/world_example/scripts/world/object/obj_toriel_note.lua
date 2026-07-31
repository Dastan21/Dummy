local ReadableObject = modRequire("scripts.world.object.obj_readable") --[[@as WorldExample.Object.Readable]]

--- @class WorldExample.Object.TorielNote : WorldExample.Object.Readable
local TorielNoteObject = Class(ReadableObject, "WorldExample.Object.TorielNote")

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
