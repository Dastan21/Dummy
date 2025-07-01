--- @alias Dummy.Text.Text string|table|fun(): string|table
--- @alias Dummy.Text.Align "left" | "center" | "right"

--- @class Dummy.Text.Char
---
--- @field char string
--- @field font love.Font|nil
--- @field color love.Color|nil

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text Dummy.Text.Text
--- @field protected font love.Font
--- @field protected max_width number
--- @field protected align Dummy.Text.Align
--- @field protected chars Dummy.Text.Char[]
--- @field protected width number
--- @field protected height number
local Text = Class:extend(Drawable)

--- Gets the class name
--- @return string
function Text:getClass()
  return "Dummy.Text"
end

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText()
  return self.text
end

--- Sets the text's value
--- @param value Dummy.Text.Text
function Text:setText(value)
  self.text = value
  self:init()
end

--- Gets the text's wrapped value
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Text
function Text:getWrappedText(value)
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

  return value
end

--- Gets the text's width
--- @return number
function Text:getWidth()
  return self.width
end

--- Gets the text's height
--- @return number
function Text:getHeight()
  return self.height
end

local set_color = Text.setColor
--- Sets the text's color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a)
  set_color(self, r, g, b, a)
end

--- Gets the text's font
--- @return love.Font
function Text:getFont()
  return self.font
end

--- Sets the text's font
--- @param font love.Font
function Text:setFont(font)
  self.font = font
  self:init()
end

--- Gets the text's max width
--- @return number
function Text:getMaxWidth()
  return self.max_width
end

--- Sets the text's max width
--- @param max_width number
function Text:setMaxWidth(max_width)
  self.max_width = max_width
  self:init()
end

--- Gets the text's align
--- @return Dummy.Text.Align
function Text:getAlign()
  return self.align
end

--- Sets the text's align
--- @param align Dummy.Text.Align
function Text:setAlign(align)
  self.align = align
end

--- Sets the text's alpha
--- @param alpha number
function Text:setAlpha(alpha)
  self.alpha = alpha
end

--- Gets the text's characters
--- @return Dummy.Text.Char[]
function Text:getCharacters()
  return self.chars
end

--- Gets the text's line width
--- @param line number
--- @return number
function Text:getLineWidth(line)
  local width = 0
  local current_line = 1
  for _, char in ipairs(self.chars) do
    if current_line == line then
      width = width + self.font:getWidth(char.char)
    elseif current_line > line then
      return width
    end

    if char.char == "\n" then
      current_line = current_line + 1
    end
  end
  return width
end

--- Draws the text
function Text:draw()
  if not self:isVisible() then return end

  love.graphics.push()

  love.graphics.applyTransform(self:getTransform())
  local origin_x, origin_y = self:getOrigin()

  if Debugger.shouldDisplayHitbox() then
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", -0.5 - self:getWidth() * origin_x, -0.5 - self:getHeight() * origin_y,
      self:getWidth() + 1, self:getHeight() + 1)
  end

  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
  local line = 1
  local function getCharOffset()
    if self.align == "right" then
      return self:getWidth() - self:getLineWidth(line)
    elseif self.align == "center" then
      return self:getWidth() / 2 - self:getLineWidth(line) / 2
    end
    return 0
  end
  local char_x, char_y = getCharOffset(), 0
  for _, char in ipairs(self.chars) do
    local text = { char.color or self.color, char.char }
    local font = char.font or self.font
    love.graphics.print(text, font, char_x - self:getWidth() * origin_x, char_y - self:getHeight() * origin_y)

    char_x = char_x + font:getWidth(char.char)
    if char.char == "\n" then
      line = line + 1
      char_x = getCharOffset()
      char_y = char_y + font:getHeight()
    end
  end

  self:drawChildren()

  love.graphics.pop()
end

--- Initialize the text
function Text:init()
  self.chars = {}

  local width, height = 0, 0
  local line_width, line_height = 0, 0
  local lines_heights = {}
  local line_count = 1
  local value = self:getWrappedText(Lang.translate(self.text))
  local length = UTF8.len(value)
  for i = 1, length do
    local font = self.font

    --- @type Dummy.Text.Char
    local char = {
      char = UTF8.sub(value, i, i)
    }

    line_width = line_width + font:getWidth(char.char)
    width = math.max(width, line_width)
    line_height = math.max(line_height, font:getHeight())
    lines_heights[line_count] = line_height
    if char.char == "\n" then
      line_width, line_height = 0, 0
      line_count = line_count + 1
    end

    table.insert(self.chars, char)
  end

  self.width = width
  self.height = math.sum(table.unpack(lines_heights))
end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value)
  local text = Class:new(Text)

  text.color = { 1, 1, 1 }
  text.font = love.graphics.getFont()
  text.max_width = Constants.SCREEN_WIDTH
  text.align = "left"

  text:setText(value)

  return text
end

return Text
