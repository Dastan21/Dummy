--- @class Dummy.Fader
---
--- @field protected background Dummy.Sprite
--- @field protected fade_timer table|nil
local Fader = {}

--- Loads the fader
function Fader.load()
  Fader.background = Sprite:new("pixel")
  Fader.background:setPosition(-Constants.SCREEN_WIDTH / 2, -Constants.SCREEN_HEIGHT / 2)
  Fader.background:setOrigin(0, 0)
  Fader.background:setVisible(false)
  Fader.background:setPersistent(true)
  Fader.background:setAlpha(0)
  Fader.background:setLayer(Constants.LAYERS.TOP)
  Fader.background:setScale(Constants.SCREEN_WIDTH * 2, Constants.SCREEN_HEIGHT * 2)
  Fader.background:setColor(0, 0, 0)

  Fader.fade_timer = nil
end

--- Fades in or out
--- @param fade_in boolean wether to fade in or out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
--- @private
function Fader.fade(fade_in, duration, fade_callback)
  Fader.reset()

  duration = Utils.getOrDefault(duration, 1)

  local alpha = fade_in and 0 or 1
  Fader.background:setAlpha(alpha)
  Fader.background:setVisible(true)

  Timer.tween(duration, Fader.background, { alpha = math.abs(1 - alpha) })

  Fader.fade_timer = Timer.after(duration, function()
    if type(fade_callback) == "function" then
      fade_callback()
    end
  end)
end

--- Fades in
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeIn(duration, fade_callback)
  Fader.fade(true, duration, fade_callback)
end

--- Fades out
--- @param duration? number duration of the fade, in seconds (Defaults to `1`)
--- @param fade_callback? fun() called when the fade is done
function Fader.fadeOut(duration, fade_callback)
  Fader.fade(false, duration, fade_callback)
end

--- Resets the currently playing fader
function Fader.reset()
  if Fader.fade_timer ~= nil then
    Timer.cancel(Fader.fade_timer)
  end

  Fader.background:setVisible(false)
end

return Fader
