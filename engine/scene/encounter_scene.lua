--- @class Dummy.Scene.Encounter : Dummy.Scene.Scene
---
--- @field protected mod Dummy.Mod
local encounter = {}

--- Loads the encounter scene
--- @param mod Dummy.Mod
function encounter.load(mod)
  Arena.load()
  Player.load()
  Encounter.load()

  encounter.mod = mod
  local mod_list = require "mod.mod_list"
  mod_list.loadMod(mod)
  mod_list.setWindowTitleAndIcon(mod:getTitle())
end

function encounter.update(dt)
  Arena.update(dt)
  Encounter.update(dt)

  if type(encounter.mod.update) == "function" then
    encounter.mod:update(dt)
  end
end

return encounter
