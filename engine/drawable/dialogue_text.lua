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
  local dialogue_text = Text.new("")

  dialogue_text.speed = 1
  dialogue_text.time = 0
  dialogue_text.text_index = 0
  dialogue_text.max_width = Constants.ARENA.DEFAULT_WIDTH - Constants.ARENA.BORDER_WIDTH * 2

  --- Sets the dialogue text value
  --- @param value string|table|fun(): string|table
  function dialogue_text:setText(value)
    local scale_x = dialogue_text:getScale()
    local _, wrapped_value = Font.FONTS.MAIN_TEXT:getWrap(Lang.translate(value), dialogue_text:getMaxWidth() / scale_x)
    dialogue_text.full_text = Lang.translate(table.concat(wrapped_value, "\n  "))
    dialogue_text:reset()
  end

  --- Updates the dialogue text sprite value
  --- @protected
  function dialogue_text:updateDialogue()
    dialogue_text.text = dialogue_text.full_text:sub(1, dialogue_text.text_index)
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
    dialogue_text.max_width = max_width
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

  --- Updates the dialogue
  --- @param dt number
  function dialogue_text:update(dt)
    if dialogue_text:isDone() then return end

    dialogue_text.time = dialogue_text.time + dt * dialogue_text.speed * 30

    if dialogue_text.text_index < math.floor(dialogue_text.time) then
      dialogue_text.text_index = math.floor(dialogue_text.time)
      Audio.playSound("text_voice")
    end

    dialogue_text:updateDialogue()
  end

  dialogue_text:setText(value)

  Scene.addDrawable(dialogue_text)
  Scene.addDialogue(dialogue_text)

  return dialogue_text
end

return self
