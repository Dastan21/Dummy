--[[
  Generated from ..\engine\camera\camera.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/camera/camera.lua
]]

---@meta

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
Camera = {}

--- Creates a camera
--- @param width number
--- @param height number
--- @param tag string
--- @return Dummy.Camera
function Camera:new(width, height, tag) end

--- Gets the camera's width and height
--- @return number, number
function Camera:getDimensions() end

--- Sets the camera's width
--- @param width number
function Camera:setDimensions(width, height) end

--- Gets the camera's position
--- @return number, number
function Camera:getPosition() end

--- Sets the camera's position
--- @param x number
--- @param y number
function Camera:setPosition(x, y) end

--- Gets the camera's angle, in degrees
--- @return number
function Camera:getAngle() end

--- Sets the camera's angle, in degrees
--- @param angle number
function Camera:setAngle(angle) end

--- Gets the camera's scale
--- @return number, number
function Camera:getScale() end

--- Sets the camera's scale
--- @overload fun(self: Dummy.Camera, scale: number)
--- @param scale_x number
--- @param scale_y? number
function Camera:setScale(scale_x, scale_y) end

--- Gets the camera's origin
--- @return number, number
function Camera:getOrigin() end

--- Sets the camera's origin
--- @overload fun(self: Dummy.Camera, origin: number)
--- @param origin_x number
--- @param origin_y? number
function Camera:setOrigin(origin_x, origin_y) end

--- Gets the camera's zoom
--- @return number
function Camera:getZoom() end

--- Zooms the camera
--- @param zoom number
function Camera:setZoom(zoom) end

--- Gets the camera's transform
--- @return love.Transform
function Camera:getTransform() end

--- Updates the camera's transform
function Camera:updateTransform() end

--- Gets the camera's viewport position
--- @return number, number
function Camera:getViewportPosition() end

--- Sets the camera's viewport position
--- @param x number
--- @param y number
function Camera:setViewportPosition(x, y) end

--- Gets the camera's viewport angle, in degrees
--- @return number
function Camera:getViewportAngle() end

--- Sets the camera's viewport angle, in degrees
--- @param angle number
function Camera:setViewportAngle(angle) end

--- Gets the camera's viewport scale
--- @return number, number
function Camera:getViewportScale() end

--- Sets the camera's viewport scale
--- @overload fun(self: Dummy.Camera, scale: number)
--- @param scale_x number
--- @param scale_y? number
function Camera:setViewportScale(scale_x, scale_y) end

--- Gets the drawable's viewport origin
--- @return number, number
function Camera:getViewportOrigin() end

--- Sets the drawable's viewport origin
--- @overload fun(self: Dummy.Camera, origin: number)
--- @param origin_x number
--- @param origin_y number
function Camera:setViewportOrigin(origin_x, origin_y) end

--- Gets the camera's layer
--- @return number
function Camera:getLayer() end

--- Sets the camera's layer
--- @param layer number
function Camera:setLayer(layer) end

--- Wether the camera is persistent
--- @return boolean
function Camera:isPersistent() end

--- Sets wether the camera is persistent
--- @param persistent boolean
function Camera:setPersistent(persistent) end

--- Gets the camera's tag
--- @return string
function Camera:getTag() end

--- Gets the camera's canvas
--- @return [ love.Canvas, love.Canvas ]
function Camera:getCanvas() end

--- Sets wether the camera is active
--- @param active boolean
function Camera:setActive(active) end

--- Wether the camera is active
--- @return boolean
function Camera:isActive() end

--- Gets the camera's ratio
--- @return number
function Camera:getRatio() end

--- Updates the camera's canvas
--- @protected
function Camera:updateCanvas() end

--- Applies the camera transformations before drawing the drawables
function Camera:apply() end

--- Applies the camera transformations before drawing the canvas
function Camera:applyCanvas() end

--- Draws the camera's bounding box for debugging
function Camera:drawDebug() end

--- Updates the camera, called on every frame
--- @param dt number
function Camera:update(dt) end

