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
--- @field protected wave Dummy.Wave
Bullet = {}

--- @alias Dummy.Bullet.Hitbox [ number, number, number, number ]

--- Gets the class name
--- @return string
function Bullet.getClassName() end

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
--- @overload fun(self: Dummy.Bullet, sprite_name?: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
function Bullet:setSprite(sprites_names, speed, loop, play, keep_last_frame) end

--- Sets the bullet's hitbox from the sprite
--- @protected
function Bullet:setHitboxFromSprite() end

--- Gets the wave the bullet is from
--- @return Dummy.Wave
function Bullet:getWave() end

--- Called when the bullet hits the player
function Bullet:onHit() end

--- Draws for debugging
function Bullet:debugDraw() end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new() end

