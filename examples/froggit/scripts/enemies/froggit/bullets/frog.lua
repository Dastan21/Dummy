--- @class FrogBullet : Dummy.Bullet
---
--- @field leap_timer table
--- @field vel_x number
--- @field vel_y number
--- @field acc_x number
--- @field acc_y number
local FrogBullet = Class:extend(Bullet)

--- Initializes the bullet
function FrogBullet:new()
  self = Class:new(FrogBullet)
  self:setSprite("waves/frog/frog_bullet_1")
  self:setOrigin(0, 0)
  self:setHitbox({ 5, 18, 32, 20 })
  self:setDamage(Encounter.getEnemies()[1]:getAT() * 1.8)
  local arena_x, arena_y = Arena.getPosition()
  self:setPosition(arena_x + Arena.getWidth() / 2 - self:getWidth(), arena_y - self:getHeight())

  self.is_jumping = false

  local leap_delay = 1 + math.random()
  self.leap_timer = Timer.after(leap_delay, function()
    self:leap()
  end)

  return self
end

--- Halts the bullet
function FrogBullet:leap()
  local gravity_direction = math.rad(280)
  self.acc_x = 90 * math.cos(gravity_direction)
  self.acc_y = -90 * math.sin(gravity_direction)

  local leap_direction = math.rad(145 - (math.random() * 20))
  self.vel_x = 120 * math.cos(leap_direction)
  self.vel_y = -120 * math.sin(leap_direction)
  self.is_jumping = true

  self:setSprite("waves/frog/frog_bullet_2")
  self:setHitbox({ 5, 6, 26, 26 })
end

--- Called when the bullet is removed
function FrogBullet:onRemoved()
  if self.leap_timer ~= nil then
    Timer.cancel(self.leap_timer)
  end

  self:getWave():done()
end

--- Called on every game update
function FrogBullet:update(dt)
  if not self.is_jumping then return end

  local x, y = self:getPosition()
  self:setPosition(x + self.vel_x * dt, y + self.vel_y * dt)

  self.vel_x = self.vel_x + self.acc_x * dt
  self.vel_y = self.vel_y + self.acc_y * dt

  if not Arena.isInBounds(x, y) then
    self:remove()
  end
end

return FrogBullet
