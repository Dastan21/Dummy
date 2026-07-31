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
local Input = {}

--- Flattens a list of inputs
--- @param ... string|string[]
--- @return string[]
function Input.group(...)
  local inputs = {}
  for _, input in ipairs({ ... }) do
    if type(input) == "string" then
      table.insert(inputs, input)
    else
      for _, i in ipairs(input) do
        table.insert(inputs, i)
      end
    end
  end
  return inputs
end

--- Wether a key is down, using a predicate function
--- @param keys string|string[]
--- @param predicate fun(key: string): boolean
--- @return boolean
function Input.hasAnyKey(keys, predicate)
  if type(predicate) ~= "function" then return false end

  if type(keys) ~= "table" then
    keys = { tostring(keys) }
  end

  local tmp_keys = {}
  for _, key in ipairs(keys) do
    if key == "ctrl" then
      table.insert(tmp_keys, "lctrl")
      table.insert(tmp_keys, "rctrl")
    elseif key == "shift" then
      table.insert(tmp_keys, "lshift")
      table.insert(tmp_keys, "rshift")
    elseif key == "alt" then
      table.insert(tmp_keys, "lalt")
      table.insert(tmp_keys, "ralt")
    else
      table.insert(tmp_keys, key)
    end
  end
  keys = tmp_keys

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
      for _, joystick in ipairs(love.joystick.getJoysticks()) do
        if joystick:isGamepadDown(k:sub(9)) then
          return true
        end
      end
      return false
    elseif k:sub(1, 9) == "joystick:" then
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
    return Input.keys_pressed[k] == 1
  end)
end

--- Wether a keybind has been released once
--- @param keybind string|string[]
--- @return boolean
function Input.isReleased(keybind)
  return Input.hasAnyKey(keybind, function(k)
    return Input.keys_released[k] == 1
  end)
end

--- Loads the input
function Input.load()
  Input.keys_pressed = {}
  Input.keys_released = {}

  Input.Up = { "w", "up", "gamepad:dpup", "joystick:lsup" }
  Input.Down = { "s", "down", "gamepad:dpdown", "joystick:lsdown" }
  Input.Left = { "a", "left", "gamepad:dpleft", "joystick:lsleft" }
  Input.Right = { "d", "right", "gamepad:dpright", "joystick:lsright" }
  Input.Confirm = { "z", "e", "return", "kpenter", "gamepad:a" }
  Input.Cancel = { "x", "q", "shift", "gamepad:b" }
  Input.Menu = { "c", "ctrl", "gamepad:y" }
  Input.Escape = { "escape", "gamepad:start" }
end

--- Updates the input, called on every game update
function Input.update()
  for key, value in pairs(Input.keys_pressed) do
    if not Input.isDown(key) and Input.keys_pressed[key] == 2 then
      Input.keys_pressed[key] = 0
    end

    if Input.keys_pressed[key] < 2 then
      Input.keys_pressed[key] = value + 1
    end
  end
  for key, value in pairs(Input.keys_released) do
    if not Input.isDown(key) and Input.keys_released[key] == 2 then
      Input.keys_pressed[key] = 0
    end

    if Input.keys_released[key] < 2 then
      Input.keys_released[key] = value + 1
    end
  end
end

function love.keypressed(_, key)
  Input.keys_pressed[key] = 0
end

function love.keyreleased(_, key)
  Input.keys_released[key] = 0
end

function love.gamepadpressed(_, button)
  Input.keys_pressed["gamepad:" .. button] = 0
end

function love.gamepadreleased(_, button)
  Input.keys_released["gamepad:" .. button] = 0
end

function love.gamepadaxis(_, axis, value)
  local stick_treshold = 0.2

  if axis == "lefty" then
    if value < -stick_treshold then
      if Input.keys_pressed["joystick:lsup"] == nil then
        Input.keys_pressed["joystick:lsup"] = 0
      end
      Input.keys_pressed["joystick:lsdown"] = nil
    elseif value > stick_treshold then
      if Input.keys_pressed["joystick:lsdown"] == nil then
        Input.keys_pressed["joystick:lsdown"] = 0
      end
      Input.keys_pressed["joystick:lsup"] = nil
    else
      Input.keys_pressed["joystick:lsdown"] = nil
      Input.keys_pressed["joystick:lsup"] = nil
    end
  elseif axis == "leftx" then
    if value < -stick_treshold then
      if Input.keys_pressed["joystick:lsleft"] == nil then
        Input.keys_pressed["joystick:lsleft"] = 0
      end
      Input.keys_pressed["joystick:lsright"] = nil
    elseif value > stick_treshold then
      if Input.keys_pressed["joystick:lsright"] == nil then
        Input.keys_pressed["joystick:lsright"] = 0
      end
      Input.keys_pressed["joystick:lsleft"] = nil
    else
      Input.keys_pressed["joystick:lsright"] = nil
      Input.keys_pressed["joystick:lsleft"] = nil
    end
  end
end

return Input
