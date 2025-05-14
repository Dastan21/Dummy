local keys_pressed = {}
local keys_released = {}

local self = {}

local function hasAnyKey(keys, callback)
  if type(callback) ~= "function" then return false end
  if type(keys) ~= "table" then
    keys = { tostring(keys) }
  end

  for _, key in ipairs(keys) do
    if callback(key) then
      return true
    end
  end
  return false
end

--- Check if a keybind is being pressed
---@param keybind string|table
function self.isDown(keybind)
  return hasAnyKey(keybind, function(k)
    if k:sub(1, 8) == "gamepad:" then
      return keys_pressed[k] ~= nil
    end
    return love.keyboard.isScancodeDown(k)
  end)
end

--- Check if a keybind is not being pressed
---@param keybind string|table
function self.isUp(keybind)
  return not self.isDown(keybind)
end

--- Check if a keybind has been pressed once
---@param keybind string|table
function self.isPressed(keybind)
  return hasAnyKey(keybind, function(k)
    return keys_pressed[k] == 0
  end)
end

--- Check if a keybind has been released once
---@param keybind string|table
function self.isReleased(keybind)
  return hasAnyKey(keybind, function(k)
    return keys_released[k] == 0
  end)
end

function self.load()
  self.Up = { "w", "up", "gamepad:dpup", "gamepad:lsup" }
  self.Down = { "s", "down", "gamepad:dpdown", "gamepad:lsdown" }
  self.Left = { "a", "left", "gamepad:dpleft", "gamepad:lsleft" }
  self.Right = { "d", "right", "gamepad:dpright", "gamepad:lsright" }
  self.Confirm = { "z", "return", "kpenter", "gamepad:a" }
  self.Cancel = { "x", "rshift", "lshift", "gamepad:b" }
end

function self.update()
  for key, value in pairs(keys_pressed) do
    if keys_pressed[key] ~= nil and keys_pressed[key] < 1 then
      keys_pressed[key] = value + 1
    end
  end
  for key, value in pairs(keys_released) do
    if keys_released[key] ~= nil and keys_released[key] < 1 then
      keys_released[key] = value + 1
    end
  end
end

function love.keypressed(_, key)
  keys_pressed[key] = -1
  keys_released[key] = nil
end

function love.keyreleased(_, key)
  keys_pressed[key] = nil
  keys_released[key] = -1
end

function love.gamepadpressed(_, button)
  keys_pressed["gamepad:" .. button] = -1
  keys_released["gamepad:" .. button] = nil
end

function love.gamepadreleased(_, button)
  keys_pressed["gamepad:" .. button] = nil
  keys_released["gamepad:" .. button] = -1
end

function love.gamepadaxis(_, axis, value)
  local stick_treshold = 0.2

  if axis == "lefty" then
    if value < -stick_treshold then
      if keys_pressed["gamepad:lsup"] == nil then
        keys_pressed["gamepad:lsup"] = -1
      end
      keys_pressed["gamepad:lsdown"] = nil
    elseif value > stick_treshold then
      if keys_pressed["gamepad:lsdown"] == nil then
        keys_pressed["gamepad:lsdown"] = -1
      end
      keys_pressed["gamepad:lsup"] = nil
    else
      keys_pressed["gamepad:lsdown"] = nil
      keys_pressed["gamepad:lsup"] = nil
    end
  elseif axis == "leftx" then
    if value < -stick_treshold then
      if keys_pressed["gamepad:lsleft"] == nil then
        keys_pressed["gamepad:lsleft"] = -1
      end
      keys_pressed["gamepad:lsright"] = nil
    elseif value > stick_treshold then
      if keys_pressed["gamepad:lsright"] == nil then
        keys_pressed["gamepad:lsright"] = -1
      end
      keys_pressed["gamepad:lsleft"] = nil
    else
      keys_pressed["gamepad:lsright"] = nil
      keys_pressed["gamepad:lsleft"] = nil
    end
  end
end

return self
