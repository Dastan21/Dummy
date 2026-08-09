--- @class WorldExample.Room.Ruins3 : Dummy.Room
---
--- @field protected dummy WorldExample.Object.Dummy
--- @field protected ruins_door WorldExample.Object.RuinsDoor|nil
--- @field protected savepoint WorldExample.Object.Savepoint|nil
local Ruins3Room = Class(Room, "WorldExample.Room.Ruins3")

--- Creates the dummy room
--- @return WorldExample.Room.Ruins3
function Ruins3Room:new()
  self = Class:new(Ruins3Room, { "ruins3", "WORLD_EXAMPLE_MOD_WORLD_RUINS3_NAME", 320, 240 })

  -- load data saved from the editor
  self:loadData("ruins3")

  return self
end

--- Called when the room is entered
---
--- Note: Initialize all he room's objects here
function Ruins3Room:onEnter()
  WorldExampleMod.ruins3_enter_count = WorldExampleMod.ruins3_enter_count + 1

  if WorldExampleMod.flag["dummy_battle"] ~= 2 then
    local RuinsDoorObject = modRequire("scripts.world.object.obj_ruins_door") --[[@as WorldExample.Object.RuinsDoor]]
    self.ruins_door = World.getCurrentRoom():getObjectsByType(RuinsDoorObject)[1]
  else
    -- save point
    self.savepoint = SavepointObject:new(205, 110,
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS3_1",
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS3_2"
    )

    -- chestbox
    ChestboxObject:new(205, 150)
  end

  local DummyObject = modRequire("scripts.world.object.obj_dummy") --[[@as WorldExample.Object.Dummy]]
  self.dummy = World.getCurrentRoom():getObjectsByType(DummyObject)[1]

  if WorldExampleMod.flag["man"] ~= 1 and WorldExampleMod.ruins3_enter_count > 3 and love.math.random() < 0.1 then
    for _, room_transition in ipairs(World.getCurrentRoom():getObjectsByType(RoomTransitionObject)) do
      local x, y = room_transition:getPosition()
      if x == 0 and y == 140 then
        room_transition:remove()
        RoomTransitionObject:new("man", 150, 190, 0, 140, 20, 40)
      end
    end
  end
end

--- Called when the room is resumed
function Ruins3Room:onResume()
  if WorldExampleMod.flag["dummy_battle"] == 1 and self.dummy ~= nil then
    self.dummy:remove()
    self.dummy = nil
  elseif WorldExampleMod.flag["dummy_battle"] == 2 and self.dummy ~= nil then
    self.ruins_door:remove()
    self.dummy:remove()
    self.dummy = nil

    ChestboxObject:new(205, 150)
  elseif WorldExampleMod.flag["dummy_battle"] == 2 and self.savepoint == nil then
    self.savepoint = SavepointObject:new(205, 110,
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS3_1",
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS3_2"
    )
  end
end

return Ruins3Room
