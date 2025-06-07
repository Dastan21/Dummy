--[[
  Generated from ..\engine\encounter\bullet.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/bullet.lua
]]

---@meta

--- @class Dummy.Bullet : Dummy.Sprite
---
--- @field protected hitbox Dummy.Bullet.Hitbox
--- @field protected persistent boolean
Bullet = {}

--- @alias Dummy.Bullet.Hitbox {[1]:number, [2]:number, [3]:number, [4]:number}

--- Gets the class name
--- @return string
function Bullet:getClass() end

--- Gets the bullet's hitbox
--- @return Dummy.Bullet.Hitbox
function Bullet:getHitbox() end

--- Sets the bullet's hitbox
--- @param hitbox Dummy.Bullet.Hitbox
function Bullet:setHitbox(hitbox) end

--- Wether the bullet is persistent after wave ends
--- @return boolean
function Bullet:getPersistent() end

--- Sets wether the bullet is persistent after wave ends
--- @param persistent boolean
function Bullet:setPersistent(persistent) end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new() end

