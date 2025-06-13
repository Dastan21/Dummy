--- @class Dummy.Player
---
--- @field protected lv number
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected speed number
--- @field protected speed_factor number
--- @field protected hitbox {[1]: number, [2]: number, [3]: number, [4]: number}
--- @field protected soul_sprite Dummy.Sprite
--- @field protected name string
--- @field protected name_text Dummy.Text
--- @field protected lv_text Dummy.Text
--- @field protected hp_sprite Dummy.Sprite
--- @field protected hp_value_text Dummy.Text
--- @field protected is_fleeing boolean
--- @field protected flee_speed number
--- @field protected items Dummy.Item[]
local Player = {}

--- Inits the player
function Player.load()
  Player.lv = 1
  Player.hp = 20
  Player.max_hp = 20
  Player.at = 10
  Player.df = 10
  Player.speed = 4
  Player.speed_factor = 1
  Player.hitbox = { 4, 4, 8, 8 }

  Player.soul_sprite = Sprite:new("heart")
  Player.soul_sprite:setPosition(320, 240)
  Player.soul_sprite:setLayer(Constants.LAYERS.SOUL)

  Player.name = "Frisk"
  Player.name_text = Text:new(Player.name)
  Player.name_text:setPosition(30, 400)
  Player.name_text:setOrigin(0)
  Player.name_text:setFont(Assets.getFont("curs"))

  Player.lv_text = Text:new("")
  Player.lv_text:setPosition(174, 400)
  Player.lv_text:setOrigin(0)
  Player.lv_text:setFont(Assets.getFont("curs"))

  Player.hp_sprite = Sprite:new("hp")
  Player.hp_sprite:setPosition(240, 400)
  Player.hp_sprite:setOrigin(0)
  Player.hp_value_text = Text:new("")
  Player.hp_value_text:setPosition(400, 400)
  Player.hp_value_text:setOrigin(0)
  Player.hp_value_text:setFont(Assets.getFont("curs"))

  Player.is_fleeing = false
  Player.flee_speed = 3

  Player.items = {}

  Player.setLV(1, true)

  Drawable:new(function()
    if Debugger.show_hitbox and not Player.isHidden() then
      local x, y = Player.getPosition()
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("line", x - Player.hitbox[1], y - Player.hitbox[2], Player.hitbox[3], Player.hitbox[4])
    end
  end):setLayer(Constants.LAYERS.ABOVE_SOUL)
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
    local player_offset = Player.hitbox[3] - Player.hitbox[1] + 4
    x = math.clamp(x, arena_x - arena_width / 2 + player_offset, arena_x + arena_width / 2 - player_offset)
    y = math.clamp(y, arena_y - arena_height + player_offset, arena_y - player_offset)
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
  Player.name_text:setText(Player.name)
  Player.lv_text:setPosition(Player.name_text:getSprite():getWidth() + 57, 400)
end

--- Gets the player's LV
--- @return number
function Player.getLV()
  return Player.lv
end

--- Sets the player's LV
--- @param lv number level
--- @param heal? boolean set HP to max HP
function Player.setLV(lv, heal)
  if type(lv) ~= "number" then return end

  Player.lv = math.clamp(lv, 1, 20)
  Player.lv_text:setText(Lang.translate("ENCOUNTER_STAT_LV") .. " " .. tostring(Player.lv))

  if Player.lv < 20 then
    Player.setMaxHP(16 + 4 * Player.lv)
  else
    Player.setMaxHP(99)
  end

  Player.setHP(math.min(Player.hp, Player.max_hp))
  if heal == true then
    Player.setHP(Player.max_hp)
  end
  Player.setAT(8 + 2 * Player.lv)
  Player.setDF(9 + math.ceil(Player.lv / 4))
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

  Player.hp = math.clamp(hp, 0, math.min(Player.max_hp, 99))
  Player.hp_value_text:setText(string.format("%02d", Player.hp) .. " / " .. tostring(Player.max_hp))
  Player.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 400)
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

--- Gets the player's max HP
--- @return number
function Player.getMaxHP()
  return Player.max_hp
end

--- Sets the player's max HP
--- @param max_hp number maximum health points
--- @param heal? boolean set HP to max HP
function Player.setMaxHP(max_hp, heal)
  if type(max_hp) ~= "number" then return end

  Player.max_hp = math.clamp(max_hp, 20, 99)
  Player.hp_value_text:setText(tostring(Player.hp) .. " / " .. tostring(Player.max_hp))
  Player.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 400)

  if heal == true then
    Player.setHP(Player.max_hp)
  end
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

--- Wether the player's hitbox collides bullet's hitbox
--- @param bullet Dummy.Bullet
function Player.isColliding(bullet)
  local player_x, player_y = Player.soul_sprite:getPosition()
  local bullet_scale = bullet:getScale()
  local bullet_origin = bullet:getOrigin()
  local bullet_hitbox = bullet:getHitbox()
end

--- Animates the soul escaping
function Player.escape(dt)
  if not Player.is_fleeing then
    Player.soul_escape_sprite = Sprite:new({ "heart_escape1", "heart_escape2" }, 2 / 30, true)
    Player.soul_escape_sprite:setPosition(Player.getPosition())
    Player.soul_escape_sprite:setLayer(Constants.LAYERS.SOUL)
    Player.soul_sprite:setVisible(false)
    Player.is_fleeing = true
  end

  local x, y = Player.soul_escape_sprite:getPosition()
  Player.soul_escape_sprite:setPosition(x - Player.flee_speed * dt * 30, y)
end

--- Wether the playing is playing the escape animation
---@return boolean
function Player.isFleeing()
  return Player.is_fleeing
end

--- Gets the player's items
--- @return Dummy.Item[]
function Player.getItems()
  return Player.items
end

--- Adds one or more items to the player
---@param item Dummy.Item|Dummy.Item[]
---@param ... Dummy.Item
function Player.addItem(item, ...)
  if #Player.items >= 8 then return end

  local items = { item, ... }
  if #item >= 1 then items = item end
  for _, item in ipairs(items) do
    if #Player.items < 8 then
      table.insert(Player.items, item)
    end
  end

  Encounter.loadItemMenu()
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

  Encounter.loadItemMenu()
end

--- Updates the player
--- @param dt number
function Player.update(dt)
  local dir_x, dir_y = 0, 0
  if Input.isDown(Input.Up) then dir_y = dir_y - 1 end
  if Input.isDown(Input.Down) then dir_y = dir_y + 1 end
  if Input.isDown(Input.Left) then dir_x = dir_x - 1 end
  if Input.isDown(Input.Right) then dir_x = dir_x + 1 end

  local s = Player.speed * dt * 30
  local x, y = Player.soul_sprite:getPosition()
  Player.setPosition(x + dir_x * s, y + dir_y * s)
end

return Player
