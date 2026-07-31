--- @class DummyMod : Dummy.Mod
local mod = Mod:new({
  name = "Dummy",                      -- displayed name, in the mods list
  title = "DUMMY_MOD_ENCOUNTER_TITLE", -- window title
  version = "1.0.0",                   -- mod version
  standalone = false,                  -- wether to auto-load this mod when starting the engine
})

--- Loads the mod
function mod:load()
  -- log in the debug console (F8)
  -- logs are saved in "logs.txt" in the save directory
  print("Dummy encounter loaded!")

  -- prepare player stats
  Player.setName("Frisk")
  Player.setLV(1)

  local encounter = modRequire("scripts.encounters.dummy")
  World.startEncounter(encounter)
end

--- Called when the main menu is loaded, for standalone mods only
function mod:preview() end

--- Called before the game is saved
function mod:onGameSave() end

--- Called when a room is entered
--- @param room Dummy.Room
function mod:onRoomEnter(room) end

--- Called when a room is left
--- @param room Dummy.Room
function mod:onRoomLeave(room) end

--- Called when an encounter starts
--- @param encounter Dummy.Battle.Encounter
function mod:onEncounterStart(encounter) end

--- Called when an encounter ends
--- @param encounter Dummy.Battle.Encounter
function mod:onEncounterEnd(encounter) end

--- Updates the mod, called on every game update
--- @param dt number
function mod:update(dt) end

return mod
