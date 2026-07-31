--[[
  Generated from ..\engine\input.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/input.lua
]]

---@meta

--- @class Dummy.Input
---
--- @field Up string[]
--- @field Down string[]
--- @field Left string[]
--- @field Right string[]
--- @field Confirm string[]
--- @field Cancel string[]
--- @field Menu string[]
---
--- @field protected keys_pressed table<string, number>
--- @field protected keys_released table<string, number>
Input = {}

--- Flattens a list of inputs
--- @param ... string|string[]
--- @return string[]
function Input.group(...) end

--- Wether a key is down, using a predicate function
--- @param keys string|string[]
--- @param predicate fun(key: string): boolean
--- @return boolean
function Input.hasAnyKey(keys, predicate) end

--- Wether a keybind is being pressed
--- @param keybind string|string[]
--- @return boolean
function Input.isDown(keybind) end

--- Wether a keybind is not being pressed
--- @param keybind string|string[]
--- @return boolean
function Input.isUp(keybind) end

--- Wether a keybind has been pressed once
--- @param keybind string|string[]
--- @return boolean
function Input.isPressed(keybind) end

--- Wether a keybind has been released once
--- @param keybind string|string[]
--- @return boolean
function Input.isReleased(keybind) end

--- Loads the input
function Input.load() end

--- Updates the input, called on every game update
function Input.update() end

