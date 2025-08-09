--- @class Dummy.Enemy : Dummy.Sprite
---
--- @field protected name Dummy.Text.Text
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected exp number
--- @field protected gold number
--- @field protected check Dummy.Text.Text|nil
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
--- @field protected acts Dummy.ACT[]
--- @field protected can_be_spared boolean
--- @field protected is_spared boolean
local Enemy = Class:extend(Sprite)

--- Gets the class name
--- @return string
function Enemy.getClassName()
  return "Dummy.Enemy"
end

--- Gets the enemy's name
--- @return Dummy.Text.Text
function Enemy:getName()
  return self.name
end

--- Sets the enemy's name
--- @param name string
function Enemy:setName(name)
  self.name = name
end

--- Gets the enemy's HP
--- @return number
function Enemy:getHP()
  return self.hp
end

--- Sets the enemy's HP
--- @param hp number health points
function Enemy:setHP(hp)
  if type(hp) ~= "number" then return end

  self.hp = math.clamp(hp, 0, self.max_hp)
end

--- Gets the enemy's max HP
--- @return number
function Enemy:getMaxHP()
  return self.max_hp
end

--- Sets the enemy's max HP
--- @param max_hp number maximum health points
function Enemy:setMaxHP(max_hp)
  if type(max_hp) ~= "number" then return end

  self.max_hp = max_hp
end

--- Gets the enemy's AT
--- @return number
function Enemy:getAT()
  return self.at
end

--- Sets the enemy's AT
--- @param at number attack point
function Enemy:setAT(at)
  self.at = at
end

--- Gets the enemy's DE
--- @return number
function Enemy:getDF()
  return self.df
end

--- Sets the enemy's DE
--- @param df number defense point
function Enemy:setDF(df)
  self.df = df
end

--- Gets the enemy's EXP
--- @return number
function Enemy:getEXP()
  return self.exp
end

--- Sets the enemy's EXP
--- @param exp number experience points
function Enemy:setEXP(exp)
  self.exp = exp
end

--- Gets the enemy's gold
--- @return number
function Enemy:getGold()
  return self.gold
end

--- Sets the enemy's gold
--- @param gold number gold
function Enemy:setGold(gold)
  self.gold = gold
end

--- Wether the enemy has a check text
--- @return boolean
function Enemy:hasCheck()
  return self.check ~= nil
end

--- Gets the enemy's check
--- @return Dummy.Text.Text
function Enemy:getCheck()
  return self.check
end

--- Sets the enemy's check
--- @param check Dummy.Text.Text
function Enemy:setCheck(check)
  self.check = check
end

--- Gets the computed enemy's check text
--- @return string
function Enemy:getCheckText()
  local check = "* " .. UTF8.upper(Lang.translate(self:getName())) .. " - "
  check = check .. Lang.translate("ENCOUNTER_STAT_AT") .. " " .. self:getAT() .. " "
  check = check .. Lang.translate("ENCOUNTER_STAT_DF") .. " " .. self:getDF()
  check = check .. "[wait:5]\n" .. Lang.translate(self:getCheck())
  return check
end

--- Gets the enemy's ACTs
--- @return Dummy.ACT[]
function Enemy:getACTs()
  return self.acts
end

--- Adds one or more ACTs to the enemy
--- @param act Dummy.ACT|Dummy.ACT[]
--- @param ... Dummy.ACT
function Enemy:addACT(act, ...)
  local acts = { act, ... }
  if #act >= 1 then acts = act end
  for _, act in ipairs(acts) do
    --- @diagnostic disable-next-line: invisible
    act.enemy = self
    table.insert(self.acts, act)
  end
end

--- Removes an ACT from the enemy
--- @param act Dummy.ACT
function Enemy:removeACT(act)
  table.removeByValue(self.acts, act)
end

--- Wether the enemy can be spared
--- @return boolean
function Enemy:getCanBeSpared()
  return self.can_be_spared and not self:isSpared() and not self:isKilled()
end

--- Sets wether the enemy can be spared
--- @param can_be_spared boolean
function Enemy:setCanBeSpared(can_be_spared)
  self.can_be_spared = can_be_spared
end

--- Wether the enemy has been spared
--- @return boolean
function Enemy:isSpared()
  return self.is_spared
end

--- Sets wether the enemy has been spared
--- @param spared boolean
function Enemy:setSpared(spared)
  self.is_spared = spared
end

--- Spares the enemy
function Enemy:spare()
  if self:isSpared() then return end
  self.is_spared = true

  self:setAlpha(0.5)
  Assets.playSound("spare", true, false, true)

  local x, y = self:getPosition()
  local width, height = self:getWidth(), self:getHeight()

  --- @type Dummy.Sprite[]
  local dustclouds = {}
  for _ = 1, 14 do
    local dustcloud = Sprite:new({ "dustcloud1", "dustcloud2", "dustcloud3" }, 4 / 30, false, true, false)
    dustcloud:setScale(love.math.random() + 0.7)
    local dust_x = (love.math.random() * width / 2) + width / 4 + x - 8
    local dust_y = (love.math.random() * height / 2) + height / 4 + y - 8
    dustcloud:setPosition(0, -height / 2)
    dustcloud:setParent(self)

    local rightside = (8 + dust_x - x) / (width / 2)
    local topside = (8 + dust_y - y) / (height / 2)
    local direction = love.math.random() * 360
    if rightside < 0.75 then
      direction = 180
    end
    if rightside > 1.25 then
      direction = 0
    end
    if topside > 1.25 and rightside > 1.25 then
      direction = 45
    end
    if topside > 1.25 and rightside > 0.75 and rightside < 1.25 then
      direction = 90
    end
    if topside > 1.25 and rightside < 0.75 then
      direction = 135
    end
    if topside < 0.75 and rightside > 1.25 then
      direction = 315
    end
    if topside < 0.75 and rightside > 0.75 and rightside < 1.25 then
      direction = 270
    end
    if topside < 0.75 and rightside < 0.75 then
      direction = 235
    end
    dustcloud["vel_x"] = math.cos(math.rad(direction)) * 8
    dustcloud["vel_y"] = math.sin(math.rad(direction)) * 8

    table.insert(dustclouds, dustcloud)
  end

  local function applyFriction(vel, friction)
    if vel > 0 then
      vel = vel - friction
      if vel < 0 then vel = 0 end
    elseif vel < 0 then
      vel = vel + friction
      if vel > 0 then vel = 0 end
    end
    return vel
  end

  Timer.during(1, function(dt)
    for _, dustcloud in ipairs(dustclouds) do
      local x, y = dustcloud:getPosition()
      dustcloud:setAlpha(math.max(0, dustcloud:getAlpha() - 0.03 * 30 * dt))
      dustcloud:setPosition(x + dustcloud["vel_x"] * 30 * dt, y + dustcloud["vel_y"] * 30 * dt)

      dustcloud["vel_x"] = applyFriction(dustcloud["vel_x"], 0.8 * 30 * dt)
      dustcloud["vel_y"] = applyFriction(dustcloud["vel_y"], 0.8 * 30 * dt)
    end
  end, function()
    for _, dustcloud in ipairs(dustclouds) do
      dustcloud:remove()
    end
  end)
end

--- Wether the enemy has been killed
--- @return boolean
function Enemy:isKilled()
  return self.hp <= 0
end

--- Gets the enemy's hurt sound
--- @return love.Source|nil
function Enemy:getHurtSound()
  return self.hurt_sound
end

--- Sets the enemy's hurt sound
--- @param hurt_sound string|nil
function Enemy:setHurtSound(hurt_sound)
  if self.hurt_sound ~= nil then
    self.hurt_sound:stop()
  end

  if hurt_sound == nil then
    self.hurt_sound = nil
  else
    self.hurt_sound = Assets.playSound(hurt_sound, false)
  end
end

--- Called when the enemy should dialogue
function Enemy:onDialogue() end

--- Called when trying to spare an enemy
--- @param spared boolean wether the enemy has been spared
function Enemy:onSpared(spared) end

--- Called before the strike animation is played on the enemy
function Enemy:onBeforeAttack() end

--- Called before the enemy is damaged
--- @param damage number calculated damage
--- @param miss boolean wether the attack missed
--- @return number|nil damage, boolean|nil miss override damage & wether the attack missed
function Enemy:onBeforeDamage(damage, miss) return damage, miss end

--- Called when the enemy is damaged
--- @param damage number damage taken
function Enemy:onDamage(damage) end

--- Called after when the enemy is damaged
function Enemy:onAfterDamage() end

--- Called after attacking the enemy
function Enemy:onAfterAttack() end

--- Called when the enemy is killed
function Enemy:onKilled() end

--- Creates an enemy
--- @param name Dummy.Text.Text
--- @param sprite string
--- @return Dummy.Enemy
function Enemy:new(name, sprite)
  assert(name ~= nil, "Enemy name is nil")
  assert(sprite ~= nil, "Enemy \"" .. name .. "\" sprite is nil")

  self = Class:new(Enemy, { sprite })
  self.name = name
  self.hp = 20
  self.max_hp = 20
  self.at = 0
  self.df = 0
  self.exp = 0
  self.gold = 0
  self.check = ""
  self.acts = {}
  self.can_be_spared = false

  self:setOrigin(0.5, 1)
  self:setLayer(Constants.LAYERS.BELOW_ARENA)
  self:setPosition(320, 240)

  return self
end

return Enemy
