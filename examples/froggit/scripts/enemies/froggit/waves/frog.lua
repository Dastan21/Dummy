--- @class FrogWave : Dummy.Wave
local FrogWave = Class:extend(Wave)

local FrogBullet = require "scripts.enemies.froggit.bullets.frog"

--- Called when the wave starts
function FrogWave:onStart()
  local frog = FrogBullet:new()
  self:spawnBullet(frog)
end

--- Called on every game update
function FrogWave:update(dt) end

--- Called when the wave ends
function FrogWave:onEnd() end

--- Initializes the wave
function FrogWave:new()
  self = Class:new(FrogWave, { 10 / 3 })
  self:setArenaSize(155, 130)

  return self
end

return FrogWave
