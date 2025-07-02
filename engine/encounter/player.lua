--- @class Dummy.Player
---
--- @field protected lv number
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected exp number
--- @field protected gold number
--- @field protected speed number
--- @field protected speed_factor number
--- @field protected is_invincible boolean
--- @field protected invincible boolean
--- @field protected invincible_duration number
--- @field protected hitbox Dummy.Bullet.Hitbox
--- @field protected override boolean
--- @field protected soul_sprite Dummy.Sprite
--- @field protected name string
--- @field protected is_fleeing boolean
--- @field protected flee_speed number
--- @field protected weapon Dummy.Item.Equipment
--- @field protected armor Dummy.Item.Equipment
--- @field protected items Dummy.Item[]
local Player = {}

--- The minimum amount of experience required by level
Player.LV_EXP = {
  [1] = 0,
  [2] = 10,
  [3] = 30,
  [4] = 70,
  [5] = 120,
  [6] = 200,
  [7] = 300,
  [8] = 500,
  [9] = 800,
  [10] = 1200,
  [11] = 1700,
  [12] = 2500,
  [13] = 3500,
  [14] = 5000,
  [15] = 7000,
  [16] = 10000,
  [17] = 15000,
  [18] = 25000,
  [19] = 50000,
  [20] = 99999
}

--- Initializes the player
function Player.load()
  Player.lv = 1
  Player.hp = 20
  Player.max_hp = 20
  Player.at = 10
  Player.df = 10
  Player.exp = 0
  Player.gold = 0
  Player.speed = 4
  Player.speed_factor = 1
  Player.is_invincible = false
  Player.invincible = false
  Player.invincible_duration = 1
  Player.hitbox = { 4, 4, 8, 8 }
  Player.override = false

  Player.soul_sprite = Sprite:new({ "heart", "heart_hurt" }, 2 / 30, nil, false)
  Player.soul_sprite:setPosition(320, 240)
  Player.soul_sprite:setLayer(Constants.LAYERS.SOUL)

  Player.name = "Frisk"

  Player.is_fleeing = false
  Player.flee_speed = 3

  Player.weapon = ItemEquipment:new("ENCOUNTER_ITEM_NAME_STICK", "ENCOUNTER_ITEM_SHORTNAME_STICK", 0, "weapon")
  Player.armor = ItemEquipment:new("ENCOUNTER_ITEM_NAME_BANDAGE", "ENCOUNTER_ITEM_SHORTNAME_BANDAGE", 0, "armor")

  Player.items = {}

  Player.setLV(1)

  local debug_hitbox_drawable = Drawable:new()
  debug_hitbox_drawable:setLayer(Constants.LAYERS.ABOVE_SOUL)
  function debug_hitbox_drawable:draw()
    if not Player.isHidden() and Debugger.shouldDisplayHitbox() then
      love.graphics.push()

      local x, y = Player.getPosition()
      local scale_x, scale_y = Player.getScale()
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("line", x + 0.5 - Player.hitbox[1] * scale_x, y + 0.5 - Player.hitbox[2] * scale_y,
        Player.hitbox[3] * scale_x - 1, Player.hitbox[4] * scale_y - 1)

      love.graphics.pop()
    end
  end
end

--- Gets the player's soul position
--- @return number x horizontal position
--- @return number y vertical position
function Player.getPosition()
  return Player.soul_sprite:getPosition()
end

--- Sets the player's soul position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function Player.setPosition(x, y, ignore_arena_bounds)
  if not ignore_arena_bounds then
    local arena_x, arena_y = Arena.getPosition()
    local arena_width, arena_height = Arena.getWidth(), Arena.getHeight()
    local scale_x, scale_y = Player.getScale()
    local width, height = Player.soul_sprite:getWidth(), Player.soul_sprite:getHeight()
    local player_offset_x = width / 2 * scale_x
    local player_offset_y = height / 2 * scale_y
    x = math.clamp(x, arena_x - arena_width / 2 + player_offset_x, arena_x + arena_width / 2 - player_offset_x)
    y = math.clamp(y, arena_y - arena_height + player_offset_y, arena_y - player_offset_y)
  end

  Player.soul_sprite:setPosition(x, y)
end

--- Shows the player's soul
function Player.show()
  Player.soul_sprite:setVisible(true)
end

--- Hides the player's soul
function Player.hide()
  Player.soul_sprite:setVisible(false)
end

--- Wether the player's soul is hidden
--- @return boolean
function Player.isHidden()
  return not Player.soul_sprite:isVisible()
end

--- Gets the player's name
--- @return string
function Player.getName()
  return Player.name
end

--- Sets the player's name
--- @param name string name displayed
function Player.setName(name)
  if name == nil then return end

  Player.name = Utils.getOrDefault(name, "Frisk")
end

--- Gets the player's LV
--- @return number
function Player.getLV()
  return Player.lv
end

--- Sets the player's LV
--- @param lv number level
--- @param silent? boolean wether to play level up sound (Defaults to `true`)
function Player.setLV(lv, silent)
  if type(lv) ~= "number" then return end

  local lv_old = Player.lv
  Player.lv = math.max(1, lv)

  if Player.lv < 20 then
    Player.setMaxHP(16 + 4 * Player.lv)
  else
    Player.setMaxHP(99)
  end

  Player.setHP(math.min(Player.hp, Player.max_hp))
  Player.setAT(8 + 2 * Player.lv)
  Player.setDF(9 + math.ceil(Player.lv / 4))

  if Player.exp < Player.LV_EXP[Player.lv] then
    Player.exp = Player.LV_EXP[Player.lv]
  end

  if silent == false and lv_old < Player.lv then
    Assets.playSound("levelup")
  end
end

--- Gets the player's HP
--- @return number
function Player.getHP()
  return Player.hp
end

--- Sets the player's HP
--- @param hp number health points
function Player.setHP(hp)
  if type(hp) ~= "number" then return end

  Player.hp = math.clamp(hp, 0, Player.max_hp)
end

--- Heals the player
--- @param amount number
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function Player.heal(amount, silent)
  Player.setHP(Player.hp + amount)

  if not silent then
    Assets.playSound("heal")
  end
end

--- Hurts the player
--- @param amount number
--- @param silent? boolean wether to play then sound, animation and shake (Defaults to `false`)
function Player.hurt(amount, silent)
  local damage = math.max(0, math.round(amount - ((Player.df + Player.weapon:getValue()) / 5)))
  Player.setHP(Player.hp - damage)

  if not silent then
    Assets.playSound("hurt")
    Player.soul_sprite:play()
    Player.is_invincible = true

    Timer.after(Player.invincible_duration, function()
      Player.soul_sprite:stop()
      Player.is_invincible = false
    end)

    local hshake = 2
    local vshake = 2
    Shaker.shakeCustom(0.25, 2 / 30, function()
      if hshake ~= 0 then
        if hshake < 0 then
          hshake = hshake + 1
        end
        hshake = -hshake
      end
      if vshake ~= 0 then
        if vshake < 0 then
          vshake = vshake + 1
        end
        vshake = -vshake
      end

      return hshake, vshake
    end, function()
      Shaker.reset()
    end)
  end
end

--- Gets the player's max HP
--- @return number
function Player.getMaxHP()
  return Player.max_hp
end

--- Sets the player's max HP
--- @param max_hp number maximum health points
function Player.setMaxHP(max_hp)
  if type(max_hp) ~= "number" then return end

  Player.max_hp = math.max(0, max_hp)
end

--- Gets the player's AT
--- @return number
function Player.getAT()
  return Player.at
end

--- Sets the player's AT
--- @param at number attack point
function Player.setAT(at)
  Player.at = at
end

--- Gets the player's DE
--- @return number
function Player.getDF()
  return Player.df
end

--- Sets the player's DE
--- @param df number defense point
function Player.setDF(df)
  Player.df = df
end

--- Gets the player's EXP
--- @return number
function Player.getEXP(exp)
  return Player.exp
end

--- Sets the player's EXP
--- @param exp number
function Player.setEXP(exp)
  Player.exp = exp

  local lv = 0
  for level, experience in pairs(Player.LV_EXP) do
    if Player.exp < experience then
      lv = level - 1
      break
    end
  end

  if lv > 0 and lv ~= Player.lv then
    Player.setLV(lv, false)
  end
end

--- Gets the player's gold
--- @return number
function Player.getGold(gold)
  return Player.gold
end

--- Sets the player's gold
--- @param gold number
function Player.setGold(gold)
  Player.gold = gold
end

--- Gets the player's speed
--- @return number
function Player.getSpeed()
  return Player.speed_factor
end

--- Sets the player's speeds
--- @param speed number
function Player.setSpeed(speed)
  Player.speed_factor = speed
end

--- Gets the player's scale
--- @return number, number
function Player.getScale()
  return Player.soul_sprite:getScale()
end

--- Sets the player's scales
--- @overload fun(scale: number)
--- @param scale_x number
--- @param scale_y number
function Player.setScale(scale_x, scale_y)
  Player.soul_sprite:setScale(scale_x, scale_y)
end

--- Wether the player is invincible
--- @return boolean
function Player.isInvincible()
  return Player.invincible or Player.is_invincible
end

--- Sets wether the player is invincible
--- @param invincible boolean
function Player.setInvincible(invincible)
  Player.invincible = invincible
end

--- Gets the player's invincibility duration, in seconds
--- @return number
function Player.getInvincibility()
  return Player.invincible_duration
end

--- Sets the player's invincibility duration, in seconds
--- @param invincibility number
function Player.setInvincibility(invincibility)
  Player.invincible_duration = invincibility
end

--- Wether the player is overriden
--- @return boolean
function Player.isOverride()
  return Player.override
end

--- Sets wether the player is overriden
--- @param override boolean
function Player.setOverride(override)
  Player.override = override
end

--- Gets the player's weapon
--- @return Dummy.Item.Equipment
function Player.getWeapon()
  return Player.weapon
end

--- Sets the player's weapon
--- @param weapon Dummy.Item.Equipment
function Player.setWeapon(weapon)
  Player.weapon = weapon
end

--- Gets the player's armor
--- @return Dummy.Item.Equipment
function Player.getArmor()
  return Player.armor
end

--- Sets the player's armor
--- @param armor Dummy.Item.Equipment
function Player.setArmor(armor)
  Player.armor = armor
end

--- Wether the player's hitbox collides bullet's hitbox
--- @param bullet Dummy.Bullet
function Player.isColliding(bullet)
  local player_x, player_y = Player.getPosition()
  local player_scale_x, player_scale_y = Player.getScale()
  local player_hitbox_x = player_x - Player.hitbox[1] * player_scale_x
  local player_hitbox_y = player_y - Player.hitbox[2] * player_scale_y
  local player_hitbox_width = Player.hitbox[3] * player_scale_x
  local player_hitbox_height = Player.hitbox[4] * player_scale_y
  local bullet_x, bullet_y = bullet:getPosition()
  local bullet_scale_x, bullet_scale_y = bullet:getScale()
  local bullet_origin_x, bullet_origin_y = bullet:getOrigin()
  local bullet_angle = math.rad(bullet:getAngle())
  local bullet_hitbox = bullet:getHitbox()
  local bullet_polygon_points = Utils.getPolygonPoints(bullet_x, bullet_y, bullet_hitbox[3], bullet_hitbox[4],
    bullet_scale_x, bullet_scale_y, bullet_origin_x, bullet_origin_y, bullet_angle)

  local bullet_hitbox_points = {}
  bullet_hitbox_points[1] = { bullet_polygon_points[1], bullet_polygon_points[2] }
  bullet_hitbox_points[2] = { bullet_polygon_points[3], bullet_polygon_points[4] }
  bullet_hitbox_points[3] = { bullet_polygon_points[5], bullet_polygon_points[6] }
  bullet_hitbox_points[4] = { bullet_polygon_points[7], bullet_polygon_points[8] }

  local function pointInPlayerHitbox(x, y)
    return x >= player_hitbox_x and x <= player_hitbox_x + player_hitbox_width and y >= player_hitbox_y and
        y <= player_hitbox_y + player_hitbox_height
  end

  local function checkPointsInPlayerHitbox(points)
    for i = 1, 4 do
      if pointInPlayerHitbox(points[i][1], points[i][2]) then
        return true
      end
    end
    return false
  end

  local function doLinesIntersect(p1, p2, p3, p4)
    local function cross(o, a, b) return (a[1] - o[1]) * (b[2] - o[2]) - (a[2] - o[2]) * (b[1] - o[1]) end
    return cross(p1, p3, p4) * cross(p2, p3, p4) < 0 and cross(p3, p1, p2) * cross(p4, p1, p2) < 0
  end

  local function checkPointsIntersectPlayerHitboxEdges(points)
    local edges = {
      { player_hitbox_x,                       player_hitbox_y,                        player_hitbox_x + player_hitbox_width, player_hitbox_y },
      { player_hitbox_x + player_hitbox_width, player_hitbox_y,                        player_hitbox_x + player_hitbox_width, player_hitbox_y + player_hitbox_height },
      { player_hitbox_x + player_hitbox_width, player_hitbox_y + player_hitbox_height, player_hitbox_x,                       player_hitbox_y + player_hitbox_height },
      { player_hitbox_x,                       player_hitbox_y + player_hitbox_height, player_hitbox_x,                       player_hitbox_y }
    }

    for _, edge in ipairs(edges) do
      local x1, y1, x2, y2 = edge[1], edge[2], edge[3], edge[4]

      for i = 1, 4 do
        local p1 = points[i]
        local p2 = points[(i % 4) + 1]
        if doLinesIntersect({ x1, y1 }, { x2, y2 }, p1, p2) then
          return true
        end
      end
    end
    return false
  end

  if checkPointsInPlayerHitbox(bullet_hitbox_points) then
    return true
  end

  if checkPointsIntersectPlayerHitboxEdges(bullet_hitbox_points) then
    return true
  end

  return false
end

--- Animates the soul escaping
function Player.flee()
  if Player.is_fleeing then return end

  Player.is_fleeing = true
  Player.soul_sprite:setSprite({ "heart_escape1", "heart_escape2" })
  Player.soul_sprite:setSpeed(2 / 30)
  Player.soul_sprite:setPosition(Player.getPosition())
  Player.soul_sprite:setLayer(Constants.LAYERS.SOUL)
  Player.soul_sprite:play()

  Timer.during(2, function(dt)
    local x, y = Player.soul_sprite:getPosition()
    Player.soul_sprite:setPosition(x - Player.flee_speed * dt * 30, y)
  end)

  Assets.playSound("escaped")
end

--- Wether the playing is playing the escape animation
--- @return boolean
function Player.isFleeing()
  return Player.is_fleeing
end

--- Gets the player's items
--- @return Dummy.Item[]
function Player.getItems()
  return Player.items
end

--- Adds one or more items to the player
--- @param item Dummy.Item|Dummy.Item[]
--- @param ... Dummy.Item
function Player.addItem(item, ...)
  local items = { item, ... }
  if #item >= 1 then items = item end
  for _, item in ipairs(items) do
    table.insert(Player.items, item)
  end
end

--- Removes an item from the player
--- @param item Dummy.Item
function Player.removeItem(item)
  for i, it in ipairs(Player.items) do
    if it == item then
      table.remove(Player.items, i)
      break
    end
  end
end

--- Updates the player
--- @param dt number
function Player.update(dt)
  if Player.isOverride() then return end

  local dir_x, dir_y = 0, 0
  if Input.isDown(Input.Up) then dir_y = dir_y - 1 end
  if Input.isDown(Input.Down) then dir_y = dir_y + 1 end
  if Input.isDown(Input.Left) then dir_x = dir_x - 1 end
  if Input.isDown(Input.Right) then dir_x = dir_x + 1 end

  local slow = Input.isDown(Input.Cancel) and 0.5 or 1
  local s = Player.speed * Player.speed_factor * slow * dt * 30
  local x, y = Player.soul_sprite:getPosition()
  Player.setPosition(x + dir_x * s, y + dir_y * s)
end

return Player
