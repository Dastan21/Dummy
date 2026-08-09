--[[
  Generated from ..\engine\drawable\drawable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/drawable.lua
]]

---@meta

--- @class Dummy.Drawable : Dummy.Class
---
--- @field protected parent Dummy.Drawable|nil
--- @field protected children Dummy.Drawable[]
--- @field protected children_to_add Dummy.Drawable[]
--- @field protected children_to_remove Dummy.Drawable[]
--- @field protected width number
--- @field protected height number
--- @field protected x number
--- @field protected y number
--- @field protected angle number
--- @field protected scale_x number
--- @field protected scale_y number
--- @field protected origin_x number
--- @field protected origin_y number
--- @field protected color love.Color
--- @field protected layer number
--- @field protected visible boolean
--- @field protected visible_on_screen boolean
--- @field protected sprite love.Image|love.Text
--- @field protected persistent boolean
--- @field protected tag string
--- @field protected removed boolean
Drawable = {}

--- @alias love.Color [ number, number, number ]

--- @class Dummy.Drawable.BoundingBox
---
--- @field x1 number
--- @field y1 number
--- @field x2 number
--- @field y2 number
--- @field x3 number
--- @field y3 number
--- @field x4 number
--- @field y4 number

--- Gets the drawable's width
--- @return number
function Drawable:getWidth() end

--- Gets the drawable's height
--- @return number
function Drawable:getHeight() end

--- Gets the drawable's relative position
--- @return number, number
function Drawable:getPosition() end

--- Sets the drawable's relative position
--- @param x number
--- @param y number
function Drawable:setPosition(x, y) end

--- Gets the drawable's absolute position
--- @return number, number
function Drawable:getAbsolutePosition() end

--- Gets the drawable's angle, in degrees
--- @return number
function Drawable:getAngle() end

--- Sets the drawable's angle, in degrees
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

--- Updates the drawable's transform
function Drawable:updateTransform() end

--- Gets the drawable's absolute transform
--- @return love.Transform
function Drawable:getAbsoluteTransform() end

--- Updates the drawable's absolute transform
function Drawable:updateAbsoluteTransform() end

--- Gets the drawable's bounding box
--- @return Dummy.Drawable.BoundingBox
function Drawable:getBoundingBox() end

--- Gets the drawable's origin
--- @return number, number
function Drawable:getOrigin() end

--- Sets the drawable's origin
--- @overload fun(self: Dummy.Drawable, origin: number)
--- @param origin_x number
--- @param origin_y number
function Drawable:setOrigin(origin_x, origin_y) end

--- Gets the drawable's left position
--- @return number
function Drawable:getLeft() end

--- Gets the drawable's right position
--- @return number
function Drawable:getRight() end

--- Gets the drawable's left position
--- @return number
function Drawable:getTop() end

--- Gets the drawable's right position
--- @return number
function Drawable:getBottom() end

--- Gets the drawable's color
--- @return love.Color
function Drawable:getColor() end

--- Sets the drawable's color
--- @overload fun(self: Dummy.Drawable, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a? number alpha
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

--- Gets the drawable's tag
--- @return string
function Drawable:getTag() end

--- Sets the drawable's tag
--- @param tag string
function Drawable:setTag(tag) end

--- Wether the drawable has been removed
--- @return boolean
function Drawable:isRemoved() end

--- Removes the drawable from the current scene
function Drawable:remove() end

--- Called when the drawable is removed
function Drawable:onRemoved() end

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

--- Updates the drawable, called on every game update
--- @param dt number
function Drawable:update(dt) end

--- Updates the drawable's children
function Drawable:updateChildren(dt) end

--- Draws the drawable
--- @param camera Dummy.Camera
function Drawable:draw(camera) end

--- Draws the drawable's children
--- @param camera Dummy.Camera
function Drawable:drawChildren(camera) end

--- Draws anything for debugging
--- @param camera Dummy.Camera
function Drawable:drawDebug(camera) end

--- Wether the drawable is visible on screen
--- @return boolean
function Drawable:isVisibleOnScreen() end

--- Updates the drawable's visibility on screen
function Drawable:updateVisibleOnScreen() end

--- Creates a drawable
--- @return Dummy.Drawable
function Drawable:new() end

