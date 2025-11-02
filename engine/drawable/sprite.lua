--- @class Dummy.Sprite : Dummy.Drawable
---
--- @field protected sprite love.Image|nil
--- @field protected frames love.Image[]
--- @field protected frames_speed number
--- @field protected loop boolean
--- @field protected keep_last_frame boolean
--- @field protected frame_index number
--- @field protected frames_timer table|nil
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
--- @return love.Image|nil
function Sprite.loadSprite(sprite_path)
  local image = nil

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    image = Sprite.loadSpriteFromFolder("mods/" .. mod:getId() .. "/assets/sprites/", sprite_path)
  end

  if image == nil or type(image) == "string" then
    image = Sprite.loadSpriteFromFolder("assets/sprites/", sprite_path)
  end

  assert(image ~= nil and type(image) ~= "string", image)

  return image
end

--- Loads a sprite from a folder
--- @param sprite_path string
--- @return love.Image|string
--- @private
function Sprite.loadSpriteFromFolder(base_sprites_path, sprite_path)
  local sprite_full_path = base_sprites_path .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  -- try to get image from cache
  local image = cache_image[sprite_full_path] or cache_image[base_sprites_path .. sprite_path .. ".png"]
  if image ~= nil then return image end

  local success = false

  -- try to get image data from cache
  local image_data = cache_image_data[sprite_full_path]
  if image_data == nil then
    if love.filesystem.getInfo(sprite_full_path) ~= nil then
      success, image_data = pcall(love.image.newImageData, sprite_full_path)
    end

    -- if sprite is not available in the current language, get it from the sprites root folder
    if not success then
      sprite_full_path = base_sprites_path .. sprite_path .. ".png"
      if love.filesystem.getInfo(sprite_full_path) ~= nil then
        success, image_data = pcall(love.image.newImageData, sprite_full_path)
      end

      if not success then
        return "Sprite \"" .. sprite_path .. "\" not found : " .. tostring(image_data)
      end
    end

    cache_image_data[sprite_full_path] = image_data
  end

  -- create an image from the sprite data
  success, image = pcall(love.graphics.newImage, image_data)
  if not success then
    return "Sprite \"" .. sprite_path .. "\" not found : " .. tostring(image)
  end

  cache_image[sprite_full_path] = image
  cache_image_data[image] = image_data

  return image
end

--- Gets the sprite's value
--- @return love.Image|nil
function Sprite:getSprite()
  if #self.frames > 0 then
    return self.frames[self.frame_index]
  end

  return self.sprite
end

--- Sets the sprite's value
--- @overload fun(self: Dummy.Sprite, sprite_name?: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
function Sprite:setSprite(sprites_names, speed, loop, play, keep_last_frame)
  self:stop()

  if type(sprites_names) == "table" then
    self.frames_speed = Utils.getOrDefault(speed, self.frames_speed)
    self.loop = Utils.getOrDefault(loop, self.loop)
    self.keep_last_frame = Utils.getOrDefault(keep_last_frame, self.keep_last_frame)
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
  end

  if Utils.getOrDefault(play, true) then
    self:play()
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
  local stopped = false

  self.frames_timer = Timer.every(self.frames_speed, function()
    if not self:isVisible() or stopped then return end
    if not self.loop and self.frame_index >= #self.frames then
      if self.keep_last_frame then
        self:setFrame(self.frame_index)
      else
        stopped = true
        self:stop()
        self.frame_index = 0
      end
    else
      self.frame_index = (self.frame_index % #self.frames) + 1
    end
  end)
end

--- Stops the sprite's animation
function Sprite:stop()
  if self.frames == nil then return end

  if self.frames_timer ~= nil then
    Timer.cancel(self.frames_timer)
  end

  self.frame_index = 1
end

--- Wether the sprite's animation is playing
--- @return boolean
function Sprite:isPlaying()
  return self.frames_timer ~= nil
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
  return self.frames_speed
end

--- Sets the sprite's animation speed
--- @param speed number
function Sprite:setSpeed(speed)
  local was_playing = self:isPlaying()
  self:stop()
  self.frames_speed = speed

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

  local sprite_image = self:getSprite()
  if sprite_image == nil then return end

  Assets.playSound("vaporized")

  local sprite_x, sprite_y = self:getPosition()
  local sprite_origin_x, sprite_origin_y = self:getOrigin()
  local sprite_width, sprite_height = self:getWidth(), self:getHeight()
  local sprite_data = self:getSpriteData()
  local sprite_pixels_height = sprite_image:getPixelHeight()
  local sprite = self

  local particles = {}
  local j = 0

  local vaporize_drawable = Drawable:new()
  vaporize_drawable:setPosition(sprite_x, sprite_y)
  function vaporize_drawable.draw()
    local image = sprite:getSprite()
    if image == nil then return end

    local origin_x, origin_y = sprite:getOrigin()
    local width, height = sprite:getWidth(), sprite:getHeight()
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
          particle["alpha"] = 1.2
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
    vaporize_drawable:remove()
    self:remove()
  end)
end

--- Draws the sprite
function Sprite:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())
  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getWidth(), self:getHeight()
  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
  local sprite = self:getSprite()
  if sprite ~= nil then
    love.graphics.draw(sprite, -width * origin_x, -height * origin_y)
  end

  self:debugDraw()
  self:drawChildren()
end

--- Draws for debugging
function Sprite:debugDraw()
  if not Debug.shouldDisplayHitbox() then return end

  local width, height = self:getWidth(), self:getHeight()
  if width == 0 and height == 0 then return end

  love.graphics.push()
  love.graphics.origin()
  local absolute_transform = self:getAbsoluteTransform()
  local origin_x, origin_y = self:getOrigin()
  local x, y = -width * origin_x, -height * origin_y
  local x1, y1 = absolute_transform:transformPoint(x, y)
  local x2, y2 = absolute_transform:transformPoint(x + width, y)
  local x3, y3 = absolute_transform:transformPoint(x + width, y + height)
  local x4, y4 = absolute_transform:transformPoint(x, y + height)
  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.setLineStyle("rough")
  love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)
  love.graphics.pop()
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
  self = Class:new(Sprite)

  self.frames_speed = Utils.getOrDefault(speed, 1 / 30)
  self.loop = Utils.getOrDefault(loop, true)
  self.keep_last_frame = Utils.getOrDefault(keep_last_frame, true)
  self.frames = {}
  self.frame_index = 1
  self.vaporize_type = nil
  self.vaporize_size = 2

  if sprites_names ~= nil then
    self:setSprite(sprites_names, speed, loop, play, keep_last_frame)
  end

  return self
end

return Sprite
