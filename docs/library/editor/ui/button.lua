--[[
  Generated from ..\engine\editor\ui\button.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/button.lua
]]

---@meta

Tooltip = {}

--- @class Dummy.Editor.Button.Inputs
---
--- @field confirm string|string[]
--- @field escape string|string[]

--- Creates a button
--- @return Dummy.Editor.Button
function Button:new() end

--- Gets the button's width
--- @return number
function Button:getWidth() end

--- Sets the button's width
--- @param width number
function Button:setWidth(width) end

--- Gets the button's height
--- @return number
function Button:getHeight() end

--- Sets the button's height
--- @param height number
function Button:setHeight(height) end

--- Gets the button's sprite
function Button:getSprite() end

--- Sets the button's sprite
--- @param sprite Dummy.Sprite
function Button:setSprite(sprite) end

--- Gets the button's text
--- @return Dummy.Text
function Button:getText() end

--- Sets the button's text
--- @param text Dummy.Text
function Button:setText(text) end

--- Gets the button's tooltip
--- @return Dummy.Editor.Tooltip|nil
function Button:getTooltip() end

--- Sets the button's tooltip text
--- @param tooltip Dummy.Text.Text|nil
function Button:setTooltip(tooltip) end

--- Sets the button's color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setColor(r, g, b, a) end

--- Gets the button's hover color
--- @return love.Color
function Button:getHoverColor() end

--- Sets the button's hover color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setHoverColor(r, g, b, a) end

--- Gets the button's border width
--- @return number
function Button:getBorder() end

--- Sets the button's border width
--- @param border number
function Button:setBorder(border) end

--- Gets the button's border color
--- @return love.Color
function Button:getBorderColor() end

--- Sets the button's border color
--- @overload fun(self: Dummy.Editor.Button, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
function Button:setBorderColor(r, g, b, a) end

--- Wether the button is disabled
--- @return boolean
function Button:isDisabled() end

--- Sets wether the button is disabled
--- @param disabled boolean
function Button:setDisabled(disabled) end

--- Wether the button is focused
function Button:isFocused() end

--- Sets wether the button is focused
--- @param focused boolean
function Button:setFocused(focused) end

--- Wether the button is hovered
--- @return boolean
function Button:isHovered() end

--- Wether the button is pressed
--- @return boolean
function Button:isPressed() end

--- Called when the pointer enters the button
function Button:onPointerEnter() end

--- Called when the pointer leaves the button
function Button:onPointerLeave() end

--- Called when the button is clicked
function Button:onClick() end

--- Called when the button is focused
function Button:onFocus() end

--- Called when the button is unfocused
function Button:onBlur() end

--- Gets the control inputs
--- @return Dummy.Editor.Button.Inputs
function Button:getControlInputs() end

--- Sets the control inputs
--- @param confirm? string|string[]
--- @param escape? string|string[]
function Button:setControlInputs(confirm, escape) end

--- Called when the button is removed from the scene
function Button:onRemoved() end

--- Wether the pointer is on the button within the window bounds
--- @return boolean
function Button:isPointerOnButtonWithinBounds() end

--- Draws the button
--- @param camera Dummy.Camera
function Button:draw(camera) end

--- Draws the button's bounding box for debugging
--- @param camera Dummy.Camera
function Button:drawDebug(camera) end

--- Updates the button
--- @param dt number
function Button:update(dt) end

