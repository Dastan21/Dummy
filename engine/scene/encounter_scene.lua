--- @class Dummy.Scene.Encounter : Dummy.Scene.Scene
---
--- @field private encounter Dummy.Encounter
local encounter = {}

--- Loads the encounter scene
--- @param mod Dummy.Mod
function encounter.load(mod)
  local mod_title = mod:getTitle()
  if mod_title ~= nil then
    love.window.setTitle(mod_title)
  end
  love.window.setIcon(love.image.newImageData("assets/icon.png"))

  Arena.load()
  Player.load()

  assert(mod:getEncounter() ~= nil, "Encounter is nil")
  encounter.encounter = mod:getEncounter()
  encounter.encounter:load()
end

function encounter.update(dt)
  Arena.update(dt)
  encounter.encounter:update(dt)
end

return encounter
