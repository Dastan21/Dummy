--[[
  Generated from ..\engine\scene\world_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/world_scene.lua
]]

---@meta

--- @class Dummy.Scene.World : Dummy.Scene.Scene
---
--- @field protected world_camera Dummy.WorldCamera
--- @field protected ui_camera Dummy.GameCamera
--- @field protected mod Dummy.Mod
WorldScene = {}

--- Loads the world scene
--- @param mod Dummy.Mod
function WorldScene.load(mod) end

--- Wether the world scene is persistent
--- @return boolean
function WorldScene.isPersistent() end

--- Called when the scene is paused
function WorldScene.onPause() end

--- Called when the scene is resumed
function WorldScene.onResume() end

--- Gets the world camera
--- @return Dummy.WorldCamera
function WorldScene.getCamera() end

--- Updates the world scene, called on every game update
--- @param dt number
function WorldScene.update(dt) end

