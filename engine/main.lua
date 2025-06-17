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
Drawable = require "drawable.drawable"
Sprite = require "drawable.sprite"
Text = require "drawable.text"
DialogueText = require "drawable.dialogue_text"
Debugger = require "debugger"
Scene = require "scene"
MainMenu = require "main_menu"
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

local dummy = {
  window = {
    width = Constants.WIDTH,
    height = Constants.HEIGHT,
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
  if Constants.DEBUG then
    love.audio.setVolume(0)
  end

  love.filesystem.createDirectory("mods")
  love.filesystem.createDirectory("saves")
  love.filesystem.createDirectory("screenshots")

  love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

  loadConfig()

  if Config["fullscreen"] == true then
    love.window.setFullscreen(true)
  end
  love.resize(love.window.getMode())

  Input.load()
  Lang.load()
  Assets.load()
  Scene.load()
  Fader.load()
  Debugger.load()

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
  Fader.update(dt)
  Debugger.update()
  Timer.update(dt)

  updateFullscreen()
  if Input.isPressed("f9") then
    Assets.playSound("screenshot")
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

  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", -dummy.window.translate_x, 0, dummy.window.translate_x, dummy.window.height)
  love.graphics.rectangle("fill", dummy.window.width, 0, dummy.window.translate_x, dummy.window.height)
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
