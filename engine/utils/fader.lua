--- @class Dummy.Fader
---
--- @field protected color love.Color
--- @field protected alpha number
--- @field protected fade_timer Dummy.Timer.Handle|nil
local Fader = {}

--- Loads the fader
function Fader.load()
  Fader.fade_timer = nil
  Fader.alpha = 0
  Fader.color = { 0, 0, 0 }
end

--- Fades in or out
--- @param fade_in boolean wether to fade in or out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
--- @private
function Fader.fade(fade_in, duration, method, fade_callback)
  Fader.reset()

  duration = Utils.getOrDefault(duration, 1)
  method = Utils.getOrDefault(method, "linear")

  local alpha = fade_in and 0 or 1
  Fader.alpha = alpha
  Fader.fade_timer = Timer.tween(duration, Fader, { alpha = math.abs(1 - alpha) }, method, function()
    if type(fade_callback) == "function" then
      fade_callback()
    end
  end)
end

--- Fades in
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeIn(duration, method, fade_callback)
  Fader.fade(true, duration, method, fade_callback)
end

--- Fades out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeOut(duration, method, fade_callback)
  Fader.fade(false, duration, method, fade_callback)
end

--- Sets the fader color
--- @overload fun(color: love.Color)
--- @param r number
--- @param g number
--- @param b number
function Fader.setColor(r, g, b)
  if type(r) == "table" then
    b = r[3]
    g = r[2]
    r = r[1]
  end

  Fader.color[1] = math.clamp(r, 0, 1)
  Fader.color[2] = math.clamp(g, 0, 1)
  Fader.color[3] = math.clamp(b, 0, 1)
end

--- Resets the currently playing fader
function Fader.reset()
  if Fader.fade_timer ~= nil then
    Timer.cancel(Fader.fade_timer)
    Fader.fade_timer = nil
  end
  Fader.alpha = 0
end

--- Draws the fader
function Fader.draw()
  if Fader.alpha <= 0 then return end

  love.graphics.setColor(Fader.color[1], Fader.color[2], Fader.color[3], Fader.alpha)
  love.graphics.rectangle("fill", 0, 0, Constants.WINDOW_WIDTH, Constants.WINDOW_HEIGHT)
end

return Fader
