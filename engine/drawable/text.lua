local self = {}

--- @alias love.Color {[1]: number, [2]: number, [3]: number}

--- Creates a text
--- @param value string|table|fun(): string|table
--- @return Dummy.Text
function self.new(value)
  --- @class Dummy.Text : Dummy.Drawable
  ---
  --- @field protected text string|table|fun(): string|table
  --- @field protected color love.Color
  --- @field protected font love.Font
  --- @field protected sprite love.Text
  local text = Drawable.new()

  text.text = value
  text.font = love.graphics.getFont()
  text.color = { 1, 1, 1 }
  text.sprite = love.graphics.newText(text.font, { text.color, Lang.translate(text.text) })

  --- Gets the text value
  --- @return string|table|fun(): string|table
  function text:getText()
    return text.text
  end

  --- Sets the text value
  --- @param value string|table|fun(): string|table
  function text:setText(value)
    text.text = value
    text:updateText()
  end

  --- Updates the text sprite value
  --- @protected
  function text:updateText()
    if text.sprite ~= nil then
      text.sprite:set({ { text.color[1], text.color[2], text.color[3], text.alpha }, Lang.translate(text.text) })
    end
  end

  --- Gets the text color
  --- @return love.Color
  function text:getColor()
    return text.color
  end

  --- Sets the text color
  --- @overload fun(self: Dummy.Text, color: love.Color)
  --- @param r number red
  --- @param g number green
  --- @param b number blue
  --- @param a number alpha
  function text:setColor(r, g, b, a)
    if type(r) == "table" then
      text.color = r
    else
      text.color = { r, g, b }
    end

    if a ~= nil then
      text.alpha = a
    end

    text:updateText()
  end

  --- Gets the text font
  --- @return love.Font
  function text:getFont()
    return text.font
  end

  --- Sets the text font
  --- @param font love.Font
  function text:setFont(font)
    text.font = font
    text.sprite:setFont(font)
  end

  --- Gets the text alpha
  --- @return number
  function text:getAlpha()
    return text.alpha
  end

  --- Sets the text alpha
  --- @param alpha number
  function text:setAlpha(alpha)
    text.alpha = alpha
    text:updateText()
  end

  --- Gets the text sprite
  --- @return love.Text
  function text:getSprite()
    return text.sprite
  end

  Scene.addDrawable(text)

  return text
end

return self
