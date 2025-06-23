--[[
  Generated from ..\engine\scene\main_menu_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/main_menu_scene.lua
]]

---@meta

--- @class Dummy.Scene.MainMenu : Dummy.Scene.Scene
---
--- @field protected mod_list Dummy.ModList
--- @field protected options Dummy.Menu.Options
--- @field protected current_menu Dummy.MainMenu
--- @field protected logo_sprite Dummy.Sprite
--- @field protected credits_text Dummy.Text
--- @field protected background_sprite Dummy.Sprite
--- @field protected menu_music love.Source
main_menu = {}

--- Loads the main menu
function main_menu.load() end

--- Loads menus
function main_menu.loadMenus() end

--- Loads main menu
function main_menu.loadMainMenu() end

--- Loads settings menu
function main_menu.loadSettingsMenu() end

--- Loads mod list menu
function main_menu.loadModListMenu() end

--- Changes menu
--- @param new_menu Dummy.MainMenu
function main_menu.changeMenu(new_menu) end

--- Switches current language
function main_menu.switchLanguage() end

function main_menu.update() end

