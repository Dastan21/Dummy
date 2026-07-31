--- @class WorldExample.Room.Ruins1 : Dummy.Room
local Ruins1Room = Class(Room, "WorldExample.Room.Ruins1")

--- Creates the dummy room
--- @return WorldExample.Room.Ruins1
function Ruins1Room:new()
  self = Class:new(Ruins1Room, { "ruins1", "WORLD_EXAMPLE_MOD_WORLD_RUINS2_NAME", 320, 240 })

  self:initTiles()
  self:setMusic("ruins")

  return self
end

--- Called when the room is entered
---
--- Note: Initialize all he room's objects here
function Ruins1Room:onEnter()
  -- walls
  SolidObject:new(20, 60, 280, 20)
  SolidObject:new(20, 60, 20, 180)
  SolidObject:new(20, 220, 280, 20)
  SolidObject:new(280, 60, 20, 180)
  SolidObject:new(40, 80, 20, 20)
  SolidObject:new(240, 80, 20, 20)
  SolidObject:new(260, 100, 20, 20)
  SolidObject:new(60, 200, 20, 20)
  SolidTriangleObject:new("bottom-left", 40, 180)
  SolidTriangleObject:new("bottom-left", 80, 200)
  SolidTriangleObject:new("bottom-right", 240, 180, 40)

  -- doors
  RoomTransitionObject:new("ruins2", 130, 190, 120, 60, 40, 20)

  -- wall switch
  local WallSwitchObject = modRequire("scripts.world.object.obj_wall_switch") --[[@as WorldExample.Object.WallSwitch]]
  WallSwitchObject:new(210, 58, "wallswitchcut1")

  -- readable
  local ReadableObject = modRequire("scripts.world.object.obj_readable") --[[@as WorldExample.Object.Readable]]
  ReadableObject:new(80, 60, "WORLD_EXAMPLE_MOD_WORLD_OBJECT_READABLE_TEXT_1")

  -- ground switches
  local GroundSwitchObject = modRequire("scripts.world.object.obj_ground_switch") --[[@as WorldExample.Object.GroundSwitch]]
  GroundSwitchObject:new(180, 100)
  GroundSwitchObject:new(220, 100)
  GroundSwitchObject:new(200, 118)
  GroundSwitchObject:new(180, 138)
  GroundSwitchObject:new(220, 138)
  GroundSwitchObject:new(200, 158)

  -- save point
  SavepointObject:new(65, 125,
    "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS2_1",
    "WORLD_EXAMPLE_MOD_WORLD_OBJECT_SAVEPOINT_RUINS2_2"
  )

  local phonecall = Player.getPhoneCalls()[1]
  if phonecall == nil then
    Player.setCellphone(true)
    Player.addPhoneCall("WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_NAME", {
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_1",
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_2",
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_3",
    })
  end

  -- cutscene joke
  local SpriteObject = modRequire("scripts.world.object.obj_sprite") --[[@as WorldExample.Object.Sprite]]
  SpriteObject:new(340, 60, "world/object/bigweb")
  SpriteObject:new(400, 80, "world/object/smallweb")
  SpriteObject:new(340, 100, "world/object/spidertable")
end

--- Initializes the room's tiles
function Ruins1Room:initTiles()
  self:setTileset("ruins1")

  -- outline
  self:setTile(13, 100, 0)
  self:setTile(21, 80, 0)
  self:setTile(21, 60, 0)
  self:setTile(14, 40, 0)
  self:setTile(13, 40, 20)
  self:setTile(14, 20, 20)
  self:setTile(7, 20, 40)
  self:setTile(7, 20, 60)
  self:setTile(7, 20, 80)
  self:setTile(7, 20, 100)
  self:setTile(7, 20, 120)
  self:setTile(7, 20, 140)
  self:setTile(7, 20, 160)
  self:setTile(6, 280, 160)
  self:setTile(6, 280, 140)
  self:setTile(6, 280, 120)
  self:setTile(6, 280, 100)
  self:setTile(6, 280, 80)
  self:setTile(6, 280, 60)
  self:setTile(15, 280, 40)
  self:setTile(12, 260, 40)
  self:setTile(15, 260, 20)
  self:setTile(12, 240, 20)
  self:setTile(15, 240, 0)
  self:setTile(21, 220, 0)
  self:setTile(21, 200, 0)
  self:setTile(21, 180, 0)
  self:setTile(12, 160, 0)

  -- ground
  self:setTile(0, 60, 80)
  self:setTile(0, 80, 80)
  self:setTile(0, 100, 80)
  self:setTile(0, 160, 80)
  self:setTile(0, 180, 80)
  self:setTile(0, 200, 80)
  self:setTile(0, 220, 80)
  self:setTile(0, 60, 100)
  self:setTile(0, 80, 100)
  self:setTile(0, 160, 100)
  self:setTile(0, 180, 100)
  self:setTile(0, 220, 100)
  self:setTile(0, 240, 100)
  self:setTile(0, 60, 120)
  self:setTile(0, 80, 120)
  self:setTile(0, 140, 120)
  self:setTile(0, 160, 120)
  self:setTile(0, 180, 120)
  self:setTile(0, 220, 120)
  self:setTile(0, 240, 120)
  self:setTile(0, 60, 140)
  self:setTile(0, 80, 140)
  self:setTile(0, 140, 140)
  self:setTile(0, 160, 140)
  self:setTile(0, 180, 140)
  self:setTile(0, 220, 140)
  self:setTile(0, 240, 140)
  self:setTile(0, 60, 160)
  self:setTile(0, 80, 160)
  self:setTile(0, 160, 160)
  self:setTile(0, 180, 160)
  self:setTile(0, 220, 160)
  self:setTile(0, 240, 160)
  self:setTile(0, 60, 180)
  self:setTile(0, 80, 180)
  self:setTile(0, 100, 180)
  self:setTile(0, 180, 180)
  self:setTile(0, 220, 180)
  self:setTile(0, 240, 180)
  self:setTile(0, 100, 200)
  self:setTile(0, 120, 200)
  self:setTile(0, 180, 200)
  self:setTile(0, 200, 200)
  self:setTile(0, 220, 200)

  -- ground shadow
  self:setTile(23, 60, 80)
  self:setTile(2, 40, 100)
  self:setTile(2, 40, 120)
  self:setTile(2, 40, 140)
  self:setTile(2, 40, 160)
  self:setTile(2, 40, 180)
  self:setTile(17, 60, 180)
  self:setTile(2, 80, 200)
  self:setTile(17, 100, 200)
  self:setTile(16, 220, 200)
  self:setTile(2, 240, 200)
  self:setTile(16, 240, 180)
  self:setTile(2, 260, 180)
  self:setTile(2, 260, 160)
  self:setTile(2, 260, 140)
  self:setTile(2, 260, 120)
  self:setTile(22, 240, 100)
  self:setTile(22, 220, 80)

  -- ground dark
  self:setTile(28, 40, 180)
  self:setTile(28, 80, 200)
  self:setTile(27, 240, 200)
  self:setTile(27, 260, 180)

  -- path
  self:setTile(1, 120, 80)
  self:setTile(1, 140, 80)
  self:setTile(4, 100, 100)
  self:setTile(1, 120, 100)
  self:setTile(11, 140, 100)
  self:setTile(1, 100, 120)
  self:setTile(1, 120, 120)
  self:setTile(1, 100, 140)
  self:setTile(1, 120, 140)
  self:setTile(10, 100, 160)
  self:setTile(1, 120, 160)
  self:setTile(5, 140, 160)
  self:setTile(10, 120, 180)
  self:setTile(1, 140, 180)
  self:setTile(5, 160, 180)
  self:setTile(1, 140, 200)
  self:setTile(1, 160, 200)
  -- self:setTile(1, 140, 220)
  -- self:setTile(1, 160, 220)
  self:setTile(3, 200, 100)
  self:setTile(8, 200, 120)
  self:setTile(8, 200, 140)
  self:setTile(8, 200, 160)
  self:setTile(9, 200, 180)

  -- walls
  self:setTile(20, 40, 40)
  self:setTile(20, 40, 60)
  self:setTile(26, 40, 80)
  self:setTile(19, 60, 20)
  self:setTile(19, 60, 40)
  self:setTile(25, 60, 60)
  self:setTile(19, 80, 20)
  self:setTile(29, 80, 40)
  self:setTile(25, 80, 60)
  self:setTile(20, 100, 20)
  self:setTile(20, 100, 40)
  self:setTile(26, 100, 60)
  self:setTile(18, 160, 20)
  self:setTile(18, 160, 40)
  self:setTile(24, 160, 60)
  self:setTile(19, 180, 20)
  self:setTile(19, 180, 40)
  self:setTile(25, 180, 60)
  self:setTile(19, 200, 20)
  self:setTile(19, 200, 40)
  self:setTile(25, 200, 60)
  self:setTile(19, 220, 20)
  self:setTile(19, 220, 40)
  self:setTile(25, 220, 60)
  self:setTile(18, 240, 40)
  self:setTile(18, 240, 60)
  self:setTile(24, 240, 80)
  self:setTile(18, 260, 60)
  self:setTile(18, 260, 80)
  self:setTile(24, 260, 100)
end

return Ruins1Room
