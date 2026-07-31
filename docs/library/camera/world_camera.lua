--[[
  Generated from ..\engine\camera\world_camera.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/camera/world_camera.lua
]]

---@meta

--- @class Dummy.WorldCamera : Dummy.GameCamera
---
--- @field protected attached boolean
--- @field protected target Dummy.Object|nil
WorldCamera = {}

--- Creates a world camera
--- @return Dummy.WorldCamera
function WorldCamera:new() end

--- Wether the camera is attached
--- @return boolean
function WorldCamera:isAttached() end

--- Sets wether the camera is attached
--- @param attached boolean
function WorldCamera:setAttached(attached) end

--- Gets the world camera's target
--- @return Dummy.Object|nil
function WorldCamera:getTarget() end

--- Sets the world camera's target
--- @param target Dummy.Object|nil
function WorldCamera:setTarget(target) end

--- Sets the world camera's viewport position
--- @param x number
--- @param y number
function WorldCamera:setViewportPosition(x, y) end

--- Applies the camera transformations before drawing the drawables
function WorldCamera:apply() end

--- Updates the world camera, called on every game update
--- @param dt number
function WorldCamera:update(dt) end

