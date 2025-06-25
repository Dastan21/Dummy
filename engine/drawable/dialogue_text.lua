--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected text_key Dummy.Text.Text
--- @field protected full_text string
--- @field protected speed number
--- @field protected time number
--- @field protected text_index number
--- @field protected voice string|nil
--- @field protected done_callback fun()|nil
--- @field protected can_skip boolean
--- @field protected can_confirm boolean
local DialogueText = Class:extend(Text)

--- Gets the class name
--- @return string
function DialogueText:getClass()
  return "Dummy.DialogueText"
end

--- Sets the dialogue's text value
--- @param value Dummy.Text.Text
function DialogueText:setText(value)
  self.text_key = value

  if self.max_width > 0 then
    local scale_x = self:getScale()
    local texts = Lang.translate(value):split("\n")
    local _, wrapped_value
    for i, txt in ipairs(texts) do
      _, wrapped_value = self.font:getWrap(txt, self.max_width / scale_x)
      texts[i] = table.concat(wrapped_value, "\n")
    end
    value = table.concat(texts, "\n")
  end

  self.full_text = Lang.translate(value)
  self:reset()
end

--- Updates the dialogue's text sprite value
--- @protected
function DialogueText:updateDialogue()
  self.text = UTF8.sub(self.full_text, 1, self.text_index)
  self:updateText()
end

--- Resets the dialogue's current text
function DialogueText:reset()
  self.time = 0
  self.text_index = 0
  self:updateDialogue()
end

--- Wether the dialogue's can be skipped
--- @return boolean
function DialogueText:canSkip()
  return self.can_skip
end

--- Sets wether the dialogue's can be skipped
--- @param can_skip boolean
function DialogueText:setCanSkip(can_skip)
  self.can_skip = can_skip
end

--- Skips the dialogue's
function DialogueText:skip()
  if self:isDone() or not self.can_skip then return end

  self.text_index = #self.full_text
  self:updateDialogue()
end

--- Wether the dialogue's can be confirmed
--- @return boolean
function DialogueText:canConfirm()
  return self.can_confirm
end

--- Sets wether the dialogue's can be confirmed
--- @param can_confirm boolean
function DialogueText:setCanConfirm(can_confirm)
  self.can_confirm = can_confirm
end

--- Wether the dialogue's is done
--- @return boolean
function DialogueText:isDone()
  return not self:isVisible() or self.text_index >= #self.full_text
end

--- Gets the dialogue's speed
--- @return number
function DialogueText:getSpeed()
  return self.speed
end

--- Sets the dialogue's speed
--- @param speed number
function DialogueText:setSpeed(speed)
  self.speed = speed
end

--- Gets the dialogue's voice
--- @return string|nil
function DialogueText:getVoice()
  return self.voice
end

--- Sets the dialogue's voice
--- @param voice string|nil
function DialogueText:setVoice(voice)
  self.voice = voice
end

--- Sets the text max width
--- @param max_width number
function DialogueText:setMaxWidth(max_width)
  self.max_width = max_width
  self:setText(self.text_key)
end

--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt)
  if self:isDone() or not self:isVisible() then return end

  self.time = self.time + dt * self.speed * 30

  if self.text_index < math.floor(self.time) then
    self.text_index = math.floor(self.time)
    Assets.playSound(self.voice)
  end

  if Input.isPressed(Input.Cancel) then
    self:skip()
  end

  if self.text_index >= #self.full_text and type(self.done_callback) == "function" then
    self.done_callback()
  end

  self:updateDialogue()
end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param done_callback? fun() called when the dialogue is done
--- @return Dummy.DialogueText
function DialogueText:new(value, done_callback)
  local dialogue_text = Class:new(DialogueText, { value })

  dialogue_text.text_key = value
  dialogue_text.full_text = ""
  dialogue_text.speed = 1
  dialogue_text.time = 0
  dialogue_text.text_index = 0
  dialogue_text.voice = "voice_text"
  dialogue_text.done_callback = done_callback
  dialogue_text.can_skip = true
  dialogue_text.can_confirm = true

  Scene.addDialogue(dialogue_text)

  return dialogue_text
end

return DialogueText
