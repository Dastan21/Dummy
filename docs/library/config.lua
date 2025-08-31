--[[
  Generated from ..\engine\config.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/config.lua
]]

---@meta

--- @class Dummy.Config
---
--- @field protected configs table<string, table<string, any>>[]
Config = {}

--- @class Dummy.Config.Settings
---
--- @field language string
--- @field fps number
--- @field window_scale number
--- @field fullscreen boolean

--- Gets the engine settings
--- @return Dummy.Config.Settings
function Config.getSettings() end

--- Loads the main config
function Config.load() end

--- Saves the configs
function Config.save() end

--- Loads a config
--- @param config_path string
function Config.loadConfig(config_path) end

