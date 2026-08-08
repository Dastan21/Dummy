require "constants"

-- libraries
JSON = require "lib.json"
UTF8 = require "lib.utf8"
require "lib.stable_sort"

-- engine
Utils = require "utils.utils"
Config = require "config"
Class = require "class"
Signal = require "signal"
Assets = require "assets"
Input = require "input"
Lang = require "lang"
Camera = require "camera.camera"
GameCamera = require "camera.game_camera"
WorldCamera = require "camera.world_camera"
Timer = require "utils.timer"
Drawable = require "drawable.drawable"
Sprite = require "drawable.sprite"
Text = require "drawable.text"
Mask = require "drawable.mask"
DialogueText = require "drawable.dialogue_text"
DialogueBubble = require "drawable.dialogue_bubble"
Textbox = require "drawable.textbox"
Player = require "player"
Fader = require "utils.fader"
Shaker = require "utils.shaker"
Debug = require "utils.debug"
Cursor = require "utils.cursor"
Shader = require "shader"
Scene = require "scene"
MainMenu = require "main_menu"
ModList = require "mod.mod_list"
Mod = require "mod.mod"

-- world
World = require "world.world"
Room = require "world.room"
Shop = require "world.shop"
Cutscene = require "world.cutscene"
PlayerMenu = require "world.menu.player_menu"
SaveMenu = require "world.menu.save_menu"
ChestboxMenu = require "world.menu.chestbox_menu"
Tileset = require "world.tileset"
Object = require "world.object.object"
SolidObject = require "world.object.obj_solid"
SolidTriangleObject = require "world.object.obj_solid_triangle"
RoomTransitionObject = require "world.object.obj_room_transition"
ShopTransitionObject = require "world.object.obj_shop_transition"
NPCObject = require "world.object.obj_npc"
PlayerObject = require "world.object.obj_player"
SavepointObject = require "world.object.obj_savepoint"
ChestboxObject = require "world.object.obj_chestbox"
ReadableObject = require "world.object.obj_readable"

-- item
Item = require "item.item"
ItemConsumable = require "item.consumable"
ItemEquipment = require "item.equipment"

-- battle
Arena = require "battle.arena"
Soul = require "battle.soul"
ActionMenu = require "battle.action_menu"
Battle = require "battle.battle"
Encounter = require "battle.encounter"
Enemy = require "battle.enemy"
ACT = require "battle.act"
Wave = require "battle.wave"
Bullet = require "battle.bullet"

--- @class Dummy.Engine
---
--- @field private time number
--- @field private hmr_time number
--- @field private canvas love.Canvas|nil
local engine = {
  time = 0,
  hmr_time = 0,
  canvas = nil
}

--- This function is called exactly once at the beginning of the game.
--- @param arg table
--- @param unfilteredArg table
function love.load(arg, unfilteredArg)
  Constants.DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1"
  Constants.HOT_RELOAD = love.system.getOS() ~= "Web"

  love.graphics.setDefaultFilter("nearest", "nearest")

  love.audio.stop()

  love.filesystem.createDirectory("mods")
  love.filesystem.createDirectory("configs")
  love.filesystem.createDirectory("screenshots")

  love.joystick.loadGamepadMappings("gamecontrollerdb.txt")

  Constants.INIT_GAME_WIDTH = Constants.GAME_WIDTH
  Constants.INIT_GAME_HEIGHT = Constants.GAME_HEIGHT

  engine.canvas = love.graphics.newCanvas()
  engine.canvas:setFilter("nearest", "nearest")

  Config.load()
  love.scale()

  Input.load()
  Lang.load()
  Assets.load()
  Scene.load()
  Cursor.load()
  Fader.load()
  Shaker.load()
  Debug.load()

  love.audio.setVolume(Config.getSettings()["volume"] / 100)

  Scene.addScene("MAIN_MENU", require "scene.main_menu_scene")
  Scene.addScene("WORLD", require "scene.world_scene")
  Scene.addScene("SHOP", require "scene.shop_scene")
  Scene.addScene("BATTLE", require "scene.battle_scene")
  Scene.addScene("EDITOR", require "scene.editor_scene")
  Scene.addScene("GAME_OVER", require "scene.game_over_scene")
  Scene.addScene("ERROR", require "scene.error_scene")
  Scene.change("MAIN_MENU")

  engine.time = love.timer.getTime()
end

--- Sets the window title
--- @param title string
function love.setTitle(title)
  if Debug.isDebugMode() then
    title = string.format("%s (%s)", title, "DEBUG")
  end
  love.window.setTitle(title)
end

--- Called to scale the game window
function love.scale()
  local settings = Config.getSettings()
  local window_width = Constants.INIT_GAME_WIDTH * settings["window_scale"]
  local window_height = Constants.INIT_GAME_HEIGHT * settings["window_scale"]
  love.window.updateMode(window_width, window_height, {
    fullscreen = settings.fullscreen,
    vsync = settings.vsync
  })

  love.resize(love.window.getMode())
end

--- Called when the window is resized, for example if the user resizes the window, or if love.window.setMode is called with an unsupported width or height in fullscreen and the window chooses the closest appropriate size.
--- @param width number
--- @param height number
function love.resize(width, height)
  Constants.WINDOW_WIDTH = width
  Constants.WINDOW_HEIGHT = height

  engine.canvas:release()
  engine.canvas = love.graphics.newCanvas()

  Signal.emit("window_resize", Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
end

--- Updates the fullscreen state
function engine.updateFullscreen()
  local settings = Config.getSettings()
  if (Input.isPressed("f4") and not Input.isDown("lalt")) or (Input.isPressed("return") and Input.isDown("lalt")) then
    local fullscreen = not love.window.getFullscreen()
    settings.fullscreen = fullscreen
    love.scale()
  end
end

--- Called when a file is dragged and dropped onto the window
function love.filedropped(file)
  ModList.copyModZip(file)
end

--- Limits the framerate
function engine.limitFPS()
  local time = love.timer.getTime()
  if engine.time <= time or not Config.getSettings()["fps"] == -1 then
    engine.time = time
    return
  end
  love.timer.sleep(engine.time - time)
end

--- Engine error handler function
--- @param err any
function engine.error_handler(err)
  if err == "stack overflow" then
    err = "Stack overflow!"
  else
    err = debug.traceback(err)
  end
  print(err)
  if Scene.getCurrentSceneId() ~= "ERROR" then
    Scene.change("ERROR", err)
  end
end

--- Callback function used to update the state of the game every frame.
--- @param dt number
function love.update(dt)
  xpcall(function()
    if dt > 2 / 30 then return end

    local fps = Config.getSettings()["fps"]
    if fps > 0 then
      engine.time = engine.time + (1 / fps)
    end

    dt = Debug.update(dt or love.timer.getDelta())

    Input.update()

    if Constants.HOT_RELOAD then
      if engine.hmr_time >= Constants.HOT_RELOAD_DELAY then
        engine.hmr_time = 0
        Lang.hotReload()
        Sprite.hotReload()
      end

      engine.hmr_time = engine.hmr_time + dt
    end

    Scene.update(dt)
    Timer.update(dt)

    engine.updateFullscreen()
  end, engine.error_handler, dt)
end

--- Callback function used to draw on the screen every frame.
function love.draw()
  xpcall(function()
    engine.limitFPS()

    love.graphics.setCanvas({ engine.canvas, stencil = true })
    love.graphics.clear()

    Scene.draw()
    Fader.draw()

    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(engine.canvas)
    love.graphics.setBlendMode("alpha", "alphamultiply")
  end, engine.error_handler)
end

--- Callback function triggered when the game is closed.
--- @return boolean abort
function love.quit()
  if love.system.getOS() == "Web" then return true end

  Config.save()
  Debug.saveLogs()

  return not Scene.canQuit()
end
