--- @class DummyMod.Enemy.Dummy : Dummy.Battle.Enemy
local DummyEnemy = Class(Enemy, "DummyMonster")

--- Initializes the Dummy
--- @return DummyMod.Enemy.Dummy
function DummyEnemy:new()
  -- create the base enemy
  self = Class:new(DummyEnemy, { "DUMMY_MOD_ENCOUNTER_DUMMY_NAME", "dummy" })

  -- set HP after max HP to heal
  self:setMaxHP(15)
  self:setHP(15)
  -- check text below the stats text
  self:setCheck("DUMMY_MOD_ENCOUNTER_CHECK_TEXT")
  -- position of the Dummy, strike animation and damage bar are positioned relative to this
  self:setPosition(260, 240)

  -- add ACTs
  local talk = modRequire("scripts.enemies.dummy.acts.talk")
  self:addACT(talk)

  -- return the newly created enemy
  return self
end

--- Called when the enemy should dialogue
function DummyEnemy:onDialogue()
  -- play the dialogue bubble
  local dialogue = Battle.playDialogueBubble("right", "DUMMY_MOD_ENCOUNTER_BUBBLE")
  -- position it to the right of the Dummy
  local x, y = self:getPosition()
  local dialogue_x = x + self:getWidth() / 2
  local dialogue_y = y - self:getHeight() / 2
  dialogue:setPosition(dialogue_x, dialogue_y)
end

--- Called when trying to spare an enemy
function DummyEnemy:onSpared(spared) end

--- Called before the enemy is damaged
function DummyEnemy:onBeforeDamage(damage) end

--- Called when the enemy is damaged
function DummyEnemy:onDamage(damage)
  self:setSprite("dummy_hurt")
end

--- Called after when the enemy is damaged
function DummyEnemy:onAfterDamage()
  self:setSprite("dummy")
end

--- Called when the enemy is killed
function DummyEnemy:onKilled() end

--- Updates the enemy, called on every game update
--- @param dt number
function DummyEnemy:update(dt)
  Enemy.update(self, dt)

  -- your code here
end

return DummyEnemy
