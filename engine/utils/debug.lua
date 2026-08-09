--- @class Dummy.Debug
---
--- @field protected debug_camera Dummy.DebugCamera
--- @field protected logs string[]
--- @field protected margin number
--- @field protected scale number
--- @field protected show_debug boolean
--- @field protected paused boolean
--- @field protected log_bg_sprite Dummy.Sprite
--- @field protected log_text Dummy.Text
--- @field protected fps_text Dummy.Text
--- @field protected screenshot_text Dummy.Text
--- @field protected screenshot_fade_delay number
--- @field protected screenshot_fade_time number
--- @field protected screenshot_fade_timer Dummy.Timer.Handle|nil
local Debug = {}

--- Wether the debug mode is enabled
--- @return boolean
function Debug.isDebugMode()
  return Debug.debug_mode
end

--- Wether the debugger should show debug information
--- @return boolean
function Debug.shouldShowDebug()
  return Debug.show_debug
end

--- Wether the debugger is paused
--- @return boolean
function Debug.isPaused()
  return Debug.paused
end

--- Pauses the game
function Debug.pause()
  Debug.paused = true
end

--- Resumes the game
function Debug.resume()
  Debug.paused = false
end

--- Loads the debugger
function Debug.load()
  local DebugCamera = require "camera.debug_camera"
  Debug.debug_camera = DebugCamera:new()

  Debug.logs = {}
  Debug.margin = 5
  Debug.scale = 1

  Debug.debug_mode = Constants.DEBUG
  Debug.show_debug = false
  Debug.paused = false

  Debug.log_bg_sprite = Sprite:new("pixel")
  Debug.log_bg_sprite:setPosition(0, 0)
  Debug.log_bg_sprite:setOrigin(0, 0)
  Debug.log_bg_sprite:setLayer(Constants.LAYERS.DEBUG)
  Debug.log_bg_sprite:setColor(0, 0, 0, 0.4)
  Debug.log_bg_sprite:setVisible(false)
  Debug.log_bg_sprite:setPersistent(true)
  Debug.log_bg_sprite:setScale(Constants.GAME_WIDTH, Constants.GAME_HEIGHT)
  Debug.log_bg_sprite:setTag("DEBUG")

  Debug.log_text = Text:new()
  Debug.log_text:setPosition(Debug.margin, Constants.GAME_HEIGHT - Debug.margin)
  Debug.log_text:setOrigin(0, 1)
  Debug.log_text:setScale(Debug.scale)
  Debug.log_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.log_text:setFont("main_text")
  Debug.log_text:setVisible(false)
  Debug.log_text:setPersistent(true)
  Debug.log_text:setTag("DEBUG")

  Debug.fps_text = Text:new()
  Debug.fps_text:setPosition(Constants.GAME_WIDTH - Debug.margin, Debug.margin)
  Debug.fps_text:setOrigin(1, 0)
  Debug.fps_text:setScale(Debug.scale)
  Debug.fps_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.fps_text:setFont("main_text")
  Debug.fps_text:setVisible(false)
  Debug.fps_text:setPersistent(true)
  Debug.fps_text:setTag("DEBUG")

  Debug.screenshot_text = Text:new("SCREENSHOT_TEXT")
  Debug.screenshot_text:setPosition(4, 0)
  Debug.screenshot_text:setOrigin(0, 0)
  Debug.screenshot_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.screenshot_text:setFont("main_text")
  Debug.screenshot_text:setVisible(false)
  Debug.screenshot_text:setPersistent(true)
  Debug.screenshot_text:setTag("DEBUG")
  Debug.screenshot_fade_delay = 3
  Debug.screenshot_fade_time = 0.5
  Lang.onSwitchLanguage(function()
    Debug.screenshot_text:setText("SCREENSHOT_TEXT", true)
  end)
end

--- Saves the logs
function Debug.saveLogs()
  if #Debug.logs <= 0 then return end

  love.filesystem.write("logs.txt", table.concat(Debug.logs, "\n"))
end

--- Clears the logs
function Debug.clearLogs()
  Debug.logs = {}
end

--- Updates the debugger, called on every game update
--- @param dt number
--- @return number
function Debug.update(dt)
  if Debug.paused and not (Input.isPressed("kp+") or (Input.isDown("ctrl") and Input.isDown("kp+"))) then
    dt = 0
  end

  Debug.fps_text:setText(tostring(love.timer.getFPS()))

  local max_lines = math.ceil((Constants.GAME_HEIGHT - Debug.margin) / Debug.log_text:getFont():getHeight())
  local logs = table.slice(Debug.logs, #Debug.logs - max_lines, #Debug.logs)
  Debug.log_text:setText(table.concat(logs, "\n"))

  Debug.screenshot_text:setAlpha(Debug.screenshot_text["alpha"] or 1)

  if Input.isPressed("f6") then
    Debug.fps_text:setVisible(not Debug.fps_text:isVisible())
  end

  if Debug.debug_mode and Input.isPressed("f7") then
    Debug.show_debug = not Debug.show_debug
  end

  if Debug.debug_mode and Input.isPressed("f8") then
    if Input.isDown("ctrl") then
      Debug.clearLogs()
    else
      local visible = not Debug.log_bg_sprite:isVisible()
      Debug.log_bg_sprite:setVisible(visible)
      Debug.log_text:setVisible(visible)
    end
  end

  if love.system.getOS() ~= "Web" and Input.isPressed("f9") then
    Debug.screenshot_text:setVisible(false)

    Assets.playSound("screenshot")
    love.graphics.captureScreenshot("screenshots/" .. os.time() .. ".png")

    if Debug.screenshot_fade_timer ~= nil then
      Timer.cancel(Debug.screenshot_fade_timer)
    end

    Debug.screenshot_fade_timer = Timer.after(0.05, function()
      Debug.screenshot_text:setAlpha(1)
      Debug.screenshot_text["alpha"] = 1
      Debug.screenshot_text:setVisible(true)
      Debug.screenshot_fade_timer = Timer.after(Debug.screenshot_fade_delay, function()
        Debug.screenshot_fade_timer = Timer.tween(Debug.screenshot_fade_time, Debug.screenshot_text, { alpha = 0 },
          "out-sine", function()
            Debug.screenshot_text:setVisible(false)
          end)
        Debug.screenshot_fade_timer.persistent = true
      end)
      Debug.screenshot_fade_timer.persistent = true
    end)
    Debug.screenshot_fade_timer.persistent = true
  end

  if love.system.getOS() ~= "Web" and Input.isPressed("f10") then
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/screenshots")
  end

  if Debug.debug_mode and Input.isDown("ctrl") and Input.isPressed("r") then
    if Input.isDown("shift") then
      Scene.fullReload()
    else
      Scene.reload()
    end
  end

  if Input.isDown("ctrl") and Input.isPressed(";") then
    love.audio.setVolume(love.audio.getVolume() > 0 and 0 or (Config.getSettings()["volume"] / 100))
  end

  if Debug.debug_mode and Input.isDown("ctrl") and Input.isPressed("g") then
    if Scene.getCurrentSceneId() == "BATTLE" then
      Soul.hurt(Player.getHP() * 2, true)
    end
  end

  if Debug.debug_mode and Input.isDown("ctrl") and Input.isPressed("h") then
    if Scene.getCurrentSceneId() == "BATTLE" or Scene.getCurrentSceneId() == "WORLD" then
      Soul.heal(Player.getMaxHP() * 2)
    end
  end

  if Debug.debug_mode and Input.isDown("ctrl") and Input.isPressed("p") then
    Debug.paused = not Debug.paused
  end

  if Debug.debug_mode and Input.isDown("ctrl") and Input.isDown("shift") and Input.isDown("kp+") then
    dt = dt * 8
  end

  if Input.isDown("ctrl") and Input.isDown("shift") and Input.isDown("alt") and Input.isPressed("d") then
    Debug.debug_mode = not Debug.debug_mode
  end

  return dt
end

local _print = print
---
---Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](command:extension.lua.doc?["en-us/54/manual.html/pdf-tostring"]).
---The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"]) and [io.write](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"]).
---
---
---[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-print"])
---
--- @param ... any
function print(...)
  local t = {}
  for _, v in pairs({ ... }) do
    table.insert(t, tostring(v))
  end

  if Debug.log_text ~= nil then
    local _, w = Debug.log_text:getFont():getWrap(table.concat(t, "	"),
      (Constants.GAME_WIDTH / Debug.scale) - (Debug.margin * 2))
    local len = #Debug.logs
    for i, s in ipairs(w) do
      Debug.logs[len + i] = (i == 1 and "> " or "  ") .. s
    end
  end

  return _print(...)
end

return Debug
