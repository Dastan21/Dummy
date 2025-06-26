--- @class Dummy.Shaker
---
--- @field protected drawable Dummy.Drawable
--- @field protected dx number
--- @field protected dy number
--- @field protected duration_timer table|nil
--- @field protected interval_timer table|nil
local Shaker = {}

--- Loads the shaker
function Shaker.load()
  Shaker.drawable = Drawable:new()
  Shaker.drawable:setPersistent(true)
  Shaker.drawable:setLayer(Constants.LAYERS.SHAKER)
  Shaker.drawable:setVisible(false)
  function Shaker.drawable:draw()
    love.graphics.push()

    love.graphics.translate(Shaker.dx, Shaker.dy)

    love.graphics.pop()
  end

  Shaker.dx = 0
  Shaker.dy = 0
  Shaker.duration_timer = nil
  Shaker.interval_timer = nil
end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param shake_function fun(): number, number custom shake function to calculate the shakes directions
--- @param shake_callback? fun() called when the shake is done
function Shaker.shake(duration, interval, shake_function, shake_callback)
  Shaker.reset()
  Shaker.drawable:setVisible(true)

  Shaker.duration_timer = Timer.after(duration, function()
    if type(shake_callback) == "function" then
      shake_callback()
    end

    Shaker.reset()
  end)

  Shaker.interval_timer = Timer.every(interval, function()
    if type(shake_function) == "function" then
      Shaker.dx, Shaker.dy = shake_function()
    end
  end)
end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param horizontal_strength number horizontal shake strength
--- @param vertical_strength number vertical shake strength
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeRandom(duration, interval, horizontal_strength, vertical_strength, shake_callback)
  Shaker.shake(duration, interval, function()
    return (math.random() - 0.5) * horizontal_strength, (math.random() - 0.5) * vertical_strength
  end, shake_callback)
end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param shake_function fun(): number, number custom shake function to calculate the shakes directions (Defaults to random directions by strength)
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeCustom(duration, interval, shake_function, shake_callback)
  Shaker.shake(duration, interval, shake_function, shake_callback)
end

--- Resets the currently playing shaker
function Shaker.reset()
  if Shaker.duration_timer ~= nil then
    Timer.cancel(Shaker.duration_timer)
  end
  if Shaker.interval_timer ~= nil then
    Timer.cancel(Shaker.interval_timer)
  end

  Shaker.drawable:setVisible(false)
  Shaker.dx = 0
  Shaker.dy = 0
end

return Shaker
