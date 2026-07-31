--[[
  Generated from ..\engine\world\menu\save_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/save_menu.lua
]]

---@meta

--- @class Dummy.SaveMenu : Dummy.Drawable
---
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_text Dummy.Text
--- @field protected playtime_text Dummy.Text
--- @field protected room_name_text Dummy.Text
--- @field protected save_action_text Dummy.Text
--- @field protected return_action_text Dummy.Text
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected saved boolean
--- @field protected action_index integer
--- @field protected total_actions integer
SaveMenu = {}

--- Creates a save menu
--- @return Dummy.SaveMenu
function SaveMenu:new() end

--- Updates the save menu's position
function SaveMenu:updatePosition() end

--- Updates the save menu's texts
function SaveMenu:updateTexts() end

--- Changes the selected action
--- @param delta integer
function SaveMenu:changeAction(delta) end

--- Updates the heart position to the current action
function SaveMenu:updateHeartPosition() end

--- Loads the save data
--- @return Dummy.Mod.Config.Savepoint
function SaveMenu:loadSavepointData() end

--- Saves the current progress
function SaveMenu:save() end

--- Opens the save menu
function SaveMenu:open() end

--- Closes the save menu
function SaveMenu:close() end

--- Draws the save menu
--- @param camera Dummy.Camera
function SaveMenu:draw(camera) end

--- Updates the save menu, called on every game update
--- @param dt number
function SaveMenu:update(dt) end

