--[[
  Generated from ..\engine\drawable\drawable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/drawable.lua
]]

---@meta

--- @class Dummy.Drawable : Dummy.Class
---
--- @field protected parent Dummy.Drawable|nil
--- @field protected children Dummy.Drawable[]
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

--- @alias love.Color [ number, number, number ]

--- Gets the class's name
--- @return string
function Drawable.getClassName() end

--- Gets the drawable's relative position
--- @return number, number
function Drawable:getPosition() end

--- Sets the drawable's relative position
--- @param x number
--- @param y number
function Drawable:setPosition(x, y) end

--- Gets the drawable's angle, in degree
--- @return number
function Drawable:getAngle() end

--- Sets the drawable's angle, in degree
--- @param angle number
function Drawable:setAngle(angle) end

--- Gets the drawable's scale
--- @return number, number
function Drawable:getScale() end

--- Sets the drawable's scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Drawable:setScale(scale_x, scale_y) end

--- Gets the drawable's transform
--- @return love.Transform
function Drawable:getTransform() end

--- Gets the drawable's origin
--- @return number, number
function Drawable:getOrigin() end

--- Sets the drawable's origin
--- @overload fun(self: Dummy.Drawable, origin: number)
--- @param origin_x number
--- @param origin_y number
function Drawable:setOrigin(origin_x, origin_y) end

--- Gets the drawable's color
--- @return love.Color
function Drawable:getColor() end

--- Sets the drawable's color
--- @overload fun(self: Dummy.Drawable, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Drawable:setColor(r, g, b, a) end

--- Gets the drawable's alpha
--- @return number
function Drawable:getAlpha() end

--- Sets the drawable's alpha
--- @param alpha number
function Drawable:setAlpha(alpha) end

--- Gets the drawable's layer
--- @return number
function Drawable:getLayer() end

--- Sets the drawable's layer
--- @param layer number
function Drawable:setLayer(layer) end

--- Wether the drawable is visible
--- @return boolean
function Drawable:isVisible() end

--- Sets wether the drawable is visible
--- @param visible boolean
function Drawable:setVisible(visible) end

--- Gets the drawable's sprite
--- @return love.Image|love.Text
function Drawable:getSprite() end

--- Wether the drawable is persistent between scenes
--- @return boolean
function Drawable:isPersistent() end

--- Sets wether the drawable is persistent between scenes
--- @param persistent boolean
function Drawable:setPersistent(persistent) end

--- Removes the drawable from the current scene
function Drawable:remove() end

--- Gets the drawable's parent
--- @return Dummy.Drawable|nil
function Drawable:getParent() end

--- Sets the drawable's parent
--- @param parent Dummy.Drawable|nil
function Drawable:setParent(parent) end

--- Wether the drawable has children
--- @return boolean
function Drawable:hasChildren() end

--- Gets the drawable's children
--- @return Dummy.Drawable[]
function Drawable:getChildren() end

--- Adds a child to the drawable
--- @param child Dummy.Drawable
function Drawable:addChild(child) end

--- Removes a child from the drawable
--- @param child Dummy.Drawable
function Drawable:removeChild(child) end

--- Sorts drawable's children by layer
function Drawable:sortChildren() end

--- Draws the drawable
function Drawable:draw() end

--- Draws the drawable's children
function Drawable:drawChildren() end

--- Creates a drawable
--- @return Dummy.Drawable
function Drawable:new() end

