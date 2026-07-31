--- @class Dummy.Camera : Dummy.Class
---
--- @field protected init_width number
--- @field protected init_height number
--- @field protected width number
--- @field protected height number
--- @field protected x number
--- @field protected y number
--- @field protected angle number
--- @field protected scale_x number
--- @field protected scale_y number
--- @field protected origin_x number
--- @field protected origin_y number
--- @field protected zoom number
--- @field protected transform love.Transform
--- @field protected viewport_x number
--- @field protected viewport_y number
--- @field protected viewport_angle number
--- @field protected viewport_scale_x number
--- @field protected viewport_scale_y number
--- @field protected viewport_origin_x number
--- @field protected viewport_origin_y number
--- @field protected tag string
--- @field protected layer number
--- @field protected persistent boolean
--- @field protected active boolean
--- @field protected canvas [ love.Canvas, love.Canvas ]
local Camera = Class("Dummy.Camera")

--- Creates a camera
--- @param width number
--- @param height number
--- @param tag string
--- @return Dummy.Camera
function Camera:new(width, height, tag)
  self = Class:new(Camera)

  self.init_width = width
  self.init_height = height
  self.width = width
  self.height = height
  self.tag = tag

  self.x = 0
  self.y = 0
  self.angle = 0
  self.scale_x = 1
  self.scale_y = 1
  self.origin_x = 0
  self.origin_y = 0
  self.zoom = 1

  self.viewport_x = width / 2
  self.viewport_y = height / 2
  self.viewport_angle = 0
  self.viewport_scale_x = 1
  self.viewport_scale_y = 1
  self.viewport_origin_x = 0.5
  self.viewport_origin_y = 0.5

  self.layer = 0
  self.persistent = false
  self.active = true
  self.transform = love.math.newTransform(self.x, self.y, self.angle, self.scale_x, self.scale_y)

  self:updateCanvas()

  Scene.addCamera(self)

  return self
end

--- Gets the camera's width and height
--- @return number, number
function Camera:getDimensions()
  return self.width, self.height
end

--- Sets the camera's width
--- @param width number
function Camera:setDimensions(width, height)
  if self.width == width and self.height == height then return end

  self.width = width
  self.height = height

  self:updateCanvas()
end

--- Gets the camera's position
--- @return number, number
function Camera:getPosition()
  return self.x, self.y
end

--- Sets the camera's position
--- @param x number
--- @param y number
function Camera:setPosition(x, y)
  if self.x == x and self.y == y then return end

  self.x = x
  self.y = y

  self:updateTransform()
end

--- Gets the camera's angle, in degrees
--- @return number
function Camera:getAngle()
  return math.deg(self.angle)
end

--- Sets the camera's angle, in degrees
--- @param angle number
function Camera:setAngle(angle)
  if self.angle == angle then return end

  self.angle = math.rad(angle)

  self:updateTransform()
end

--- Gets the camera's scale
--- @return number, number
function Camera:getScale()
  return self.scale_x, self.scale_y
end

--- Sets the camera's scale
--- @overload fun(self: Dummy.Camera, scale: number)
--- @param scale_x number
--- @param scale_y? number
function Camera:setScale(scale_x, scale_y)
  scale_y = Utils.getOrDefault(scale_y, scale_x)
  if self.scale_x == scale_x and self.scale_y == scale_y then return end

  self.scale_x = scale_x
  self.scale_y = scale_y

  self:updateTransform()
end

--- Gets the camera's origin
--- @return number, number
function Camera:getOrigin()
  return self.origin_x, self.origin_y
end

--- Sets the camera's origin
--- @overload fun(self: Dummy.Camera, origin: number)
--- @param origin_x number
--- @param origin_y? number
function Camera:setOrigin(origin_x, origin_y)
  origin_y = Utils.getOrDefault(origin_y, origin_x)
  if self.origin_x == origin_x and self.origin_y == origin_y then return end

  self.origin_x = origin_x
  self.origin_y = origin_y
end

--- Gets the camera's zoom
--- @return number
function Camera:getZoom()
  return self.zoom
end

--- Zooms the camera
--- @param zoom number
function Camera:setZoom(zoom)
  if zoom == 0 then zoom = 1 end
  if self.zoom == zoom then return end

  self.zoom = zoom

  local scale = 1 / zoom
  self:setDimensions(self.init_width * scale, self.init_height * scale)
end

--- Gets the camera's transform
--- @return love.Transform
function Camera:getTransform()
  return self.transform
end

--- Updates the camera's transform
function Camera:updateTransform()
  self.transform:setTransformation(self.x, self.y, self.angle, self.scale_x, self.scale_y)
end

--- Gets the camera's viewport position
--- @return number, number
function Camera:getViewportPosition()
  return self.viewport_x, self.viewport_y
end

--- Sets the camera's viewport position
--- @param x number
--- @param y number
function Camera:setViewportPosition(x, y)
  if self.viewport_x == x and self.viewport_y == y then return end

  self.viewport_x = x
  self.viewport_y = y
end

--- Gets the camera's viewport angle, in degrees
--- @return number
function Camera:getViewportAngle()
  return self.viewport_angle
end

--- Sets the camera's viewport angle, in degrees
--- @param angle number
function Camera:setViewportAngle(angle)
  if self.viewport_angle == angle then return end

  self.viewport_angle = math.rad(angle)
end

--- Gets the camera's viewport scale
--- @return number, number
function Camera:getViewportScale()
  return self.viewport_scale_x, self.viewport_scale_y
end

--- Sets the camera's viewport scale
--- @overload fun(self: Dummy.Camera, scale: number)
--- @param scale_x number
--- @param scale_y? number
function Camera:setViewportScale(scale_x, scale_y)
  scale_y = Utils.getOrDefault(scale_y, scale_x)
  if self.viewport_scale_x == scale_x and self.viewport_scale_y == scale_y then return end

  self.viewport_scale_x = scale_x
  self.viewport_scale_y = scale_y
end

--- Gets the drawable's viewport origin
--- @return number, number
function Camera:getViewportOrigin()
  return self.viewport_origin_x, self.viewport_origin_y
end

--- Sets the drawable's viewport origin
--- @overload fun(self: Dummy.Camera, origin: number)
--- @param origin_x number
--- @param origin_y number
function Camera:setViewportOrigin(origin_x, origin_y)
  self.viewport_origin_x = origin_x
  self.viewport_origin_y = Utils.getOrDefault(origin_y, origin_x)
end

--- Gets the camera's layer
--- @return number
function Camera:getLayer()
  return self.layer
end

--- Sets the camera's layer
--- @param layer number
function Camera:setLayer(layer)
  if self.layer == layer then return end

  self.layer = layer

  Scene.removeCamera(self)
  Scene.addCamera(self)
end

--- Wether the camera is persistent
--- @return boolean
function Camera:isPersistent()
  return self.persistent
end

--- Sets wether the camera is persistent
--- @param persistent boolean
function Camera:setPersistent(persistent)
  self.persistent = persistent
end

--- Gets the camera's tag
--- @return string
function Camera:getTag()
  return self.tag
end

--- Gets the camera's canvas
--- @return [ love.Canvas, love.Canvas ]
function Camera:getCanvas()
  return self.canvas
end

--- Sets wether the camera is active
--- @param active boolean
function Camera:setActive(active)
  self.active = active
end

--- Wether the camera is active
--- @return boolean
function Camera:isActive()
  return self.active
end

--- Gets the camera's ratio
--- @return number
function Camera:getRatio()
  local width, height = self:getDimensions()
  return math.min(Constants.WINDOW_WIDTH / width, Constants.WINDOW_HEIGHT / height)
end

--- Updates the camera's canvas
--- @protected
function Camera:updateCanvas()
  self.canvas = {
    love.graphics.newCanvas(math.ceil(self.width), math.ceil(self.height)),
    love.graphics.newCanvas(math.ceil(self.width), math.ceil(self.height))
  }
end

--- Applies the camera transformations before drawing the drawables
function Camera:apply()
  love.graphics.origin()

  local width, height = self:getDimensions()
  local viewport_origin_x, viewport_origin_y = self:getViewportOrigin()
  local viewport_angle = self:getViewportAngle()
  local viewport_scale_x, viewport_scale_y = self:getViewportScale()
  local viewport_x, viewport_y = self:getViewportPosition()

  love.graphics.translate(math.round(width * viewport_origin_x), math.round(height * viewport_origin_y))
  love.graphics.rotate(viewport_angle)
  love.graphics.scale(1 / viewport_scale_x, 1 / viewport_scale_y)
  love.graphics.translate(math.round(-viewport_x), math.round(-viewport_y))

  Shaker.draw()
end

--- Applies the camera transformations before drawing the canvas
function Camera:applyCanvas()
  love.graphics.origin()

  local x, y = self:getPosition()
  local angle = self:getAngle()
  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getDimensions()
  local ratio = self:getRatio()
  x = math.round(x - width * origin_x * ratio)
  y = math.round(y - height * origin_y * ratio)

  love.graphics.translate(x, y)
  love.graphics.rotate(angle)
  love.graphics.scale(ratio, ratio)
end

--- Draws the camera's bounding box for debugging
function Camera:drawDebug()
  if not Debug.shouldDisplayHitbox() or not self:isActive() then return end

  love.graphics.setColor(1, 1, 0)
  local width, height = self:getDimensions()
  local origin_x, origin_y = self:getOrigin()
  local ratio = self:getRatio()
  width = width * ratio
  height = height * ratio
  local x, y = self:getTransform():transformPoint(-width * origin_x, -height * origin_y)
  love.graphics.rectangle("line", x - 0.5, y - 0.5, width + 1, height + 1)
end

--- Updates the camera, called on every frame
--- @param dt number
function Camera:update(dt) end

return Camera
