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
--- @field protected title string|nil
--- @field protected standalone boolean
Mod = {}

--- @class Dummy.Mod.Encounter
---
--- @field text Dummy.Text.Text|nil the encounter text
--- @field can_flee boolean|nil wether the action is displayed (Defaults to `true`)
--- @field music string|nil the encounter music (Defaults to `"battle"`)


--- @class Dummy.Mod.Enemy
---
--- @field name string
--- @field hp number|nil
--- @field at number|nil
--- @field df number|nil
--- @field xp number|nil
--- @field gold number|nil
--- @field check Dummy.Text.Text|nil
--- @field position { [1]: number, [2]: number }|nil
--- @field size { [1]: number, [2]: number }|nil


--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title string|nil
--- @field version string|nil
--- @field standalone boolean|nil


--- Gets the class name
--- @return string
function Mod:getClass() end

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
--- @return string|nil
function Mod:getTitle() end

--- Gets the mod's title
--- @param title string
function Mod:setTitle(title) end

--- Called when the mod is loaded
function Mod:load() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data) end

