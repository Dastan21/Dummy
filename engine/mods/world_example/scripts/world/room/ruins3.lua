--- @class WorldExample.Room.Ruins3 : Dummy.Room
---
--- @field protected dummy WorldExample.Object.Dummy
--- @field protected ruins_door WorldExample.Object.RuinsDoor|nil
--- @field protected savepoint WorldExample.Object.Savepoint|nil
local Ruins3Room = Class(Room, "WorldExample.Room.Ruins3")

--- Creates the dummy room
--- @return WorldExample.Room.Ruins3
function Ruins3Room:new()
  self = Class:new(Ruins3Room, { "ruins3", "WORLD_EXAMPLE_MOD_WORLD_RUINS4_NAME", 320, 240 })

  self:initTiles()
  self:setMusic("ruins")

  return self
end

--- Called when the room is entered
---
--- Note: Initialize all he room's objects here
function Ruins3Room:onEnter()
  -- walls
  SolidObject:new(0, 220, 300, 20)
  SolidObject:new(280, 60, 20, 180)
  SolidObject:new(0, 60, 300, 20)
  SolidObject:new(0, 60, 20, 180)
  SolidObject:new(60, 80)
  SolidObject:new(40, 100)
  SolidObject:new(20, 120)
  SolidObject:new(20, 180)
  SolidObject:new(40, 180)
  SolidObject:new(60, 200)
  SolidObject:new(240, 80)
  SolidObject:new(260, 100)
  SolidObject:new(260, 180)
  SolidObject:new(240, 200)

  -- dummy object
  if (WorldExampleMod.flag["dummy_battle"] or 0) < 1 then
    local DummyObject = modRequire("scripts.world.object.obj_dummy") --[[@as WorldExample.Object.Dummy]]
    self.dummy = DummyObject:new(200, 90)
  end

  if WorldExampleMod.flag["dummy_battle"] ~= 2 then
    -- ruins door
    local RuinsDoorObject = modRequire("scripts.world.object.obj_ruins_door") --[[@as WorldExample.Object.RuinsDoor]]
    self.ruins_door = RuinsDoorObject:new(140, 20)
  else
    -- save point
    self.savepoint = SavepointObject:new(205, 110,
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS4_1",
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS4_2"
    )

    -- chestbox
    ChestboxObject:new(205, 150)
  end

  -- doors
  RoomTransitionObject:new("ruins2", 700, 140, 0, 140, 20, 40)
  ShopTransitionObject:new("dummy_shop", 140, 60, 40, 20)
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
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS4_1",
      "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS4_2"
    )
  end
end

--- Initializes the room's tiles
function Ruins3Room:initTiles()
  self:setTileset("ruins3")

  -- outline
  self:setTile(15, 60, 0)
  self:setTile(25, 80, 0)
  self:setTile(25, 100, 0)
  self:setTile(26, 120, 0)
  self:setTile(24, 180, 0)
  self:setTile(25, 200, 0)
  self:setTile(25, 220, 0)
  self:setTile(16, 240, 0)
  self:setTile(15, 40, 20)
  self:setTile(15, 20, 40)
  self:setTile(26, 60, 20)
  self:setTile(26, 40, 40)
  self:setTile(26, 20, 60)
  self:setTile(25, 0, 60)
  self:setTile(24, 240, 20)
  self:setTile(24, 260, 40)
  self:setTile(16, 260, 20)
  self:setTile(18, 280, 60)
  self:setTile(18, 280, 80)
  self:setTile(18, 280, 100)
  self:setTile(18, 280, 120)
  self:setTile(18, 280, 140)
  self:setTile(18, 280, 160)
  self:setTile(22, 280, 180)
  self:setTile(22, 260, 200)
  self:setTile(22, 240, 220)
  self:setTile(12, 260, 180)
  self:setTile(12, 240, 200)
  self:setTile(13, 220, 220)
  self:setTile(13, 200, 220)
  self:setTile(13, 180, 220)
  self:setTile(13, 160, 220)
  self:setTile(13, 140, 220)
  self:setTile(13, 120, 220)
  self:setTile(13, 100, 220)
  self:setTile(13, 80, 220)
  self:setTile(21, 60, 220)
  self:setTile(21, 40, 200)
  self:setTile(14, 60, 200)
  self:setTile(14, 40, 180)
  self:setTile(13, 20, 180)
  self:setTile(13, 0, 180)

  -- ground
  self:setTile(1, 40, 120)
  self:setTile(1, 60, 120)
  self:setTile(1, 80, 120)
  self:setTile(1, 100, 120)
  self:setTile(1, 60, 100)
  self:setTile(1, 80, 100)
  self:setTile(1, 100, 100)
  self:setTile(1, 120, 100)
  self:setTile(1, 80, 80)
  self:setTile(1, 100, 80)
  self:setTile(1, 120, 80)
  self:setTile(1, 180, 80)
  self:setTile(1, 200, 80)
  self:setTile(1, 220, 80)
  self:setTile(1, 240, 100)
  self:setTile(1, 240, 120)
  self:setTile(1, 260, 120)
  self:setTile(1, 180, 140)
  self:setTile(1, 200, 140)
  self:setTile(1, 220, 140)
  self:setTile(1, 240, 140)
  self:setTile(1, 260, 140)
  self:setTile(1, 180, 160)
  self:setTile(1, 200, 160)
  self:setTile(1, 220, 160)
  self:setTile(1, 240, 160)
  self:setTile(1, 260, 160)
  self:setTile(1, 60, 180)
  self:setTile(1, 80, 180)
  self:setTile(1, 100, 180)
  self:setTile(1, 120, 180)
  self:setTile(1, 140, 180)
  self:setTile(1, 160, 180)
  self:setTile(1, 180, 180)
  self:setTile(1, 200, 180)
  self:setTile(1, 220, 180)
  self:setTile(1, 240, 180)
  self:setTile(1, 80, 200)
  self:setTile(1, 100, 200)
  self:setTile(1, 120, 200)
  self:setTile(1, 140, 200)
  self:setTile(1, 160, 200)
  self:setTile(1, 180, 200)
  self:setTile(1, 200, 200)
  self:setTile(1, 220, 200)

  -- path
  self:setTile(0, 0, 160)
  self:setTile(0, 20, 160)
  self:setTile(0, 40, 160)
  self:setTile(0, 60, 160)
  self:setTile(0, 80, 160)
  self:setTile(0, 100, 160)
  self:setTile(0, 120, 160)
  self:setTile(0, 140, 160)
  self:setTile(0, 0, 140)
  self:setTile(0, 20, 140)
  self:setTile(0, 40, 140)
  self:setTile(0, 60, 140)
  self:setTile(0, 80, 140)
  self:setTile(0, 100, 140)
  self:setTile(0, 120, 140)
  self:setTile(0, 140, 140)
  self:setTile(0, 160, 140)
  self:setTile(0, 140, 120)
  self:setTile(0, 160, 120)
  self:setTile(0, 180, 120)
  self:setTile(0, 200, 120)
  self:setTile(0, 140, 100)
  self:setTile(0, 160, 100)
  self:setTile(0, 180, 100)
  self:setTile(0, 200, 100)
  self:setTile(0, 140, 80)
  self:setTile(0, 160, 80)

  -- path corners
  self:setTile(7, 120, 120)
  self:setTile(6, 160, 160)
  self:setTile(5, 220, 100)
  self:setTile(11, 220, 120)

  -- walls
  self:setTile(2, 260, 60)
  self:setTile(2, 260, 80)
  self:setTile(8, 260, 100)
  self:setTile(2, 240, 40)
  self:setTile(2, 240, 60)
  self:setTile(8, 240, 80)
  self:setTile(2, 180, 20)
  self:setTile(2, 180, 40)
  self:setTile(8, 180, 60)
  self:setTile(3, 220, 20)
  self:setTile(3, 220, 40)
  self:setTile(9, 220, 60)
  self:setTile(3, 200, 20)
  self:setTile(3, 200, 40)
  self:setTile(9, 200, 60)
  self:setTile(4, 120, 20)
  self:setTile(4, 120, 40)
  self:setTile(10, 120, 60)
  self:setTile(4, 60, 40)
  self:setTile(4, 60, 60)
  self:setTile(10, 60, 80)
  self:setTile(4, 40, 60)
  self:setTile(4, 40, 80)
  self:setTile(10, 40, 100)
  self:setTile(4, 20, 80)
  self:setTile(4, 20, 100)
  self:setTile(10, 20, 120)
  self:setTile(3, 100, 20)
  self:setTile(3, 100, 40)
  self:setTile(9, 100, 60)
  self:setTile(3, 80, 20)
  self:setTile(3, 80, 40)
  self:setTile(9, 80, 60)
  self:setTile(3, 0, 80)
  self:setTile(3, 0, 100)
  self:setTile(9, 0, 120)

  -- wines
  self:setTile(17, 100, 20)
  self:setTile(17, 100, 40)
  self:setTile(17, 100, 60)
  self:setTile(17, 200, 20)
  self:setTile(17, 200, 40)
  self:setTile(17, 200, 60)
end

return Ruins3Room
