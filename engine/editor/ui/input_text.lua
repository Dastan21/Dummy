local Button = require "editor.ui.button"

--- @class Dummy.Editor.InputText : Dummy.Editor.Button
---
--- @field protected value string
--- @field protected text_height number
--- @field protected max_characters number
--- @field protected placeholder Dummy.Text.Text
--- @field protected unfocus boolean
--- @field protected padding number
--- @field protected min_width number
--- @field protected onTextInput fun(text: string)
--- @field protected caret_index number
--- @field protected caret_offset number
--- @field protected caret_timer number
--- @field protected caret_draw Dummy.Drawable
--- @field protected filter fun(v: string): string|nil
local InputText = Class(Button, "Dummy.Editor.InputText")

--- Amount of seconds to blink the caret
InputText.CARET_BLINK_DELAY = 0.5

--- Creates an input
--- @param value? string
--- @return Dummy.Editor.InputText
function InputText:new(value)
  self = Class:new(InputText)

  self.text_height = 0
  self.max_characters = 0
  self.placeholder = ""
  self.unfocus = false
  self.padding = 4
  self.min_width = 0
  self.filter = function(v) return v end

  self:setControlInputs({ "return", "kpenter", "gamepad:1:a" })
  self:setOrigin(0, 0)
  self:setBorder(0)

  self.onTextInput = function(txt)
    if not self:isFocused() or self.max_characters > 0 and UTF8.len(self:getValue()) >= self.max_characters then return end

    local first = UTF8.sub(self.value, 1, self.caret_index)
    local last = UTF8.sub(self.value, self.caret_index + 1, UTF8.len(self.value))
    local new_value = first .. txt .. last
    self.caret_index = math.min(self.caret_index + UTF8.len(txt), UTF8.len(new_value))
    self:setValue(new_value)
  end
  Input.addTextInputListener(self.onTextInput)

  self.caret_index = 0
  self.caret_offset = 0
  self.caret_timer = 0
  self.caret_draw = Drawable:new()
  self.caret_draw:setParent(self)

  function self.caret_draw.draw(draw)
    if not draw:isVisible() or not self:isFocused() then return end

    love.graphics.setColor(1, 1, 1)
    local text = UTF8.sub(self.value, 1 + self.caret_offset, self.caret_index)
    local width = self.text:getFont():getWidth(text)
    local height = self:getHeight()
    love.graphics.rectangle("fill", width + self:getPadding(), 0.1 * height, 1, height * 0.8 - 0.5)
  end

  local text = Text:new("", true)
  text:setPosition(self.padding, 0)
  text:setOrigin(0, 0)
  self:setText(text)

  value = tostring(Utils.getOrDefault(value, ""))
  if value == "" then
    self:setValue(" ")
  end
  self:setValue(value)

  return self
end

--- Gets the input's value
--- @return string
function InputText:getValue()
  return self.value
end

--- Sets the input's value
--- @param value string
function InputText:setValue(value)
  if self.value == value then return end

  if type(self.filter) == "function" then
    local v = self.filter(value)
    if v == nil then return end
    value = tostring(v)
  end

  self.value = value

  if value == "" then
    self.text:setAlpha(0.5)
    self.text:setText(self:getPlaceholder())
  else
    self.text:setAlpha(1)
    self.text:setText(value)
  end

  self.caret_timer = 0
  self.caret_draw:setVisible(true)

  self:updateDimensions()
  self:updateDisplayedText()

  if type(self.onInput) == "function" then
    self:onInput(value)
  end
end

--- Updates the input's dimensions
function InputText:updateDimensions()
  local min_width = self:getMinWidth()
  local width = self.text:getWidth() + self:getPadding() * 2
  if min_width ~= 0 then
    width = math.max(width, min_width)
  end
  self:setWidth(width)

  if self:getValue() ~= "" then
    self.text_height = self.text:getHeight()
  end
end

--- Updates the input's displayed text
function InputText:updateDisplayedText()
  local font = self.text:getFont()
  local displayed_width = font:getWidth(UTF8.sub(self.value, 1, self.caret_index))
  local width = self:getWidth() - self:getPadding() * 2
  if displayed_width > width then
    for i = 1, self.caret_index do
      local text_width = font:getWidth(UTF8.sub(self.value, 1, i))
      if text_width >= width then
        self.caret_offset = self.caret_index - i + 1
        break
      end
    end
    local offset_text = UTF8.sub(self.value, 1 + self.caret_offset, self.caret_index)
    self.text:setText(offset_text)
  else
    self.caret_offset = 0

    if self.value == "" then
      self.text:setText(self:getPlaceholder())
    else
      self.text:setText(self.value)
    end
  end
end

--- Gets the input text's height
--- @return number
function InputText:getHeight()
  if self.height ~= 0 then return self.height end
  if self.text_height ~= 0 then return self.text_height end

  return Button.getHeight(self)
end

--- Gets the input's max characters, `0` for no limit
--- @return number
function InputText:getMaxCharacters()
  return self.max_characters
end

--- Sets the input's max characters, `0` for no limit
--- @param max_characters number
function InputText:setMaxCharacters(max_characters)
  self.max_characters = math.max(0, max_characters)
end

--- Gets the input's placeholder
--- @return Dummy.Text.Text
function InputText:getPlaceholder()
  return self.placeholder
end

--- Sets the input's placeholder
--- @param placeholder Dummy.Text.Text
function InputText:setPlaceholder(placeholder)
  self.placeholder = Utils.getOrDefault(placeholder, "")

  if self.value == "" then
    self.text:setText(self.placeholder)
  end
end

--- Gets the input's min width
--- @return number
function InputText:getMinWidth()
  return self.min_width
end

--- Sets the input's min width
--- @param min_width number
function InputText:setMinWidth(min_width)
  if self.min_width == min_width then return end

  self.min_width = min_width

  self:updateDimensions()
end

--- Gets the input's padding
--- @return number
function InputText:getPadding()
  return self.padding
end

--- Sets the input's padding
--- @param padding number
function InputText:setPadding(padding)
  self.padding = padding
end

--- Sets wether the input is disabled
--- @param disabled boolean
function InputText:setDisabled(disabled)
  Button.setDisabled(self, disabled)

  if disabled then
    self:setFocused(false)
  end
end

--- Sets wether the input is focused
--- @param focused boolean
function InputText:setFocused(focused)
  if not focused then
    self.caret_index = 0

    love.keyboard.setKeyRepeat(focused)
    love.keyboard.setTextInput(focused)
  else
    self.caret_index = UTF8.len(self.value)
  end

  self:setCaret(self.caret_index)

  Button.setFocused(self, focused)
end

--- Sets the input's caret
--- @param index number
function InputText:setCaret(index)
  self.caret_index = index
  self.caret_timer = 0
  self.caret_draw:setVisible(true)

  self:updateDisplayedText()
end

--- Sets the input's filter function
--- @param filter fun(v: string): string|nil a function to filter the input's value
function InputText:setFilter(filter)
  self.filter = filter
end

--- Called when the input is removed
function InputText:onRemoved()
  Input.removeTextInputListener(self.onTextInput)
end

--- Called when the input is focused
function InputText:onFocus()
  Button.onFocus(self)
end

--- Called when the input is unfocused
function InputText:onBlur()
  Button.onBlur(self)
end

--- Called when the input's value has changed
--- @param value string
function InputText:onInput(value) end

--- Updates the input, called on every frame
--- @param dt number
function InputText:update(dt)
  Button.update(self, dt)

  if not self:isVisible() or self:isDisabled() then return end

  if self:isPressed() then
    self:setFocused(true)
  end

  if self:isFocused() then
    if self.unfocus then
      self:setFocused(false)
      self.unfocus = false
      return
    end

    love.keyboard.setKeyRepeat(true)
    love.keyboard.setTextInput(true)

    self.caret_timer = self.caret_timer + dt
    if self.caret_timer >= InputText.CARET_BLINK_DELAY then
      self.caret_timer = 0
      self.caret_draw:setVisible(not self.caret_draw:isVisible())
    end

    if Input.isPressed(Input.Escape) then
      self.unfocus = true
    else
      local value_length = UTF8.len(self.value)
      if Input.isPressed("backspace") then
        if value_length ~= nil and value_length > 0 and self.caret_index > 0 then
          local first = UTF8.sub(self.value, 1, self.caret_index - 1)
          local last = UTF8.sub(self.value, self.caret_index + 1, value_length)
          self.caret_index = self.caret_index - 1
          self:setValue(first .. last)
        end
      elseif Input.isPressed("delete") then
        if value_length ~= nil and value_length > 0 and self.caret_index < value_length then
          local first = UTF8.sub(self.value, 1, self.caret_index)
          local last = UTF8.sub(self.value, self.caret_index + 2, value_length)
          self:setValue(first .. last)
        end
      elseif (Input.isPressed("left") or Input.isPressed("mouse:wheel_x_down") or (Input.isPressed("mouse:wheel_y_up") and Input.isDown("shift"))) and self.caret_index > 0 then
        self:setCaret(Input.isDown("ctrl") and 0 or (self.caret_index - 1))
      elseif (Input.isPressed("right") or Input.isPressed("mouse:wheel_x_up") or (Input.isPressed("mouse:wheel_y_down") and Input.isDown("shift"))) and self.caret_index < value_length then
        self:setCaret(Input.isDown("ctrl") and value_length or (self.caret_index + 1))
      elseif Input.isPressed("home") then
        self:setCaret(0)
      elseif Input.isPressed("end") then
        self:setCaret(UTF8.len(self.value))
      elseif Input.isPressed("v") and Input.isDown("ctrl") then
        local clipboard = love.system.getClipboardText()
        if clipboard ~= "" then
          self.onTextInput(clipboard)
        end
      elseif Input.isPressed("mouse:left") and not self:isHovered() then
        self.unfocus = true
      end
    end
  end

  if self:isHovered() then
    Cursor.setIcon("text")
  end
end

return InputText
