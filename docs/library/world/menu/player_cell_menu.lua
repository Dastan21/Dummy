--[[
  Generated from ..\engine\world\menu\player_cell_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/player_cell_menu.lua
]]

---@meta

--- @class Dummy.PlayerCellMenu : Dummy.Drawable
---
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected closing boolean
--- @field protected number_index integer
--- @field protected phone_name_texts Dummy.Text[]
PlayerCellMenu = {}

--- Creates a player cell menu
--- @return Dummy.PlayerCellMenu
function PlayerCellMenu:new() end

--- Opens the player cell menu
function PlayerCellMenu:open() end

--- Closes the player cell menu
function PlayerCellMenu:close() end

--- Cleans the player cell menu
function PlayerCellMenu:clean() end

--- Changes the selected number
--- @param delta integer
function PlayerCellMenu:changeNumber(delta) end

--- Updates the player cell menu's heart position
function PlayerCellMenu:updateHeartPosition() end

--- Calls the selected number
function PlayerCellMenu:callSelectedNumber() end

--- Draws the player cell menu
--- @param camera Dummy.Camera
function PlayerCellMenu:draw(camera) end

--- Updates the player cell menu, called on every game update
--- @param dt number
function PlayerCellMenu:update(dt) end

