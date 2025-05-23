local self = {}

--- @alias Dummy.Bullet.Hitbox {[1]:number, [2]:number, [3]:number, [4]:number}

--- Creates a bullet
--- @return Dummy.Bullet
function self.new()
  --- @class Dummy.Bullet
  ---
  --- @field private sprite Dummy.Sprite
  --- @field private hitbox Dummy.Bullet.Hitbox
  local bullet = {}
  --- Gets bullet sprite
  --- @return Dummy.Sprite
  function bullet.getSprite()
    return bullet.sprite
  end

  --- Gets bullet hitbox
  --- @return Dummy.Bullet.Hitbox
  function bullet.getHitbox()
    return bullet.hitbox
  end

  --- Sets bullet hitbox
  --- @param hitbox Dummy.Bullet.Hitbox
  function bullet.setHitbox(hitbox)
    bullet.hitbox = hitbox
  end

  Scene.addDrawable(bullet.sprite)

  return bullet
end

return self
