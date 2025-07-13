--- @class DummyMod : Dummy.Mod
---
--- @field turn number
--- @field fire_turn number
--- @field done boolean
--- @field dummy DummyMonster
local mod = Mod:new({
  name = "Dummy",                      -- displayed name
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

  -- add items
  Player.addItem(ItemConsumable:new("DUMMY_MOD_MONSTER_CANDY_NAME", "DUMMY_MOD_MONSTER_CANDY_SHORTNAME", 50, "food"))
  Player.addItem(ItemEquipment:new("DUMMY_MOD_TOY_KNIFE_NAME", "DUMMY_MOD_TOY_KNIFE_SHORTNAME", 3, "weapon"))

  -- initialize additional variables
  self.turn = 0
  self.tire_turn = 6
  self.done = false
end

--- Called when on every game update
function mod:update(dt)
  if self.turn > self.tire_turn then
    local x, y = self.dummy:getPosition()
    self.dummy:setPosition(x, y - 120 * dt)
  end
end

--- Called when an enemy is selected for attack
function mod:onEnemyAttackSelected() end

--- Called when an enemy is selected for ACT
function mod:onEnemyActSelected() end

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

--- Called when the player escaped
function mod:onEscaped()
  self.done = true
end

--- Called when the encounter state changes
function mod:onStateChange(current_state, previous_state)
  if current_state == Constants.ENCOUNTER_STATES.DONE and not self.done then
    self.done = true
    Encounter.setState(Constants.ENCOUNTER_STATES.NONE)
    Fader.fadeIn(0.5, function()
      Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
    end)
  end
end

return mod
