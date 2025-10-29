--- @class FrogWave : Dummy.Wave
local FrogWave = Class:extend(Wave)

local FrogBullet = modRequire "scripts.enemies.froggit.bullets.frog"

--- Initializes the wave
function FrogWave:new()
  self = Class:new(FrogWave)
  self:setDuration(10 / 3)
  self:setArenaSize(155, 130)

  return self
end

--- Called when the wave starts
function FrogWave:onStart()
  local frog = FrogBullet:new()
  self:spawnBullet(frog)
end

--- Called on every game update
function FrogWave:update(dt) end

--- Called when the wave ends
function FrogWave:onEnd() end

return FrogWave
