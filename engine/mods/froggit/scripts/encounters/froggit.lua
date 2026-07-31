--- @class FroggitMod.Encounter.Froggit : Dummy.Battle.Encounter
---
--- @field command number
--- @field protected froggit FroggitMod.Enemy.Froggit
local Froggit = Class(Encounter, "FroggitMod.Encounter.Froggit")

--- Creates an encounter dummy
--- @return FroggitMod.Encounter.Froggit
function Froggit:new()
  self = Class:new(Froggit)

  self.command = 0

  -- set wether the encounter can be fleed
  self:setCanFlee(true)

  return self
end

--- Called when the encounter starts
function Froggit:onStart()
  -- set the battle music
  Battle.setMusic("battle")
  -- set the first displayed text
  Battle.setText("FROGGIT_MOD_ENCOUNTER_TEXT_1")

  self.froggit = modRequire("scripts.enemies.froggit.froggit"):new()
end

--- Called when an enemy is selected for attack
--- @param enemy Dummy.Battle.Enemy
function Froggit:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
--- @param enemy Dummy.Battle.Enemy
function Froggit:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function Froggit:onTextEnd() end

--- Called when all enemy dialogues are done
function Froggit:onEnemyDialoguesEnd() end

--- Called when the defending phase is done
function Froggit:onDefendingEnd()
  local text = "FROGGIT_MOD_ENCOUNTER_TEXT_5"
  if self.command < 0.3 then
    text = "FROGGIT_MOD_ENCOUNTER_TEXT_2"
  elseif self.command < 0.6 then
    text = "FROGGIT_MOD_ENCOUNTER_TEXT_3"
  elseif self.command < 0.8 then
    text = "FROGGIT_MOD_ENCOUNTER_TEXT_4"
  end

  if self.froggit:getCanBeSpared() then
    text = "FROGGIT_MOD_ENCOUNTER_TEXT_MERCY"
  end

  if self.froggit:getHP() < 5 then
    text = "FROGGIT_MOD_ENCOUNTER_TEXT_LOW_LIFE"
  end

  Battle.setText(text)
end

--- Called when the player is fleeing
function Froggit:onFlee() end

--- Called when the encounter state changes
function Froggit:onStateChange(current_state, previous_state) end

--- Called when the encounter ends
function Froggit:onEnd() end

return Froggit
