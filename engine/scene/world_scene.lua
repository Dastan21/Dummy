--- @class Dummy.Scene.World : Dummy.Scene.Scene
---
--- @field protected world_camera Dummy.WorldCamera
--- @field protected ui_camera Dummy.GameCamera
--- @field protected mod Dummy.Mod
local WorldScene = {}

--- Loads the world scene
--- @param mod Dummy.Mod
function WorldScene.load(mod)
  WorldScene.world_camera = WorldCamera:new()
  WorldScene.ui_camera = GameCamera:new(Constants.GAME_WIDTH, Constants.GAME_HEIGHT, "UI")

  World.load()
  Player.load()

  if World.getCurrentRoom() == nil then
    local DefaultRoom = Class(Room, "Dummy.Room.DefaultRoom")
    function DefaultRoom:new() return Class:new(DefaultRoom, { "default", "--", 320, 240 }) end

    World.addRoom("default", DefaultRoom)
    World.transitionRoom("default", 150, 105, true)
  end

  WorldScene.mod = mod
  ModList.loadMod(mod)
  ModList.setWindowTitleAndIcon()

  local save_config = mod:getConfig()
  if save_config.savepoint ~= nil then
    ---@diagnostic disable-next-line: invisible
    World.playtime = save_config.savepoint.time
  end
end

--- Wether the world scene is persistent
--- @return boolean
function WorldScene.isPersistent()
  return true
end

--- Called when the scene is paused
function WorldScene.onPause()
  World.onPause()
end

--- Called when the scene is resumed
function WorldScene.onResume()
  World.onResume()
end

--- Gets the world camera
--- @return Dummy.WorldCamera
function WorldScene.getCamera()
  return WorldScene.world_camera
end

--- Updates the world scene, called on every game update
--- @param dt number
function WorldScene.update(dt)
  if type(WorldScene.mod.update) == "function" then
    WorldScene.mod:update(dt)
  end

  if dt <= 0 then return end

  if Constants.DEBUG then
    local obj_player = Player.getObject()
    if obj_player ~= nil then
      if Input.isDown("shift") and Input.isPressed("b") then
        obj_player:setCollisionEnabled(not obj_player:isCollisionEnabled())
      end
    end
  end

  World.update(dt)
end

return WorldScene
