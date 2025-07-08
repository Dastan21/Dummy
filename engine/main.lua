require "constants"

-- libraries
JSON = require "lib.json"
Timer = require "lib.timer"
UTF8 = require "lib.utf8"
require "lib.stable_sort"

-- engine
Utils = require "utils"
Class = require "class"
Assets = require "assets"
Input = require "input"
Lang = require "lang"
Fader = require "fader"
Shaker = require "shaker"
Drawable = require "drawable.drawable"
Sprite = require "drawable.sprite"
Text = require "drawable.text"
DialogueText = require "drawable.dialogue_text"
DialogueBubble = require "drawable.dialogue_bubble"
Debugger = require "debugger"
Scene = require "scene"
MainMenu = require "main_menu"
ModList = require "mod.mod_list"
Mod = require "mod.mod"

-- encounter
Arena = require "encounter.arena"
Player = require "encounter.player"
ActionMenu = require "encounter.action_menu"
Encounter = require "encounter.encounter"
Enemy = require "encounter.enemy"
ACT = require "encounter.act"
Wave = require "encounter.wave"
Bullet = require "encounter.bullet"
-- encounter item
Item = require "encounter.item"
ItemConsumable = require "encounter.item.consumable"
ItemEquipment = require "encounter.item.equipment"

local engine = {
  window = {
    translate_x = 0,
    translate_y = 0,
    scale = 1,
  },
  time = 0
}

Config = {
  language = "en",
  fps = 30,
  window_scale = 1,
  fullscreen = false
}

local function loadConfig()
  if love.filesystem.getInfo("settings.json") ~= nil then
    table.merge(Config, JSON.decode(love.filesystem.read("settings.json")))
  end
end

local function saveConfig()
  love.filesystem.write("settings.json", JSON.encode(Config))
end

function love.scale()
  if Config["fullscreen"] == true then
    love.window.setFullscreen(true)
  else
    local width = Constants.SCREEN_WIDTH * Config["window_scale"]
    local height = Constants.SCREEN_HEIGHT * Config["window_scale"]
    love.window.setMode(width, height)
    love.resize(width, height)
  end
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  love.audio.stop()
  if Constants.DEBUG then love.audio.setVolume(0) end

  love.filesystem.createDirectory("mods")
  love.filesystem.createDirectory("screenshots")

  love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

  loadConfig()

  engine.canvas = love.graphics.newCanvas(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
  engine.canvas:setFilter("nearest", "nearest")

  love.scale()

  Input.load()
  Lang.load()
  Assets.load()
  Scene.load()
  Fader.load()
  Shaker.load()
  Debugger.load()

  Scene.addScene("MAIN_MENU", require "scene.main_menu_scene")
  Scene.addScene("ENCOUNTER", require "scene.encounter_scene")
  Scene.addScene("GAME_OVER", require "scene.game_over_scene")
  Scene.addScene("ERROR", require "scene.error_scene")
  Scene.change("MAIN_MENU")

  engine.time = love.timer.getTime()
end

local function updateFullscreen()
  if Input.isPressed("f4") or (Input.isDown("lalt") and Input.isPressed("return")) then
    local fullscreen = not love.window.getFullscreen()
    Config["fullscreen"] = fullscreen
    love.scale()
  end
end

local function update(dt)
  engine.time = engine.time + (1 / Config["fps"])

  dt = Debugger.update(dt or love.timer.getDelta())

  Input.update()
  Scene.update(dt)
  Timer.update(dt)

  updateFullscreen()
end

local function limitFPS()
  local time = love.timer.getTime()
  if engine.time <= time then
    engine.time = time
    return
  end
  love.timer.sleep(engine.time - time)
end

local function draw()
  limitFPS()

  love.graphics.setCanvas(engine.canvas)
  love.graphics.clear()

  Scene.draw()
  Shaker.draw()

  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.translate(engine.window.translate_x, engine.window.translate_y)
  love.graphics.scale(engine.window.scale)
  love.graphics.draw(engine.canvas)

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", -engine.window.translate_x, 0, engine.window.translate_x, Constants.SCREEN_HEIGHT)
  love.graphics.rectangle("fill", Constants.SCREEN_WIDTH, 0, engine.window.translate_x, Constants.SCREEN_HEIGHT)
end

function love.resize(width, height)
  local scale = math.min(width / Constants.SCREEN_WIDTH, height / Constants.SCREEN_HEIGHT)
  engine.window.translate_x = (width - Constants.SCREEN_WIDTH * scale) / 2
  engine.window.translate_y = (height - Constants.SCREEN_HEIGHT * scale) / 2
  engine.window.scale = scale
end

function love.quit()
  saveConfig()
  Debugger.saveLogs()
end

local function error_handler(err)
  if err == "stack overflow" then
    err = "Stack overflow!"
  else
    err = debug.traceback(err)
  end
  print(err)
  if Scene.getSceneName() ~= "ERROR" then
    Scene.change("ERROR", err)
  end
end

function love.update(dt)
  xpcall(update, error_handler, dt)
end

function love.draw()
  xpcall(draw, error_handler)
end
