--- @class WorldExample.Room.Man : Dummy.Room
local ManRoom = Class(Room, "WorldExample.Room.Man")

--- Creates the man room
--- @return WorldExample.Room.Man
function ManRoom:new()
  self = Class:new(ManRoom, { "man", "???", 320, 240 })

  -- load data saved from the editor
  self:loadData("man")

  return self
end

--- Called when the room is entered
---
--- Note: Initialize all he room's objects here
function ManRoom:onEnter()
  WorldExampleMod.flag["man"] = 1
end

return ManRoom
