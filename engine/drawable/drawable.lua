local self = {}

function self.new()
  ---@class Dummy.Drawable
  ---
  ---@field private x number
  ---@field private y number
  ---@field private rotation number
  ---@field private scale_x number
  ---@field private scale_y number
  ---@field private origin_x number
  ---@field private origin_y number
  ---@field private alpha number
  ---@field private layer number
  ---@field private active boolean
  ---@field private sprite love.Image|love.Text
  ---
  ---@field draw fun()|nil
  local drawable = {}

  drawable.x = 0
  drawable.y = 0
  drawable.rotation = 0
  drawable.scale_x = 1
  drawable.scale_y = 1
  drawable.origin_x = 0.5
  drawable.origin_y = 0.5
  drawable.alpha = 1
  drawable.layer = Constants.LAYERS.UI
  drawable.active = true

  --- Gets drawable position
  ---@return number, number
  function drawable:getPosition()
    return self.x, self.y
  end

  --- Sets drawable position
  ---@param x number
  ---@param y number
  function drawable:setPosition(x, y)
    self.x = x
    self.y = y
  end

  --- Gets drawable rotation
  ---@return number
  function drawable:getRotation()
    return self.rotation
  end

  --- Sets drawable rotation
  ---@param rotation number
  function drawable:setRotation(rotation)
    self.rotation = rotation
  end

  --- Gets drawable scale
  ---@return number, number
  function drawable:getScale()
    return self.scale_x, self.scale_y
  end

  --- Sets drawable scale
  ---@overload fun(self: Dummy.Drawable, scale: number)
  ---@param scale_x number
  ---@param scale_y number
  function drawable:setScale(scale_x, scale_y)
    if type(scale_x) == "number" and scale_y == nil then
      self.scale_x = scale_x
      self.scale_y = scale_x
    else
      self.scale_x = scale_x
      self.scale_y = scale_y
    end
  end

  --- Gets drawable origin
  ---@return number, number
  function drawable:getOrigin()
    return self.origin_x, self.origin_y
  end

  --- Sets drawable origin
  ---@overload fun(self: Dummy.Drawable, origin: number)
  ---@param origin_x number
  ---@param origin_y number
  function drawable:setOrigin(origin_x, origin_y)
    if type(origin_x) == "number" and origin_y == nil then
      self.origin_x = origin_x
      self.origin_y = origin_x
    else
      self.origin_x = origin_x
      self.origin_y = origin_y
    end
  end

  --- Gets drawable alpha
  ---@return number
  function drawable:getAlpha()
    return self.alpha
  end

  --- Sets drawable alpha
  ---@param alpha number
  function drawable:setAlpha(alpha)
    self.alpha = alpha
  end

  --- Gets drawable layer
  ---@return number
  function drawable:getLayer()
    return self.layer
  end

  --- Sets drawable layer
  ---@param layer number
  function drawable:setLayer(layer)
    self.layer = layer
    Scene.sortDrawables()
  end

  --- Wether the drawable is active
  ---@return boolean
  function drawable:isActive()
    return self.active
  end

  --- Sets if the drawable is active
  ---@param active boolean
  function drawable:setActive(active)
    self.active = active
    Scene.sortDrawables()
  end

  --- Gets the drawable sprite
  --- @return love.Image|love.Text
  function drawable:getSprite()
    return drawable.sprite
  end

  return drawable
end

return self
