--[[
  Generated from ..\engine\drawable\text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/text.lua
]]

---@meta

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text Dummy.Text.Text
--- @field protected font love.Font
--- @field protected max_width number
--- @field protected align Dummy.Text.Align
--- @field protected sprite love.Text
Text = {}

--- @alias Dummy.Text.Text string|table|fun(): string|table
--- @alias Dummy.Text.Align "left" | "center" | "right" | "justify"

--- Gets the class name
--- @return string
function Text:getClass() end

--- Gets the text value
--- @return Dummy.Text.Text
function Text:getText() end

--- Sets the text value
--- @param value Dummy.Text.Text
function Text:setText(value) end

--- Updates the text sprite value
--- @protected
function Text:updateText() end

--- Sets the text color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a) end

--- Gets the text font
--- @return love.Font
function Text:getFont() end

--- Sets the text font
--- @param font love.Font
function Text:setFont(font) end

--- Gets the text max width
--- @return number
function Text:getMaxWidth() end

--- Sets the text max width
--- @param max_width number
function Text:setMaxWidth(max_width) end

--- Gets the text align
--- @return Dummy.Text.Align
function Text:getAlign() end

--- Sets the text align
--- @param align Dummy.Text.Align
function Text:setAlign(align) end

--- Sets the text alpha
--- @param alpha number
function Text:setAlpha(alpha) end

--- Gets the text sprite
--- @return love.Text
function Text:getSprite() end

--- Draws the text
function Text:draw() end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value) end

