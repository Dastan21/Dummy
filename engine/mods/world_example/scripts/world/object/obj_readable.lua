--- @class WorldExample.Object.Readable : Dummy.Object
---
--- @field protected texts Dummy.Text.Text[]
local ReadableObject = Class(Object, "WorldExample.Object.Readable")

--- Creates a sign
--- @param x number
--- @param y number
--- @param text string
--- @param ... Dummy.Text.Text
function ReadableObject:new(x, y, text, ...)
  self = Class:new(ReadableObject)

  self:setCanInteract(true)
  self:setOrigin(0, 0)
  self:setPosition(x, y)
  self:setHitbox(0, 0, 20, 20)

  self.texts = { text, ... }

  return self
end

--- Called when the sign is interacted by the player
function ReadableObject:onInteract()
  World.playDialogue(self.texts)
end

return ReadableObject
