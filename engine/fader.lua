--- @class Dummy.Fader
---
--- @field protected background Dummy.Sprite
--- @field protected default_speed number
--- @field protected speed number
--- @field protected is_fading boolean
--- @field protected is_fade_in boolean
--- @field protected is_fade_done boolean
--- @field protected fade_callback fun()|nil
local Fader = {}

--- Loads the fader
function Fader.load()
  Fader.background = Sprite:new("pixel")
  Fader.background:setPosition(-Constants.WIDTH / 2, -Constants.HEIGHT / 2)
  Fader.background:setOrigin(0, 0)
  Fader.background:setVisible(false)
  Fader.background:setPersistent(true)
  Fader.background:setAlpha(0)
  Fader.background:setLayer(Constants.LAYERS.TOP)
  Fader.background:setScale(Constants.WIDTH * 2, Constants.HEIGHT * 2)
  Fader.background:setColor(0, 0, 0)

  Fader.default_speed = 0.08
  Fader.speed = Fader.default_speed
  Fader.is_fading = false
  Fader.is_fade_in = false
  Fader.is_fade_done = false
end

--- Fades in
--- @param speed? number
--- @param fade_callback? fun()
function Fader.fadeIn(speed, fade_callback)
  Fader.speed = Utils.getOrDefault(speed, Fader.default_speed)
  Fader.fade_callback = fade_callback

  Fader.background:setAlpha(0)
  Fader.background:setVisible(true)
  Fader.is_fade_in = true
  Fader.is_fading = true
end

--- Fades out
--- @param speed? number
--- @param fade_callback? fun()
function Fader.fadeOut(speed, fade_callback)
  Fader.speed = Utils.getOrDefault(speed, Fader.default_speed)
  Fader.fade_callback = fade_callback

  Fader.background:setAlpha(1)
  Fader.background:setVisible(true)
  Fader.is_fade_in = false
  Fader.is_fading = true
end

--- Called when the fade is done
function Fader.onDone() end

--- Updates the fader
function Fader.update(dt)
  if Fader.is_fading then
    local sign = Fader.is_fade_in and 1 or -1
    local alpha = Fader.background:getAlpha()
    alpha = math.clamp(alpha + sign * Fader.speed * dt * 30, 0, 1)
    Fader.background:setAlpha(alpha)

    if (Fader.is_fade_in and alpha >= 1) or (not Fader.is_fade_in and alpha <= 0) then
      Fader.is_fading = false
      Fader.is_fade_done = true
      if type(Fader.fade_callback) == "function" then
        Fader.fade_callback()
      end
    end
  elseif Fader.is_fade_done then
    Fader.is_fade_done = false
    Fader.background:setVisible(false)
  end
end

return Fader
