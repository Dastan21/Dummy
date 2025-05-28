--- @class Dummy.Bullet : Dummy.Sprite
---
--- @field protected hitbox Dummy.Bullet.Hitbox
local Bullet = Class:extend(Sprite)

--- @alias Dummy.Bullet.Hitbox {[1]:number, [2]:number, [3]:number, [4]:number}

--- Gets bullet hitbox
--- @return Dummy.Bullet.Hitbox
function Bullet:getHitbox()
  return self.hitbox
end

--- Sets bullet hitbox
--- @param hitbox Dummy.Bullet.Hitbox
function Bullet:setHitbox(hitbox)
  self.hitbox = hitbox
end

--- Creates a bullet
--- @return Dummy.Bullet
function Bullet:new()
  return Class:new(Bullet)
end

return Bullet
