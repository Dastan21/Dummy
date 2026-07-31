--- @class Dummy.Battle.Soul
---
--- @field protected speed number
--- @field protected speed_factor number
--- @field protected is_invincible boolean
--- @field protected invincible boolean
--- @field protected invincible_duration number
--- @field protected hitbox Dummy.Hitbox
--- @field protected override boolean
--- @field protected sprite Dummy.Sprite
--- @field protected is_fleeing boolean
--- @field protected flee_speed number
--- @field protected debug_hitbox_drawable Dummy.Drawable
local Soul = {}

--- Initializes the soul
function Soul.load()
  Soul.speed = 4
  Soul.speed_factor = 1
  Soul.is_invincible = false
  Soul.invincible = false
  Soul.invincible_duration = 1
  Soul.hitbox = { 4, 4, 8, 8 }
  Soul.override = false

  if Soul.sprite ~= nil then
    Soul.sprite:remove()
  end
  Soul.sprite = Sprite:new({ "heart", "heart_hurt" }, 2 / 30, true, false)
  Soul.sprite:setPosition(320, 240)
  Soul.sprite:setLayer(Constants.LAYERS.SOUL)

  Soul.is_fleeing = false
  Soul.flee_speed = 3

  if Soul.debug_hitbox_drawable ~= nil then
    Soul.debug_hitbox_drawable:remove()
  end
  Soul.debug_hitbox_drawable = Drawable:new()
  Soul.debug_hitbox_drawable:setLayer(Constants.LAYERS.ABOVE_SOUL)
  function Soul.debug_hitbox_drawable.draw(_self)
    if not _self:isVisible() or not Soul.sprite:isVisible() or not Debug.shouldDisplayHitbox() then return end
    if Soul.hitbox[3] == 0 and Soul.hitbox[4] == 0 then return end

    local absolute_transform = Soul.sprite:getAbsoluteTransform()
    local origin_x, origin_y = Soul.sprite:getOrigin()
    local width, height = Soul.sprite:getWidth(), Soul.sprite:getHeight()
    local x, y = -width * origin_x + Soul.hitbox[1], -height * origin_y + Soul.hitbox[2]
    local x1, y1 = absolute_transform:transformPoint(x, y)
    local x2, y2 = absolute_transform:transformPoint(x + Soul.hitbox[3], y)
    local x3, y3 = absolute_transform:transformPoint(x + Soul.hitbox[3], y + Soul.hitbox[4])
    local x4, y4 = absolute_transform:transformPoint(x, y + Soul.hitbox[4])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)
  end
end

--- Gets the player soul's sprite
--- @return Dummy.Sprite
function Soul.getSprite()
  return Soul.sprite
end

--- Gets the player soul's position
--- @return number x horizontal position
--- @return number y vertical position
function Soul.getPosition()
  return Soul.sprite:getPosition()
end

--- Sets the player soul's position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function Soul.setPosition(x, y, ignore_arena_bounds)
  if not ignore_arena_bounds and World.isInBattle() then
    local arena_x, arena_y = Arena.getPosition()
    local arena_width, arena_height = Arena.getWidth(), Arena.getHeight()
    local scale_x, scale_y = Soul.sprite:getScale()
    local width, height = Soul.sprite:getWidth(), Soul.sprite:getHeight()
    local player_offset_x = width / 2 * scale_x
    local player_offset_y = height / 2 * scale_y
    x = math.clamp(x, arena_x - arena_width / 2 + player_offset_x, arena_x + arena_width / 2 - player_offset_x)
    y = math.clamp(y, arena_y - arena_height + player_offset_y, arena_y - player_offset_y)
  end

  Soul.sprite:setPosition(x, y)
end

--- Gets the player soul's speed
--- @return number
function Soul.getSpeed()
  return Soul.speed_factor
end

--- Sets the player soul's speeds
--- @param speed number
function Soul.setSpeed(speed)
  Soul.speed_factor = speed
end

--- Wether the player is invincible
--- @return boolean
function Soul.isInvincible()
  return Soul.invincible or Soul.is_invincible
end

--- Sets wether the player is invincible
--- @param invincible boolean
function Soul.setInvincible(invincible)
  Soul.invincible = invincible
end

--- Gets the player soul's invincibility duration, in seconds
--- @return number
function Soul.getInvincibility()
  return Soul.invincible_duration
end

--- Sets the player soul's invincibility duration, in seconds
--- @param invincibility number
function Soul.setInvincibility(invincibility)
  Soul.invincible_duration = invincibility
end

--- Wether the player is overriden
--- @return boolean
function Soul.isOverride()
  return Soul.override
end

--- Sets wether the player is overriden
--- @param override boolean
function Soul.setOverride(override)
  Soul.override = override
end

--- Heals the player
--- @param amount number
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function Soul.heal(amount, silent)
  Player.setHP(Player.getHP() + amount)

  if not silent then
    Assets.playSound("heal")
  end
end

--- Hurts the player
--- @param amount number
--- @param silent? boolean wether to play then sound, animation and shake (Defaults to `false`)
function Soul.hurt(amount, silent)
  local damage = math.max(0, math.round(amount - ((Player.getDF() + Player.getArmor():getValue()) / 5)))
  Player.setHP(Player.getHP() - damage)

  if not silent then
    Assets.playSound("hurt")
    Soul.sprite:play()
    Soul.is_invincible = true

    Timer.after(Soul.getInvincibility(), function()
      Soul.sprite:stop()
      Soul.is_invincible = false
    end)

    Shaker.shakeDecrease(0.25, 2 / 30, 2, 2)
  end
end

--- Wether the player soul's hitbox collides bullet's hitbox
--- @param bullet Dummy.Battle.Bullet
function Soul.isColliding(bullet)
  if not bullet:isVisible() then return end

  local bullet_hitbox = bullet:getHitbox()
  if bullet_hitbox[3] == 0 and bullet_hitbox[4] == 0 then
    return false
  end

  local bullet_width, bullet_height = bullet:getWidth(), bullet:getHeight()
  local bullet_absolute_transform = bullet:getAbsoluteTransform()
  local bullet_origin_x, bullet_origin_y = bullet:getOrigin()
  local bullet_x = -bullet_width * bullet_origin_x + bullet_hitbox[1]
  local bullet_y = -bullet_height * bullet_origin_y + bullet_hitbox[2]
  local bullet_rect = {
    { bullet_absolute_transform:transformPoint(bullet_x, bullet_y) },
    { bullet_absolute_transform:transformPoint(bullet_x + bullet_hitbox[3], bullet_y) },
    { bullet_absolute_transform:transformPoint(bullet_x + bullet_hitbox[3], bullet_y + bullet_hitbox[4]) },
    { bullet_absolute_transform:transformPoint(bullet_x, bullet_y + bullet_hitbox[4]) },
  }

  local player_width, player_height = Soul.sprite:getWidth(), Soul.sprite:getHeight()
  local player_absolute_transform = Soul.sprite:getAbsoluteTransform()
  local player_origin_x, player_origin_y = Soul.sprite:getOrigin()
  local player_x = -player_width * player_origin_x + Soul.hitbox[1]
  local player_y = -player_height * player_origin_y + Soul.hitbox[2]
  local player_rect = {
    { player_absolute_transform:transformPoint(player_x, player_y) },
    { player_absolute_transform:transformPoint(player_x + Soul.hitbox[3], player_y) },
    { player_absolute_transform:transformPoint(player_x + Soul.hitbox[3], player_y + Soul.hitbox[4]) },
    { player_absolute_transform:transformPoint(player_x, player_y + Soul.hitbox[4]) },
  }

  return Utils.checkCollision(player_rect, bullet_rect)
end

--- Animates the soul escaping
function Soul.flee()
  if Soul.is_fleeing then return end

  Soul.is_fleeing = true
  Soul.sprite:setSprite({ "heart_escape1", "heart_escape2" }, 2 / 30)
  Soul.sprite:setPosition(Soul.getPosition())
  Soul.sprite:setLayer(Constants.LAYERS.SOUL)

  Timer.during(1, function(dt)
    local x, y = Soul.sprite:getPosition()
    Soul.sprite:setPosition(x - Soul.flee_speed * dt * 30, y)
  end)

  Assets.playSound("escaped")
end

--- Wether the playing is playing the escape animation
--- @return boolean
function Soul.isFleeing()
  return Soul.is_fleeing
end

--- Updates the soul, called on every game update
--- @param dt number
function Soul.update(dt)
  if Soul.isOverride() then return end

  if World.isInBattle() then
    local dir_x, dir_y = 0, 0
    if Input.isDown(Input.Up) then dir_y = dir_y - 1 end
    if Input.isDown(Input.Down) then dir_y = dir_y + 1 end
    if Input.isDown(Input.Left) then dir_x = dir_x - 1 end
    if Input.isDown(Input.Right) then dir_x = dir_x + 1 end

    local slow = Input.isDown(Input.Cancel) and 0.5 or 1
    local s = Soul.speed * Soul:getSpeed() * slow * dt * 30
    local x, y = Soul.sprite:getPosition()
    Soul.setPosition(x + dir_x * s, y + dir_y * s)
  end
end

return Soul
