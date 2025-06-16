--[[
  Generated from ..\engine\encounter\wave.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/wave.lua
]]

---@meta

--- @class Dummy.Wave : Dummy.Class
---
--- @field protected duration number
--- @field protected time number
--- @field protected is_done boolean
--- @field protected bullets table<Dummy.Bullet, boolean>
Wave = {}

--- Gets the class name
--- @return string
function Wave:getClass() end

--- Gets the wave's duration
--- @return number
function Wave:getDuration() end

--- Gets the wave's elapsed time
--- @return number
function Wave:getTime() end

--- Spawns a bullet
--- @param bullet Dummy.Bullet the bullet to spawn
function Wave:spawnBullet(bullet) end

--- Gets the wave's bullets
--- @return Dummy.Bullet[]
function Wave:getBullets() end

--- [INTERNAL] Called when the wave starts
--- @private
function Wave:__start() end

--- [INTERNAL] Called when the wave is updating
--- @private
function Wave:__update(dt) end

--- [INTERNAL] Called when the wave is done
--- @private
function Wave:__done() end

--- Called when the wave starts
function Wave:start() end

--- Called when the wave is updating
--- @param dt number
function Wave:update(dt) end

--- Called when the wave is done
function Wave:done() end

--- Creates an enemy Waveing
--- @param duration? number wave duration, in seconds (Defaults to `10`)
--- @return Dummy.Wave
function Wave:new(duration) end

