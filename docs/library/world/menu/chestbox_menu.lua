--[[
  Generated from ..\engine\world\menu\chestbox_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/menu/chestbox_menu.lua
]]

---@meta

--- @class Dummy.ChestboxMenu : Dummy.Drawable
---
--- @field protected inventory_text Dummy.Text
--- @field protected box_text Dummy.Text
--- @field protected hint_close_text Dummy.Text
--- @field protected heart_sprite Dummy.Sprite
--- @field protected twin_bars_drawable Dummy.Drawable
--- @field protected player_items_texts Dummy.Text[]
--- @field protected box_items_texts Dummy.Text[]
--- @field protected list Dummy.Item[]
--- @field protected on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @field protected on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
--- @field protected opening boolean
--- @field protected cursor_i integer
--- @field protected cursor_j integer
ChestboxMenu = {}

--- Creates a chestbox menu
--- @return Dummy.ChestboxMenu
function ChestboxMenu:new() end

--- Updates the chestbox menu's position
function ChestboxMenu:updatePosition() end

--- Updates the chestbox menu's texts
function ChestboxMenu:updateTexts() end

--- Changes the selected action
--- @param delta_x integer
--- @param delta_y integer
function ChestboxMenu:changeCursor(delta_x, delta_y) end

--- Swaps the item in the chestbox
function ChestboxMenu:swapItem() end

--- Called when an item is added to the chestbox
--- @param item Dummy.Item
function ChestboxMenu:onAdd(item) end

--- Called when an item is added to the chestbox
--- @param index integer
function ChestboxMenu:onRemove(index) end

--- Updates the heart position to the current action
function ChestboxMenu:updateHeartPosition() end

--- Opens the chestbox menu
--- @param list Dummy.Item[]
--- @param on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @param on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
function ChestboxMenu:open(list, on_add, on_remove) end

--- Closes the chestbox menu
function ChestboxMenu:close() end

--- Draws the chestbox menu
--- @param camera Dummy.Camera
function ChestboxMenu:draw(camera) end

--- Updates the chestbox menu, called on every game update
--- @param dt number
function ChestboxMenu:update(dt) end

