--- @alias Dummy.DialogueBubble.Type "left" | "left_short" | "left_wide_short" | "right" | "right_large" | "right_short" | "right_thin" | "right_wide" | "right_wide_short" | "top" | "bottom" | "tiny" | "tiny_above" | "shock"

--- @class Dummy.DialogueBubble : Dummy.Sprite
---
--- @field protected type Dummy.DialogueBubble.Type
--- @field protected dialogue Dummy.DialogueText
local DialogueBubble = Class:extend(Sprite)

--- Gets the class name
--- @return string
function DialogueBubble:getClass()
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
  -- TODO: all bubble types
  if self.type == "right" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(84)
  elseif self.type == "right_large" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(104)
  elseif self.type == "right_short" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(25, 5 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(84)
  elseif self.type == "right_thin" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(19, 10 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(84)
  elseif self.type == "right_wide" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(38, 10 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(164)
  elseif self.type == "right_wide_short" then
    self:setOrigin(0, 0.5)
    self.dialogue:setPosition(35, 10 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(204)
  elseif self.type == "left" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(25 - self:getWidth(), 5 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(84)
  elseif self.type == "left_short" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(25 - self:getWidth(), 5 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(84)
  elseif self.type == "left_wide_short" then
    self:setOrigin(1, 0.5)
    self.dialogue:setPosition(35 - self:getWidth(), 10 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(204)
  elseif self.type == "top" then
    self:setOrigin(0.5, 1)
    self.dialogue:setPosition(25 - self:getWidth() / 2, 5 - self:getHeight())
    self.dialogue:setMaxWidth(164)
  elseif self.type == "bottom" then
    self:setOrigin(0.5, 0)
    self.dialogue:setPosition(25 - self:getWidth() / 2, 20)
    self.dialogue:setMaxWidth(164)
  elseif self.type == "tiny" then
  elseif self.type == "tiny_above" then
  elseif self.type == "shock" then
    self.dialogue:setPosition(45 - self:getWidth() / 2, 39 - self:getHeight() / 2)
    self.dialogue:setMaxWidth(174)
  end
end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param type? Dummy.DialogueBubble.Type bubble type
--- @param done_callback? fun() called when the dialogue is done
--- @return Dummy.DialogueBubble
function DialogueBubble:new(value, type, done_callback)
  type = Utils.getOrDefault(type, "right")

  local dialogue_bubble = Class:new(DialogueBubble, { "bubble_" .. type })

  dialogue_bubble.type = type
  dialogue_bubble.dialogue = DialogueText:new(value, done_callback)
  dialogue_bubble.dialogue:setOrigin(0, 0)
  dialogue_bubble.dialogue:setColor(type ~= "shock" and { 0, 0, 0 } or { 1, 1, 1 })
  dialogue_bubble.dialogue:setVoice("voice_bubble")
  dialogue_bubble.dialogue:setCanSkip(false)
  dialogue_bubble.dialogue:setCanConfirm(true)
  dialogue_bubble.dialogue:setFont(Assets.getFont("plain"))
  dialogue_bubble.dialogue:setParent(dialogue_bubble)

  dialogue_bubble:init()

  return dialogue_bubble
end

return DialogueBubble
