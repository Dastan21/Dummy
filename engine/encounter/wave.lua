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

--- [INTERNAL] Called when the wave starts
--- @private
function Wave:__start()
  self.bullets = {}
  self.time = 0
  self.is_done = false

  self:start()
end

--- [INTERNAL] Called when the wave is updating
--- @private
function Wave:__update(dt)
  self.time = self.time + dt
  if self.time >= self.duration then
    if not self.is_done then
      self.is_done = true
      Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
      if (type(self.done) == "function") then
        self:__done()
      end
    end
    return
  end

  for bullet in pairs(self.bullets) do
    bullet:update(dt)

    if bullet:isVisible() and not Player.isInvincible() and Player.isColliding(bullet) then
      bullet:destroy()
      Player.hurt(bullet:getDamage())
    end
  end

  self:update(dt)
end

--- [INTERNAL] Called when the wave is done
--- @private
function Wave:__done()
  for bullet in pairs(self.bullets) do
    bullet:destroy()
  end

  self:done()
end

--- Called when the wave starts
function Wave:start() end

--- Called when the wave is updating
--- @param dt number
function Wave:update(dt) end

--- Called when the wave is done
function Wave:done() end

--- Creates an enemy Waveing
--- @param duration? number wave duration, in seconds (Defaults to `8`)
--- @return Dummy.Wave
function Wave:new(duration)
  return Class:new(Wave, {
    duration = Utils.getOrDefault(duration, 8),
    time = 0,
    is_done = false
  })
end

return Wave
