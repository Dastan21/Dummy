--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text Dummy.Text.Text
--- @field protected color love.Color
--- @field protected font love.Font
--- @field protected sprite love.Text
local Text = Class:extend(Drawable)

--- @alias Dummy.Text.Text string|table|fun(): string|table

--- Gets the class name
--- @return string
function Text:getClass()
  return "Dummy.Text"
end

--- @alias love.Color {[1]: number, [2]: number, [3]: number}

--- Gets the text value
--- @return Dummy.Text.Text
function Text:getText()
  return self.text
end

--- Sets the text value
--- @param value Dummy.Text.Text
function Text:setText(value)
  self.text = value
  self:updateText()
end

--- Updates the text sprite value
--- @protected
function Text:updateText()
  if self.sprite ~= nil then
    self.sprite:set({ { self.color[1], self.color[2], self.color[3], self.alpha }, Lang.translate(self.text) })
  end
end

--- Gets the text color
--- @return love.Color
function Text:getColor()
  return self.color
end

--- Sets the text color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a)
  if type(r) == "table" then
    self.color = r
  else
    self.color = { r, g, b }
  end

  if a ~= nil then
    self.alpha = a
  end

  self:updateText()
end

--- Gets the text font
--- @return love.Font
function Text:getFont()
  return self.font
end

--- Sets the text font
--- @param font love.Font
function Text:setFont(font)
  self.font = font
  self.sprite:setFont(font)
end

--- Gets the text alpha
--- @return number
function Text:getAlpha()
  return self.alpha
end

--- Sets the text alpha
--- @param alpha number
function Text:setAlpha(alpha)
  self.alpha = alpha
  self:updateText()
end

--- Gets the text sprite
--- @return love.Text
function Text:getSprite()
  return self.sprite
end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value)
  local text = Class:new(Text, {
    text = value,
    font = love.graphics.getFont(),
    color = { 1, 1, 1 },
    sprite = love.graphics.newText(love.graphics.getFont(), { { 1, 1, 1 }, Lang.translate(value) }),
  })

  return text
end

return Text
