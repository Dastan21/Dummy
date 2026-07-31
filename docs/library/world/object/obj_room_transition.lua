--[[
  Generated from ..\engine\world\object\obj_room_transition.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_room_transition.lua
]]

---@meta

--- @class Dummy.Object.RoomTransition : Dummy.Object
---
--- @field protected room_id string
--- @field protected spawn_x number
--- @field protected spawn_y number
--- @field protected instant boolean
--- @field protected enabled boolean
RoomTransitionObject = {}

--- Creates a room transition
--- @param room_id string
--- @param spawn_x number
--- @param spawn_y number
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
--- @param instant? boolean wether the room transition is instant (Defaults to `false`)
function RoomTransitionObject:new(room_id, spawn_x, spawn_y, x, y, width, height, instant) end

--- Gets wether the room transition is enabled
--- @return boolean
function RoomTransitionObject:isEnabled() end

--- Sets wether the room transition is enabled
--- @param enabled boolean
function RoomTransitionObject:setEnabled(enabled) end

--- Called when the room transition collides with another object
--- @param data Dummy.Object.CollisionData
function RoomTransitionObject:onCollisionSolid(data) end

--- Draws the room transition's hitbox for debugging
--- @param camera Dummy.Camera
function RoomTransitionObject:drawDebug(camera) end

