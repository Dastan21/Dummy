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
  local mod_list = require "mod.mod_list"
  mod_list.loadMod(mod)
  mod_list.setWindowTitleAndIcon(mod:getTitle())

  Encounter.updatePlayerUI()
end

function encounter.update(dt)
  if type(encounter.mod.update) == "function" then
    encounter.mod:update(dt)
  end

  if Encounter.getCurrentState() ~= encounter.previous_state then
    if type(encounter.mod.onStateChange) == "function" then
      encounter.mod:onStateChange(Encounter.getCurrentState(), encounter.previous_state)
    end

    encounter.previous_state = Encounter.getCurrentState()
  end

  if Scene.getSceneName() ~= "ENCOUNTER" then return end

  Arena.update(dt)
  Encounter.update(dt)
end

return encounter
