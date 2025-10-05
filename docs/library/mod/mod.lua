--[[
  Generated from ..\engine\mod\mod.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/mod/mod.lua
]]

---@meta

--- @class Dummy.Mod : Dummy.Class
---
--- @field protected id string
--- @field protected name string
--- @field protected version string
--- @field protected title Dummy.Text.Text|nil
--- @field protected standalone boolean
--- @field protected config table<string, any>
Mod = {}

--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title Dummy.Text.Text|nil
--- @field version string|nil
--- @field standalone boolean|nil

--- Gets the class name
--- @return string
function Mod.getClassName() end

--- Gets the mod's id
--- @return string
function Mod:getId() end

--- Gets the mod's name
--- @return string
function Mod:getName() end

--- Gets the mod's version
--- @return string
function Mod:getVersion() end

--- Gets the mod's title
--- @return Dummy.Text.Text|nil
function Mod:getTitle() end

--- Gets the mod's title
--- @param title string
function Mod:setTitle(title) end

--- Gets the mod's config
--- @return table<string, any>
function Mod:getConfig() end

--- Called when the mod is loading
function Mod:load() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

--- Called on every game update
--- @param dt number
function Mod:update(dt) end

--- Called when the encounter state changes
--- @param current_state string
--- @param previous_state string
function Mod:onStateChange(current_state, previous_state) end

--- Called when an enemy is selected for attack
--- @param enemy Dummy.Enemy|nil
function Mod:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
--- @param enemy Dummy.Enemy|nil
function Mod:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function Mod:onEncounterTextEnd() end

--- Called when all enemy dialogues are done
function Mod:onEnemyDialoguesEnd() end

--- Called when the defending phase is done
function Mod:onDefendingEnd() end

--- Called when the player is fleeing
function Mod:onFlee() end

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data) end

