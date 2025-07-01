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
--- @field protected chars Dummy.Text.Char[]
--- @field protected width number
--- @field protected height number
Text = {}

--- @alias Dummy.Text.Text string|table|fun(): string|table
--- @alias Dummy.Text.Align "left" | "center" | "right"

--- @class Dummy.Text.Char
---
--- @field char string
--- @field font love.Font|nil
--- @field color love.Color|nil

--- Gets the class name
--- @return string
function Text:getClass() end

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText() end

--- Sets the text's value
--- @param value Dummy.Text.Text
function Text:setText(value) end

--- Gets the text's wrapped value
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Text
function Text:getWrappedText(value) end

--- Gets the text's width
--- @return number
function Text:getWidth() end

--- Gets the text's height
--- @return number
function Text:getHeight() end

--- Sets the text's color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a) end

--- Gets the text's font
--- @return love.Font
function Text:getFont() end

--- Sets the text's font
--- @param font love.Font
function Text:setFont(font) end

--- Gets the text's max width
--- @return number
function Text:getMaxWidth() end

--- Sets the text's max width
--- @param max_width number
function Text:setMaxWidth(max_width) end

--- Gets the text's align
--- @return Dummy.Text.Align
function Text:getAlign() end

--- Sets the text's align
--- @param align Dummy.Text.Align
function Text:setAlign(align) end

--- Sets the text's alpha
--- @param alpha number
function Text:setAlpha(alpha) end

--- Gets the text's characters
--- @return Dummy.Text.Char[]
function Text:getCharacters() end

--- Gets the text's line width
--- @param line number
--- @return number
function Text:getLineWidth(line) end

--- Draws the text
function Text:draw() end

--- Initialize the text
function Text:init() end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value) end

