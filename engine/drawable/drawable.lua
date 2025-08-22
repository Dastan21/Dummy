--- @alias love.Color [ number, number, number ]

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
--- @field protected removed boolean
local Drawable = Class()

--- Gets the class's name
--- @return string
function Drawable.getClassName()
  return "Dummy.Drawable"
end

--- Gets the drawable's absolute position
--- @return number, number
function Drawable:getAbsolutePosition()
  return self:getAbsoluteTransform():apply(self:getTransform():inverse()):transformPoint(self.x, self.y)
end

--- Gets the drawable's relative position
--- @return number, number
function Drawable:getPosition()
  return self.x, self.y
end

--- Sets the drawable's relative position
--- @param x number
--- @param y number
function Drawable:setPosition(x, y)
  self.x = x
  self.y = y
end

--- Gets the drawable's angle, in degrees
--- @return number
function Drawable:getAngle()
  return math.deg(self.angle)
end

--- Sets the drawable's angle, in degrees
--- @param angle number
function Drawable:setAngle(angle)
  self.angle = math.rad(angle)
end

--- Gets the drawable's scale
--- @return number, number
function Drawable:getScale()
  return self.scale_x, self.scale_y
end

--- Sets the drawable's scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Drawable:setScale(scale_x, scale_y)
  self.scale_x = scale_x
  self.scale_y = Utils.getOrDefault(scale_y, scale_x)
end

--- Gets the drawable's transform
--- @return love.Transform
function Drawable:getTransform()
  return love.math.newTransform(self.x, self.y, self.angle, self.scale_x, self.scale_y)
end

--- Gets the drawable's absolute transform
--- @return love.Transform
function Drawable:getAbsoluteTransform()
  local parent = self:getParent()
  if parent == nil then return self:getTransform() end

  return parent:getAbsoluteTransform():apply(self:getTransform())
end

--- Gets the drawable's origin
--- @return number, number
function Drawable:getOrigin()
  return self.origin_x, self.origin_y
end

--- Sets the drawable's origin
--- @overload fun(self: Dummy.Drawable, origin: number)
--- @param origin_x number
--- @param origin_y number
function Drawable:setOrigin(origin_x, origin_y)
  self.origin_x = origin_x
  self.origin_y = Utils.getOrDefault(origin_y, origin_x)
end

--- Gets the drawable's color
--- @return love.Color
function Drawable:getColor()
  return self.color
end

--- Sets the drawable's color
--- @overload fun(self: Dummy.Drawable, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Drawable:setColor(r, g, b, a)
  if type(r) == "table" then
    a = r[4]
    b = r[3]
    g = r[2]
    r = r[1]
  end

  self.color = {
    math.clamp(r, 0, 1),
    math.clamp(g, 0, 1),
    math.clamp(b, 0, 1)
  }

  if a ~= nil then
    self:setAlpha(a)
  end
end

--- Gets the drawable's alpha
--- @return number
function Drawable:getAlpha()
  return self.alpha
end

--- Sets the drawable's alpha
--- @param alpha number
function Drawable:setAlpha(alpha)
  self.alpha = math.clamp(alpha, 0, 1)
end

--- Gets the drawable's layer
--- @return number
function Drawable:getLayer()
  return self.layer
end

--- Sets the drawable's layer
--- @param layer number
function Drawable:setLayer(layer)
  self.layer = layer

  Scene.removeDrawable(self)
  Scene.addDrawable(self)
end

--- Wether the drawable is visible
--- @return boolean
function Drawable:isVisible()
  return self.visible and not self.removed
end

--- Sets wether the drawable is visible
--- @param visible boolean
function Drawable:setVisible(visible)
  self.visible = visible
end

--- Gets the drawable's sprite
--- @return love.Image|love.Text
function Drawable:getSprite()
  return self.sprite
end

--- Wether the drawable is persistent between scenes
--- @return boolean
function Drawable:isPersistent()
  return self.persistent
end

--- Sets wether the drawable is persistent between scenes
--- @param persistent boolean
function Drawable:setPersistent(persistent)
  self.persistent = persistent
end

--- Wether the drawable has been removed
--- @return boolean
function Drawable:isRemoved()
  return self.removed
end

--- Removes the drawable from the current scene
function Drawable:remove()
  if self.removed then return end
  self.removed = true

  if #self.children > 0 then
    for _, child in ipairs(self.children) do
      child:remove()
    end
  end

  Scene.removeDrawable(self)

  if self.parent ~= nil then
    self.parent:removeChild(self)
  end

  if self.onRemoved ~= nil then
    self:onRemoved()
  end
end

--- Called when the drawable is removed
function Drawable:onRemoved() end

--- Gets the drawable's parent
--- @return Dummy.Drawable|nil
function Drawable:getParent()
  return self.parent
end

--- Sets the drawable's parent
--- @param parent Dummy.Drawable|nil
function Drawable:setParent(parent)
  if self.parent == parent then return end

  if parent ~= nil then
    parent:removeChild(self)
    parent:addChild(self)
  else
    self.parent:removeChild(self)
  end
end

--- Wether the drawable has children
--- @return boolean
function Drawable:hasChildren()
  return #self.children > 0
end

--- Gets the drawable's children
--- @return Dummy.Drawable[]
function Drawable:getChildren()
  return self.children
end

--- Adds a child to the drawable
--- @param child Dummy.Drawable
function Drawable:addChild(child)
  if child == self then return end

  if child == self.parent then
    self.parent = nil
  else
    child.parent = self
  end

  table.insert(self.children, child)

  self:sortChildren()
end

--- Removes a child from the drawable
--- @param child Dummy.Drawable
function Drawable:removeChild(child)
  table.removeByValue(self.children, child)
  child.parent = nil

  self:sortChildren()
end

--- Sorts drawable's children by layer
function Drawable:sortChildren()
  if #self.children <= 0 then return end

  table.stable_sort(self.children, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Updates the drawable, called on every game update
--- @param dt number
function Drawable:update(dt)
  self:updateChildren(dt)
end

--- Updates the drawable's children
function Drawable:updateChildren(dt)
  if #self.children <= 0 then return end

  local children = { table.unpack(self.children) }
  for _, child in ipairs(children) do
    if type(child.update) == "function" then
      child:update(dt)
    end
  end
end

--- Draws the drawable
function Drawable:draw()
  love.graphics.applyTransform(self:getTransform())
  self:drawChildren()
end

--- Draws the drawable's children
function Drawable:drawChildren()
  if #self.children <= 0 then return end

  local children = { table.unpack(self.children) }
  for _, child in ipairs(children) do
    if type(child.draw) == "function" then
      love.graphics.push()
      child:draw()
      love.graphics.pop()
    end
  end
end

--- Creates a drawable
--- @return Dummy.Drawable
function Drawable:new()
  self = Class:new(Drawable)
  self.parent = nil
  self.children = {}
  self.x = 0
  self.y = 0
  self.angle = 0
  self.scale_x = 1
  self.scale_y = 1
  self.origin_x = 0.5
  self.origin_y = 0.5
  self.color = { 1, 1, 1 }
  self.alpha = 1
  self.layer = Constants.LAYERS.UI
  self.visible = true
  self.persistent = false
  self.sprite = nil
  self.removed = false

  Scene.addDrawable(self)

  return self
end

return Drawable
