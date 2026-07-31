--- @class FroggitMod.Bullet.Fly : Dummy.Battle.Bullet
---
--- @field protected target_angle number
--- @field protected fly_speed number
--- @field protected move_timer Dummy.Timer.Handle|nil
--- @field protected stop_timer Dummy.Timer.Handle|nil
local FlyBullet = Class(Bullet, "FroggitMod.Bullet.Fly")

--- Initializes the bullet
function FlyBullet:new()
  self = Class:new(FlyBullet)
  self:setSprite({ "waves/fly/fly_bullet_1", "waves/fly/fly_bullet_2" }, 2 / 30)
  self:setHitbox({ 4, 4, 4, 4 })
  self:setDamage(Battle.getEncounter():getEnemies()[1]:getAT())

  local arena_x, arena_y = Arena.getPosition()
  self:setPosition(arena_x + math.round((love.math.random() - 0.5) * Arena.getWidth()), arena_y - Arena.getHeight())

  self.target_angle = 0

  return self
end

--- Called when the bullet is spawned
function FlyBullet:onSpawned()
  self:targetSoul()
end

--- Targets the soul
function FlyBullet:targetSoul()
  local soul_x, soul_y = Soul.getPosition()
  local x, y = self:getPosition()
  local dx = soul_x - x
  local dy = soul_y - y
  self.target_angle = math.atan(dy / dx)
  if dx < 0 then self.target_angle = self.target_angle + math.pi end

  self.fly_speed = 3
  self.stop_timer = Timer.after(1, function()
    self:halt()
  end)
end

--- Halts the bullet
function FlyBullet:halt()
  self.fly_speed = 0
  self.move_timer = Timer.after(0.5, function()
    self:targetSoul()
  end)
end

--- Called when the bullet is removed
function FlyBullet:onRemoved()
  if self.move_timer ~= nil then
    Timer.cancel(self.move_timer)
  end
  if self.stop_timer ~= nil then
    Timer.cancel(self.stop_timer)
  end
end

--- Updates the bullet, called on every game update
--- @param dt number
function FlyBullet:update(dt)
  local x, y = self:getPosition()
  x = x + math.cos(self.target_angle) * self.fly_speed * dt * 30
  y = y + math.sin(self.target_angle) * self.fly_speed * dt * 30
  self:setPosition(x, y)

  if not Arena.isInBounds(x, y) then
    self:remove()
  end
end

return FlyBullet
