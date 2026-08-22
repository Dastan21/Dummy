--[[
  Generated from ..\engine\battle\soul.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/soul.lua
]]

---@meta

--- @class Dummy.Battle.Soul
---
--- @field protected init_speed number
--- @field protected speed number
--- @field protected is_invincible boolean
--- @field protected invincible boolean
--- @field protected invincible_duration number
--- @field protected hitbox Dummy.Hitbox
--- @field protected override boolean
--- @field protected sprite Dummy.Sprite
--- @field protected is_fleeing boolean
--- @field protected flee_speed number
--- @field protected debug_hitbox_drawable Dummy.Drawable
Soul = {}

--- Initializes the soul
function Soul.load() end

--- Gets the player soul's sprite
--- @return Dummy.Sprite
function Soul.getSprite() end

--- Gets the player soul's position
--- @return number x horizontal position
--- @return number y vertical position
function Soul.getPosition() end

--- Sets the player soul's position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function Soul.setPosition(x, y, ignore_arena_bounds) end

--- Gets the player soul's speed
--- @return number
function Soul.getSpeed() end

--- Sets the player soul's speeds
--- @param speed number
function Soul.setSpeed(speed) end

--- Resets the player soul's speed to its default value
function Soul.resetSpeed() end

--- Wether the player is invincible
--- @return boolean
function Soul.isInvincible() end

--- Sets wether the player is invincible
--- @param invincible boolean
function Soul.setInvincible(invincible) end

--- Gets the player soul's invincibility duration, in seconds
--- @return number
function Soul.getInvincibility() end

--- Sets the player soul's invincibility duration, in seconds
--- @param invincibility number
function Soul.setInvincibility(invincibility) end

--- Wether the player is overriden
--- @return boolean
function Soul.isOverride() end

--- Sets wether the player is overriden
--- @param override boolean
function Soul.setOverride(override) end

--- Heals the player
--- @param amount number
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function Soul.heal(amount, silent) end

--- Hurts the player
--- @param amount number
--- @param silent? boolean wether to play then sound, animation and shake (Defaults to `false`)
function Soul.hurt(amount, silent) end

--- Wether the player soul's hitbox collides bullet's hitbox
--- @param bullet Dummy.Battle.Bullet
function Soul.isColliding(bullet) end

--- Animates the soul escaping
function Soul.flee() end

--- Wether the playing is playing the escape animation
--- @return boolean
function Soul.isFleeing() end

--- Updates the soul, called on every game update
--- @param dt number
function Soul.update(dt) end

