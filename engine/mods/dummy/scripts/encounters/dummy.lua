--- @class DummyMod.Encounter.Dummy : Dummy.Battle.Encounter
---
--- @field protected turn number
--- @field protected tire_turn number
--- @field protected dummy DummyMod.Enemy.Dummy
local Dummy = Class(Encounter, "DummyMod.Encounter.Dummy")

--- Creates an encounter dummy
--- @return DummyMod.Encounter.Dummy
function Dummy:new()
  self = Class:new(Dummy)

  self.turn = 0
  self.tire_turn = 6

  -- set wether the encounter can be fleed
  self:setCanFlee(true)

  return self
end

--- Called when the encounter starts
function Dummy:onStart()
  -- set the battle music
  Battle.setMusic("prebattle")
  -- set the first displayed text
  Battle.setText("DUMMY_MOD_ENCOUNTER_TEXT_1")

  self.dummy = modRequire("scripts.enemies.dummy.dummy"):new()
end

--- Called when an enemy is selected for attack
function Dummy:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
function Dummy:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function Dummy:onTextEnd() end

--- Called when all enemy dialogues are done
function Dummy:onEnemyDialoguesEnd()
  self.turn = self.turn + 1

  if self.turn > self.tire_turn then
    Assets.playSound("slidewhist")
    Battle.playDialogueText("DUMMY_MOD_ENCOUNTER_TIRE")
    self.dummy:setSpared(true)
  end
end

--- Called when the defending phase is done
function Dummy:onDefendingEnd()
  if love.math.random() > 0.5 then
    Battle.setText("DUMMY_MOD_ENCOUNTER_TEXT_2")
  else
    Battle.setText("DUMMY_MOD_ENCOUNTER_TEXT_3")
  end
end

--- Called when the player is fleeing
function Dummy:onFlee() end

--- Called when the encounter state changes
function Dummy:onStateChange(current_state, previous_state) end

--- Called when the encounter ends
function Dummy:onEnd() end

--- Updates the mod, called on every game update
--- @param dt number
function Dummy:update(dt)
  if self.turn > self.tire_turn then
    local x, y = self.dummy:getPosition()
    self.dummy:setPosition(x, y - 120 * dt)
  end
end

return Dummy
