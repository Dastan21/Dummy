--[[
  Generated from ..\engine\fader.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/fader.lua
]]

---@meta

--- @class Dummy.Fader
---
--- @field protected background Dummy.Sprite
--- @field protected default_speed number
--- @field protected speed number
--- @field protected is_fading boolean
--- @field protected is_fade_in boolean
--- @field protected is_fade_done boolean
--- @field protected fade_callback fun()|nil
Fader = {}

--- Loads the fader
function Fader.load() end

--- Fades in
--- @param speed? number
--- @param fade_callback? fun()
function Fader.fadeIn(speed, fade_callback) end

--- Fades out
--- @param speed? number
--- @param fade_callback? fun()
function Fader.fadeOut(speed, fade_callback) end

--- Called when the fade is done
function Fader.onDone() end

--- Updates the fader
function Fader.update(dt) end

