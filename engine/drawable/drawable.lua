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
local Drawable = Class()

--- Gets the class's name
--- @return string
function Drawable.getClassName()
  return "Dummy.Drawable"
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

--- Gets the drawable's angle, in degree
--- @return number
function Drawable:getAngle()
  return math.deg(self.angle)
end

--- Sets the drawable's angle, in degree
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
    self.color = r
  else
    self.color = {
      math.clamp(r, 0, 1),
      math.clamp(g, 0, 1),
      math.clamp(b, 0, 1)
    }
  end

  if a ~= nil then
    self.alpha = math.clamp(a, 0, 1)
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
  return self.visible
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

--- Removes the drawable from the current scene
function Drawable:remove()
  if self.parent ~= nil then
    self.parent:removeChild(self)
  end
  Scene.removeDrawable(self)
end

--- Gets the drawable's parent
--- @return Dummy.Drawable|nil
function Drawable:getParent()
  return self.parent
end

--- Sets the drawable's parent
--- @param parent Dummy.Drawable|nil
function Drawable:setParent(parent)
  if self.parent ~= parent then
    self.parent = parent

    if parent ~= nil then
      self:removeChild(parent)
      parent:addChild(self)
    end
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
  for i, c in ipairs(self.children) do
    if c == child then
      table.remove(self.children, i)
      break
    end
  end

  self:sortChildren()
end

--- Sorts drawable's children by layer
function Drawable:sortChildren()
  if #self.children <= 0 then return end

  table.stable_sort(self.children, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Updates the drawable
--- @param dt number
function Drawable:update(dt) end

--- Draws the drawable
function Drawable:draw()
  self:drawChildren()
end

--- Draws the drawable's children
function Drawable:drawChildren()
  if #self.children <= 0 then return end

  for _, child in ipairs(self.children) do
    love.graphics.push()
    child:draw()
    love.graphics.pop()
  end
end

--- Creates a drawable
--- @return Dummy.Drawable
function Drawable:new()
  local drawable = Class:new(Drawable)

  drawable.parent = nil
  drawable.children = {}
  drawable.x = 0
  drawable.y = 0
  drawable.angle = 0
  drawable.scale_x = 1
  drawable.scale_y = 1
  drawable.origin_x = 0.5
  drawable.origin_y = 0.5
  drawable.color = { 1, 1, 1 }
  drawable.alpha = 1
  drawable.layer = Constants.LAYERS.UI
  drawable.visible = true
  drawable.persistent = false
  drawable.sprite = nil

  Scene.addDrawable(drawable)

  return drawable
end

return Drawable
