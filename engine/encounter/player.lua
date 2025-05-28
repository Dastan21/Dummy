local INTERNAL_SPEED = 110

--- @class Dummy.Player
---
--- @field private lv number
--- @field private hp number
--- @field private max_hp number
--- @field private at number
--- @field private df number
--- @field private speed number
--- @field private hitbox {[1]: number, [2]: number, [3]: number, [4]: number}
--- @field private is_fleeing boolean
local self = {}

--- Inits the player
function self.load()
  self.lv = 1
  self.hp = 20
  self.max_hp = 20
  self.at = 10
  self.df = 10
  self.speed = 1
  self.hitbox = { 4, 4, 8, 8 }

  self.soul_sprite = Sprite:new("heart")
  self.soul_sprite:setPosition(320, 240)
  self.soul_sprite:setLayer(Constants.LAYERS.SOUL)

  self.name = "Frisk"
  self.name_text = Text:new(self.name)
  self.name_text:setPosition(30, 400)
  self.name_text:setOrigin(0)
  self.name_text:setFont(Font.FONTS.CURS)

  self.lv_text = Text:new("")
  self.lv_text:setPosition(174, 400)
  self.lv_text:setOrigin(0)
  self.lv_text:setFont(Font.FONTS.CURS)

  self.hp_sprite = Sprite:new("hp")
  self.hp_sprite:setPosition(244, 405)
  self.hp_sprite:setOrigin(0)
  self.hp_value_text = Text:new("")
  self.hp_value_text:setPosition(400, 409)
  self.hp_value_text:setOrigin(0, 0.5)
  self.hp_value_text:setFont(Font.FONTS.CURS)

  self.is_fleeing = false

  self.setLV(1, true)

  local hitbox_draw = Drawable:new(function()
    if Debug.show_hitbox and not self.isHidden() then
      local x, y = self.getPosition()
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("line", x - self.hitbox[1], y - self.hitbox[2], self.hitbox[3], self.hitbox[4])
    end
  end)
  hitbox_draw:setLayer(Constants.LAYERS.ABOVE_SOUL)
end

--- Sets the player's soul position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function self.setPosition(x, y, ignore_arena_bounds)
  if not ignore_arena_bounds then
    local arena_x, arena_y = Arena.getPosition()
    local arena_width, arena_height = Arena.getWidth(), Arena.getHeight()
    local player_offset = self.hitbox[3] - self.hitbox[1] + 4
    x = math.clamp(x, arena_x - arena_width / 2 + player_offset, arena_x + arena_width / 2 - player_offset)
    y = math.clamp(y, arena_y - arena_height + player_offset, arena_y - player_offset)
  end

  self.soul_sprite:setPosition(x, y)
end

--- Gets the player's soul position
--- @return number x horizontal position
--- @return number y vertical position
function self.getPosition()
  return self.soul_sprite:getPosition()
end

--- Shows the player's soul
function self.show()
  self.soul_sprite:setVisible(true)
end

--- Hides the player's soul
function self.hide()
  self.soul_sprite:setVisible(false)
end

--- Wether the player's soul is hidden
--- @return boolean
function self.isHidden()
  return not self.soul_sprite:isVisible()
end

--- Sets the player's name
--- @param name string name displayed
function self.setName(name)
  if name == nil then return end

  self.name = name
  self.name_text:setText(self.name)
  self.lv_text:setPosition(self.name_text:getSprite():getWidth() + 57, 400)
end

--- Gets the player's name
--- @return string
function self.getName()
  return self.name
end

--- Sets the player's LV
--- @param lv number level
--- @param heal? boolean set HP to max HP
function self.setLV(lv, heal)
  if type(lv) ~= "number" then return end

  self.lv = math.clamp(lv, 1, 20)
  self.lv_text:setText(Lang.translate("ENCOUNTER_STAT_LV") .. " " .. tostring(self.lv))

  if self.lv < 20 then
    self.setMaxHP(16 + 4 * self.lv)
  else
    self.setMaxHP(99)
  end

  self.setHP(math.min(self.hp, self.max_hp))
  if heal == true then
    self.setHP(self.max_hp)
  end
  self.setAT(8 + 2 * self.lv)
  self.setDF(9 + math.ceil(self.lv / 4))
end

--- Gets the player's LV
--- @return number
function self.getLV()
  return self.lv
end

--- Sets the player's HP
--- @param hp number health points
function self.setHP(hp)
  if type(hp) ~= "number" then return end

  self.hp = math.clamp(hp, 0, math.min(self.max_hp, 99))
  self.hp_value_text:setText(string.format("%02d", self.hp) .. " / " .. tostring(self.max_hp))
  self.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 409)
end

--- Gets the player's HP
--- @return number
function self.getHP()
  return self.hp
end

--- Sets the player's max HP
--- @param max_hp number maximum health points
--- @param heal? boolean set HP to max HP
function self.setMaxHP(max_hp, heal)
  if type(max_hp) ~= "number" then return end

  self.max_hp = math.clamp(max_hp, 20, 99)
  self.hp_value_text:setText(tostring(self.hp) .. " / " .. tostring(self.max_hp))
  self.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 409)

  if heal == true then
    self.setHP(self.max_hp)
  end
end

--- Gets the player's AT
--- @return number
function self.getAT()
  return self.at
end

--- Sets the player's AT
--- @param at number attack point
function self.setAT(at)
  self.at = at
end

--- Gets the player's DE
--- @return number
function self.getDF()
  return self.df
end

--- Sets the player's DE
--- @param df number defense point
function self.setDF(df)
  self.df = df
end

--- Wether the player's hitbox collides bullet's hitbox
--- @param bullet Dummy.Bullet
function self.isColliding(bullet)
  local player_x, player_y = self.soul_sprite:getPosition()
  local bullet_scale = bullet:getScale()
  local bullet_origin = bullet:getOrigin()
  local bullet_hitbox = bullet:getHitbox()
end

--- Gets the player's max HP
--- @return number
function self.getMaxHP()
  return self.max_hp
end

--- Wether the playing is playing the escape animation
---@return boolean
function self.isFleeing()
  return self.is_fleeing
end

--- Animates the soul escaping
function self.flee(dt)
  if not self.is_fleeing then
    self.soul_escape_sprite = Sprite:new({ "heart_escape1", "heart_escape2" }, 0.08, true)
    self.soul_escape_sprite:setPosition(self.getPosition())
    self.soul_escape_sprite:setLayer(Constants.LAYERS.SOUL)
    self.soul_sprite:setVisible(false)
    self.is_fleeing = true
  end

  local x, y = self.soul_escape_sprite:getPosition()
  local s = 90 * dt
  self.soul_escape_sprite:setPosition(x - 1 * s, y)
end

--- Updates the player
--- @param dt number
function self.update(dt)
  local dir_x, dir_y = 0, 0
  if Input.isDown(Input.Up) then dir_y = dir_y - 1 end
  if Input.isDown(Input.Down) then dir_y = dir_y + 1 end
  if Input.isDown(Input.Left) then dir_x = dir_x - 1 end
  if Input.isDown(Input.Right) then dir_x = dir_x + 1 end

  local s = INTERNAL_SPEED * self.speed * dt
  local x, y = self.soul_sprite:getPosition()
  self.setPosition(x + dir_x * s, y + dir_y * s)
end

return self
