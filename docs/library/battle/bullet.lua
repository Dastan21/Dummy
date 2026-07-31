--[[
  Generated from ..\engine\battle\bullet.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/bullet.lua
]]

---@meta

--- @class Dummy.Battle.Bullet : Dummy.Sprite
---
--- @field protected damage number
--- @field protected hitbox Dummy.Hitbox
--- @field protected removed boolean
--- @field protected wave Dummy.Battle.Wave
Bullet = {}

--- Gets the bullet's hitbox
--- @return Dummy.Hitbox
function Bullet:getHitbox() end

--- Sets the bullet's hitbox
--- @param hitbox Dummy.Hitbox
function Bullet:setHitbox(hitbox) end

--- Gets the bullet's damage
--- @return number
function Bullet:getDamage() end

--- Sets the bullet's damage
--- @param damage number
function Bullet:setDamage(damage) end

--- Sets the bullet's sprite
--- @overload fun(self: Dummy.Battle.Bullet, sprite_name?: string|love.Image): Dummy.Sprite
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
--- @return Dummy.Battle.Wave
function Bullet:getWave() end

--- Called when the bullet is spawned
function Bullet:onSpawned() end

--- Called when the bullet hits the player
function Bullet:onHit() end

--- Draws for debugging
--- @param camera Dummy.Camera
function Bullet:drawDebug(camera) end

--- Creates a bullet
--- @return Dummy.Battle.Bullet
function Bullet:new() end

