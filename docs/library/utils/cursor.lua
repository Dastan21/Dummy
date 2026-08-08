--[[
  Generated from ..\engine\utils\cursor.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/cursor.lua
]]

---@meta

--- @class Dummy.Cursor
---
--- @field protected prev_x number
--- @field protected prev_y number
--- @field protected visible boolean
--- @field protected hidden boolean
--- @field protected icon Dummy.Cursor.Icon|string
--- @field protected sprite Dummy.Sprite
Cursor = {}

--- @alias Dummy.Cursor.Icon "default" | "pointer" | "text" | "crosshair" | "grab"

--- Loads the cursor
--- @return Dummy.Cursor
function Cursor.load() end

--- Gets the cursor's previous position
--- @return number, number
function Cursor.getPreviousPosition() end

--- Gets the cursor's position
--- @return number, number
function Cursor.getPosition() end

--- Sets the cursor's position
--- @param x number
--- @param y number
function Cursor.setPosition(x, y) end

--- Gets the cursor's visibility
--- @return boolean
function Cursor.isVisible() end

--- Sets the cursor's visibility
--- @param visible boolean
function Cursor.setVisible(visible) end

--- Shows the cursor
function Cursor.show() end

--- Hides the cursor
function Cursor.hide() end

--- Wether the cursor is hidden
--- @return boolean
function Cursor.isHidden() end

--- Sets the cursor's icon
--- @param icon Dummy.Cursor.Icon|string
function Cursor.setIcon(icon) end

