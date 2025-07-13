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

--- Updates the bullet
--- @param dt number
function Bullet:update(dt) end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new()
  local bullet = Class:new(Bullet, { "bullet" })

  bullet.damage = 4
  bullet.hitbox = { 0, 0, 0, 0 }

  bullet:setLayer(Constants.LAYERS.BULLET)
  bullet:setHitboxFromSprite()

  bullet.debug_hitbox_drawable = Drawable:new()
  bullet.debug_hitbox_drawable:setLayer(Constants.LAYERS.ABOVE_BULLET)
  function bullet.debug_hitbox_drawable:draw()
    if Debugger.shouldDisplayHitbox() and bullet:isVisible() then
      local x, y = bullet:getPosition()
      local origin_x, origin_y = bullet:getOrigin()
      local scale_x, scale_y = bullet:getScale()
      local angle = math.rad(bullet:getAngle())
      local hitbox = bullet:getHitbox()
      local width, height = hitbox[3], hitbox[4]

      if width < 0 or height < 0 then return end

      love.graphics.setColor(0, 1, 0, 1)
      if angle % (2 * math.pi) == 0 then
        local hitbox_x = x - width * origin_x * scale_x
        local hitbox_y = y - height * origin_y * scale_y
        love.graphics.rectangle("line", hitbox_x + 0.5, hitbox_y + 0.5, width * scale_x - 1, height * scale_y - 1)
      else
        local points = Utils.getPolygonPoints(x + 0.5, y + 0.5, width - 1, height - 1, scale_x, scale_y, origin_x,
          origin_y, angle)
        love.graphics.polygon("line", table.unpack(points))
      end
    end
  end

  return bullet
end

return Bullet
