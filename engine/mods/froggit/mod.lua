--- @class FroggitMod : Dummy.Mod
---
--- @field command number
--- @field froggit FroggitMonster
local mod = Mod:new({
  name = "Froggit",                      -- displayed name, in the mods list
  title = "FROGGIT_MOD_ENCOUNTER_TITLE", -- window title
  version = "1.0.0",                     -- mod version
  standalone = false,                    -- wether to auto-load this mod when starting the engine
})

function mod:load()
  -- log in the debug console (F8)
  -- logs are saved in "logs.txt" in the save directory
  print("Froggit encounter loaded!")

  -- fancy opening transition
  Fader.fadeOut(0.5)

  -- encounter dialogue text
  Encounter.setText("FROGGIT_MOD_ENCOUNTER_TEXT_1")
  -- musics must be placed in the "assets/musics" folder
  Encounter.setMusic("battle")

  -- prepare player stats
  Player.setName("Frisk")
  Player.setLV(1)

  -- add the Froggit to the encounter
  local Dummy = modRequire("scripts.enemies.froggit.froggit")
  self.froggit = Dummy:new()
  Encounter.addEnemy(self.froggit)

  -- add items
  Player.addItem(ItemConsumable:new("FROGGIT_MOD_MONSTER_CANDY_NAME", "FROGGIT_MOD_MONSTER_CANDY_SHORTNAME", 50, "food"))
  Player.addItem(ItemEquipment:new("FROGGIT_MOD_TOY_KNIFE_NAME", "FROGGIT_MOD_TOY_KNIFE_SHORTNAME", 3, "weapon"))

  -- initialize additional variables
  self.command = 0
end

--- Called on every game update
function mod:update(dt) end

--- Called when an enemy is selected for attack
function mod:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
function mod:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function mod:onEncounterTextEnd() end

--- Called when all enemy dialogues are done
function mod:onEnemyDialoguesEnd() end

--- Called when the defending phase is done
function mod:onDefendingEnd()
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

  Encounter.setText(text)
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
