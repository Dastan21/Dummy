--[[
  Generated from ..\engine\utils\fader.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/fader.lua
]]

---@meta

--- @class Dummy.Fader
---
--- @field protected color love.Color
--- @field protected alpha number
--- @field protected fade_timer Dummy.Timer.Handle|nil
Fader = {}

--- Loads the fader
function Fader.load() end

--- Fades in or out
--- @param fade_in boolean wether to fade in or out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
--- @private
function Fader.fade(fade_in, duration, method, fade_callback) end

--- Fades in
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeIn(duration, method, fade_callback) end

--- Fades out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeOut(duration, method, fade_callback) end

--- Sets the fader color
--- @overload fun(color: love.Color)
--- @param r number
--- @param g number
--- @param b number
function Fader.setColor(r, g, b) end

--- Resets the currently playing fader
function Fader.reset() end

--- Draws the fader
function Fader.draw() end

