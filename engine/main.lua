local dummy = {
  window = {
    width = 640,
    height = 480,
    translate_x = 0,
    translate_y = 0,
    scale = 1,
  },
  next_time = 0
}

Config = {
  language = "en",
  fps = 30,
  fullscreen = false
}

JSON = require "engine.lib.json"
Timer = require "engine.lib.timer"
require "engine.lib.stable_sort"

Utils = require "engine.utils"
Audio = require "engine.audio"
Input = require "engine.input"
Lang = require "engine.lang"
Font = require "engine.font"
Drawable = require "engine.drawable.drawable"
Sprite = require "engine.drawable.sprite"
Text = require "engine.drawable.text"
DialogueText = require "engine.drawable.dialogue_text"
Debug = require "engine.debug"
Scene = require "engine.scene"

local function loadConfig()
  if love.filesystem.getInfo("settings.json") ~= nil then
    table.merge(Config, JSON.decode(love.filesystem.read("settings.json")))
  end
end

local function saveConfig()
  love.filesystem.write("settings.json", JSON.encode(Config))
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.audio.stop()
  love.audio.setVolume(0) -- DEBUG

  love.filesystem.createDirectory("mods")
  love.filesystem.createDirectory("saves")
  love.filesystem.createDirectory("screenshots")

  love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

  loadConfig()

  if Config["fullscreen"] == true then
    love.window.setFullscreen(true)
  end

  Input.load()
  Lang.load()
  Font.load()
  Scene.load()
  Debug.load()
  Scene.change("MAIN_MENU")

  dummy.next_time = love.timer.getTime()
end

local function updateFullscreen()
  if Input.isPressed("f4") or (Input.isDown("lalt") and Input.isPressed("return")) then
    local is_fullscreen = love.window.getFullscreen()
    love.window.setFullscreen(not is_fullscreen)
    Config["fullscreen"] = not is_fullscreen
  end
end

local function update(dt)
  dummy.next_time = dummy.next_time + (1 / Config["fps"])

  Input.update()
  Scene.update(dt)
  Debug.update()
  Timer.update(dt)

  updateFullscreen()
  if Input.isPressed("f9") then
    Audio.playSound("screenshot")
    love.graphics.captureScreenshot("screenshots/" .. os.time() .. ".png")
  end
end

local function limitFPS()
  local cur_time = love.timer.getTime()
  if dummy.next_time <= cur_time then
    dummy.next_time = cur_time
    return
  end
  love.timer.sleep(dummy.next_time - cur_time)
end

local function draw()
  if not love.graphics.isActive() then return end

  limitFPS()
  love.graphics.translate(dummy.window.translate_x, dummy.window.translate_y)
  love.graphics.scale(dummy.window.scale)

  Scene.draw()

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", -dummy.window.translate_x, 0, dummy.window.translate_x, dummy.window.height)
  love.graphics.rectangle("fill", dummy.window.width, 0, dummy.window.translate_x, dummy.window.height)
  love.graphics.setColor(1, 1, 1)
end

function love.resize(width, height)
  local target_width, target_height = dummy.window.width, dummy.window.height
  local scale = math.min(width / target_width, height / target_height)
  dummy.window.translate_x = (width - target_width * scale) / 2
  dummy.window.translate_y = (height - target_height * scale) / 2
  dummy.window.scale = scale
end

function love.quit()
  saveConfig()
end

local function error_handler(err)
  if Scene.scene_name == "ERROR" then
    print(err)
  else
    Scene.change("ERROR", err)
  end
end

function love.update(dt)
  xpcall(update, error_handler, dt)
end

function love.draw()
  xpcall(draw, error_handler)
end
