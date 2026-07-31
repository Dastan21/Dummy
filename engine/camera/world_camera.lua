--- @class Dummy.WorldCamera : Dummy.GameCamera
---
--- @field protected attached boolean
--- @field protected target Dummy.Object|nil
local WorldCamera = Class(GameCamera, "Dummy.WorldCamera")

--- Creates a world camera
--- @return Dummy.WorldCamera
function WorldCamera:new()
  self = Class:new(WorldCamera, { Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT })

  self.attached = true

  return self
end

--- Wether the camera is attached
--- @return boolean
function WorldCamera:isAttached()
  return self.attached
end

--- Sets wether the camera is attached
--- @param attached boolean
function WorldCamera:setAttached(attached)
  self.attached = attached
end

--- Gets the world camera's target
--- @return Dummy.Object|nil
function WorldCamera:getTarget()
  return self.target
end

--- Sets the world camera's target
--- @param target Dummy.Object|nil
function WorldCamera:setTarget(target)
  self.target = target
end

--- Sets the world camera's viewport position
--- @param x number
--- @param y number
function WorldCamera:setViewportPosition(x, y)
  local current_room = World.getCurrentRoom()
  if current_room == nil then return end

  local width, height = self:getDimensions()
  local room_width, room_height = current_room:getWidth(), current_room:getHeight()
  if self:isAttached() then
    x = math.clamp(x, width / 2, room_width - width / 2)
    y = math.clamp(y, height / 2, room_height - height / 2)
  end

  if self.viewport_x == x and self.viewport_y == y then return end

  GameCamera.setViewportPosition(self, x, y)
end

--- Applies the camera transformations before drawing the drawables
function WorldCamera:apply()
  love.graphics.origin()

  local width, height = self:getDimensions()
  local viewport_origin_x, viewport_origin_y = self:getViewportOrigin()
  local viewport_angle = self:getViewportAngle()
  local viewport_scale_x, viewport_scale_y = self:getViewportScale()

  love.graphics.translate(math.round(width * viewport_origin_x), math.round(height * viewport_origin_y))
  love.graphics.rotate(viewport_angle)
  love.graphics.scale(1 / viewport_scale_x, 1 / viewport_scale_y)

  -- clamp the viewport to the room
  local current_room = World.getCurrentRoom()
  if current_room == nil then return end

  local room_width, room_height = current_room:getWidth(), current_room:getHeight()
  local viewport_x, viewport_y = self:getViewportPosition()
  local offset_x, offset_y = Shaker.getOffset()
  if self:isAttached() then
    viewport_x = math.clamp(viewport_x + offset_x, width / 2, room_width - width / 2)
    viewport_y = math.clamp(viewport_y + offset_y, height / 2, room_height - height / 2)
  end
  love.graphics.translate(math.round(-viewport_x), math.round(-viewport_y))
end

--- Updates the world camera, called on every game update
--- @param dt number
function WorldCamera:update(dt)
  GameCamera.update(self, dt)

  if not self:isAttached() then return end

  local current_room = World.getCurrentRoom()
  if current_room == nil then return end

  local target = self:getTarget()
  if target == nil then return end

  local target_x, target_y = target:getPosition()
  self:setViewportPosition(math.round(target_x), math.round(target_y))
end

return WorldCamera
