--- @class Dummy.Scene.World : Dummy.Scene.Scene
---
--- @field protected world_camera Dummy.WorldCamera
--- @field protected ui_camera Dummy.GameCamera
--- @field protected mod Dummy.Mod
--- @field protected persistent boolean
local WorldScene = {}

--- Loads the world scene
--- @param mod Dummy.Mod
--- @param room_id? string
function WorldScene.load(mod, room_id)
  WorldScene.world_camera = WorldCamera:new()
  WorldScene.ui_camera = GameCamera:new(Constants.GAME_WIDTH, Constants.GAME_HEIGHT, "UI")
  WorldScene.persistent = room_id == nil

  Cursor.setVisible(false)

  Player.load()
  World.load(room_id ~= nil)

  if World.getCurrentRoom() == nil then
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

  if room_id ~= nil then
    Timer.next(function()
      Timer.next(function()
        World.transitionRoom(room_id, 150, 105, true)
      end)
    end)
  end
end

--- Wether the world scene is persistent
--- @return boolean
function WorldScene.isPersistent()
  return WorldScene.persistent
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

  if Debug.isDebugMode() then
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
