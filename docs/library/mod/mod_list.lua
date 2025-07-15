--[[
  Generated from ..\engine\mod\mod_list.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/mod/mod_list.lua
]]

---@meta

--- @class Dummy.ModList
---
--- @field protected mods Dummy.Mod[]
--- @field protected current_mod Dummy.Mod|nil
--- @field protected standalone Dummy.Mod|nil
ModList = {}

--- Gets the mods
--- @return Dummy.Mod[]
function ModList.getMods() end

--- Gets the standalone mod
--- @return Dummy.Mod|nil
function ModList.getStandalone() end

--- Gets the current loaded mod
--- @return Dummy.Mod|nil
function ModList.getCurrentMod() end

--- Loads the mod list
function ModList.load() end

--- Preloads a mod
--- @param mod_id string
--- @private
function ModList.preloadMod(mod_id) end

--- Loads a mod
--- @param mod Dummy.Mod
function ModList.loadMod(mod) end

--- Mounts a mod
--- @param mod Dummy.Mod
function ModList.mountMod(mod) end

--- Unloads a mod
--- @param mod Dummy.Mod
function ModList.unloadMod(mod) end

--- Unloads all mods
function ModList.unloadMods() end

--- Wether a mod is valid
--- @param success boolean
--- @param mod Dummy.Mod
--- @return boolean
function ModList.isModValid(success, mod) end

--- Sets the window title and icon
--- @param title Dummy.Text.Text|nil
function ModList.setWindowTitleAndIcon(title) end

