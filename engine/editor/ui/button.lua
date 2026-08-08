local Tooltip = require "editor.ui.tooltip"

--- @class Dummy.Editor.Button.Inputs
---
--- @field confirm string|string[]
--- @field escape string|string[]

--- @class Dummy.Editor.Button : Dummy.Drawable
---
--- @field protected width number|nil
--- @field protected height number|nil
--- @field protected sprite Dummy.Sprite|nil
--- @field protected text Dummy.Text|nil
--- @field protected tooltip Dummy.Editor.Tooltip|nil
--- @field protected base_color love.Color
--- @field protected hover_color love.Color
--- @field protected border number
--- @field protected border_color love.Color
--- @field protected hovered boolean
--- @field protected pressed boolean
--- @field protected focused boolean
--- @field protected unfocus boolean
--- @field protected disabled boolean
--- @field protected control_inputs Dummy.Editor.Button.Inputs
local Button = Class(Drawable, "Dummy.Editor.Button")

--- Creates a button
--- @return Dummy.Editor.Button
function Button:new()
  self = Class:new(Button)

  self:setLayer(Constants.LAYERS.UI)
  self:setColor(0, 0, 0)
  self:setTag("UI")

  self.hover_color = { 0.2, 0.2, 0.2, 1 }
  self.border = 1
  self.border_color = { 1, 1, 1, 1 }

  self.hovered = false
  self.pressed = false
  self.focused = false
  self.unfocus = false
  self.disabled = false

  self.control_inputs = {
    confirm = Input.Confirm,
    escape = Input.Escape,
  }

  return self
end

--- Gets the button's width
--- @return number
function Button:getWidth()
  if self.width ~= 0 then
    return self.width
  elseif self.sprite ~= nil then
    return self.sprite:getWidth()
  elseif self.text ~= nil then
    return self.text:getWidth()
  end

  return 0
end

--- Sets the button's width
--- @param width number
function Button:setWidth(width)
  self.width = width
end

--- Gets the button's height
--- @return number
function Button:getHeight()
  if self.height ~= 0 then
    return self.height
  elseif self.sprite ~= nil then
    return self.sprite:getHeight()
  elseif self.text ~= nil then
    return self.text:getHeight()
  end

  return 0
end

--- Sets the button's height
--- @param height number
function Button:setHeight(height)
  self.height = height
end

--- Gets the button's sprite
function Button:getSprite()
  return self.sprite
end

--- Sets the button's sprite
--- @param sprite Dummy.Sprite
function Button:setSprite(sprite)
  if self.text ~= nil then
    self.text:remove()
    self.text = nil
  end

  self.sprite = sprite
  sprite:setParent(self)
end

--- Gets the button's text
--- @return Dummy.Text
function Button:getText()
  return self.text
end

--- Sets the button's text
--- @param text Dummy.Text
function Button:setText(text)
  if self.sprite ~= nil then
    self.sprite:remove()
    self.sprite = nil
  end

  self.text = text
  text:setParent(self)
  text:setFont("main_text")
end

--- Gets the button's tooltip
--- @return Dummy.Editor.Tooltip|nil
function Button:getTooltip()
  return self.tooltip
end

--- Sets the button's tooltip text
--- @param tooltip Dummy.Text.Text|nil
function Button:setTooltip(tooltip)
  if tooltip == nil then
    if self.tooltip ~= nil then
      self.tooltip:remove()
      self.tooltip = nil
    end
    return
  end

  if self.tooltip == nil then
    self.tooltip = Tooltip:new(self)
    self.tooltip:setLayer(Constants.LAYERS.CURSOR)
    self.tooltip:setVisible(false)
  end

  self.tooltip:setText(tooltip)
end

--- Sets the button's color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setColor(r, g, b, a)
  Drawable.setColor(self, r, g, b, a)

  self.base_color = self:getColor()
end

--- Gets the button's hover color
--- @return love.Color
function Button:getHoverColor()
  return table.copy(self.hover_color)
end

--- Sets the button's hover color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setHoverColor(r, g, b, a)
  if type(r) == "table" then
    a = r[4]
    b = r[3]
    g = r[2]
    r = r[1]
  end

  self.hover_color[1] = math.clamp(r, 0, 1)
  self.hover_color[2] = math.clamp(g, 0, 1)
  self.hover_color[3] = math.clamp(b, 0, 1)
  self.hover_color[4] = math.clamp(Utils.getOrDefault(a, 1), 0, 1)
end

--- Gets the button's border width
--- @return number
function Button:getBorder()
  return self.border
end

--- Sets the button's border width
--- @param border number
function Button:setBorder(border)
  self.border = border
end

--- Gets the button's border color
--- @return love.Color
function Button:getBorderColor()
  return table.copy(self.border_color)
end

--- Sets the button's border color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setBorderColor(r, g, b, a)
  if type(r) == "table" then
    a = r[4]
    b = r[3]
    g = r[2]
    r = r[1]
  end

  self.border_color[1] = math.clamp(r, 0, 1)
  self.border_color[2] = math.clamp(g, 0, 1)
  self.border_color[3] = math.clamp(b, 0, 1)
  self.border_color[4] = math.clamp(Utils.getOrDefault(a, 1), 0, 1)
end

--- Wether the button is disabled
--- @return boolean
function Button:isDisabled()
  return self.disabled
end

--- Sets wether the button is disabled
--- @param disabled boolean
function Button:setDisabled(disabled)
  self.disabled = disabled

  if disabled and self.tooltip ~= nil then
    self.tooltip:setVisible(false)
  end
end

--- Wether the button is focused
function Button:isFocused()
  return self.focused
end

--- Sets wether the button is focused
--- @param focused boolean
function Button:setFocused(focused)
  self.unfocus = false

  if self.focused == focused then return end

  self.focused = focused

  if focused then
    if type(self.onFocus) == "function" then
      self:onFocus()
    end
  else
    if type(self.onBlur) == "function" then
      self:onBlur()
    end
  end
end

--- Wether the button is hovered
--- @return boolean
function Button:isHovered()
  return self.hovered
end

--- Wether the button is pressed
--- @return boolean
function Button:isPressed()
  return self.pressed
end

--- Called when the pointer enters the button
function Button:onPointerEnter()
  if self:isDisabled() then return end

  Drawable.setColor(self, self:getHoverColor())
end

--- Called when the pointer leaves the button
function Button:onPointerLeave()
  if not self:isFocused() then
    Drawable.setColor(self, self.base_color)
  end

  Cursor.setIcon("default")
end

--- Called when the button is clicked
function Button:onClick() end

--- Called when the button is focused
function Button:onFocus()
  Drawable.setColor(self, self:getHoverColor())
end

--- Called when the button is unfocused
function Button:onBlur()
  Drawable.setColor(self, self.base_color)
end

--- Gets the control inputs
--- @return Dummy.Editor.Button.Inputs
function Button:getControlInputs()
  return self.control_inputs
end

--- Sets the control inputs
--- @param confirm? string|string[]
--- @param escape? string|string[]
function Button:setControlInputs(confirm, escape)
  if confirm ~= nil then
    self.control_inputs.confirm = confirm
  end
  if escape ~= nil then
    self.control_inputs.escape = escape
  end
end

--- Called when the button is removed from the scene
function Button:onRemoved()
  if self.tooltip ~= nil then
    self.tooltip:remove()
    self.tooltip = nil
  end
end

--- Wether the pointer is on the button within the window bounds
--- @return boolean
function Button:isPointerOnButtonWithinBounds()
  local x, y = self:getAbsolutePosition()
  local border = self:getBorder()
  local width, height = self:getWidth() + border, self:getHeight() + border
  local cursor_x, cursor_y = Cursor.getPosition()
  if not Utils.isPointInRect(cursor_x, cursor_y, x, y, width - 1, height - 1) then
    return false
  end

  local parent = self:getParent()
  if parent ~= nil then
    local Window = require "editor.ui.window"
    local grandparent = parent:getParent()
    if grandparent ~= nil and grandparent:is(Window) then
      local window = grandparent --[[@as Dummy.Editor.Window]]
      local window_x, window_y = window:getAbsolutePosition()
      local window_width, window_height = window:getVisibleWidth(), window:getVisibleHeight()
      if not Utils.isPointInRect(cursor_x, cursor_y, window_x, window_y, window_width, window_height) then
        return false
      end
    end
  end

  return true
end

--- Draws the button
--- @param camera Dummy.Camera
function Button:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getWidth(), self:getHeight()
  local origin_x, origin_y = self:getOrigin()
  local btn_x, btn_y = -width * origin_x, -height * origin_y

  -- background
  love.graphics.setColor(self:getColor())
  love.graphics.rectangle("fill", btn_x, btn_y, width, height)

  -- outline
  if self.border > 0 then
    love.graphics.setColor(self:getBorderColor())
    love.graphics.setLineWidth(self.border)
    love.graphics.rectangle("line", btn_x + 0.5, btn_y + 0.5, width - 1, height - 1)
    love.graphics.setLineWidth(1)
  end

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Draws the button's bounding box for debugging
--- @param camera Dummy.Camera
function Button:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() or not self:isVisibleOnScreen() then return end

  love.graphics.push()
  love.graphics.origin()

  love.graphics.setColor(0, 1, 1, 1)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle("rough")
  local bb = self:getBoundingBox()
  love.graphics.polygon("line",
    bb[1] + 0.5, bb[2] + 0.5,
    bb[3] - 0.5, bb[4] + 0.5,
    bb[5] - 0.5, bb[6] - 0.5,
    bb[7] + 0.5, bb[8] - 0.5
  )

  love.graphics.pop()
end

--- Updates the button
--- @param dt number
function Button:update(dt)
  Drawable.update(self, dt)

  self.pressed = false

  if not self:isVisible() then return end

  if self.unfocus then
    self:setFocused(false)
  end

  if self:isPointerOnButtonWithinBounds() then
    if not self:isDisabled() then
      Cursor.setIcon("pointer")
    end

    if self.tooltip ~= nil and not self:isDisabled() then
      self.tooltip:setVisible(true)
    end

    if not self:isHovered() then
      self.hovered = true

      if type(self.onPointerEnter) == 'function' then
        self:onPointerEnter()
      end
    end

    if Input.isPressed("mouse:left") and not self:isDisabled() then
      self.pressed = true
      self:setFocused(true)

      if type(self.onClick) == 'function' then
        self:onClick()
      end
    end
  elseif self:isHovered() then
    self.hovered = false

    Cursor.setIcon("default")

    if type(self.onPointerLeave) == 'function' then
      self:onPointerLeave()
    end

    if self.tooltip ~= nil then
      self.tooltip:setVisible(false)
    end
  end

  if self:isFocused() then
    if Input.isPressed(self.control_inputs.confirm) and type(self.onClick) == 'function' then
      self.pressed = true
      self:onClick()
    elseif Input.isPressed(self.control_inputs.escape) or (Input.isPressed("mouse:left") and not self:isHovered()) then
      self.unfocus = true
    end
  end
end

return Button
