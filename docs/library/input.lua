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
--- @field protected gamepad_axis table<string, number>
--- @field protected gamepad_axis_deadzone number
--- @field protected gamepad_trigger_treshold number
--- @field protected text_input_callbacks table<fun(text: string), boolean>
--- @field protected mouse_focus boolean
Input = {}

--- Loads the input
function Input.load() end

--- Clears a key
--- @param key string
function Input.clear(key) end

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

--- Gets the pointer position
--- @return number, number
function Input.getPointerPosition() end

--- Sets the pointer position
--- @param x number
--- @param y number
function Input.setPointerPosition(x, y) end

--- Wether the pointer is in the window
function Input.isPointerInWindow() end

--- Gets the gamepad axis value
--- @param axis string
--- @return number
function Input.getGamepadAxis(axis) end

--- Gets the gamepad axis deadzone
--- @return number
function Input.getGamepadDeadzone() end

--- Sets the gamepad axis deadzone
--- @param deadzone number
function Input.setGamepadDeadzone(deadzone) end

--- Gets the gamepad axis treshold
--- @return number
function Input.getTriggerTreshold() end

--- Sets the gamepad axis treshold
--- @param treshold number
function Input.setTriggerTreshold(treshold) end

--- Gets the key pressed
--- @return string|nil
function Input.getKeyPressed() end

--- Gets the key released
--- @return string|nil
function Input.getKeyReleased() end

--- Adds a text input listener
--- @param callback fun(text: string) the callback to add
function Input.addTextInputListener(callback) end

--- Removes a text input listener
--- @param callback fun(text: string) the callback to remove
function Input.removeTextInputListener(callback) end

--- Updates the input
function Input.update() end

