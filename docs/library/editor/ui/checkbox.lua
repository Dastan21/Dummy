--[[
  Generated from ..\engine\editor\ui\checkbox.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/checkbox.lua
]]

---@meta

Button = {}

--- Creates a checkbox
--- @param value? boolean
--- @return Dummy.Editor.Checkbox
function Checkbox:new(value) end

--- Sets the checkbox's icons
--- @param checked string
--- @param unchecked string
function Checkbox:setIcons(checked, unchecked) end

--- Gets the checkbox's value
--- @return boolean
function Checkbox:getValue() end

--- Sets the checkbox's value
--- @param value boolean
function Checkbox:setValue(value) end

--- Toggles the checkbox's value
function Checkbox:toggle() end

--- Called when the checkbox's value has changed
function Checkbox:onChange() end

--- Updates the input, called on every frame
--- @param dt number
function Checkbox:update(dt) end

