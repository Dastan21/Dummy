--[[
  Generated from ..\engine\world\menu\player_item_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/player_item_menu.lua
]]

---@meta

--- @class Dummy.PlayerItemMenu : Dummy.Drawable
---
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected closing boolean
--- @field protected item_index integer
--- @field protected item_action_index integer
--- @field protected item_selected_index integer|nil
--- @field protected item_name_texts Dummy.Text[]
PlayerItemMenu = {}

--- Creates a player item menu
--- @return Dummy.PlayerItemMenu
function PlayerItemMenu:new() end

--- Opens the player item menu
function PlayerItemMenu:open() end

--- Closes the player item menu
function PlayerItemMenu:close() end

--- Cleans the player item menu
function PlayerItemMenu:clean() end

--- Changes the selected item
--- @param delta integer
function PlayerItemMenu:changeItem(delta) end

--- Changes the selected action for the selected item
--- @param delta integer
function PlayerItemMenu:changeItemAction(delta) end

--- Updates the player item menu's heart position
function PlayerItemMenu:updateHeartPosition() end

--- Selects the item to which do actions
function PlayerItemMenu:selectItem() end

--- Does an action on the selected item
function PlayerItemMenu:doActionOnSelectItem() end

--- Draws the player item menu
--- @param camera Dummy.Camera
function PlayerItemMenu:draw(camera) end

--- Updates the player item menu, called on every game update
--- @param dt number
function PlayerItemMenu:update(dt) end

