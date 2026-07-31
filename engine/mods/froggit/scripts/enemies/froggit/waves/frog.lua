--- @class FroggitMod.Wave.Frog : Dummy.Battle.Wave
local FrogWave = Class(Wave, "FroggitMod.Wave.Frog")

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

--- Called when the wave ends
function FrogWave:onEnd() end

--- Updates the wave, called on every game update
--- @param dt number
function FrogWave:update(dt) end

return FrogWave
