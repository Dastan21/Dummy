--[[
  Generated from ..\engine\world\object\obj_shop_transition.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_shop_transition.lua
]]

---@meta

--- @class Dummy.Object.ShopTransition : Dummy.Object
---
--- @field protected shop_id string
ShopTransitionObject = {}

--- Creates a shop transition
--- @param shop_id string
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
function ShopTransitionObject:new(shop_id, x, y, width, height) end

--- Called when the shop transition collides with another object
--- @param data Dummy.Object.CollisionData
function ShopTransitionObject:onCollisionSolid(data) end

--- Draws the shop transition's hitbox for debugging
--- @param camera Dummy.Camera
function ShopTransitionObject:drawDebug(camera) end

