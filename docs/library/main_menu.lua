--[[
  Generated from ..\engine\main_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/main_menu.lua
]]

---@meta

--- @class Dummy.MainMenu : Dummy.Class
---
--- @field protected options Dummy.Menu.Options
--- @field protected onBack fun()|nil
MainMenu = {}

--- @alias Dummy.Menu.Options Dummy.Menu.Option[]

--- @class Dummy.Menu.Option
---
--- @field id string|nil unique identifier
--- @field text Dummy.Text text to display
--- @field action fun(self: Dummy.Menu.Option)|nil callback when the option is confirmed
--- @field draw fun(self: Dummy.Menu.Option)|nil draw along the option
--- @field drawable Dummy.Drawable|nil option drawable created from `option.draw`
--- @field disabled boolean|nil wether the option is disabled
--- @field silent boolean|nil wether the option is silent
--- @field selected boolean|nil wether the option is selected
--- @field menu Dummy.MainMenu|nil sub menu

--- Gets the class name
--- @return string
function MainMenu.getClassName() end

--- Select a menu option
--- @param index number options index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function MainMenu:select(index, silent) end

--- Shows the menu
function MainMenu:show() end

--- Hides the menu
function MainMenu:hide() end

--- Sets the menu options
--- @param options Dummy.Menu.Option[]
function MainMenu:setOptions(options) end

--- Gets the menu options
--- @return Dummy.Menu.Option[]
function MainMenu:getOptions() end

--- Gets the selected option
--- @return Dummy.Menu.Option
function MainMenu:getSelectedOption() end

--- Gets a meny option by id
--- @param id string
--- @return Dummy.Menu.Option|nil
function MainMenu:getOptionById(id) end

--- Initializes the menu options
function MainMenu:init() end

--- Updates the menu
function MainMenu:update() end

--- Creates a menu
--- @param options Dummy.Menu.Options
--- @param onBack? fun()
function MainMenu:new(options, onBack) end

