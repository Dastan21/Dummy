--- @class Dummy.Scene.Encounter : Dummy.Scene.Scene
local encounter = {}

--- Loads the encounter scene
--- @param mod Dummy.Mod
function encounter.load(mod)
  Arena.load()
  Player.load()
  Encounter.load()

  local mod_list = require "mod.mod_list"
  mod_list.loadMod(mod)
  mod_list.setWindowTitleAndIcon(mod:getTitle())
end

function encounter.update(dt)
  Arena.update(dt)
  Encounter.update(dt)
end

return encounter
