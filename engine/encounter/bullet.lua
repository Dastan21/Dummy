--- @alias Dummy.Bullet.Hitbox [ number, number, number, number ]

--- @class Dummy.Bullet : Dummy.Sprite
---
--- @field protected damage number
--- @field protected hitbox Dummy.Bullet.Hitbox
--- @field protected removed boolean
--- @field protected wave Dummy.Wave
local Bullet = Class:extend(Sprite)

--- Gets the class name
--- @return string
function Bullet.getClassName()
  return "Dummy.Bullet"
end

--- Gets the bullet's hitbox
--- @return Dummy.Bullet.Hitbox
function Bullet:getHitbox()
  return self.hitbox
end

--- Sets the bullet's hitbox
--- @param hitbox Dummy.Bullet.Hitbox
function Bullet:setHitbox(hitbox)
  self.hitbox = hitbox
end

--- Gets the bullet's damage
--- @return number
function Bullet:getDamage()
  return self.damage
end

--- Sets the bullet's damage
--- @param damage number
function Bullet:setDamage(damage)
  self.damage = damage
end

--- Sets the bullet's sprite
--- @overload fun(self: Dummy.Sprite, sprite_name: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
function Bullet:setSprite(sprites_names)
  Sprite.setSprite(self, sprites_names)
  self:setHitboxFromSprite()
end

--- Sets the bullet's hitbox from the sprite
--- @protected
function Bullet:setHitboxFromSprite()
  local sprite = self:getSprite()
  if sprite == nil then return end

  local width, height = sprite:getWidth(), sprite:getHeight()
  self:setHitbox({ 0, 0, width, height })
end

--- Gets the wave the bullet is from
--- @return Dummy.Wave
function Bullet:getWave()
  return self.wave
end

--- Called when the bullet hits the player
function Bullet:onHit()
  Player.hurt(self:getDamage())
  self:remove()
end

--- Draws for debugging
function Bullet:debugDraw()
  if not Debugger.shouldDisplayHitbox() then return end

  local width, height = self:getWidth(), self:getHeight()
  if width == 0 and height == 0 then return end

  Sprite.debugDraw(self)

  love.graphics.push()
  love.graphics.origin()
  local absolute_transform = self:getAbsoluteTransform()
  local origin_x, origin_y = self:getOrigin()
  local hitbox = self:getHitbox()
  local x, y = -width * origin_x + hitbox[1], -height * origin_y + hitbox[2]
  local x1, y1 = absolute_transform:transformPoint(x, y)
  local x2, y2 = absolute_transform:transformPoint(x + hitbox[3], y)
  local x3, y3 = absolute_transform:transformPoint(x + hitbox[3], y + hitbox[4])
  local x4, y4 = absolute_transform:transformPoint(x, y + hitbox[4])
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setLineStyle("rough")
  love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)
  love.graphics.pop()
end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new()
  self = Class:new(Bullet, { "bullet" })
  self.damage = 4
  self.hitbox = { 0, 0, 0, 0 }

  self:setLayer(Constants.LAYERS.BULLET)
  self:setHitboxFromSprite()

  return self
end

return Bullet
