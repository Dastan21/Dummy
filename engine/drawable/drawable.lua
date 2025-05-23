local self = {}

function self.new()
  --- @class Dummy.Drawable
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
  ---
  --- @field draw fun()|nil
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
  drawable.visible = true

  --- Gets drawable position
  --- @return number, number
  function drawable:getPosition()
    return drawable.x, drawable.y
  end

  --- Sets drawable position
  --- @param x number
  --- @param y number
  function drawable:setPosition(x, y)
    drawable.x = x
    drawable.y = y
  end

  --- Gets drawable rotation
  --- @return number
  function drawable:getRotation()
    return drawable.rotation
  end

  --- Sets drawable rotation
  --- @param rotation number
  function drawable:setRotation(rotation)
    drawable.rotation = rotation
  end

  --- Gets drawable scale
  --- @return number, number
  function drawable:getScale()
    return drawable.scale_x, drawable.scale_y
  end

  --- Sets drawable scale
  --- @overload fun(self: Dummy.Drawable, scale: number)
  --- @param scale_x number
  --- @param scale_y number
  function drawable:setScale(scale_x, scale_y)
    if type(scale_x) == "number" and scale_y == nil then
      drawable.scale_x = scale_x
      drawable.scale_y = scale_x
    else
      drawable.scale_x = scale_x
      drawable.scale_y = scale_y
    end
  end

  --- Gets drawable origin
  --- @return number, number
  function drawable:getOrigin()
    return drawable.origin_x, drawable.origin_y
  end

  --- Sets drawable origin
  --- @overload fun(self: Dummy.Drawable, origin: number)
  --- @param origin_x number
  --- @param origin_y number
  function drawable:setOrigin(origin_x, origin_y)
    if type(origin_x) == "number" and origin_y == nil then
      drawable.origin_x = origin_x
      drawable.origin_y = origin_x
    else
      drawable.origin_x = origin_x
      drawable.origin_y = origin_y
    end
  end

  --- Gets drawable alpha
  --- @return number
  function drawable:getAlpha()
    return drawable.alpha
  end

  --- Sets drawable alpha
  --- @param alpha number
  function drawable:setAlpha(alpha)
    drawable.alpha = alpha
  end

  --- Gets drawable layer
  --- @return number
  function drawable:getLayer()
    return drawable.layer
  end

  --- Sets drawable layer
  --- @param layer number
  --- @param silent? boolean wether to dispatch event to the scene (Defaults to `true`)
  function drawable:setLayer(layer, silent)
    drawable.layer = layer

    Scene.removeDrawable(drawable)
    Scene.addDrawable(drawable)
  end

  --- Wether the drawable is visible
  --- @return boolean
  function drawable:isVisible()
    return drawable.visible
  end

  --- Sets if the drawable is visible
  --- @param visible boolean
  function drawable:setVisible(visible)
    drawable.visible = visible
  end

  --- Gets the drawable sprite
  --- @return love.Image|love.Text
  function drawable:getSprite()
    return drawable.sprite
  end

  return drawable
end

return self
