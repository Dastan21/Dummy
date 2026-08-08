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

--- @class Dummy.Object.RoomTransition.Data : Dummy.Object.Data
---
--- @field room_id string
--- @field spawn_x number
--- @field spawn_y number
--- @field instant boolean

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

--- Initializes the room transition's arguments before creating it
--- @param data Dummy.Object.RoomTransition.Data
function RoomTransitionObject.initArgs(data) end

--- Gets the room transition metadata
--- @return Dummy.Editor.Metadata[]
function RoomTransitionObject.getMetadata() end

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

--- Draws the room transition for the editor
--- @param data Dummy.Object.Solid.Data
function RoomTransitionObject.drawEditor(data) end

