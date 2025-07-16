--- @alias Dummy.Bullet.Hitbox [ number, number, number, number ]

--- @class Dummy.Bullet : Dummy.Sprite
---
--- @field protected damage number
--- @field protected hitbox Dummy.Bullet.Hitbox
--- @field protected removed boolean
--- @field protected wave Dummy.Wave
--- @field protected debug_hitbox_drawable Dummy.Drawable
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

--- Removes the drawable from the current scene
function Bullet:remove()
  self.debug_hitbox_drawable:remove()
  Drawable.remove(self)
end

--- Gets the wave the bullet is from
--- @return Dummy.Wave
function Bullet:getWave()
  return self.wave
end

--- Called on every game update
--- @param dt number
function Bullet:update(dt) end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new()
  self = Class:new(Bullet, { "bullet" })
  self.damage = 4
  self.hitbox = { 0, 0, 0, 0 }

  self:setLayer(Constants.LAYERS.BULLET)
  self:setHitboxFromSprite()

  self.debug_hitbox_drawable = Drawable:new()
  self.debug_hitbox_drawable:setLayer(Constants.LAYERS.ABOVE_BULLET)
  function self.debug_hitbox_drawable.draw()
    if Debugger.shouldDisplayHitbox() and self:isVisible() then
      local hitbox = self:getHitbox()
      if hitbox[3] < 0 and hitbox[4] < 0 then return end

      local x, y = self:getPosition()
      local width, height = self:getWidth(), self:getHeight()
      local origin_x, origin_y = self:getOrigin()
      local scale_x, scale_y = self:getScale()
      local angle = math.rad(self:getAngle())
      local hitbox_x = x - width * origin_x * scale_x + hitbox[1] * scale_x + 0.5
      local hitbox_y = y - height * origin_y * scale_y + hitbox[2] * scale_y + 0.5
      local hitbox_width = hitbox[3] * scale_x - 1
      local hitbox_height = hitbox[4] * scale_y - 1

      love.graphics.setColor(0, 1, 0, 1)
      if angle % (2 * math.pi) == 0 then
        love.graphics.rectangle("line", hitbox_x, hitbox_y, hitbox_width, hitbox_height)
      else
        local points = Utils.getPolygonPoints(hitbox_x, hitbox_y, hitbox_width, hitbox_height, 1, 1, 0, 0, angle)
        love.graphics.polygon("line", table.unpack(points))
      end
    end
  end

  return self
end

return Bullet
