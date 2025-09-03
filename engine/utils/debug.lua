--- @class Dummy.Debug
---
--- @field protected logs string[]
--- @field protected margin number
--- @field protected scale number
--- @field protected display_hitbox boolean
--- @field protected paused boolean
--- @field protected log_bg_sprite Dummy.Sprite
--- @field protected log_text Dummy.Text
--- @field protected fps_text Dummy.Text
--- @field protected screenshot_text Dummy.Text
--- @field protected screenshot_fade_delay number
--- @field protected screenshot_fade_time number
--- @field protected screenshot_fade_timer table|nil
local Debug = {}

--- Wether the hitboxes should be displayed
--- @return boolean
function Debug.shouldDisplayHitbox()
  return Debug.display_hitbox
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
  Debug.logs = {}
  Debug.margin = 5
  Debug.scale = 1

  Debug.display_hitbox = false
  Debug.paused = false

  Debug.log_bg_sprite = Sprite:new("pixel")
  Debug.log_bg_sprite:setPosition(0, 0)
  Debug.log_bg_sprite:setOrigin(0, 0)
  Debug.log_bg_sprite:setLayer(Constants.LAYERS.DEBUG)
  Debug.log_bg_sprite:setColor(0, 0, 0, 0.4)
  Debug.log_bg_sprite:setVisible(false)
  Debug.log_bg_sprite:setPersistent(true)
  Debug.log_bg_sprite:setScale(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)

  Debug.log_text = Text:new("")
  Debug.log_text:setPosition(Debug.margin, Constants.SCREEN_HEIGHT - Debug.margin)
  Debug.log_text:setOrigin(0, 1)
  Debug.log_text:setScale(Debug.scale)
  Debug.log_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.log_text:setFont("main_text")
  Debug.log_text:setVisible(false)
  Debug.log_text:setPersistent(true)

  Debug.fps_text = Text:new("")
  Debug.fps_text:setPosition(Constants.SCREEN_WIDTH - Debug.margin, Debug.margin)
  Debug.fps_text:setOrigin(1, 0)
  Debug.fps_text:setScale(Debug.scale)
  Debug.fps_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.fps_text:setFont("main_text")
  Debug.fps_text:setVisible(false)
  Debug.fps_text:setPersistent(true)

  Debug.screenshot_text = Text:new("SCREENSHOT_TEXT")
  Debug.screenshot_text:setPosition(4, 0)
  Debug.screenshot_text:setOrigin(0, 0)
  Debug.screenshot_text:setLayer(Constants.LAYERS.DEBUG)
  Debug.screenshot_text:setFont("main_text")
  Debug.screenshot_text:setVisible(false)
  Debug.screenshot_text:setPersistent(true)
  Debug.screenshot_fade_delay = 3
  Debug.screenshot_fade_time = 0.5
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

--- Updates the debugger
--- @param dt number
--- @return number
function Debug.update(dt)
  if Debug.paused and not (Input.isPressed("kp+") or (Input.isDown("ctrl") and Input.isDown("kp+"))) then
    dt = 0
  end

  Debug.fps_text:setText(tostring(love.timer.getFPS()))

  local max_lines = math.ceil((Constants.SCREEN_HEIGHT - Debug.margin) / Debug.log_text:getFont():getHeight())
  local logs = table.slice(Debug.logs, #Debug.logs - max_lines, #Debug.logs)
  Debug.log_text:setText(table.concat(logs, "\n"))

  if Input.isPressed("f6") then
    Debug.fps_text:setVisible(not Debug.fps_text:isVisible())
  elseif Input.isPressed("f7") then
    Debug.display_hitbox = not Debug.display_hitbox
  elseif Input.isDown("ctrl") and Input.isPressed("f8") then
    Debug.clearLogs()
  elseif Input.isPressed("f8") then
    local visible = not Debug.log_bg_sprite:isVisible()
    Debug.log_bg_sprite:setVisible(visible)
    Debug.log_text:setVisible(visible)
  elseif Input.isPressed("f9") then
    Debug.screenshot_text:setVisible(false)

    Assets.playSound("screenshot")
    love.graphics.captureScreenshot("screenshots/" .. os.time() .. ".png")

    if Debug.screenshot_fade_timer ~= nil then
      Timer.cancel(Debug.screenshot_fade_timer)
    end

    Debug.screenshot_fade_timer = Timer.after(0.05, function()
      Debug.screenshot_text:setAlpha(1)
      Debug.screenshot_text:setVisible(true)
      Debug.screenshot_fade_timer = Timer.after(Debug.screenshot_fade_delay, function()
        Debug.screenshot_fade_timer = Timer.tween(Debug.screenshot_fade_time, Debug.screenshot_text, { alpha = 0 },
          "out-sine", function()
            Debug.screenshot_text:setVisible(false)
          end)
      end)
    end)
  elseif Input.isPressed("f10") then
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/screenshots")
  elseif Input.isDown("ctrl") and Input.isPressed("r") then
    if Input.isDown("shift") then
      Scene.fullReload()
    else
      Scene.reload()
    end
  elseif Input.isDown("ctrl") and Input.isPressed(";") then
    love.audio.setVolume(love.audio.getVolume() > 0 and 0 or 1)
  elseif Input.isDown("ctrl") and Input.isPressed("g") then
    if Scene.getSceneName() == "ENCOUNTER" then
      Player.hurt(Player.getHP() * 2, true)
    end
  elseif Input.isDown("ctrl") and Input.isPressed("p") then
    Debug.paused = not Debug.paused
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
---@param ... any
function print(...)
  local t = {}
  for _, v in pairs({ ... }) do
    table.insert(t, tostring(v))
  end

  if Debug.log_text ~= nil then
    local _, w = Debug.log_text:getFont():getWrap(table.concat(t, "	"),
      (Constants.SCREEN_WIDTH / Debug.scale) - (Debug.margin * 2))
    local len = #Debug.logs
    for i, s in ipairs(w) do
      Debug.logs[len + i] = (i == 1 and "> " or "  ") .. s
    end
  end

  return _print(...)
end

return Debug
