--- @class Dummy.Wave : Dummy.Class
---
--- @field protected duration number
--- @field protected time number
--- @field protected is_done boolean
--- @field protected bullets table<Dummy.Bullet, boolean>
--- @field protected arena_width number
--- @field protected arena_height number
local Wave = Class()

--- Gets the class name
--- @return string
function Wave.getClassName()
  return "Dummy.Wave"
end

--- Gets the wave's elapsed time
--- @return number
function Wave:getTime()
  return self.time
end

--- Gets the wave's duration
--- @return number
function Wave:getDuration()
  return self.duration
end

--- Sets the wave's duration
--- @param duration number
function Wave:setDuration(duration)
  self.duration = duration
end

--- Wether the wave is done
--- @return boolean
function Wave:isDone()
  return self.is_done
end

--- Ends the wave
function Wave:done()
  self.is_done = true
  self:__end()
end

--- Spawns a bullet
--- @param bullet Dummy.Bullet the bullet to spawn
function Wave:spawnBullet(bullet)
  --- @diagnostic disable-next-line: invisible
  bullet.wave = self
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

--- Sets the wave's arena size
--- @param width number
--- @param height number
function Wave:setArenaSize(width, height)
  self.arena_width = width
  self.arena_height = height
end

--- Gets the wave's arena size
--- @return number, number
function Wave:getArenaSize()
  return self.arena_width, self.arena_height
end

--- [INTERNAL] Starts the wave
--- @private
function Wave:__start()
  self.bullets = {}
  self.time = 0
  self.is_done = false

  if type(self.onStart) == "function" then
    self:onStart()
  end
end

--- [INTERNAL] Updates the wave
--- @private
function Wave:__update(dt)
  if self.is_done then return end

  self.time = self.time + dt
  if self.time >= self.duration then
    self:done()
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

  if type(self.onEnd) == "function" then
    self:onEnd()
  end
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
  wave.arena_width = Constants.ARENA.DEFAULT_WIDTH
  wave.arena_height = Constants.ARENA.DEFAULT_HEIGHT

  return wave
end

return Wave
