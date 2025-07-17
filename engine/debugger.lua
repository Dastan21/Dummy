--- @class Dummy.Debugger
---
--- @field protected logs string[]
--- @field protected margin number
--- @field protected scale number
--- @field protected display_hitbox boolean
--- @field protected paused boolean
--- @field protected log_bg_sprite Dummy.Sprite
--- @field protected log_text Dummy.Text
--- @field protected fps_text Dummy.Text
local Debugger = {}

--- Wether the hitboxes should be displayed
--- @return boolean
function Debugger.shouldDisplayHitbox()
  return Debugger.display_hitbox
end

--- Wether the debugger is paused
--- @return boolean
function Debugger.isPaused()
  return Debugger.paused
end

--- Pauses the game
function Debugger.pause()
  Debugger.paused = true
end

--- Resumes the game
function Debugger.resume()
  Debugger.paused = false
end

--- Loads the debugger
function Debugger.load()
  Debugger.logs = {}
  Debugger.margin = 5
  Debugger.scale = 1

  Debugger.display_hitbox = false
  Debugger.paused = false

  Debugger.log_bg_sprite = Sprite:new("pixel")
  Debugger.log_bg_sprite:setPosition(0, 0)
  Debugger.log_bg_sprite:setOrigin(0, 0)
  Debugger.log_bg_sprite:setLayer(Constants.LAYERS.DEBUG)
  Debugger.log_bg_sprite:setColor(0, 0, 0, 0.4)
  Debugger.log_bg_sprite:setVisible(false)
  Debugger.log_bg_sprite:setPersistent(true)
  Debugger.log_bg_sprite:setScale(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)

  Debugger.log_text = Text:new("")
  Debugger.log_text:setPosition(Debugger.margin, Constants.SCREEN_HEIGHT - Debugger.margin)
  Debugger.log_text:setOrigin(0, 1)
  Debugger.log_text:setScale(Debugger.scale)
  Debugger.log_text:setLayer(Constants.LAYERS.DEBUG)
  Debugger.log_text:setFont(Assets.getFont("main_text"))
  Debugger.log_text:setVisible(false)
  Debugger.log_text:setPersistent(true)

  Debugger.fps_text = Text:new("")
  Debugger.fps_text:setPosition(Constants.SCREEN_WIDTH - Debugger.margin, Debugger.margin)
  Debugger.fps_text:setOrigin(1, 0)
  Debugger.fps_text:setScale(Debugger.scale)
  Debugger.fps_text:setLayer(Constants.LAYERS.DEBUG)
  Debugger.fps_text:setFont(Assets.getFont("main_text"))
  Debugger.fps_text:setVisible(false)
  Debugger.fps_text:setPersistent(true)
end

--- Saves the logs
function Debugger.saveLogs()
  if #Debugger.logs <= 0 then return end

  love.filesystem.write("logs.txt", table.concat(Debugger.logs, "\n"))
end

--- Clears the logs
function Debugger.clearLogs()
  Debugger.logs = {}
end

--- Updates the debugger
--- @param dt number
--- @return number
function Debugger.update(dt)
  if Debugger.paused and not (Input.isPressed("kp+") or (Input.isDown("ctrl") and Input.isDown("kp+"))) then
    dt = 0
  end

  Debugger.fps_text:setText(tostring(love.timer.getFPS()))

  local max_lines = math.ceil((Constants.SCREEN_HEIGHT - Debugger.margin) / Debugger.log_text:getFont():getHeight())
  local logs = table.slice(Debugger.logs, #Debugger.logs - max_lines, #Debugger.logs)
  Debugger.log_text:setText(table.concat(logs, "\n"))

  if Input.isPressed("f6") then
    Debugger.fps_text:setVisible(not Debugger.fps_text:isVisible())
  elseif Input.isPressed("f7") then
    Debugger.display_hitbox = not Debugger.display_hitbox
  elseif Input.isDown("ctrl") and Input.isPressed("f8") then
    Debugger.clearLogs()
  elseif Input.isPressed("f8") then
    local visible = not Debugger.log_bg_sprite:isVisible()
    Debugger.log_bg_sprite:setVisible(visible)
    Debugger.log_text:setVisible(visible)
  elseif Input.isPressed("f9") then
    Assets.playSound("screenshot")
    love.graphics.captureScreenshot("screenshots/" .. os.time() .. ".png")
  elseif Input.isDown("ctrl") and Input.isPressed("r") then
    if Input.isDown({ "lshift", "rshift" }) then
      Scene.fullReload()
    else
      Scene.reload()
    end
  elseif Input.isDown("ctrl") and Input.isPressed(";") then
    love.audio.setVolume(love.audio.getVolume() > 0 and 0 or 1)
  elseif Input.isDown("ctrl") and Input.isPressed("g") then
    if Scene.getSceneName() == "ENCOUNTER" then
      local x, y = Player.getPosition()
      Scene.change("GAME_OVER", x, y)
    end
  elseif Input.isDown("ctrl") and Input.isPressed("p") then
    Debugger.paused = not Debugger.paused
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

  if Debugger.log_text ~= nil then
    local _, w = Debugger.log_text:getFont():getWrap(table.concat(t, "	"),
      (Constants.SCREEN_WIDTH / Debugger.scale) - (Debugger.margin * 2))
    local len = #Debugger.logs
    for i, s in ipairs(w) do
      Debugger.logs[len + i] = (i == 1 and "> " or "  ") .. s
    end
  end

  return _print(...)
end

return Debugger
