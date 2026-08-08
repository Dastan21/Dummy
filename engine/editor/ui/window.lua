local Button = require "editor.ui.button"
local InputText = require "editor.ui.input_text"

--- @class Dummy.Editor.Window.Inputs
---
--- @field next string|string[]
--- @field up string|string[]
--- @field down string|string[]
--- @field left string|string[]
--- @field right string|string[]

--- @class Dummy.Editor.Window : Dummy.Mask
---
--- @field protected container Dummy.Drawable
--- @field protected elements Dummy.Editor.Button[][]
--- @field protected max_width number
--- @field protected max_height number
--- @field protected padding [number, number, number, number]
--- @field protected next_focus_timer Dummy.Timer.Handle|nil
--- @field protected control_inputs Dummy.Editor.Window.Inputs
local Window = Class(Mask, "Dummy.Editor.Window")

--- @type table<Dummy.Editor.Window, boolean>
local active_windows = {}

--- Amount of pixels to scroll when scrolling inside the window
Window.SCROLL_DELTA = 8

--- Creates a window
--- @return Dummy.Editor.Window
function Window:new()
  self = Class:new(Window)

  self:setTag("UI")

  self.container = Drawable:new()
  self.container:setParent(self)

  self.scroll_draw = Drawable:new()
  function self.scroll_draw.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.applyTransform(_self:getTransform())
    love.graphics.setColor(1, 1, 1, 1)

    local container_x, container_y = self.container:getPosition()

    -- horizontal scroll
    local scroll_h_y = self:getVisibleHeight() - container_y - 0.5
    local scroll_h_ratio = container_x / self:getScrollWidth()
    local scroll_h_width = self:getVisibleWidth() * self:getVisibleWidth() / self:getVirtualWidth()
    local scroll_h_x = scroll_h_ratio * (self:getVisibleWidth() - scroll_h_width) - container_x
    if scroll_h_width < self:getVisibleWidth() then
      love.graphics.line(scroll_h_x, scroll_h_y, scroll_h_x + scroll_h_width, scroll_h_y)
    end

    -- vertical scroll
    local scroll_v_x = self:getVisibleWidth() - container_x - 0.5
    local scroll_v_ratio = container_y / self:getScrollHeight()
    local scroll_v_height = self:getVisibleHeight() * self:getVisibleHeight() / self:getVirtualHeight()
    local scroll_v_y = scroll_v_ratio * (self:getVisibleHeight() - scroll_v_height) - container_y
    if scroll_v_height < self:getVisibleHeight() then
      love.graphics.line(scroll_v_x, scroll_v_y, scroll_v_x, scroll_v_y + scroll_v_height)
    end
  end

  self.scroll_draw:setLayer(Constants.LAYERS.WINDOW)
  self.scroll_draw:setParent(self)

  self.elements = {}
  self.max_width = Constants.WORLD_WIDTH
  self.max_height = Constants.WORLD_HEIGHT
  self.padding = { 0, 0, 0, 0 }

  self:setLayer(Constants.LAYERS.WINDOW)
  self:setOrigin(0, 0)
  self:setColor(0, 0, 0)

  self.control_inputs = {
    next = "tab",
    up = Input.Up,
    down = Input.Down,
    left = Input.Left,
    right = Input.Right
  }

  active_windows[self] = true

  return self
end

--- Gets the active windows
--- @return Dummy.Editor.Window[]
function Window.getActiveWindows()
  --- @type Dummy.Editor.Window[]
  local windows = {}
  for window in pairs(active_windows) do
    table.insert(windows, window)
  end
  return windows
end

--- Sets wether the window is visible
--- @param visible boolean
--- @param i? number
--- @param j? number
function Window:setVisible(visible, i, j)
  Mask.setVisible(self, visible)

  self:resetScroll()

  for _, elements in ipairs(self.elements) do
    for _, element in ipairs(elements) do
      local tooltip = element:getTooltip()
      if tooltip ~= nil then
        tooltip:setVisible(false)
      end
    end
  end

  if visible then
    self:focus(i, j)
  else
    self:unfocus()
  end
end

--- Sets the window's width
--- @param width number
function Window:setWidth(width)
  self.width = width
end

--- Sets the window's height
--- @param height number
function Window:setHeight(height)
  self.height = height
end

--- Gets the window's virtual width
--- @return number
function Window:getVirtualWidth()
  local width = 0
  local padding = self:getPadding()
  for _, child in ipairs(self.container:getChildren()) do
    width = math.max(width, child:getRight() + padding[2])
  end
  return width
end

--- Gets the window's virtual height
--- @return number
function Window:getVirtualHeight()
  local height = 0
  local padding = self:getPadding()
  for _, child in ipairs(self.container:getChildren()) do
    height = math.max(height, child:getBottom() + padding[3])
  end
  return height
end

--- Gets the window's visible width
--- @return number
function Window:getVisibleWidth()
  local x = self:getAbsolutePosition()
  return math.min(self:getWidth(), Constants.WORLD_WIDTH - x)
end

--- Gets the window's visible height
--- @return number
function Window:getVisibleHeight()
  local _, y = self:getAbsolutePosition()
  return math.min(self:getHeight(), Constants.WORLD_HEIGHT - y)
end

--- Gets the window's scroll width
--- @return number
function Window:getScrollWidth()
  local virtual_width = self:getVirtualWidth()
  if virtual_width < self:getVisibleWidth() then return 0 end
  return self:getVisibleWidth() - virtual_width
end

--- Gets the window's scroll height
--- @return number
function Window:getScrollHeight()
  local virtual_height = self:getVirtualHeight()
  if virtual_height < self:getVisibleHeight() then return 0 end
  return self:getVisibleHeight() - virtual_height
end

--- Wether the window can be scrolled
--- @return boolean
function Window:canScroll()
  local Select = require("editor.ui.select")
  for _, elements in ipairs(self.elements) do
    for _, element in ipairs(elements) do
      if element:is(Select) then
        local select = element --[[@as Dummy.Editor.Select]]
        if select:isOpen() then
          return false
        end
      end
    end
  end
  return true
end

--- Scrolls the window
--- @param delta_x number
--- @param delta_y number
--- @param absolute? boolean
function Window:scroll(delta_x, delta_y, absolute)
  if not self:canScroll() then return end

  local padding = self:getPadding()
  local container_x, container_y = self.container:getPosition()
  local scroll_x, scroll_y = delta_x, delta_y

  if absolute ~= true then
    scroll_x = container_x + delta_x
    scroll_y = container_y + delta_y
  end

  scroll_x = math.round(math.clamp(scroll_x, self:getScrollWidth(), padding[4]))
  scroll_y = math.round(math.clamp(scroll_y, self:getScrollHeight(), padding[1]))
  self.container:setPosition(scroll_x, scroll_y)
end

--- Resets the window's scroll
function Window:resetScroll()
  local padding = self:getPadding()
  self.container:setPosition(padding[4], padding[1])
end

--- Sets the window's padding
--- @overload fun(self: Dummy.Editor.Window, padding: [number, number, number, number])
--- @param padding_top number
--- @param padding_right number
--- @param padding_bottom number
--- @param padding_left number
function Window:setPadding(padding_top, padding_right, padding_bottom, padding_left)
  if type(padding_top) == "table" then
    padding_left = padding_top[1]
    padding_right = padding_top[2]
    padding_bottom = padding_top[3]
    padding_top = padding_top[4]
  end

  self.padding[1] = padding_top
  self.padding[2] = padding_right
  self.padding[3] = padding_bottom
  self.padding[4] = padding_left
end

--- Gets the window's padding
--- @return [number, number, number, number]
function Window:getPadding()
  return table.copy(self.padding)
end

--- Adds a child to the window
--- @param child Dummy.Drawable
function Window:addChild(child)
  if child == self then return end

  if child == self.container then
    Mask.addChild(self, child)
  else
    self.container:addChild(child)
  end
end

--- Wether the window has one of its element focused
--- @return boolean
function Window:isFocused()
  if not self:isVisible() then return false end

  for _, elements in ipairs(self.elements) do
    for _, element in ipairs(elements) do
      if element:isFocused() then
        return true
      end
    end
  end
  return false
end

--- Gets the window's focusable UI element at the given index
--- @param i number
--- @param j number
--- @return Dummy.Editor.Button|nil
function Window:getUIElement(i, j)
  if i < 1 or i > #self.elements then return end
  if j < 1 or j > #self.elements[i] then return end

  return self.elements[i][j]
end

--- Gets the window's focusable UI elements
--- @return Dummy.Editor.Button[][]
function Window:getUIElements()
  return table.copy(self.elements)
end

--- Sets the window's focusable UI elements
--- @param elements Dummy.Editor.Button[][]
--- @param focus_element_hover? boolean wether to focus element on hover (Defaults to `false`)
function Window:setUIElements(elements, focus_element_hover)
  self.elements = elements

  local nil_elements = 0
  if focus_element_hover == true then
    for i, els in ipairs(elements) do
      nil_elements = 0
      for j, element in ipairs(els) do
        if element == nil then
          nil_elements = nil_elements + 1
        else
          local on_pointer_enter = element.onPointerEnter
          function element.onPointerEnter()
            self:focus(i, j)

            if type(on_pointer_enter) == "function" then
              on_pointer_enter(element)
            end
          end
        end
      end
      assert(nil_elements < #els, "A line cannot contains only nil elements")
    end
  end
end

--- Gets the focused UI element index
--- @return number, number
function Window:getFocusedIndex()
  for i, elements in ipairs(self.elements) do
    for j, element in ipairs(elements) do
      if element:isFocused() then
        return i, j
      end
    end
  end

  return 1, 1
end

--- Focuses the specific UI element
--- @param i number
--- @param j number
--- @param init? boolean wether to init the focus (Defaults to `false`)
function Window:focusAt(i, j, init)
  if #self.elements <= 0 then return end

  if i < 1 then
    i = #self.elements
  elseif i > #self.elements then
    i = 1
  end
  if j < 1 then
    j = #self.elements[i]
  elseif j > #self.elements[i] then
    j = 1
  end

  local element = self.elements[i][j]
  if element == nil or not element:is(Button) then return end

  local prev_index_i, prev_index_j = self:getFocusedIndex()
  local prev_element = self.elements[prev_index_i][prev_index_j]
  if not init and prev_element == element then return end

  if prev_element ~= nil then
    prev_element:setFocused(false)
  end

  element:setFocused(true)

  local left = element:getLeft()
  local right = element:getRight()
  local visible_width = self:getVisibleWidth()
  local container_x = self.container:getPosition()
  local delta_x = math.min(visible_width - right - container_x, math.max(-left - container_x, 0))
  if element:getWidth() > self:getVisibleWidth() then
    delta_x = 0
  end

  local top = element:getTop()
  local bottom = element:getBottom()
  local visible_height = self:getVisibleHeight()
  local _, container_y = self.container:getPosition()
  local delta_y = math.min(visible_height - bottom - container_y, math.max(-top - container_y, 0))
  if element:getHeight() > self:getVisibleHeight() then
    delta_y = 0
  end

  if delta_x == 0 and delta_y == 0 then return end

  self:scroll(delta_x, delta_y)
end

--- Focuses the next element
function Window:focusNext()
  local i, j = self:getFocusedIndex()
  if j + 1 > #self.elements[i] then
    self:focusAt(i + 1, 1)
  else
    self:focusAt(i, j + 1)
  end
end

--- Focuses the previous element
function Window:focusPrevious()
  local i, j = self:getFocusedIndex()
  if j - 1 < 1 then
    if i - 1 < 1 then
      self:focusAt(#self.elements, #self.elements[#self.elements])
    else
      self:focusAt(i - 1, #self.elements[i - 1])
    end
  else
    self:focusAt(i, j - 1)
  end
end

--- Focuses the window
--- @param i? number
--- @param j? number
function Window:focus(i, j)
  if not self:isVisible() then return end

  for window in pairs(active_windows) do
    window:unfocus()
  end

  self.next_focus_timer = Timer.next(function()
    self:focusAt(i or 1, j or 1, true)
  end)
end

--- Unfocuses the window
function Window:unfocus()
  if self.next_focus_timer ~= nil then
    Timer.cancel(self.next_focus_timer)
  end

  for _, elements in ipairs(self.elements) do
    for _, element in ipairs(elements) do
      if element:isFocused() then
        element:setFocused(false)
      end
    end
  end
end

--- Gets the control inputs
--- @return Dummy.Editor.Window.Inputs
function Window:getControlInputs()
  return self.control_inputs
end

--- Sets the control inputs
--- @param next? string|string[]
--- @param up? string|string[]
--- @param down? string|string[]
--- @param left? string|string[]
--- @param right? string|string[]
function Window:setControlInputs(next, up, down, left, right)
  if next ~= nil then
    self.control_inputs.next = next
  end
  if up ~= nil then
    self.control_inputs.up = up
  end
  if down ~= nil then
    self.control_inputs.down = down
  end
  if left ~= nil then
    self.control_inputs.left = left
  end
  if right ~= nil then
    self.control_inputs.right = right
  end
end

--- Called when the window is removed from the scene
function Window:onRemoved()
  active_windows[self] = nil
end

--- Draws to the window's mask
function Window:drawMask()
  love.graphics.rectangle("fill", 0, 0, self:getVisibleWidth(), self:getVisibleHeight())
end

--- Draws the window
--- @param camera Dummy.Camera
function Window:draw(camera)
  if not self:isVisible() then return end

  love.graphics.push()

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getVisibleWidth(), self:getVisibleHeight()
  local origin_x, origin_y = self:getOrigin()
  local x, y = -width * origin_x, -height * origin_y
  -- background
  love.graphics.setColor(self:getColor())
  love.graphics.rectangle("fill", x, y, width, height)
  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", x - 0.5, y - 0.5, width + 1, height + 1)

  love.graphics.pop()

  Mask.draw(self, camera)
end

--- Updates the window, called on every frame
--- @param dt number
function Window:update(dt)
  if not self:isVisible() then return end

  local cursor_x, cursor_y = Cursor:getPosition()
  local abs_x, abs_y = self:getAbsolutePosition()
  if Utils.isPointInRect(cursor_x, cursor_y, abs_x, abs_y, self:getVisibleWidth(), self:getVisibleHeight()) then
    if Input.isPressed("mouse:wheel_x_up") or (Input.isPressed("mouse:wheel_y_down") and Input.isDown("shift")) then
      self:scroll(-Window.SCROLL_DELTA, 0)
    elseif Input.isPressed("mouse:wheel_x_down") or (Input.isPressed("mouse:wheel_y_up") and Input.isDown("shift")) then
      self:scroll(Window.SCROLL_DELTA, 0)
    elseif Input.isPressed("mouse:wheel_y_up") then
      self:scroll(0, Window.SCROLL_DELTA)
    elseif Input.isPressed("mouse:wheel_y_down") then
      self:scroll(0, -Window.SCROLL_DELTA)
    end
  end

  if Input.isPressed(self.control_inputs.up) and self:isFocused() then
    local i, j = self:getFocusedIndex()
    self:focusAt(i - 1, j)
  elseif (Input.isDown("shift") and Input.isPressed(self.control_inputs.next)) and self:isFocused() then
    self:focusPrevious()
  elseif Input.isPressed(self.control_inputs.down) and self:isFocused() then
    local i, j = self:getFocusedIndex()
    self:focusAt(i + 1, j)
  elseif Input.isPressed(self.control_inputs.next) and self:isFocused() then
    self:focusNext()
  elseif Input.isPressed(self.control_inputs.left) and self:isFocused() then
    local i, j = self:getFocusedIndex()
    local focused_element = self.elements[i][j]
    if focused_element == nil or (Input.isPressed(self.control_inputs.left) and not focused_element:is(InputText)) then
      self:focusAt(i, j - 1)
    end
  elseif Input.isPressed(self.control_inputs.right) and self:isFocused() then
    local i, j = self:getFocusedIndex()
    local focused_element = self.elements[i][j]
    if focused_element == nil or (Input.isPressed(self.control_inputs.right) and not focused_element:is(InputText)) then
      self:focusAt(i, j + 1)
    end
  end

  Mask.update(self, dt)
end

return Window
