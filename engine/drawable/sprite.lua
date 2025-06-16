--- @class Dummy.Sprite : Dummy.Drawable
---
--- @field protected sprite love.Image
--- @field protected frames table
--- @field protected speed number
--- @field protected loop boolean
--- @field protected keep_last_frame boolean
--- @field protected frame_index number
--- @field protected timer table|nil
local Sprite = Class:extend(Drawable)

--- Gets the class name
--- @return string
function Sprite:getClass()
  return "Dummy.Sprite"
end

---@type table<string, love.ImageData>
local cache = {}

--- Clears the cache
function Sprite.clear()
  cache = {}
end

--- Loads a sprite
---@param sprite_path string
---@return love.Image
---@private
function Sprite:loadSprite(sprite_path)
  local sprite_full_path = "assets/sprites/" .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  -- try to get sprite data from cache
  local image_data = cache[sprite_full_path]
  if image_data == nil then
    local success_image_data, new_image_data = pcall(love.image.newImageData, sprite_full_path)

    -- if sprite is not available in the current language, get it from the sprites root folder
    if not success_image_data then
      sprite_full_path = "assets/sprites/" .. sprite_path .. ".png"
      success_image_data, new_image_data = pcall(love.image.newImageData, sprite_full_path)
      assert(success_image_data, "Sprite \"" .. sprite_path .. "\" not found")
    end

    if cache[sprite_full_path] == nil then
      cache[sprite_full_path] = new_image_data
    end

    image_data = new_image_data
  end

  -- create an image from the sprite data
  local successImage, image = pcall(love.graphics.newImage, image_data)
  assert(successImage, "Sprite \"" .. sprite_path .. "\" not found")

  return image
end

--- Gets the sprite's value
--- @return love.Image
function Sprite:getSprite()
  if self.frames ~= nil then
    return self.frames[self.frame_index]
  end

  return self.sprite
end

--- Sets the sprite's value
--- @overload fun(self: Dummy.Sprite, sprite_name: string): Dummy.Sprite
--- @param sprites_names string[]
function Sprite:setSprite(sprites_names)
  self:stop()

  if type(sprites_names) == "table" then
    self.frames = {}
    self.frame_index = 1
    for i, frame in ipairs(sprites_names) do
      self.frames[i] = self:loadSprite(frame)
    end
  else
    self.sprite = self:loadSprite(sprites_names)
    self.sprite_name = sprites_names

    if self.sprite ~= nil then
      Scene.addDrawable(self)
    end
  end
end

--- Gets the sprite's width
---@return number
function Sprite:getWidth()
  local sprite = self:getSprite()
  if sprite == nil then return 0 end
  return sprite:getWidth()
end

--- Gets the sprite's height
---@return number
function Sprite:getHeight()
  local sprite = self:getSprite()
  if sprite == nil then return 0 end
  return sprite:getHeight()
end

--- Plays the sprite's animation
function Sprite:play()
  if self.frames == nil then return end

  self:stop()

  self.timer = Timer.every(self.speed, function()
    if self:isVisible() then
      if not self.loop and self.frame_index >= #self.frames then
        if self.keep_last_frame then
          self:setFrame(self.frame_index)
        else
          self:stop()
          self.frame_index = 0
        end
      else
        self.frame_index = (self.frame_index % #self.frames) + 1
      end
    end
  end)
end

--- Stops the sprite's animation
function Sprite:stop()
  if self.frames == nil then return end

  if self.timer ~= nil then
    Timer.cancel(self.timer)
  end

  self.frame_index = 1
end

--- Wether the sprite's animation is playing
--- @return boolean
function Sprite:isPlaying()
  return self.timer ~= nil
end

--- Sets the current sprite's animation frame
--- @param index number
function Sprite:setFrame(index)
  self:stop()
  self.frame_index = math.clamp(index, 1, #self.frames)
end

--- Gets the sprite's animation speed
--- @return number
function Sprite:getSpeed()
  return self.speed
end

--- Sets the sprite's animation speed
--- @param speed number
function Sprite:setSpeed(speed)
  local was_playing = self:isPlaying()
  self:stop()
  self.speed = speed

  if was_playing then
    self:play()
  end
end

--- Creates a sprite
--- @overload fun(self: Dummy.Sprite, sprite_name: string): Dummy.Sprite
--- @param sprites_names string[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @return Dummy.Sprite
function Sprite:new(sprites_names, speed, loop, play, keep_last_frame)
  local sprite = Class:new(Sprite)

  sprite.speed = Utils.getOrDefault(speed, 1 / 30)
  sprite.loop = Utils.getOrDefault(loop, true)
  sprite.keep_last_frame = Utils.getOrDefault(keep_last_frame, true)

  sprite:setSprite(sprites_names)

  if Utils.getOrDefault(play, true) then
    sprite:play()
  end

  return sprite
end

return Sprite
