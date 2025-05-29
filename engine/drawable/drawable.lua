--- @class Dummy.Drawable : Dummy.Class
---
--- @field protected x number
--- @field protected y number
--- @field protected rotation number
--- @field protected scale_x number
--- @field protected scale_y number
--- @field protected origin_x number
--- @field protected origin_y number
--- @field protected alpha number
--- @field protected layer number
--- @field protected visible boolean
--- @field protected sprite love.Image|love.Text
--- @field protected draw fun()|nil
--- @field protected persistent boolean
local Drawable = Class:extend()

--- Gets the drawable position
--- @return number, number
function Drawable:getPosition()
  return self.x, self.y
end

--- Sets drawable position
--- @param x number
--- @param y number
function Drawable:setPosition(x, y)
  self.x = x
  self.y = y
end

--- Gets the drawable width
---@return number
function Drawable:getWidth()
  if self.sprite == nil then return 0 end
  return self.sprite:getWidth()
end

--- Gets the drawable height
---@return number
function Drawable:getHeight()
  if self.sprite == nil then return 0 end
  return self.sprite:getHeight()
end

--- Gets the drawable rotation
--- @return number
function Drawable:getRotation()
  return self.rotation
end

--- Sets drawable rotation
--- @param rotation number
function Drawable:setRotation(rotation)
  self.rotation = rotation
end

--- Gets the drawable scale
--- @return number, number
function Drawable:getScale()
  return self.scale_x, self.scale_y
end

--- Sets drawable scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Drawable:setScale(scale_x, scale_y)
  if type(scale_x) == "number" and scale_y == nil then
    self.scale_x = scale_x
    self.scale_y = scale_x
  else
    self.scale_x = scale_x
    self.scale_y = scale_y
  end
end

--- Gets the drawable origin
--- @return number, number
function Drawable:getOrigin()
  return self.origin_x, self.origin_y
end

--- Sets drawable origin
--- @overload fun(self: Dummy.Drawable, origin: number)
--- @param origin_x number
--- @param origin_y number
function Drawable:setOrigin(origin_x, origin_y)
  if type(origin_x) == "number" and origin_y == nil then
    self.origin_x = origin_x
    self.origin_y = origin_x
  else
    self.origin_x = origin_x
    self.origin_y = origin_y
  end
end

--- Gets the drawable alpha
--- @return number
function Drawable:getAlpha()
  return self.alpha
end

--- Sets drawable alpha
--- @param alpha number
function Drawable:setAlpha(alpha)
  self.alpha = alpha
end

--- Gets the drawable layer
--- @return number
function Drawable:getLayer()
  return self.layer
end

--- Sets drawable layer
--- @param layer number
--- @param silent? boolean wether to dispatch event to the scene (Defaults to `true`)
function Drawable:setLayer(layer, silent)
  self.layer = layer

  Scene.removeDrawable(self)
  Scene.addDrawable(self)
end

--- Wether the drawable is visible
--- @return boolean
function Drawable:isVisible()
  return self.visible
end

--- Sets if the drawable is visible
--- @param visible boolean
function Drawable:setVisible(visible)
  self.visible = visible
end

--- Gets the drawable sprite
--- @return love.Image|love.Text
function Drawable:getSprite()
  return self.sprite
end

--- Gets the drawable draw function
--- @return fun()|nil
function Drawable:getDraw()
  return self.draw
end

--- Wether the drawable is persistent between scenes
--- @return boolean
function Drawable:isPersistent()
  return self.persistent
end

--- Sets if the drawable is persistent between scenes
--- @param persistent boolean
function Drawable:setPersistent(persistent)
  self.persistent = persistent
end

--- Creates a drawable
--- @param draw? fun() custom draw function
--- @param persistent? boolean wether the drawable is persistent between scenes (Defaults to `false`)
--- @return Dummy.Drawable
function Drawable:new(draw, persistent)
  local drawable = Class:new(Drawable, {
    x = 0,
    y = 0,
    rotation = 0,
    scale_x = 1,
    scale_y = 1,
    origin_x = 0.5,
    origin_y = 0.5,
    alpha = 1,
    layer = Constants.LAYERS.UI,
    visible = true,
    draw = draw,
    persistent = Utils.getOrDefault(persistent, false),
    sprite = nil,
  })

  Scene.addDrawable(drawable)

  return drawable
end

return Drawable
