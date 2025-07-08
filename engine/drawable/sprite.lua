--- @class Dummy.Sprite : Dummy.Drawable
---
--- @field protected sprite love.Image
--- @field protected frames love.Image[]
--- @field protected speed number
--- @field protected loop boolean
--- @field protected keep_last_frame boolean
--- @field protected frame_index number
--- @field protected timer table|nil
--- @field protected vaporize_type "pixel" | "line" | nil
--- @field protected vaporize_size number
local Sprite = Class:extend(Drawable)

--- Gets the class name
--- @return string
function Sprite.getClassName()
  return "Dummy.Sprite"
end

--- @type table<string, love.Image>
local cache_image = {}
--- @type table<string|love.Image, love.ImageData>
local cache_image_data = {}

--- Clears the cache
function Sprite.clear()
  cache_image = {}
  cache_image_data = {}
end

--- Loads a sprite
--- @param sprite_path string
--- @return love.Image
function Sprite.loadSprite(sprite_path)
  local sprite_full_path = "assets/sprites/" .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  -- try to get image data from cache
  local image = cache_image[sprite_full_path]
  if image ~= nil then return image end

  local success

  -- try to get image data from cache
  local image_data = cache_image_data[sprite_full_path]
  if image_data == nil then
    if love.filesystem.getInfo(sprite_full_path) ~= nil then
      success, image_data = pcall(love.image.newImageData, sprite_full_path)
    end

    -- if sprite is not available in the current language, get it from the sprites root folder
    if not success then
      sprite_full_path = "assets/sprites/" .. sprite_path .. ".png"
      if love.filesystem.getInfo(sprite_full_path) ~= nil then
        success, image_data = pcall(love.image.newImageData, sprite_full_path)
      end

      assert(success, "Sprite \"" .. sprite_path .. "\" not found : " .. tostring(image_data))
    end

    cache_image_data[sprite_full_path] = image_data
  end

  -- create an image from the sprite data
  success, image = pcall(love.graphics.newImage, image_data)
  assert(success, "Sprite \"" .. sprite_path .. "\" not found : " .. tostring(image))

  cache_image[sprite_full_path] = image
  cache_image_data[image] = image_data

  return image
end

--- Gets the sprite's value
--- @return love.Image
function Sprite:getSprite()
  if #self.frames > 0 then
    return self.frames[self.frame_index]
  end

  return self.sprite
end

--- Sets the sprite's value
--- @overload fun(self: Dummy.Sprite, sprite_name: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
function Sprite:setSprite(sprites_names)
  self:stop()

  if type(sprites_names) == "table" then
    self.frames = {}
    self.frame_index = 1
    for i, frame in ipairs(sprites_names) do
      if type(frame) == "string" then
        self.frames[i] = Sprite.loadSprite(frame)
      else
        self.frames[i] = frame
      end
    end
  else
    if type(sprites_names) == "string" then
      self.sprite = Sprite.loadSprite(sprites_names)
    else
      self.sprite = sprites_names
    end

    if self.sprite ~= nil then
      Scene.addDrawable(self)
    end
  end
end

--- Gets the sprite's image data
--- @return love.ImageData
function Sprite:getSpriteData()
  return cache_image_data[self.sprite]
end

--- Gets the sprite's frames
--- @return love.Image[]
function Sprite:getFrames()
  return self.frames
end

--- Gets the sprite's width
--- @return number
function Sprite:getWidth()
  local sprite = self:getSprite()
  if sprite == nil then return 0 end
  return sprite:getWidth()
end

--- Gets the sprite's height
--- @return number
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
    self.timer = nil
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

--- Wether the sprite's animation loops
--- @return boolean
function Sprite:getLoop()
  return self.loop
end

--- Sets wether the sprite's animation loops
--- @param loop boolean
function Sprite:setLoop(loop)
  local was_playing = self:isPlaying()
  self:stop()
  self.loop = loop

  if was_playing then
    self:play()
  end
end

--- Gets the sprite's vaporize type
--- @return "pixel" | "line" | nil
function Sprite:getVaporizeType()
  return self.vaporize_type
end

--- Sets the sprite's vaporize type
--- @param type "pixel" | "line" | nil
function Sprite:setVaporizeType(type)
  self.vaporize_type = type
end

--- Gets the sprite's vaporize size
--- @return number
function Sprite:getVaporizeSize()
  return self.vaporize_size
end

--- Sets the sprite's vaporize size
--- @param size number
function Sprite:setVaporizeSize(size)
  self.vaporize_size = size
end

--- Makes the sprite vaporize
--- @param type? "pixel" | "line" wether the particles are pixels or lines (Defaults to `vaporize_type` if set, `"line"` if the sprite's width is greater than 120px, else `"pixel"`)
--- @param size? number size of the particles (Defaults to `vaporize_size` if set, else `2`)
function Sprite:vaporize(type, size)
  type = Utils.getOrDefault(type, Utils.getOrDefault(self.vaporize_type, self:getWidth() > 120 and "line" or "pixel"))
  size = Utils.getOrDefault(size, Utils.getOrDefault(self.vaporize_size, 2))

  Assets.playSound("vaporized")

  local sprite_x, sprite_y = self:getPosition()
  local sprite_origin_x, sprite_origin_y = self:getOrigin()
  local sprite_width, sprite_height = self:getWidth(), self:getHeight()
  local sprite_image = self:getSprite()
  local sprite_data = self:getSpriteData()
  local sprite_pixels_height = sprite_image:getPixelHeight()
  local sprite = self

  local particles = {}
  local j = 0

  local vaporize_drawable = Drawable:new()
  vaporize_drawable:setPosition(sprite_x, sprite_y)
  function vaporize_drawable:draw()
    local origin_x, origin_y = sprite:getOrigin()
    local width, height = sprite:getWidth(), sprite:getHeight()
    local image = sprite:getSprite()
    love.graphics.applyTransform(sprite:getTransform())

    -- particles
    for particle in pairs(particles) do
      love.graphics.setColor(1, 1, 1, particle["alpha"])
      love.graphics.rectangle("fill", particle["x"], particle["y"] - size, particle["width"], size)
    end

    -- cut sprite
    love.graphics.setColor(1, 1, 1, 1)
    local quad = love.graphics.newQuad(0, j, width, (height - j), width, height)
    love.graphics.draw(image, quad, 0, 0, 0, 1, 1, origin_x * width, origin_y * height - j)
  end

  self:setVisible(false)

  local interval = 1 / 30 / 4
  local total_intervals = sprite_pixels_height / size
  Timer.every(interval, function()
    local following_count = 0
    local particle = {}
    for i = 0, (sprite_image:getPixelWidth() - 1), size do
      local r, g, b, a = sprite_data:getPixel(i, j)
      if a == 1 and r == 1 and g == 1 and b == 1 then
        if type == "pixel" or type == "line" and following_count <= 0 then
          particle = {}
          particle["x"] = -sprite_width * sprite_origin_x + i
          particle["y"] = -sprite_height * sprite_origin_y + (j + size)
          particle["vel_x"] = (love.math.random() * 4 - 2) * 30
          particle["acc_y"] = -(love.math.random() * 0.5 + 0.2) * 30 * 5
          particle["vel_y"] = particle["acc_y"]
          particle["alpha"] = 1
          particle["width"] = size
          particles[particle] = true
        end

        following_count = following_count + 1
      else
        if type == "line" and following_count > 0 then
          if particles[particle] ~= nil then
            particle["width"] = following_count * size
          end

          following_count = 0
        end
      end
    end

    j = j + size
  end, total_intervals)

  Timer.during(total_intervals * interval + 1, function(dt)
    for particle in pairs(particles) do
      particle["x"] = particle["x"] + particle["vel_x"] * dt
      particle["y"] = particle["y"] + particle["vel_y"] * dt
      particle["vel_y"] = particle["vel_y"] + particle["acc_y"] * dt
      particle["alpha"] = math.max(0, particle["alpha"] - 1 / 10 * dt * 30)

      if particle["alpha"] <= 0 then
        particles[particle] = nil
      end
    end
  end, function()
    Scene.removeDrawable(vaporize_drawable)
    self:remove()
  end)
end

--- Draws the sprite
function Sprite:draw()
  if not self:isVisible() then return end

  local sprite = self:getSprite()
  if sprite == nil then return end

  love.graphics.applyTransform(self:getTransform())
  local origin_x, origin_y = self:getOrigin()

  if Debugger.shouldDisplayHitbox() then
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", -0.5 - self:getWidth() * origin_x, -0.5 - self:getHeight() * origin_y,
      self:getWidth() + 1, self:getHeight() + 1)
  end

  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
  love.graphics.draw(sprite, -self:getWidth() * origin_x, -self:getHeight() * origin_y)

  self:drawChildren()
end

--- Creates a sprite
--- @overload fun(self: Dummy.Sprite, sprite_name?: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
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
  sprite.frames = {}
  sprite.frame_index = 1
  sprite.vaporize_type = nil
  sprite.vaporize_size = 2


  if sprites_names ~= nil then
    sprite:setSprite(sprites_names)
  end

  if Utils.getOrDefault(play, true) then
    sprite:play()
  end

  return sprite
end

return Sprite
