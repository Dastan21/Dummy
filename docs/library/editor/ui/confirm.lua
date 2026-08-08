--[[
  Generated from ..\engine\editor\ui\confirm.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/confirm.lua
]]

---@meta

Window = {}

--- Creates an entity window
--- @return Dummy.Editor.Confirm
function Confirm:new() end

--- Initializes the confirm modal
function Confirm:initConfirm() end

--- Opens the confirm modal
--- @param message string
--- @param confirm_text? Dummy.Text.Text
--- @param cancel_text? Dummy.Text.Text
--- @param middle_text? Dummy.Text.Text
function Confirm:open(message, confirm_text, cancel_text, middle_text) end

--- Updates the modal buttons
--- @param has_middle boolean
function Confirm:updateButtons(has_middle) end

--- Closes the confirm modal
function Confirm:close() end

--- Called when the confirm modal is canceled
function Confirm:onCancel() end

--- Called when the confirm modal is confirmed
--- @param button_index number
function Confirm:onConfirm(button_index) end

--- Called when the middle button modal is pressed
function Confirm:onMiddle() end

--- Called when the confirm modal is closed
function Confirm:onClose() end

--- Updates the confirm modal
function Confirm:update(dt) end

