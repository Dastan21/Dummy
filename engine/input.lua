--- @class Dummy.Input
---
--- @field Up string[]
--- @field Down string[]
--- @field Left string[]
--- @field Right string[]
--- @field Confirm string[]
--- @field Cancel string[]
---
--- @field protected keys_pressed table<string, number>
--- @field protected keys_released table<string, number>
local Input = {}

--- Wether a key is down, using a predicate function
--- @param keys string|string[]
--- @param predicate fun(key: string): boolean
--- @return boolean
function Input.hasAnyKey(keys, predicate)
  if type(predicate) ~= "function" then return false end

  if keys == "ctrl" then
    keys = { "lctrl", "rctrl" }
  elseif keys == "shift" then
    keys = { "lshift", "rshift" }
  end

  if type(keys) ~= "table" then
    keys = { tostring(keys) }
  end

  for _, key in ipairs(keys) do
    if predicate(key) then
      return true
    end
  end

  return false
end

--- Wether a keybind is being pressed
--- @param keybind string|string[]
--- @return boolean
function Input.isDown(keybind)
  return Input.hasAnyKey(keybind, function(k)
    if k:sub(1, 8) == "gamepad:" then
      return Input.keys_pressed[k] ~= nil
    end
    return love.keyboard.isScancodeDown(k)
  end)
end

--- Wether a keybind is not being pressed
--- @param keybind string|string[]
--- @return boolean
function Input.isUp(keybind)
  return not Input.isDown(keybind)
end

--- Wether a keybind has been pressed once
--- @param keybind string|string[]
--- @return boolean
function Input.isPressed(keybind)
  return Input.hasAnyKey(keybind, function(k)
    return Input.keys_pressed[k] == 0
  end)
end

--- Wether a keybind has been released once
--- @param keybind string|string[]
--- @return boolean
function Input.isReleased(keybind)
  return Input.hasAnyKey(keybind, function(k)
    return Input.keys_released[k] == 0
  end)
end

--- Loads the input
function Input.load()
  Input.keys_pressed = {}
  Input.keys_released = {}

  Input.Up = { "w", "up", "gamepad:dpup", "gamepad:lsup" }
  Input.Down = { "s", "down", "gamepad:dpdown", "gamepad:lsdown" }
  Input.Left = { "a", "left", "gamepad:dpleft", "gamepad:lsleft" }
  Input.Right = { "d", "right", "gamepad:dpright", "gamepad:lsright" }
  Input.Confirm = { "z", "return", "kpenter", "gamepad:a" }
  Input.Cancel = { "x", "rshift", "lshift", "gamepad:b" }
end

--- Updates the input
function Input.update()
  for key, value in pairs(Input.keys_pressed) do
    if Input.keys_pressed[key] ~= nil and Input.keys_pressed[key] < 1 then
      Input.keys_pressed[key] = value + 1
    end
  end
  for key, value in pairs(Input.keys_released) do
    if Input.keys_released[key] ~= nil and Input.keys_released[key] < 1 then
      Input.keys_released[key] = value + 1
    end
  end
end

function love.keypressed(_, key)
  Input.keys_pressed[key] = -1
  Input.keys_released[key] = nil
end

function love.keyreleased(_, key)
  Input.keys_pressed[key] = nil
  Input.keys_released[key] = -1
end

function love.gamepadpressed(_, button)
  Input.keys_pressed["gamepad:" .. button] = -1
  Input.keys_released["gamepad:" .. button] = nil
end

function love.gamepadreleased(_, button)
  Input.keys_pressed["gamepad:" .. button] = nil
  Input.keys_released["gamepad:" .. button] = -1
end

function love.gamepadaxis(_, axis, value)
  local stick_treshold = 0.2

  if axis == "lefty" then
    if value < -stick_treshold then
      if Input.keys_pressed["gamepad:lsup"] == nil then
        Input.keys_pressed["gamepad:lsup"] = -1
      end
      Input.keys_pressed["gamepad:lsdown"] = nil
    elseif value > stick_treshold then
      if Input.keys_pressed["gamepad:lsdown"] == nil then
        Input.keys_pressed["gamepad:lsdown"] = -1
      end
      Input.keys_pressed["gamepad:lsup"] = nil
    else
      Input.keys_pressed["gamepad:lsdown"] = nil
      Input.keys_pressed["gamepad:lsup"] = nil
    end
  elseif axis == "leftx" then
    if value < -stick_treshold then
      if Input.keys_pressed["gamepad:lsleft"] == nil then
        Input.keys_pressed["gamepad:lsleft"] = -1
      end
      Input.keys_pressed["gamepad:lsright"] = nil
    elseif value > stick_treshold then
      if Input.keys_pressed["gamepad:lsright"] == nil then
        Input.keys_pressed["gamepad:lsright"] = -1
      end
      Input.keys_pressed["gamepad:lsleft"] = nil
    else
      Input.keys_pressed["gamepad:lsright"] = nil
      Input.keys_pressed["gamepad:lsleft"] = nil
    end
  end
end

return Input
