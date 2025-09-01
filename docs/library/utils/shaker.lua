--[[
  Generated from ..\engine\utils\shaker.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/shaker.lua
]]

---@meta

--- @class Dummy.Shaker
---
--- @field protected dx number
--- @field protected dy number
--- @field protected duration_timer table|nil
--- @field protected interval_timer table|nil
Shaker = {}

--- Loads the shaker
function Shaker.load() end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param shake_function fun(): number, number custom shake function to calculate the shakes directions
--- @param shake_callback? fun() called when the shake is done
function Shaker.shake(duration, interval, shake_function, shake_callback) end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param horizontal_strength number horizontal shake strength
--- @param vertical_strength number vertical shake strength
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeRandom(duration, interval, horizontal_strength, vertical_strength, shake_callback) end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param shake_function fun(): number, number custom shake function to calculate the shakes directions (Defaults to random directions by strength)
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeCustom(duration, interval, shake_function, shake_callback) end

--- Resets the currently playing shaker
function Shaker.reset() end

--- Draws the shaker
function Shaker.draw() end

