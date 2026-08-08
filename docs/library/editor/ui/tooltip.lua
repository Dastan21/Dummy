--[[
  Generated from ..\engine\editor\ui\tooltip.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/tooltip.lua
]]

---@meta

--- @class Dummy.Editor.Tooltip : Dummy.Drawable
---
--- @field protected target Dummy.Drawable
--- @field protected background Dummy.Drawable
--- @field protected text Dummy.Text
--- @field protected direction Dummy.Editor.Tooltip.Direction
--- @field protected offset number
Tooltip = {}

--- @alias Dummy.Editor.Tooltip.Direction "top" | "bottom" | "left" | "right"

--- Creates a tooltip
--- @param target Dummy.Drawable
--- @return Dummy.Editor.Tooltip
function Tooltip:new(target) end

--- Gets the tooltip's width
--- @return number
function Tooltip:getWidth() end

--- Gets the tooltip's height
--- @return number
function Tooltip:getHeight() end

--- Gets the tooltip's target
--- @return Dummy.Drawable
function Tooltip:getTarget() end

--- Sets the tooltip's target
--- @param target Dummy.Drawable
function Tooltip:setTarget(target) end

--- Gets the tooltip's text
--- @return Dummy.Text.Text
function Tooltip:getText() end

--- Sets the tooltip's text
--- @param text? Dummy.Text.Text
function Tooltip:setText(text) end

--- Gets the tooltip's direction
--- @return Dummy.Editor.Tooltip.Direction
function Tooltip:getDirection() end

--- Sets the tooltip's direction
--- @param direction Dummy.Editor.Tooltip.Direction
function Tooltip:setDirection(direction) end

--- Gets the tooltip's offset
--- @return number
function Tooltip:getOffset() end

--- Sets the tooltip's offset
--- @param offset number
function Tooltip:setOffset(offset) end

--- Updates the tooltip
--- @param dt number
function Tooltip:update(dt) end

