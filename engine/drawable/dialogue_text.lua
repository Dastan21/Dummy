local self = {}

--- Creates a dialogue text
--- @param value string|table|fun(): string|table
--- @return Dummy.DialogueText
function self.new(value)
  --- @class Dummy.DialogueText : Dummy.Text
  ---
  --- @field protected full_text string
  --- @field protected speed number
  --- @field protected time number
  --- @field protected text_index number
  --- @field protected voice string
  local dialogue_text = Text.new("")

  dialogue_text.full_text = ""
  dialogue_text.speed = 1
  dialogue_text.time = 0
  dialogue_text.text_index = 0
  dialogue_text.voice = "text_voice"
  dialogue_text.max_width = 0

  --- Sets the dialogue text value
  --- @param value string|table|fun(): string|table
  function dialogue_text:setText(value)
    if dialogue_text.max_width > 0 then
      local scale_x = dialogue_text:getScale()
      local texts = Lang.translate(value):split("\n")
      local wrapped_value
      for i, txt in ipairs(texts) do
        wrapped_value = select(2, dialogue_text.font:getWrap(txt, dialogue_text.max_width / scale_x))
        texts[i] = table.concat(wrapped_value, "\n  ")
      end
      value = table.concat(texts, "\n")
    end

    dialogue_text.full_text = Lang.translate(value)
    dialogue_text:reset()
  end

  --- Updates the dialogue text sprite value
  --- @protected
  function dialogue_text:updateDialogue()
    dialogue_text.text = UTF8.sub(dialogue_text.full_text, 1, dialogue_text.text_index)
    dialogue_text:updateText()
  end

  --- Resets the dialogue current text
  function dialogue_text.reset()
    dialogue_text.time = 0
    dialogue_text.text_index = 0
    dialogue_text:updateDialogue()
  end

  --- Skips the dialogue
  function dialogue_text.skip()
    if dialogue_text:isDone() then return end

    dialogue_text.text_index = #dialogue_text.full_text
    dialogue_text:updateDialogue()
  end

  --- Wether the dialogue is done
  ---@return boolean
  function dialogue_text:isDone()
    return not dialogue_text:isVisible() or dialogue_text.text_index >= #dialogue_text.full_text
  end

  function dialogue_text:getMaxWidth()
    return dialogue_text.max_width
  end

  function dialogue_text:setMaxWidth(max_width)
    dialogue_text.max_width = math.max(0, max_width)
  end

  --- Gets the dialogue speed
  --- @return number
  function dialogue_text:getSpeed()
    return dialogue_text.speed
  end

  --- Sets the dialogue speed
  --- @param speed number
  function dialogue_text:setSpeed(speed)
    dialogue_text.speed = speed
  end

  --- Gets the dialogue voice
  --- @return string
  function dialogue_text:getVoice()
    return dialogue_text.voice
  end

  --- Sets the dialogue voice
  --- @param voice string
  function dialogue_text:setVoice(voice)
    dialogue_text.voice = voice
  end

  --- Updates the dialogue
  --- @param dt number
  function dialogue_text:update(dt)
    if dialogue_text:isDone() then return end

    dialogue_text.time = dialogue_text.time + dt * dialogue_text.speed * 30

    if dialogue_text.text_index < math.floor(dialogue_text.time) then
      dialogue_text.text_index = math.floor(dialogue_text.time)
      Audio.playSound(dialogue_text.voice)
    end

    dialogue_text:updateDialogue()
  end

  dialogue_text:setText(value)

  Scene.addDialogue(dialogue_text)

  return dialogue_text
end

return self
