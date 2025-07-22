--- @alias Path [ number, number ]

--- @class FroggitMonster : Dummy.Enemy
---
--- @field legs Dummy.Sprite
--- @field head Dummy.Sprite
--- @field private head_paths Path[]
--- @field private current_head_path Path
--- @field private head_paths_index number
--- @field private head_orig_x number
--- @field private head_orig_y number
--- @field private target_angle number
local Froggit = Class:extend(Enemy)

--- Initializes the Froggit
function Froggit:new()
  -- create the base enemy
  self = Class:new(Froggit, { "FROGGIT_MOD_ENCOUNTER_FROGGIT_NAME", "froggit_empty" })

  -- set HP after max HP to heal
  self:setMaxHP(30)
  self:setHP(30)
  self:setAT(4)
  self:setDF(5)
  self:setEXP(3)
  self:setGold(2)
  -- check text below the stats text
  self:setCheck("FROGGIT_MOD_ENCOUNTER_CHECK_TEXT")
  -- position of the Froggit, strike animation and damage bar are positioned relative to this
  self:setPosition(271, 246)
  --- sound played when the Froggit is hurt
  self:setHurtSound("enemy_hurt")

  -- add ACTs
  self:addACT(require("scripts.enemies.froggit.acts.compliment"))
  self:addACT(require("scripts.enemies.froggit.acts.threat"))

  -- add custom animation
  self.legs = Sprite:new({ "froggit_legs_1", "froggit_legs_2" }, 1 / 0.04 / 30)
  self.legs:setOrigin(0.5, 1)
  self.legs:setPosition(271, 246)
  self.head = Sprite:new({ "froggit_head_1", "froggit_head_2" }, 1 / 0.02 / 30)
  self.head:setPosition(268, 194)
  self.head_orig_x, self.head_orig_y = self.head:getPosition()

  -- head path
  self.head_paths = {
    { -8, 4 },
    { 0,  0 },
    { 8,  4 },
    { 0,  8 },
    { 0,  -4 },
  }
  self.head_paths_index = 0
  -- self.current_head_path = table.clone(self.head_paths[1])
  self.target_angle = 0
  self:nextHeadPath()

  -- return the newly created enemy
  return self
end

--- Called when the enemy should dialogue
function Froggit:onDialogue()
  local mod = ModList.getCurrentMod() --[[@as FroggitMod]]
  mod.command = math.random()
  local bubble_text = "FROGGIT_MOD_ENCOUNTER_BUBBLE_4"
  if mod.command < 0.3 then
    bubble_text = "FROGGIT_MOD_ENCOUNTER_BUBBLE_1"
  elseif mod.command < 0.5 then
    bubble_text = "FROGGIT_MOD_ENCOUNTER_BUBBLE_2"
  elseif mod.command < 0.8 then
    bubble_text = "FROGGIT_MOD_ENCOUNTER_BUBBLE_3"
  end

  -- play the dialogue bubble
  local dialogue = Encounter.playDialogueBubble("right", bubble_text)
  -- position it to the right of the Froggit
  local x, y = self:getPosition()
  local dialogue_x = x + self:getWidth() / 2
  local dialogue_y = y - self:getHeight() / 2
  dialogue:setPosition(dialogue_x, dialogue_y)

  if mod.command <= 0.4 then
    local FrogWave = require "scripts.enemies.froggit.waves.frog"
    Encounter.setWaves(FrogWave:new())
  else
    local FlyWave = require "scripts.enemies.froggit.waves.fly"
    Encounter.setWaves(FlyWave:new())
  end
end

--- Called when trying to spare an enemy
function Froggit:onSpared(spared)
  if not spared then return end

  self.legs:setVisible(false)
  self.head:setVisible(false)
  self:setSprite("froggit_idle")
end

--- Called before the enemy is damaged
function Froggit:onBeforeDamage(damage) end

--- Called when the enemy is damaged
function Froggit:onDamage(damage)
  self.legs:setVisible(false)
  self.head:setVisible(false)
  self:setSprite("froggit_idle")
end

--- Called after when the enemy is damaged
function Froggit:onAfterDamage()
  self.legs:setVisible(true)
  self.head:setVisible(true)
  self:setSprite("froggit_empty")
end

--- Called when the enemy is killed
function Froggit:onKilled() end

function Froggit:nextHeadPath()
  self.head_paths_index = (self.head_paths_index % #self.head_paths) + 1
  self.current_head_path = table.clone(self.head_paths[self.head_paths_index])

  local x, y = self.head:getPosition()
  local target_x, target_y = self.current_head_path[1], self.current_head_path[2]
  local dx = target_x - (x - self.head_orig_x)
  local dy = target_y - (y - self.head_orig_y)
  self.target_angle = math.atan(dy / dx)
  if dx < 0 then self.target_angle = self.target_angle + math.pi end
end

--- Called on every game update
function Froggit:update(dt)
  local x, y = self.head:getPosition()
  local target_x, target_y = self.current_head_path[1], self.current_head_path[2]
  local dx = target_x - (x - self.head_orig_x)
  local dy = target_y - (y - self.head_orig_y)
  local distance = math.sqrt(dx * dx + dy * dy)
  if math.abs(distance) < 0.5 then
    self:nextHeadPath()
  end

  x = x + math.cos(self.target_angle) * dt * 9
  y = y + math.sin(self.target_angle) * dt * 9
  self.head:setPosition(x, y)
end

return Froggit
