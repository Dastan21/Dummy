--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected full_text string
--- @field protected speed number
--- @field protected time number
--- @field protected text_index number
--- @field protected voice string
local DialogueText = Class:extend(Text)

--- Sets the dialogue text value
--- @param value string|table|fun(): string|table
function DialogueText:setText(value)
  if self.max_width > 0 then
    local scale_x = self:getScale()
    local texts = Lang.translate(value):split("\n")
    local _, wrapped_value
    for i, txt in ipairs(texts) do
      _, wrapped_value = self.font:getWrap(txt, self.max_width / scale_x)
      texts[i] = table.concat(wrapped_value, "\n  ")
    end
    value = table.concat(texts, "\n")
  end

  self.full_text = Lang.translate(value)
  self:reset()
end

--- Updates the dialogue text sprite value
--- @protected
function DialogueText:updateDialogue()
  self.text = UTF8.sub(self.full_text, 1, self.text_index)
  self:updateText()
end

--- Resets the dialogue current text
function DialogueText:reset()
  self.time = 0
  self.text_index = 0
  self:updateDialogue()
end

--- Wether the dialogue can be skipped
---@return boolean
function DialogueText:canSkip()
  return self.can_skip
end

--- Sets if the dialogue can be skipped
--- @param can_skip boolean
function DialogueText:setCanSkip(can_skip)
  self.can_skip = can_skip
end

--- Skips the dialogue
function DialogueText:skip()
  if self:isDone() or not self.can_skip then return end

  self.text_index = #self.full_text
  self:updateDialogue()
end

--- Wether the dialogue is done
---@return boolean
function DialogueText:isDone()
  return not self:isVisible() or self.text_index >= #self.full_text
end

function DialogueText:getMaxWidth()
  return self.max_width
end

function DialogueText:setMaxWidth(max_width)
  self.max_width = math.max(0, max_width)
end

--- Gets the dialogue speed
--- @return number
function DialogueText:getSpeed()
  return self.speed
end

--- Sets the dialogue speed
--- @param speed number
function DialogueText:setSpeed(speed)
  self.speed = speed
end

--- Gets the dialogue voice
--- @return string
function DialogueText:getVoice()
  return self.voice
end

--- Sets the dialogue voice
--- @param voice string
function DialogueText:setVoice(voice)
  self.voice = voice
end

--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt)
  if self:isDone() then return end

  self.time = self.time + dt * self.speed * 30

  if self.text_index < math.floor(self.time) then
    self.text_index = math.floor(self.time)
    Audio.playSound(self.voice)
  end

  if Input.isPressed(Input.Cancel) then
    self:skip()
  end

  self:updateDialogue()
end

--- Creates a dialogue text
--- @param value string|table|fun(): string|table
--- @return Dummy.DialogueText
function DialogueText:new(value)
  local dialogue_text = Class:new(DialogueText, {
    full_text = "",
    speed = 1,
    time = 0,
    text_index = 0,
    voice = "text_voice",
    max_width = 0,
    can_skip = true
  }, { value })

  Scene.addDialogue(dialogue_text)

  return dialogue_text
end

return DialogueText
