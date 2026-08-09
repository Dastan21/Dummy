--[[
  Generated from ..\engine\editor\ui\input_text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/input_text.lua
]]

---@meta

Button = {}

--- Creates an input
--- @param value? string
--- @return Dummy.Editor.InputText
function InputText:new(value) end

--- Gets the input's value
--- @return string
function InputText:getValue() end

--- Sets the input's value
--- @param value string
function InputText:setValue(value) end

--- Updates the input's dimensions
function InputText:updateDimensions() end

--- Updates the input's displayed text
function InputText:updateDisplayedText() end

--- Gets the input text's height
--- @return number
function InputText:getHeight() end

--- Gets the input's max characters, `0` for no limit
--- @return number
function InputText:getMaxCharacters() end

--- Sets the input's max characters, `0` for no limit
--- @param max_characters number
function InputText:setMaxCharacters(max_characters) end

--- Gets the input's placeholder
--- @return Dummy.Text.Text
function InputText:getPlaceholder() end

--- Sets the input's placeholder
--- @param placeholder Dummy.Text.Text
function InputText:setPlaceholder(placeholder) end

--- Gets the input's min width
--- @return number
function InputText:getMinWidth() end

--- Sets the input's min width
--- @param min_width number
function InputText:setMinWidth(min_width) end

--- Gets the input's padding
--- @return number
function InputText:getPadding() end

--- Sets the input's padding
--- @param padding number
function InputText:setPadding(padding) end

--- Sets wether the input is disabled
--- @param disabled boolean
function InputText:setDisabled(disabled) end

--- Sets wether the input is focused
--- @param focused boolean
function InputText:setFocused(focused) end

--- Sets the input's caret
--- @param index number
function InputText:setCaret(index) end

--- Sets the input's filter function
--- @param filter fun(v: string): string|nil a function to filter the input's value
function InputText:setFilter(filter) end

--- Called when the input is removed
function InputText:onRemoved() end

--- Called when the input is focused
function InputText:onFocus() end

--- Called when the input is unfocused
function InputText:onBlur() end

--- Called when the input's value has changed
--- @param value string
function InputText:onInput(value) end

--- Updates the input, called on every frame
--- @param dt number
function InputText:update(dt) end

