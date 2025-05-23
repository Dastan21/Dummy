local cache = {}
local self = {}

local function getSprite(sprite_path)
  local sprite_full_path = "assets/sprites/" .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  -- try to get sprite data from cache
  local image_data = cache[sprite_full_path]
  local success = true
  success, image_data = pcall(love.image.newImageData, sprite_full_path)

  -- if sprite is not available in the current language, get it from the sprites root folder
  if not success then
    sprite_full_path = "assets/sprites/" .. sprite_path .. ".png"
    success, image_data = pcall(love.image.newImageData, sprite_full_path)
    assert(success, "Sprite \"" .. sprite_path .. "\" not found")
  end

  if cache[sprite_full_path] == nil then
    cache[sprite_full_path] = image_data
  end

  -- create an image from the sprite data
  success, image_data = pcall(love.graphics.newImage, image_data)
  assert(success, "Sprite \"" .. sprite_path .. "\" not found")

  return image_data
end

--- Creates a sprite
--- @overload fun(sprite: string): Dummy.Sprite
--- @param frames table<number, string>
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @return Dummy.Sprite
function self.new(frames, speed, loop, keep_last_frame)
  --- @class Dummy.Sprite : Dummy.Drawable
  ---
  --- @field protected sprite love.Image
  --- @field protected frames table
  --- @field protected speed number
  --- @field protected loop boolean
  --- @field protected keep_last_frame boolean
  --- @field protected frame_index number
  --- @field protected timer table|nil
  local sprite = Drawable.new()

  --- Gets the sprite value
  --- @return love.Image
  function sprite:getSprite()
    if sprite.frames ~= nil then
      return sprite.frames[sprite.frame_index]
    end

    return sprite.sprite
  end

  --- Sets the sprite value
  --- @param sprite_name string|table<number, string>
  function sprite:setSprite(sprite_name)
    if sprite.sprite ~= nil then
      Scene.removeDrawable(sprite)
    end

    sprite.sprite = getSprite(sprite_name)
    sprite.sprite_name = sprite_name

    Scene.addDrawable(sprite)
  end

  --- Plays the sprite animation
  function sprite:play()
    if sprite.frames == nil then return end

    sprite:stop()

    sprite.timer = Timer.every(sprite.speed, function()
      if sprite:isVisible() then
        if not sprite.loop and sprite.frame_index >= #sprite.frames then
          if sprite.keep_last_frame then
            sprite:setFrame(sprite.frame_index)
          else
            sprite:stop()
            sprite.frame_index = 0
          end
        else
          sprite.frame_index = (sprite.frame_index % #sprite.frames) + 1
        end
      end
    end)
  end

  --- Stops the sprite animation
  function sprite:stop()
    if sprite.frames == nil then return end

    if sprite.timer ~= nil then
      Timer.cancel(sprite.timer)
    end

    sprite.frame_index = 1
  end

  --- Sets the current sprite animation frame
  --- @param index number
  function sprite:setFrame(index)
    sprite:stop()
    sprite.frame_index = math.clamp(index, 1, #sprite.frames)
  end

  if type(frames) == "table" then
    sprite.frames = {}
    sprite.frame_index = 1
    for i, frame in ipairs(frames) do
      sprite.frames[i] = getSprite(frame)
    end

    sprite.speed = Utils.getOrDefault(speed, 1 / 30)
    sprite.loop = Utils.getOrDefault(loop, true)
    sprite.keep_last_frame = Utils.getOrDefault(keep_last_frame, true)

    sprite:play()

    Scene.addDrawable(sprite)
  else
    sprite:setSprite(frames)
  end

  return sprite
end

return self
