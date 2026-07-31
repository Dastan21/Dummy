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
--- @field protected config Dummy.Mod.Config
Mod = {}

--- @class Dummy.Mod.Config.Savepoint
---
--- @field name string
--- @field lv number
--- @field time number
--- @field room_id string
--- @field room_name string
--- @field [string] unknown

--- @class Dummy.Mod.Config
---
--- @field savepoint Dummy.Mod.Config.Savepoint
--- @field [string] unknown

--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title Dummy.Text.Text|nil
--- @field version string|nil
--- @field standalone boolean|nil

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data) end

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
--- @param title Dummy.Text.Text|nil
function Mod:setTitle(title) end

--- Gets the mod's config
--- @return Dummy.Mod.Config
function Mod:getConfig() end

--- Loads the mod
function Mod:load() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

--- Called before the game is saved
function Mod:onGameSave() end

--- Called when a room is entered
--- @param room Dummy.Room
function Mod:onRoomEnter(room) end

--- Called when a room is left
--- @param room Dummy.Room
function Mod:onRoomLeave(room) end

--- Called when an encounter starts
--- @param encounter Dummy.Battle.Encounter
function Mod:onEncounterStart(encounter) end

--- Called when an encounter ends
--- @param encounter Dummy.Battle.Encounter
function Mod:onEncounterEnd(encounter) end

--- Updates the mod, called on every game update
--- @param dt number
function Mod:update(dt) end

