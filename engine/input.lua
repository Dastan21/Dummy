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
local Input = {}

--- Loads the input
function Input.load()
  Input.keys_pressed = {}
  Input.keys_released = {}
  Input.gamepad_axis = {}
  Input.gamepad_axis_deadzone = 0.2
  Input.gamepad_trigger_treshold = 0.5
  Input.text_input_callbacks = {}
  Input.mouse_focus = false

  Input.Up = { "w", "up", "gamepad:1:dpup", "joystick:1:lsup" }
  Input.Down = { "s", "down", "gamepad:1:dpdown", "joystick:1:lsdown" }
  Input.Left = { "a", "left", "gamepad:1:dpleft", "joystick:1:lsleft" }
  Input.Right = { "d", "right", "gamepad:1:dpright", "joystick:1:lsright" }
  Input.Confirm = { "z", "e", "return", "kpenter", "gamepad:1:a" }
  Input.Cancel = { "x", "q", "shift", "gamepad:1:b" }
  Input.Menu = { "c", "ctrl", "gamepad:1:y" }
  Input.Escape = { "escape", "gamepad:1:start" }
end

--- Clears a key
--- @param key string
function Input.clear(key)
  Input.keys_pressed[key] = nil
  Input.keys_released[key] = nil
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
    --- @type string[]
    local cmd = string.split(k, ":")
    if cmd[1] == "mouse" then
      local button_index = 0
      if cmd[2] == "left" then
        button_index = 1
      elseif cmd[2] == "right" then
        button_index = 2
      elseif cmd[2] == "middle" then
        button_index = 3
      end
      return love.mouse.isDown(button_index)
    elseif cmd[1] == "gamepad" then
      for _, joystick in ipairs(love.joystick.getJoysticks() --[[@as table<number, love.Joystick>]]) do
        if tostring(joystick:getID()) == cmd[2] and joystick:isGamepadDown(cmd[3]) then
          return true
        end
      end
      return false
    elseif cmd[1] == "joystick" then
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

--- Gets the pointer position
--- @return number, number
function Input.getPointerPosition()
  return love.mouse.getPosition()
end

--- Sets the pointer position
--- @param x number
--- @param y number
function Input.setPointerPosition(x, y)
  love.mouse.setPosition(x, y)
end

--- Wether the pointer is in the window
function Input.isPointerInWindow()
  return Input.mouse_focus
end

--- Gets the gamepad axis value
--- @param axis string
--- @return number
function Input.getGamepadAxis(axis)
  return Input.gamepad_axis[axis] or 0
end

--- Gets the gamepad axis deadzone
--- @return number
function Input.getGamepadDeadzone()
  return Input.gamepad_axis_deadzone
end

--- Sets the gamepad axis deadzone
--- @param deadzone number
function Input.setGamepadDeadzone(deadzone)
  Input.gamepad_axis_deadzone = deadzone
end

--- Gets the gamepad axis treshold
--- @return number
function Input.getTriggerTreshold()
  return Input.gamepad_trigger_treshold
end

--- Sets the gamepad axis treshold
--- @param treshold number
function Input.setTriggerTreshold(treshold)
  Input.gamepad_trigger_treshold = treshold
end

--- Gets the key pressed
--- @return string|nil
function Input.getKeyPressed()
  for key, time in pairs(Input.keys_pressed) do
    if time == 1 then
      return key
    end
  end
end

--- Gets the key released
--- @return string|nil
function Input.getKeyReleased()
  for key, time in pairs(Input.keys_released) do
    if time == 1 then
      return key
    end
  end
end

--- Adds a text input listener
--- @param callback fun(text: string) the callback to add
function Input.addTextInputListener(callback)
  assert(type(callback) == "function", "Callback must be a function")

  Input.text_input_callbacks[callback] = true
end

--- Removes a text input listener
--- @param callback fun(text: string) the callback to remove
function Input.removeTextInputListener(callback)
  Input.text_input_callbacks[callback] = nil
end

--- Updates the input
function Input.update()
  for key, value in pairs(Input.keys_pressed) do
    if Input.keys_pressed[key] < 2 then
      Input.keys_pressed[key] = value + 1
    end

    if not Input.isDown(key) and Input.keys_pressed[key] >= 2 then
      Input.keys_pressed[key] = nil
    end
  end
  for key, value in pairs(Input.keys_released) do
    if Input.keys_released[key] < 2 then
      Input.keys_released[key] = value + 1
    end

    if not Input.isDown(key) and Input.keys_released[key] >= 2 then
      Input.keys_pressed[key] = nil
    end
  end
end

--- Callback function triggered when a mouse button is pressed.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousepressed(x, y, button, istouch, presses)
  local key = ""
  if button == 1 then
    key = "left"
  elseif button == 2 then
    key = "right"
  elseif button == 3 then
    key = "middle"
  end
  Input.keys_pressed["mouse:" .. key] = 0
end

--- Callback function triggered when a mouse button is released.
--- @param x number
--- @param y number
--- @param button number
--- @param istouch boolean
--- @param presses number
function love.mousereleased(x, y, button, istouch, presses)
  local key = ""
  if button == 1 then
    key = "left"
  elseif button == 2 then
    key = "right"
  elseif button == 3 then
    key = "middle"
  end
  Input.keys_released["mouse:" .. key] = 0
end

--- Callback function triggered when window receives or loses mouse focus.
--- @param focus boolean
function love.mousefocus(focus)
  Input.mouse_focus = focus
end

--- Callback function triggered when the mouse wheel is moved.
--- @param x number
--- @param y number
function love.wheelmoved(x, y)
  if x > 0 then
    Input.keys_pressed["mouse:wheel_x_up"] = 0
  elseif x < 0 then
    Input.keys_pressed["mouse:wheel_x_down"] = 0
  elseif y > 0 then
    Input.keys_pressed["mouse:wheel_y_up"] = 0
  elseif y < 0 then
    Input.keys_pressed["mouse:wheel_y_down"] = 0
  end
end

--- Callback function triggered when a key is pressed.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
--- @param isrepeat boolean
function love.keypressed(key, scancode, isrepeat)
  Input.keys_pressed[scancode] = 0
end

--- Callback function triggered when a keyboard key is released.
--- @param key love.KeyConstant
--- @param scancode love.Scancode
function love.keyreleased(key, scancode)
  Input.keys_released[scancode] = 0
end

--- Called when a Joystick's virtual gamepad button is pressed.
--- @param joystick love.Joystick
--- @param button love.GamepadButton
function love.gamepadpressed(joystick, button)
  Input.keys_pressed["gamepad:" .. joystick:getID() .. ":" .. button] = 0
end

--- Called when a Joystick's virtual gamepad button is released.
--- @param joystick love.Joystick
--- @param button love.GamepadButton
function love.gamepadreleased(joystick, button)
  Input.keys_released["gamepad:" .. joystick:getID() .. ":" .. button] = 0
end

--- Called when a Joystick's virtual gamepad axis is moved.
--- @param joystick love.Joystick
--- @param axis love.GamepadAxis
--- @param value number
function love.gamepadaxis(joystick, axis, value)
  local id = joystick:getID()
  local deadzone = Input.getGamepadDeadzone()

  if axis == "lefty" then
    Input.gamepad_axis["lsy"] = value
    if value < -deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":lsup"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":lsup"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":lsdown"] = nil
      Input.gamepad_axis["lsup"] = -value
    elseif value > deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":lsdown"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":lsdown"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":lsup"] = nil
      Input.gamepad_axis["lsdown"] = value
    else
      Input.keys_pressed["joystick:" .. id .. ":lsdown"] = nil
      Input.keys_pressed["joystick:" .. id .. ":lsup"] = nil
      Input.gamepad_axis["lsup"] = 0
      Input.gamepad_axis["lsdown"] = 0
    end
  elseif axis == "leftx" then
    Input.gamepad_axis["lsx"] = value
    if value < -deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":lsleft"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":lsleft"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":lsright"] = nil
      Input.gamepad_axis["lsleft"] = -value
    elseif value > deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":lsright"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":lsright"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":lsleft"] = nil
      Input.gamepad_axis["lsright"] = value
    else
      Input.keys_pressed["joystick:" .. id .. ":lsright"] = nil
      Input.keys_pressed["joystick:" .. id .. ":lsleft"] = nil
      Input.gamepad_axis["lsleft"] = 0
      Input.gamepad_axis["lsright"] = 0
    end
  elseif axis == "righty" then
    Input.gamepad_axis["rsy"] = value
    if value < -deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":rsup"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":rsup"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":rsdown"] = nil
      Input.gamepad_axis["rsup"] = -value
    elseif value > deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":rsdown"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":rsdown"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":rsup"] = nil
      Input.gamepad_axis["rsdown"] = value
    else
      Input.keys_pressed["joystick:" .. id .. ":rsdown"] = nil
      Input.keys_pressed["joystick:" .. id .. ":rsup"] = nil
      Input.gamepad_axis["rsup"] = 0
      Input.gamepad_axis["rsdown"] = 0
    end
  elseif axis == "rightx" then
    Input.gamepad_axis["rsx"] = value
    if value < -deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":rsleft"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":rsleft"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":rsright"] = nil
      Input.gamepad_axis["rsleft"] = -value
    elseif value > deadzone then
      if Input.keys_pressed["joystick:" .. id .. ":rsright"] == nil then
        Input.keys_pressed["joystick:" .. id .. ":rsright"] = 0
      end
      Input.keys_pressed["joystick:" .. id .. ":rsleft"] = nil
      Input.gamepad_axis["rsright"] = value
    else
      Input.keys_pressed["joystick:" .. id .. ":rsright"] = nil
      Input.keys_pressed["joystick:" .. id .. ":rsleft"] = nil
      Input.gamepad_axis["rsleft"] = 0
      Input.gamepad_axis["rsright"] = 0
    end
  else
    local trigger_treshold = Input.getTriggerTreshold()
    if value > trigger_treshold then
      if Input.keys_pressed["joystick:" .. id .. ":" .. axis] == nil then
        Input.keys_pressed["joystick:" .. id .. ":" .. axis] = 0
      end
    else
      Input.keys_pressed["joystick:" .. id .. ":" .. axis] = nil
    end
    Input.gamepad_axis[axis] = value
  end
end

--- Called when text has been entered by the user. For example if shift-2 is pressed on an American keyboard layout, the text "@" will be generated.
--- @param text string
function love.textinput(text)
  for callback in pairs(Input.text_input_callbacks) do
    callback(text)
  end
end

return Input
