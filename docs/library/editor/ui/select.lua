--[[
  Generated from ..\engine\editor\ui\select.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/select.lua
]]

---@meta

Button = {}

--- @class Dummy.Editor.Select.Option
---
--- @field value any
--- @field label string

--- Creates a select
--- @param options Dummy.Editor.Select.Option[]
--- @param value? any
--- @return Dummy.Editor.Select
function Select:new(options, value) end

--- Gets the select's value
--- @return any
function Select:getValue() end

--- Sets the select's value
--- @param value any
function Select:setValue(value) end

--- Updates the select's dimensions
function Select:updateDimensions() end

--- Gets the select's options
--- @return Dummy.Editor.Select.Option[]
function Select:getOptions() end

--- Sets the select's options
--- @param options Dummy.Editor.Select.Option[]
function Select:setOptions(options) end

--- Wether the select is open
--- @return boolean
function Select:isOpen() end

--- Gets the select's min width
--- @return number
function Select:getMinWidth() end

--- Sets the select's min width
--- @param min_width number
function Select:setMinWidth(min_width) end

--- Gets the select's options max width
--- @return number
function Select:getOptionsMaxWidth() end

--- Sets the select's options max width
--- @param options_max_width number
function Select:setOptionsMaxWidth(options_max_width) end

--- Gets the select's options max height
--- @return number
function Select:getOptionsMaxHeight() end

--- Sets the select's options max height
--- @param options_max_height number
function Select:setOptionsMaxHeight(options_max_height) end

--- Gets the select's padding
--- @return number
function Select:getPadding() end

--- Sets the select's padding
--- @param padding number
function Select:setPadding(padding) end

--- Called when the select is removed from the scene
function Select:onRemoved() end

--- Wether the pointer is on the select within the window bounds
--- @return boolean
function Select:isPointerOnButtonWithinBounds() end

--- Called when the select's value has changed
function Select:onChange() end

--- Updates the select, called on every frame
--- @param dt number
function Select:update(dt) end

