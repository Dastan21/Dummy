--- @class Dummy.GameCamera : Dummy.Camera
local GameCamera = Class(Camera, "Dummy.GameCamera")

--- Creates a game camera
--- @param width? number
--- @param height? number
--- @param tag? string
--- @return Dummy.GameCamera
function GameCamera:new(width, height, tag)
  width = Utils.getOrDefault(width, Constants.GAME_WIDTH)
  height = Utils.getOrDefault(height, Constants.GAME_HEIGHT)
  tag = Utils.getOrDefault(tag, "GAME")

  self = Class:new(GameCamera, { width, height, tag })

  Signal.on("window_resize", function()
    self:centerCamera()
  end)
  self:centerCamera()

  return self
end

--- Centers the game camera
function GameCamera:centerCamera()
  local width, height = self:getDimensions()
  local viewport_origin_x, viewport_origin_y = self:getViewportOrigin()
  self:setViewportPosition(width * viewport_origin_x, height * viewport_origin_y)

  local ratio = self:getRatio()
  local offset_x = (Constants.WINDOW_WIDTH - width * ratio) / 2
  local offset_y = (Constants.WINDOW_HEIGHT - height * ratio) / 2
  self:setPosition(offset_x, offset_y)
end

return GameCamera
