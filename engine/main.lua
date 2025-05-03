local next_time = 0

local window = {
  width = 640,
  height = 480
}

Config = {
  language = "en",
  fps = 30,
}

require "engine.utils"

JSON = require "lib.json"

Audio = require "engine.audio"
Input = require "engine.input"
Lang = require "engine.lang"
Font = require "engine.font"
Sprite = require "engine.sprite"
Text = require "engine.text"
Debug = require "engine.debug"
Scene = require "engine.scene"

local function loadConfig()
  if love.filesystem.getInfo("settings.json") then
    table.merge(Config, JSON.decode(love.filesystem.read("settings.json")))
  end
end

local function saveConfig()
  love.filesystem.write("settings.json", JSON.encode(Config))
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.audio.stop()

  love.filesystem.createDirectory("mods")
  love.filesystem.createDirectory("saves")

  love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

  loadConfig()

  Input.load()
  Lang.load()
  Font.load()
  Debug.load()
  Scene.load("main_menu")

  next_time = love.timer.getTime()
end

local function checkFullscreen()
  if Input.isKeyPressed("f4") or (Input.isKeyDown("lalt") and Input.isKeyPressed("return")) then
    love.window.setFullscreen(not love.window.getFullscreen())
  end
end

function love.update(dt)
  next_time = next_time + (1 / Config["fps"])

  Input.update()
  Debug.update()
  Scene.update(dt)

  checkFullscreen()
end

local function limitFPS()
  local cur_time = love.timer.getTime()
  if next_time <= cur_time then
    next_time = cur_time
    return
  end
  love.timer.sleep(next_time - cur_time)
end

function love.draw()
  limitFPS()
  love.graphics.translate((window.translateX or 0), (window.translateY or 0))
  love.graphics.scale(window.scale or 1)

  Scene.draw()
  Debug.draw()
end

function love.resize(w, h)
  local w1, h1 = window.width, window.height
  local scale = math.min(w / w1, h / h1)
  window.translateX, window.translateY, window.scale = (w - w1 * scale) / 2, (h - h1 * scale) / 2, scale
end

function love.quit()
  saveConfig()
end
