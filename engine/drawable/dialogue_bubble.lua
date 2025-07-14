--- @alias Dummy.DialogueBubble.Type "left" | "left_short" | "left_wide_short" | "right" | "right_large" | "right_short" | "right_thin" | "right_wide" | "right_wide_short" | "top" | "bottom" | "tiny" | "tiny_top" | "shock"

--- @class Dummy.DialogueBubble : Dummy.Sprite
---
--- @field protected type Dummy.DialogueBubble.Type
--- @field protected dialogue Dummy.DialogueText
local DialogueBubble = Class:extend(Sprite)

--- Gets the class name
--- @return string
function DialogueBubble.getClassName()
  return "Dummy.DialogueBubble"
end

--- Gets the dialogue bubble's dialogue text
--- @return Dummy.DialogueText
function DialogueBubble:getDialogue()
  return self.dialogue
end

--- Sets the dialogue bubble's alpha
--- @param alpha number
function DialogueBubble:setAlpha(alpha)
  self.alpha = alpha
  self.dialogue:setAlpha(alpha)
end

--- Initializes the dialogue bubble
function DialogueBubble:init()
  if self.type == "right" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
  elseif self.type == "right_large" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
  elseif self.type == "right_short" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
  elseif self.type == "right_thin" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(19, 10 - self:getHeight() / 2)
  elseif self.type == "right_wide" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(38, 10 - self:getHeight() / 2)
  elseif self.type == "right_wide_short" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(35, 10 - self:getHeight() / 2)
  elseif self.type == "left" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(25 - self:getWidth(), 5 - self:getHeight() / 2)
  elseif self.type == "left_short" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(25 - self:getWidth(), 5 - self:getHeight() / 2)
  elseif self.type == "left_wide_short" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(35 - self:getWidth(), 10 - self:getHeight() / 2)
  elseif self.type == "top" then
    self:setOrigin(0.5, 1)
    self.dialogue:setPosition(25 - self:getWidth() / 2, 5 - self:getHeight())
  elseif self.type == "bottom" then
    self:setOrigin(0.5, 0)
    self.dialogue:setPosition(25 - self:getWidth() / 2, 20)
  elseif self.type == "tiny" then
    self:setOrigin(0.5, 0)
    self.dialogue:setPosition(25 - self:getWidth() / 2, 5)
  elseif self.type == "tiny_top" then
    self:setOrigin(0.5, 1)
    self.dialogue:setPosition(32 - self:getWidth() / 2, 4 - self:getHeight())
  elseif self.type == "shock" then
    self.dialogue:setPosition(45 - self:getWidth() / 2, 39 - self:getHeight() / 2)
  end
end

--- Creates a dialogue text
--- @param type Dummy.DialogueBubble.Type bubble type
--- @param value Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
--- @return Dummy.DialogueBubble
function DialogueBubble:new(type, value, ...)
  type = Utils.getOrDefault(type, "right")

  self = Class:new(DialogueBubble, { "bubble_" .. type })
  self.type = type
  self.dialogue = DialogueText:new(value, ...)
  self.dialogue:setOrigin(0, 0)
  self.dialogue:setColor(type ~= "shock" and { 0, 0, 0 } or { 1, 1, 1 })
  self.dialogue:setVoice("voice_bubble")
  self.dialogue:setFont(Assets.getFont("plain"))
  self.dialogue:setParent(self)

  self:init()

  return self
end

return DialogueBubble
