--[[
  Generated from ..\engine\encounter\bullet.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/bullet.lua
]]

---@meta

--- @class Dummy.Bullet : Dummy.Sprite
---
--- @field protected damage number
--- @field protected hitbox Dummy.Bullet.Hitbox
--- @field protected removed boolean
Bullet = {}

--- @alias Dummy.Bullet.Hitbox [ number, number, number, number ]

--- Gets the class name
--- @return string
function Bullet:getClass() end

--- Gets the bullet's hitbox
--- @return Dummy.Bullet.Hitbox
function Bullet:getHitbox() end

--- Sets the bullet's hitbox
--- @param hitbox Dummy.Bullet.Hitbox
function Bullet:setHitbox(hitbox) end

--- Gets the bullet's damage
--- @return number
function Bullet:getDamage() end

--- Sets the bullet's damage
--- @param damage number
function Bullet:setDamage(damage) end

--- Sets the bullet's sprite
--- @param sprite_name string
function Bullet:setSprite(sprite_name) end

--- Sets the bullet's hitbox from the sprite
--- @protected
function Bullet:setHitboxFromSprite() end

--- Removes the bullet
function Bullet:remove() end

--- Updates the bullet
--- @param dt number
function Bullet:update(dt) end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new() end

