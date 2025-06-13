--[[
  Generated from ..\engine\encounter\action_menu.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/action_menu.lua
]]

---@meta

--- @class Dummy.Encounter.ActionMenu : Dummy.Class
---
--- @field protected options Dummy.Menu.Option[]
--- @field protected indexes_x number[][]
--- @field protected indexes_y number[][]
--- @field protected index_x number
--- @field protected index_y number
--- @field protected direction "horizontal"|"vertical"
--- @field protected pagination boolean
--- @field protected onBack fun(i: number)|nil
--- @field protected page_text Dummy.Text
--- @field protected active boolean
ActionMenu = {}

--- Gets the class name
--- @return string
function ActionMenu:getClass() end

--- Selects an option
--- @param index_x number horizontal index
--- @param index_y number vertical index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function ActionMenu:select(index_x, index_y, silent) end

--- Moves cursor option
--- @param delta_x number
--- @param delta_y number
function ActionMenu:move(delta_x, delta_y) end

--- Selects an option by index
--- @param index number options index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function ActionMenu:selectByIndex(index, silent) end

function ActionMenu:fillIndexes() end

--- Shows the menu
function ActionMenu:show() end

--- Hides the menu
function ActionMenu:hide() end

--- Gets the number of options
--- @return number
function ActionMenu:getSize() end

--- Wether all the options are disabled
--- @return boolean
function ActionMenu:allDisabled() end

--- Gets an option
--- @param index_x number
--- @param index_y number
--- @return Dummy.Menu.Option
function ActionMenu:getOption(index_x, index_y) end

--- Gets the selected option
--- @return Dummy.Menu.Option
function ActionMenu:getSelectedOption() end

--- Gets the option index
--- @param index_x number
--- @param index_y number
--- @return number
function ActionMenu:getOptionIndex(index_x, index_y) end

--- Gets the selected option index
--- @return number
function ActionMenu:getSelectedOptionIndex() end

--- Gets the grid indexes by option index
--- @param index number
function ActionMenu:getIndexesByOptionIndex(index) end

--- Gets an option by its index
--- @param index number
--- @return Dummy.Menu.Option
function ActionMenu:getOptionByIndex(index) end

--- Gets the max x option index
--- @return number
--- @protected
function ActionMenu:getMaxX() end

--- Gets the max y option index
--- @return number
--- @protected
function ActionMenu:getMaxY() end

--- Wether the menu is active
--- @return boolean
function ActionMenu:isActive() end

--- Sets wether the menu is active
--- @param active boolean
function ActionMenu:setActive(active) end

--- Initializes the menu options
function ActionMenu:init() end

--- Updates the menu
function ActionMenu:update() end

--- Creates an action menu
--- @param options Dummy.Menu.Option[]
--- @param direction? "horizontal"|"vertical"
--- @param pagination? boolean
--- @param onBack? fun(i: number)
--- @return Dummy.Encounter.ActionMenu
function ActionMenu:new(options, direction, pagination, onBack) end

