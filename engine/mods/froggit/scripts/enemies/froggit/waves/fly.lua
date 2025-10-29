--- @class FlyWave : Dummy.Wave
---
--- @field spawn_timer table|nil
local FlyWave = Class:extend(Wave)

local FlyBullet = modRequire "scripts.enemies.froggit.bullets.fly"

--- Initializes the wave
function FlyWave:new()
  self = Class:new(FlyWave)
  self:setDuration(10 / 3)
  self:setArenaSize(155, 130)

  return self
end

--- Called when the wave starts
function FlyWave:onStart()
  self.spawn_timer = Timer.every(20 / 30, function()
    self:spawnFly()
  end)
  self:spawnFly()
end

--- Spawns a fly
function FlyWave:spawnFly()
  local fly = FlyBullet:new()
  self:spawnBullet(fly)

  local fly_dust_frames = { "waves/fly/fly_dust_1", "waves/fly/fly_dust_2", "waves/fly/fly_dust_3" }
  local fly_dust = Sprite:new(fly_dust_frames, 1 / 30, false, true, false)
  fly_dust:setPosition(fly:getPosition())
end

--- Called on every game update
function FlyWave:update(dt) end

--- Called when the wave ends
function FlyWave:onEnd()
  if self.spawn_timer ~= nil then
    Timer.cancel(self.spawn_timer)
  end
end

return FlyWave
