--[[
  Generated from ..\engine\editor\ui\keybinds_window.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/keybinds_window.lua
]]

---@meta

Window = {}

--- @class Dummy.Editor.KeybindGroup
---
--- @field id Dummy.Text.Text
--- @field keybinds Dummy.Editor.Keybind[]

--- @class Dummy.Editor.Keybind
---
--- @field id Dummy.Text.Text
--- @field key string

--- Creates a keybinds window
--- @return Dummy.Editor.KeybindsWindow
function KeybindsWindow:new() end

--- Initializes the keybinds window
function KeybindsWindow:initKeybindsWindow() end

--- Called when the keybinds window is closed
function KeybindsWindow:onClose() end

--- Updates the keybinds window, called on every frame
--- @param dt number
function KeybindsWindow:update(dt) end

