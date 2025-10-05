--- @class DummyMod : Dummy.Mod
---
--- @field turn number
--- @field tire_turn number
--- @field done boolean
--- @field dummy DummyMonster
local mod = Mod:new({
  name = "Dummy",                      -- displayed name, in the mods list
  title = "DUMMY_MOD_ENCOUNTER_TITLE", -- window title
  version = "1.0.0",                   -- mod version
  standalone = false,                  -- wether to auto-load this mod when starting the engine
})

function mod:load()
  -- log in the debug console (F8)
  -- logs are saved in "logs.txt" in the save directory
  print("Dummy encounter loaded!")

  -- fancy opening transition
  Fader.fadeOut(0.5)

  -- encounter dialogue text
  Encounter.setText("DUMMY_MOD_ENCOUNTER_TEXT_1")
  -- musics must be placed in the "assets/musics" folder
  Encounter.setMusic("prebattle")

  -- prepare player stats
  Player.setName("Frisk")
  Player.setLV(1)

  -- add the Dummy to the encounter
  local Dummy = require("scripts.enemies.dummy.dummy")
  self.dummy = Dummy:new()
  Encounter.addEnemy(self.dummy)

  -- initialize additional variables
  self.turn = 0
  self.tire_turn = 6
  self.done = false
end

--- Called on every game update
function mod:update(dt)
  if self.turn > self.tire_turn then
    local x, y = self.dummy:getPosition()
    self.dummy:setPosition(x, y - 120 * dt)
  end
end

--- Called when an enemy is selected for attack
function mod:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
function mod:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function mod:onEncounterTextEnd() end

--- Called when all enemy dialogues are done
function mod:onEnemyDialoguesEnd()
  self.turn = self.turn + 1

  if self.turn > self.tire_turn then
    Assets.playSound("slidewhist")
    Encounter.playDialogueText("DUMMY_MOD_ENCOUNTER_TIRE")
    self.dummy:setSpared(true)
  end
end

--- Called when the defending phase is done
function mod:onDefendingEnd()
  if math.random() > 0.5 then
    Encounter.setText("DUMMY_MOD_ENCOUNTER_TEXT_2")
  else
    Encounter.setText("DUMMY_MOD_ENCOUNTER_TEXT_3")
  end
end

--- Called when the player is fleeing
function mod:onFlee()
  self.done = true
end

--- Called when the encounter state changes
function mod:onStateChange(current_state, previous_state)
  if current_state == Constants.ENCOUNTER_STATES.DONE and not self.done then
    self.done = true
    Encounter.setState(Constants.ENCOUNTER_STATES.NONE)
    Fader.fadeIn(0.5, "linear", function()
      Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
    end)
  end
end

return mod
