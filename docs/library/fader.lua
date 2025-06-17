--[[
  Generated from ..\engine\fader.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/fader.lua
]]

---@meta

--- @class Dummy.Fader
---
--- @field protected background Dummy.Sprite
--- @field protected fade_timer table|nil
Fader = {}

--- Loads the fader
function Fader.load() end

--- Fades in or out
--- @param fade_in boolean wether to fade in or out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fade(fade_in, duration, fade_callback) end

--- Fades in
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeIn(duration, fade_callback) end

--- Fades out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeOut(duration, fade_callback) end

--- Resets the fader
function Fader.reset() end

