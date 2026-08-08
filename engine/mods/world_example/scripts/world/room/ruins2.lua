--- @class WorldExample.Room.Ruins2 : Dummy.Room
local Ruins2Room = Class(Room, "WorldExample.Room.Ruins2")

--- Creates the dummy room
--- @return WorldExample.Room.Ruins2
function Ruins2Room:new()
  self = Class:new(Ruins2Room, { "ruins2", "", 740, 240 })

  -- load data saved from the editor
  self:loadData("ruins2")

  return self
end

return Ruins2Room
