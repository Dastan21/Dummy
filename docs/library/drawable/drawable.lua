--[[
  Generated from ..\engine\drawable\drawable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/drawable.lua
]]

---@meta

--- @class Dummy.Drawable : Dummy.Class
---
--- @field protected x number
--- @field protected y number
--- @field protected angle number
--- @field protected scale_x number
--- @field protected scale_y number
--- @field protected origin_x number
--- @field protected origin_y number
--- @field protected color love.Color
--- @field protected alpha number
--- @field protected layer number
--- @field protected visible boolean
--- @field protected sprite love.Image|love.Text
--- @field protected persistent boolean
Drawable = {}

--- @alias love.Color { [1]: number, [2]: number, [3]: number }

--- Gets the class name
--- @return string
function Drawable:getClass() end

--- Gets the drawable position
--- @return number, number
function Drawable:getPosition() end

--- Sets drawable position
--- @param x number
--- @param y number
function Drawable:setPosition(x, y) end

--- Gets the drawable width
--- @return number
function Drawable:getWidth() end

--- Gets the drawable height
--- @return number
function Drawable:getHeight() end

--- Gets the drawable angle, in degree
--- @return number
function Drawable:getAngle() end

--- Sets drawable angle, in degree
--- @param angle number
function Drawable:setAngle(angle) end

--- Gets the drawable scale
--- @return number, number
function Drawable:getScale() end

--- Sets drawable scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Drawable:setScale(scale_x, scale_y) end

--- Gets the drawable origin
--- @return number, number
function Drawable:getOrigin() end

--- Sets drawable origin
--- @overload fun(self: Dummy.Drawable, origin: number)
--- @param origin_x number
--- @param origin_y number
function Drawable:setOrigin(origin_x, origin_y) end

--- Gets the drawable color
--- @return love.Color
function Drawable:getColor() end

--- Sets the drawable color
--- @overload fun(self: Dummy.Drawable, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Drawable:setColor(r, g, b, a) end

--- Gets the drawable alpha
--- @return number
function Drawable:getAlpha() end

--- Sets drawable alpha
--- @param alpha number
function Drawable:setAlpha(alpha) end

--- Gets the drawable layer
--- @return number
function Drawable:getLayer() end

--- Sets drawable layer
--- @param layer number
function Drawable:setLayer(layer) end

--- Wether the drawable is visible
--- @return boolean
function Drawable:isVisible() end

--- Sets wether the drawable is visible
--- @param visible boolean
function Drawable:setVisible(visible) end

--- Gets the drawable sprite
--- @return love.Image|love.Text
function Drawable:getSprite() end

--- Draws the drawable
function Drawable:draw() end

--- Wether the drawable is persistent between scenes
--- @return boolean
function Drawable:isPersistent() end

--- Sets wether the drawable is persistent between scenes
--- @param persistent boolean
function Drawable:setPersistent(persistent) end

--- Destroys the drawable
function Drawable:remove() end

--- Creates a drawable
--- @return Dummy.Drawable
function Drawable:new() end

