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
--- @field protected arena_width number
--- @field protected arena_height number
Wave = {}

--- Gets the class name
--- @return string
function Wave.getClassName() end

--- Gets the wave's elapsed time
--- @return number
function Wave:getTime() end

--- Gets the wave's duration
--- @return number
function Wave:getDuration() end

--- Sets the wave's duration
--- @param duration number
function Wave:setDuration(duration) end

--- Wether the wave is done
--- @return boolean
function Wave:isDone() end

--- Ends the wave
function Wave:done() end

--- Spawns a bullet
--- @param bullet Dummy.Bullet the bullet to spawn
function Wave:spawnBullet(bullet) end

--- Gets the wave's bullets
--- @return Dummy.Bullet[]
function Wave:getBullets() end

--- Sets the wave's arena size
--- @param width number
--- @param height number
function Wave:setArenaSize(width, height) end

--- Gets the wave's arena size
--- @return number, number
function Wave:getArenaSize() end

--- [INTERNAL] Starts the wave
--- @private
function Wave:__start() end

--- [INTERNAL] Updates the wave
--- @private
function Wave:__update(dt) end

--- [INTERNAL] Ends the wave
--- @private
function Wave:__end() end

--- Called when the wave starts
function Wave:onStart() end

--- Called when the wave updates
--- @param dt number
function Wave:update(dt) end

--- Called when the wave ends
function Wave:onEnd() end

--- Creates an enemy Waveing
--- @param duration? number wave duration, in seconds (Defaults to `8`)
--- @return Dummy.Wave
function Wave:new(duration) end

