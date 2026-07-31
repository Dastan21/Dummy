--- @class Dummy.DebugCamera : Dummy.GameCamera
local DebugCamera = Class(GameCamera, "Dummy.DebugCamera")

--- Creates a debug camera
--- @return Dummy.DebugCamera
function DebugCamera:new()
  self = Class:new(DebugCamera, { Constants.GAME_WIDTH, Constants.GAME_HEIGHT, "DEBUG" })

  self:setLayer(Constants.LAYERS.DEBUG)
  self:setPersistent(true)

  return self
end

return DebugCamera
