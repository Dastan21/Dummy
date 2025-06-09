--[[
  Generated from ..\engine\mod\mod.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/mod/mod.lua
]]

---@meta

--- @class Dummy.Mod : Dummy.Class
---
--- @field id string
--- @field name string
--- @field title string|nil
--- @field encounter Dummy.Scene.Encounter
Mod = {}

--- @class Dummy.Mod.Player
---
--- @field name string|nil
--- @field level number|nil
--- @field hp number|nil
--- @field max_hp number|nil
--- @field at number|nil
--- @field df number|nil

--- @class Dummy.Mod.Encounter
---
--- @field text string|nil
--- @field flee boolean|nil
--- @field music string|nil


--- @class Dummy.Mod.Enemy
---
--- @field name string
--- @field hp number|nil
--- @field at number|nil
--- @field df number|nil
--- @field xp number|nil
--- @field gold number|nil
--- @field check string|table<number, string>|nil
--- @field position { [1]: number, [2]: number }|nil
--- @field size { [1]: number, [2]: number }|nil

--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title string|nil
--- @field standalone boolean|nil

--- Gets the class name
--- @return string
function Mod:getClass() end

--- Called when the mod is loaded
function Mod:load() end

--- Called right before the encounter starts
function Mod:start() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

function Mod:addEnemy(enemy) end

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data) end

