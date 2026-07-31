--[[
  Generated from ..\engine\world\menu\player_stat_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/player_stat_menu.lua
]]

---@meta

--- @class Dummy.PlayerStatMenu : Dummy.Drawable
---
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_text Dummy.Text
--- @field protected player_hp_text Dummy.Text
--- @field protected player_at_text Dummy.Text
--- @field protected player_df_text Dummy.Text
--- @field protected player_weapon_text Dummy.Text
--- @field protected player_armor_text Dummy.Text
--- @field protected player_gold_text Dummy.Text
--- @field protected player_exp_text Dummy.Text
--- @field protected player_next_text Dummy.Text
--- @field protected closing boolean
PlayerStatMenu = {}

--- Creates a player stat menu
--- @return Dummy.PlayerStatMenu
function PlayerStatMenu:new() end

--- Updates the save menu's texts
function PlayerStatMenu:updateTexts() end

--- Opens the player stat menu
function PlayerStatMenu:open() end

--- Closes the player stat menu
function PlayerStatMenu:close() end

--- Draws the player stat menu
--- @param camera Dummy.Camera
function PlayerStatMenu:draw(camera) end

--- Updates the player stat menu, called on every game update
--- @param dt number
function PlayerStatMenu:update(dt) end

