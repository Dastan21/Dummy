--- @class WorldExample.Object.Telescope : Dummy.Object.NPC
---
--- @field protected zoomed boolean
local TelescopeObject = Class(NPCObject, "WorldExample.Object.Telescope")

--- Creates a telescope
--- @param x number
--- @param y number
--- @return WorldExample.Object.Telescope
function TelescopeObject:new(x, y)
  self = Class:new(TelescopeObject)

  self:setSprite("world/object/telescope")
  self:setPosition(x, y)
  self:setHitbox(4, 20, 17, 15)

  self.zoomed = false

  return self
end

--- Toggles the room transitions
--- @param enabled boolean
function TelescopeObject:toggleRoomTransitions(enabled)
  local room_transitions = World.getCurrentRoom():getObjectsByType(RoomTransitionObject)
  for _, transition in ipairs(room_transitions) do
    transition:setEnabled(enabled)
  end
end

--- Called when the telescope is interacted by the player
function TelescopeObject:onInteract()
  if WorldExampleMod.plot < 4.5 then
    World.playDialogue({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_TELESCOPE_USE_TORIEL_DIALOGUE_1" })
    return
  elseif WorldExampleMod.plot < 5 then
    World.playDialogue({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_TELESCOPE_USE_TORIEL_DIALOGUE_2" })
    return
  end

  -- special cutscene to show camera zooming
  if self.zoomed then
    World.playCutscene(function(cutscene)
      Player.getObject():setInteraction("cutscene")
      cutscene:zoomCamera(1, 1, "in-bounce")
      self.zoomed = false
      self:toggleRoomTransitions(true)
      Player.getObject():setInteraction("none")
    end)
    return
  end

  World.playCutscene(function(cutscene)
    local choice = cutscene:text({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_TELESCOPE_USE" })
    if choice == 1 then return end

    Player.getObject():setInteraction("cutscene")
    cutscene:zoomCamera(5, 0.3, "in-out-sine")
    self.zoomed = true
    self:toggleRoomTransitions(false)
    Player.getObject():setInteraction("none")
  end)
end

return TelescopeObject
