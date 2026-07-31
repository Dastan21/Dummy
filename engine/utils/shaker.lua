--- @class Dummy.Shaker
---
--- @field protected dx number
--- @field protected dy number
--- @field protected duration_timer Dummy.Timer.Handle|nil
--- @field protected interval_timer Dummy.Timer.Handle|nil
local Shaker = {}

--- Loads the shaker
function Shaker.load()
  Shaker.dx = 0
  Shaker.dy = 0
  Shaker.duration_timer = nil
  Shaker.interval_timer = nil
end

--- Gets the shaker's offset
--- @return number, number
function Shaker.getOffset()
  return Shaker.dx, Shaker.dy
end

--- Shakes the screen
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param shake_function fun(): number, number custom shake function to calculate the shakes directions
--- @param shake_callback? fun() called when the shake is done
function Shaker.shake(duration, interval, shake_function, shake_callback)
  Shaker.reset()

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

--- Shakes the screen in random directions
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param horizontal_strength number horizontal shake strength
--- @param vertical_strength number vertical shake strength
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeRandom(duration, interval, horizontal_strength, vertical_strength, shake_callback)
  Shaker.shake(duration, interval, function()
    return (love.math.random() - 0.5) * horizontal_strength, (love.math.random() - 0.5) * vertical_strength
  end, shake_callback)
end

--- Shakes the screen, decreasing the strength each shake
--- @param duration number duration of the shake, in seconds
--- @param interval number interval between shakes
--- @param horizontal_strength number horizontal shake strength
--- @param vertical_strength number vertical shake strength
--- @param shake_callback? fun() called when the shake is done
function Shaker.shakeDecrease(duration, interval, horizontal_strength, vertical_strength, shake_callback)
  Shaker.shake(duration, interval, function()
    if horizontal_strength ~= 0 then
      if horizontal_strength < 0 then
        horizontal_strength = horizontal_strength + 1
      end
      horizontal_strength = -horizontal_strength
    end
    if vertical_strength ~= 0 then
      if vertical_strength < 0 then
        vertical_strength = vertical_strength + 1
      end
      vertical_strength = -vertical_strength
    end

    return horizontal_strength, vertical_strength
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
    Shaker.duration_timer = nil
  end
  if Shaker.interval_timer ~= nil then
    Timer.cancel(Shaker.interval_timer)
    Shaker.interval_timer = nil
  end

  Shaker.dx = 0
  Shaker.dy = 0
end

--- Draws the shaker
function Shaker.draw()
  love.graphics.translate(Shaker.dx, Shaker.dy)
end

return Shaker
