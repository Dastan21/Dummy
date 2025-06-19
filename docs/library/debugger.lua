--[[
  Generated from ..\engine\debugger.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/debugger.lua
]]

---@meta

--- @class Dummy.Debugger
---
--- @field protected logs string[]
--- @field protected margin number
--- @field protected scale number
--- @field protected display_hitbox boolean
--- @field protected log_bg_sprite Dummy.Sprite
--- @field protected log_text Dummy.Text
--- @field protected fps_text Dummy.Text
Debugger = {}

--- Wether the hitboxes should be displayed
--- @return boolean
function Debugger.shouldDisplayHitbox() end

--- Loads the debugger
function Debugger.load() end

--- Saves the logs
function Debugger.saveLogs() end

--- Updates the debugger
function Debugger.update() end

function print(...) end

