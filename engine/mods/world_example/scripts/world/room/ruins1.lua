--- @class WorldExample.Room.Ruins1 : Dummy.Room
local Ruins1Room = Class(Room, "WorldExample.Room.Ruins1")

--- Creates the dummy room
--- @return WorldExample.Room.Ruins1
function Ruins1Room:new()
  self = Class:new(Ruins1Room, { "ruins1", "WORLD_EXAMPLE_MOD_WORLD_RUINS1_NAME", 320, 240 })

  -- load data saved from the editor
  self:loadData("ruins1")

  return self
end

--- Called when the room is entered
function Ruins1Room:onEnter()
  local phonecall = Player.getPhoneCalls()[1]
  if phonecall == nil then
    Player.setCellphone(true)
    Player.addPhoneCall("WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_NAME", {
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_1",
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_2",
      "WORLD_EXAMPLE_MOD_PLAYER_PHONECALL_TORIEL_CALL_3",
    })
  end
end

return Ruins1Room
