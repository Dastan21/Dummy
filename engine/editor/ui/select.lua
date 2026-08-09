local Button = require "editor.ui.button"
local Window = require "editor.ui.window"

--- @class Dummy.Editor.Select.Option
---
--- @field value any
--- @field label string

--- @class Dummy.Editor.Select : Dummy.Editor.Button
---
--- @field protected options Dummy.Editor.Select.Option[]
--- @field protected value any
--- @field protected open boolean
--- @field protected padding number
--- @field protected min_width number
--- @field protected options_max_width number
--- @field protected options_max_height number
--- @field protected arrow Dummy.Sprite
--- @field protected options_window Dummy.Editor.Window
--- @field protected buttons table<Dummy.Editor.Button, boolean>
local Select = Class(Button, "Dummy.Editor.Select")

--- Creates a select
--- @param options Dummy.Editor.Select.Option[]
--- @param value? any
--- @return Dummy.Editor.Select
function Select:new(options, value)
  self = Class:new(Select)

  self.open = false
  self.padding = 4
  self.min_width = 0
  self.options_max_width = 0
  self.options_max_height = 0

  local text = Text:new(value)
  text:setPosition(self:getPadding(), 0)
  text:setOrigin(0, 0)
  text:setOverflow("ellipsis")
  self:setText(text)

  self.arrow = Sprite:new("editor/arrow")
  self.arrow:setOrigin(0, 0)
  self.arrow:setParent(self)

  self:setOrigin(0, 0)

  self:setOptions(options)
  self:setValue(value)

  return self
end

--- Gets the select's value
--- @return any
function Select:getValue()
  return self.value
end

--- Sets the select's value
--- @param value any
function Select:setValue(value)
  if self.value == value then return end

  local old_value = self.value
  self.value = value

  for _, option in ipairs(self.options) do
    if option.value == value then
      self:getText():setText(option.label)
      break
    end
  end

  self:updateDimensions()

  if self.value ~= old_value and type(self.onChange) == "function" then
    self:onChange()
  end
end

--- Updates the select's dimensions
function Select:updateDimensions()
  local min_width = self:getMinWidth()
  local padding = self:getPadding()
  local text = self:getText()
  local width = text:getWidth() + self.arrow:getWidth() + padding * 2
  if min_width ~= 0 then
    width = math.max(width, min_width)

    if width > min_width then
      text:setMaxWidth(min_width - self.arrow:getWidth() - padding * 2)
      width = min_width
    end
  end
  self:setWidth(width)

  local font = text:getFont()
  local options_width = width - 2
  for button in pairs(self.buttons) do
    options_width = math.max(options_width, font:getWidth(Lang.translate(button:getText():getText())) + padding * 2)
  end

  for button in pairs(self.buttons) do
    button:setWidth(options_width)
    button:getText():setPosition(padding, -1)
  end

  local options_max_width = self:getOptionsMaxWidth()
  if options_max_width ~= 0 then
    options_width = math.min(options_width, options_max_width)
  end

  self.options_window:setWidth(options_width)

  if self:getValue() ~= "" then
    local height = text:getHeight()
    local options_max_height = self:getOptionsMaxHeight()
    if options_max_height ~= 0 then
      height = math.min(height, options_max_height)
    end
    self:setHeight(math.max(height, self:getHeight()))
  end

  self.arrow:setPosition(self:getWidth() - self.arrow:getWidth() - 4, 4)
end

--- Gets the select's options
--- @return Dummy.Editor.Select.Option[]
function Select:getOptions()
  return self.options
end

--- Sets the select's options
--- @param options Dummy.Editor.Select.Option[]
function Select:setOptions(options)
  self.options = table.copy(options)

  if self.options_window ~= nil then
    self.options_window:remove()
  end
  self.options_window = Window:new()
  self.options_window:setVisible(false)

  function self.options_window.getVisibleWidth(_self)
    local x = _self:getAbsolutePosition()
    return math.min(_self:getWidth(), Constants.WORLD_WIDTH - x - 1)
  end

  function self.options_window.getVisibleHeight(_self)
    local _, y = _self:getAbsolutePosition()
    return math.min(_self:getHeight(), Constants.WORLD_HEIGHT - y - 1)
  end

  self.buttons = {}
  local elements = {}
  local offset_y = 0
  local max_width = 0
  local font = self:getText():getFont()
  for _, option in ipairs(self.options) do
    max_width = math.max(max_width, font:getWidth(Lang.translate(option.label)) + self:getPadding() * 2)

    local button = Button:new()
    button:setParent(self.options_window)
    button:setOrigin(0, 0)
    local text = Text:new(option.label)
    button:setText(text)
    text:setOrigin(0, 0)
    text:setOverflow("ellipsis")
    text:setPosition(self:getPadding(), -1)
    button:setPosition(0, offset_y)
    button:setBorder(0)
    button["option"] = option

    function button.onClick()
      self:setValue(button["option"].value)

      self.open = false
      self:setFocused(true)
    end

    offset_y = offset_y + text:getHeight()
    self.buttons[button] = true

    table.insert(elements, { button })
  end
  self.options_window:setWidth(max_width - 2)
  self.options_window:setHeight(offset_y)

  self:updateDimensions()

  self.options_window:setUIElements(elements, true)
end

--- Wether the select is open
--- @return boolean
function Select:isOpen()
  return self.open
end

--- Gets the select's min width
--- @return number
function Select:getMinWidth()
  return self.min_width
end

--- Sets the select's min width
--- @param min_width number
function Select:setMinWidth(min_width)
  if self.min_width == min_width then return end

  self.min_width = min_width

  self:updateDimensions()
end

--- Gets the select's options max width
--- @return number
function Select:getOptionsMaxWidth()
  return self.options_max_width
end

--- Sets the select's options max width
--- @param options_max_width number
function Select:setOptionsMaxWidth(options_max_width)
  if self.options_max_width == options_max_width then return end

  self.options_max_width = options_max_width

  self:updateDimensions()
end

--- Gets the select's options max height
--- @return number
function Select:getOptionsMaxHeight()
  return self.options_max_height
end

--- Sets the select's options max height
--- @param options_max_height number
function Select:setOptionsMaxHeight(options_max_height)
  if self.options_max_height == options_max_height then return end

  self.options_max_height = options_max_height

  self:updateDimensions()
end

--- Gets the select's padding
--- @return number
function Select:getPadding()
  return self.padding
end

--- Sets the select's padding
--- @param padding number
function Select:setPadding(padding)
  if self.padding == padding then return end

  self.padding = padding

  self:updateDimensions()
end

--- Called when the select is removed from the scene
function Select:onRemoved()
  self.options_window:remove()
end

--- Wether the pointer is on the select within the window bounds
--- @return boolean
function Select:isPointerOnButtonWithinBounds()
  local within_bounds = Button.isPointerOnButtonWithinBounds(self)
  if not within_bounds then return false end

  local cursor_x, cursor_y = Cursor.getPosition()
  for _, window in ipairs(Window.getActiveWindows()) do
    if window:isFocused() then
      local parent = self:getParent()
      if parent ~= nil then
        local grandparent = parent:getParent()
        if grandparent ~= nil and grandparent ~= window and grandparent:is(Window) then
          local window_x, window_y = window:getAbsolutePosition()
          local window_width, window_height = window:getVisibleWidth(), window:getVisibleHeight()
          if Utils.isPointInRect(cursor_x, cursor_y, window_x, window_y, window_width, window_height) then
            return false
          end
        end
      end
    end
  end

  return true
end

--- Called when the select's value has changed
function Select:onChange() end

--- Updates the select, called on every frame
--- @param dt number
function Select:update(dt)
  Button.update(self, dt)

  if not self:isVisible() then return end

  if not self.open then
    self.options_window:setVisible(false)
  end

  if self:isFocused() and self:isPressed() then
    local element_index_i, element_index_j = 1, 1
    for i, elements in ipairs(self.options_window:getUIElements()) do
      for j, element in ipairs(elements) do
        if element["option"].value == self.value then
          element_index_i = i
          element_index_j = j
          break
        end
      end
    end
    self.open = not self.options_window:isVisible()
    self.options_window:setVisible(self.open, element_index_i, element_index_j)
  elseif self.options_window:isVisible() and not self:isFocused() and Input.isPressed("mouse:left") and not self:isHovered() then
    self.open = false
  end

  local x, y = self:getAbsolutePosition()
  local option_border = 0
  local first_option = self.options_window:getUIElement(1, 1)
  if first_option ~= nil then
    option_border = first_option:getBorder()
  end
  self.options_window:setPosition(math.round(x) - 1 - self.options_window:getWidth() + self:getWidth(),
    math.round(y) + self:getHeight() - 2 + self:getBorder() + option_border)
end

return Select
