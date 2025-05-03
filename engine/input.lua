local keys_pressed = {}
local keys_released = {}

local self = {}

--- Check if a key is being pressed
--- @param key string
function self.isKeyDown(key)
  if key:sub(1, 8) == "gamepad:" then
    return keys_pressed[key or ""] ~= nil
  end
  return love.keyboard.isScancodeDown(key)
end

--- Check if a key is not being pressed
--- @param key string
function self.isKeyUp(key)
  return not self.isKeyDown(key)
end

--- Check if a key has been pressed once
--- @param key string
function self.isKeyPressed(key)
  return keys_pressed[key or ""] == 0
end

--- Check if a key has been released once
--- @param key string
function self.isKeyReleased(key)
  return keys_released[key or ""] == 0
end

local function hasAnyKey(keys, callback)
  if type(keys) ~= "table" or type(callback) ~= "function" then return false end

  for _, key in ipairs(keys) do
    if callback(key) then return true end
  end
  return false
end

local function setupKeysFunctions(keys)
  return {
    isDown = function() return hasAnyKey(keys, self.isKeyDown) end,
    isUp = function() return hasAnyKey(keys, self.isKeyUp) end,
    isPressed = function() return hasAnyKey(keys, self.isKeyPressed) end,
    isReleased = function() return hasAnyKey(keys, self.isKeyReleased) end,
  }
end

function self.load()
  self.Up = setupKeysFunctions({ "w", "up", "gamepad:dpup", "gamepad:lsup" })
  self.Down = setupKeysFunctions({ "s", "down", "gamepad:dpdown", "gamepad:lsdown" })
  self.Left = setupKeysFunctions({ "a", "left", "gamepad:dpleft", "gamepad:lsleft" })
  self.Right = setupKeysFunctions({ "d", "right", "gamepad:dpright", "gamepad:lsright" })
  self.Confirm = setupKeysFunctions({ "z", "return", "kpenter", "gamepad:a" })
  self.Cancel = setupKeysFunctions({ "x", "rshift", "lshift", "gamepad:b" })
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
