--- @alias Dummy.Text.Text string|table|fun(): string|table
--- @alias Dummy.Text.Align "left" | "center" | "right" | "justify"

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text Dummy.Text.Text
--- @field protected font love.Font
--- @field protected max_width number
--- @field protected align Dummy.Text.Align
--- @field protected sprite love.Text
local Text = Class:extend(Drawable)

--- Gets the class name
--- @return string
function Text:getClass()
  return "Dummy.Text"
end

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
    local color = { self.color[1], self.color[2], self.color[3], self.alpha }
    local value = Lang.translate(self.text)
    local wraplimit = math.min(self.font:getWidth(value), self.max_width)
    self.sprite:setf({ color, value }, wraplimit, self.align)
  end
end

local set_color = Text.setColor
--- Sets the text color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a)
  set_color(self, r, g, b, a)
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

--- Gets the text max width
--- @return number
function Text:getMaxWidth()
  return self.max_width
end

--- Sets the text max width
--- @param max_width number
function Text:setMaxWidth(max_width)
  self.max_width = max_width
end

--- Gets the text align
--- @return Dummy.Text.Align
function Text:getAlign()
  return self.align
end

--- Sets the text align
--- @param align Dummy.Text.Align
function Text:setAlign(align)
  self.align = align
  self:updateText()
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
    max_width = Constants.SCREEN_WIDTH,
    align = "left",
    color = { 1, 1, 1 },
    sprite = love.graphics.newText(love.graphics.getFont(), { { 1, 1, 1 }, Lang.translate(value) }),
  })

  return text
end

return Text
