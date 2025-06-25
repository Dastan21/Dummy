--- @class Dummy.Wave : Dummy.Class
---
--- @field protected duration number
--- @field protected time number
--- @field protected is_done boolean
--- @field protected bullets table<Dummy.Bullet, boolean>
local Wave = Class()

--- Gets the class name
--- @return string
function Wave:getClass()
  return "Dummy.Wave"
end

--- Gets the wave's duration
--- @return number
function Wave:getDuration()
  return self.duration
end

--- Gets the wave's elapsed time
--- @return number
function Wave:getTime()
  return self.time
end

--- Spawns a bullet
--- @param bullet Dummy.Bullet the bullet to spawn
function Wave:spawnBullet(bullet)
  self.bullets[bullet] = true
end

--- Gets the wave's bullets
--- @return Dummy.Bullet[]
function Wave:getBullets()
  local bullets = {}
  for bullet in pairs(self.bullets) do
    table.insert(bullets, bullet)
  end
  return bullets
end

--- [INTERNAL] Starts the wave
--- @private
function Wave:__start()
  self.bullets = {}
  self.time = 0
  self.is_done = false

  self:onStart()
end

--- [INTERNAL] Updates the wave
--- @private
function Wave:__update(dt)
  self.time = self.time + dt
  if self.time >= self.duration then
    if not self.is_done then
      self.is_done = true
      Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
      if (type(self.onEnd) == "function") then
        self:__end()
      end
    end
    return
  end

  for bullet in pairs(self.bullets) do
    bullet:update(dt)

    if bullet:isVisible() and not Player.isInvincible() and Player.isColliding(bullet) then
      bullet:remove()
      Player.hurt(bullet:getDamage())
    end
  end

  self:update(dt)
end

--- [INTERNAL] Ends the wave
--- @private
function Wave:__end()
  for bullet in pairs(self.bullets) do
    bullet:remove()
  end

  self:onEnd()
end

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
function Wave:new(duration)
  local wave = Class:new(Wave)

  wave.duration = Utils.getOrDefault(duration, 8)
  wave.time = 0
  wave.is_done = false

  return wave
end

return Wave
