--[[
  Generated from ..\engine\shaker.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/shaker.lua
]]

---@meta

--- @class Dummy.Shaker
---
--- @field protected vertical_shake number
--- @field protected horizontal_shake number
Shaker = {}

--- Loads the shaker
function Shaker.load() end

--- Shakes the screen
--- @param vertical_strength? number vertical shake strength
--- @param horizontal_strength? number horizontal shake strength
--- @param interval number interval between shakes
--- @param shake_callback? fun() called when the shake is done
function Shaker.shake(vertical_strength, horizontal_strength, interval, shake_callback) end

--- Called when the shake is done
function Shaker.onDone() end

