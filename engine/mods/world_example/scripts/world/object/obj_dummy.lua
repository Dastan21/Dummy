--- @class WorldExample.Object.Dummy : Dummy.Object.NPC
local DummyObject = Class(NPCObject, "WorldExample.Object.NPC.Dummy")

DummyObject.ALLOW_EDITOR = true

DummyObject.EDITOR_SPRITE = "world/object/dummy"

--- Creates a dummy NPC
--- @param x number
--- @param y number
function DummyObject:new(x, y)
  self = Class:new(DummyObject, { "dummy" })

  self:setSprite("world/object/dummy")
  self:setPosition(x, y)
  self:setHitbox(4, 16, 13, 14)

  local room_name = World.getCurrentRoom():getId()
  if room_name == "ruins3" and (WorldExampleMod.flag["dummy_battle"] or 0) >= 1 then
    self:remove()
    return
  end

  return self
end

--- Called when the dummy is interacted by the player
function DummyObject:onInteract()
  WorldExampleMod.plot = math.max(WorldExampleMod.plot, 6)

  -- start encounter on interact
  local encounter = modRequire("scripts.encounters.dummy"):new()
  World.startEncounter(encounter)
end

return DummyObject
