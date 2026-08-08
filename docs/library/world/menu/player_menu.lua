--[[
  Generated from ..\engine\world\menu\player_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/player_menu.lua
]]

---@meta

PlayerItemMenu = {}

--- Creates a player menu
--- @return Dummy.PlayerMenu
function PlayerMenu:new() end

--- Updates the player menu's position
function PlayerMenu:updatePosition() end

--- Updates the player menu's texts
function PlayerMenu:updateTexts() end

--- Changes the selected action
--- @param delta integer
function PlayerMenu:changeAction(delta) end

--- Updates the heart position to the current action
function PlayerMenu:updateHeartPosition() end

--- Opens the selected action submenu
function PlayerMenu:openSubmenu() end

--- Opens the player menu
function PlayerMenu:open() end

--- Closes the player menu
function PlayerMenu:close() end

--- Wether the player menu has focus
--- @return boolean
function PlayerMenu:hasFocus() end

--- Draws the player menu
--- @param camera Dummy.Camera
function PlayerMenu:draw(camera) end

--- Updates the player menu, called on every game update
--- @param dt number
function PlayerMenu:update(dt) end

