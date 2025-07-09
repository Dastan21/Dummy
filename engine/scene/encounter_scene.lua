--- @class Dummy.Scene.Encounter : Dummy.Scene.Scene
---
--- @field protected mod Dummy.Mod
--- @field protected previous_state string
local encounter = {}

--- Loads the encounter scene
--- @param mod Dummy.Mod
function encounter.load(mod)
  Arena.load()
  Player.load()
  Encounter.load()
  encounter.previous_state = Encounter.getCurrentState()

  encounter.mod = mod
  ModList.loadMod(mod)
  ModList.setWindowTitleAndIcon(mod:getTitle())

  Encounter.updatePlayerUI()
end

function encounter.update(dt)
  if type(encounter.mod.update) == "function" then
    encounter.mod:update(dt)
  end

  local current_state = Encounter.getCurrentState()
  if current_state ~= encounter.previous_state then
    if type(encounter.mod.onStateChange) == "function" then
      encounter.mod:onStateChange(current_state, encounter.previous_state)
    end

    if encounter.previous_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU and current_state == Constants.ENCOUNTER_STATES.ATTACKING then
      if type(encounter.mod.onEnemyAttackSelected) == "function" then
        encounter.mod:onEnemyAttackSelected(Encounter.getSelectedEnemy())
      end
    elseif encounter.previous_state == Constants.ENCOUNTER_STATES.ACT_MENU and current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
      if type(encounter.mod.onEnemyActSelected) == "function" then
        encounter.mod:onEnemyActSelected(Encounter.getSelectedEnemy())
      end
    elseif encounter.previous_state == Constants.ENCOUNTER_STATES.TEXT_DIALOGUE and current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
      if type(encounter.mod.onEncounterTextEnd) == "function" then
        encounter.mod:onEncounterTextEnd()
      end
    elseif encounter.previous_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE and (current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT or current_state == Constants.ENCOUNTER_STATES.DEFENDING) then
      if type(encounter.mod.onEnemyDialoguesEnd) == "function" then
        encounter.mod:onEnemyDialoguesEnd()
      end
    elseif encounter.previous_state == Constants.ENCOUNTER_STATES.DEFENDING and current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
      if type(encounter.mod.onDefendingEnd) == "function" then
        encounter.mod:onDefendingEnd()
      end
    end

    encounter.previous_state = current_state
  end

  if Scene.getSceneName() ~= "ENCOUNTER" then return end

  Arena.update(dt)
  Encounter.update(dt)
end

return encounter
