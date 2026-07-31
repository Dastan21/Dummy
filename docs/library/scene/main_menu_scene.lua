--[[
  Generated from ..\engine\scene\main_menu_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/main_menu_scene.lua
]]

---@meta

--- @class Dummy.Scene.MainMenu : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected options Dummy.Menu.Options
--- @field protected current_menu Dummy.MainMenu
--- @field protected settings_menu Dummy.MainMenu
--- @field protected reset_save_menu Dummy.MainMenu
--- @field protected reset_selected_save_menu Dummy.MainMenu
--- @field protected reset_selected_save_mod string
--- @field protected mod_list_menu Dummy.MainMenu
--- @field protected logo_sprite Dummy.Sprite
--- @field protected credits_text Dummy.Text
--- @field protected background_sprite Dummy.Sprite
--- @field protected menu_music love.Source
--- @field protected was_fullscreen boolean
--- @field protected input_hold_time number
--- @field protected input_hold_delay number
MainMenuScene = {}

--- Loads the main menu
function MainMenuScene.load() end

--- Loads menus
function MainMenuScene.loadMenus() end

--- Loads main menu
function MainMenuScene.loadMainMenu() end

--- Loads settings menu
function MainMenuScene.loadSettingsMenu() end

--- Loads reset save menu
function MainMenuScene.loadResetSavesMenu() end

--- Loads reset selected save menu
function MainMenuScene.loadResetSelectedSaveMenu() end

--- Loads mod list menu
function MainMenuScene.loadModListMenu() end

--- Gets the mods savepoints
--- @return { id: string, name: string }[]
function MainMenuScene.getModsSavepoints() end

--- Changes menu
--- @param new_menu Dummy.MainMenu
--- @param index? integer
function MainMenuScene.changeMenu(new_menu, index) end

--- Sets the logo sprite
--- @param sprite_name string
function MainMenuScene.setLogo(sprite_name) end

--- Sets the background sprite
--- @param sprite_name string
function MainMenuScene.setBackground(sprite_name) end

--- Sets the menu music
--- @param music_name string
function MainMenuScene.setMenuMusic(music_name) end

--- Updates the main menu, called on every game update
--- @param dt number
function MainMenuScene.update(dt) end

