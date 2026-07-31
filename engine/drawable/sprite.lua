--- @class Dummy.Sprite.Image
---
--- @field image love.Image|nil
--- @field image_data love.ImageData|nil
--- @field timestamp number
--- @field sprite_path string
--- @field full_sprite_path string

--- @class Dummy.Sprite : Dummy.Drawable
---
--- @field protected sprite love.Image|nil
--- @field protected flip_x boolean
--- @field protected flip_y boolean
--- @field protected frames_speed number
--- @field protected loop boolean
--- @field protected keep_last_frame boolean
--- @field protected frame_index number
--- @field protected frames_timer Dummy.Timer.Handle|nil
--- @field protected sprite_paths string[]
--- @field protected vaporize_type "pixel" | "line" | nil
--- @field protected vaporize_size number
--- @field protected vaporize_dust_timer Dummy.Timer.Handle|nil
--- @field protected vaporize_update_timer Dummy.Timer.Handle|nil
local Sprite = Class(Drawable, "Dummy.Sprite")

--- @type table<string, Dummy.Sprite.Image>
local images = {}

--- Clears the cache
function Sprite.clear()
  images = {}
end

--- Loads a sprite
--- @param sprite_path string
--- @param force? boolean
--- @return Dummy.Sprite.Image
function Sprite.loadImage(sprite_path, force)
  local image = nil

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    image = Sprite.loadImageFromFolder("mods/" .. mod:getId() .. "/assets/sprites/", sprite_path, force)
  end

  if image == nil or type(image) == "string" then
    image = Sprite.loadImageFromFolder("assets/sprites/", sprite_path, force)
  end

  assert(image ~= nil and type(image) ~= "string", image)

  return image
end

--- Loads a sprite from a folder
--- @param sprite_path string
--- @param force? boolean
--- @return Dummy.Sprite.Image|string
--- @private
function Sprite.loadImageFromFolder(base_sprites_path, sprite_path, force)
  local full_image_path = base_sprites_path .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  -- try to get image from cache
  local image = images[full_image_path] or images[base_sprites_path .. sprite_path .. ".png"]
  if force ~= true and image ~= nil then return image end

  local success = false
  --- @type love.ImageData
  local love_image_data
  --- @type love.Image
  local love_image

  -- try to get image data from cache
  if force == true or image == nil then
    image = image or {
      image = nil,
      image_data = nil,
      timestamp = 0,
      sprite_path = sprite_path,
      full_sprite_path = full_image_path
    }
    local info = love.filesystem.getInfo(full_image_path)
    if info ~= nil then
      image.timestamp = info.modtime
      success, love_image_data = pcall(love.image.newImageData, full_image_path)
    end

    -- if sprite is not available in the current language, get it from the sprites root folder
    if not success then
      full_image_path = base_sprites_path .. sprite_path .. ".png"
      info = love.filesystem.getInfo(full_image_path)
      if info ~= nil then
        image.timestamp = info.modtime
        success, love_image_data = pcall(love.image.newImageData, full_image_path)
      end

      if not success then
        return "Sprite \"" .. sprite_path .. "\" not found: " .. tostring(love_image_data)
      end
    end

    image.image_data = love_image_data
  end

  -- create an image from the sprite data
  success, love_image = pcall(love.graphics.newImage, love_image_data)
  if not success then
    return "Sprite \"" .. sprite_path .. "\" not found: " .. tostring(love_image)
  end

  image.full_sprite_path = full_image_path
  image.sprite_path = sprite_path
  image.image = love_image
  images[full_image_path] = image

  return image
end

--- Loads the sprite cached from an image
--- @param image love.Image|nil
function Sprite.loadSpriteFromImage(image)
  return table.find(images, function(sprite)
    return sprite.image == image
  end)
end

--- Reloads the sprite if it has changed
function Sprite.hotReload()
  for full_sprite_path in pairs(images) do
    local info = love.filesystem.getInfo(full_sprite_path)
    if info ~= nil and info.modtime ~= images[full_sprite_path].timestamp then
      local image = images[full_sprite_path]
      Sprite.loadImage(image.sprite_path, true)

      Signal.emit("hot_reload_sprite", image)
    end
  end
end

--- Gets the sprite's image
--- @return Dummy.Sprite.Image|nil
function Sprite:getSprite()
  local sprite_path = self.sprite_paths[self.frame_index]
  if sprite_path == nil then return end
  if images[sprite_path] == nil then
    local mod = ModList.getCurrentMod()
    if mod ~= nil then
      sprite_path = sprite_path:gsub("^mods/" .. mod:getId() .. "/assets/sprites/", "")
    end
    sprite_path = sprite_path:gsub("^assets/sprites/", "")
    Sprite.loadImage(Utils.getFilenameWithoutExt(sprite_path), true)
  end
  return images[sprite_path]
end

--- Sets the sprite's image or frames
--- @overload fun(self: Dummy.Sprite, image: love.Image)
--- @overload fun(self: Dummy.Sprite, sprite_name: string|love.Image)
--- @overload fun(self: Dummy.Sprite, images: love.Image[], speed?: number, loop?: boolean, play?: boolean, keep_last_frame?: boolean, remove_when_done?: boolean)
--- @param sprites_names string[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @param remove_when_done? boolean removes the sprite when it's done playing (Defaults to `false`)
function Sprite:setSprite(sprites_names, speed, loop, play, keep_last_frame, remove_when_done)
  self:stop()
  self.sprite_paths = {}

  if type(sprites_names) == "table" then
    self.frames_speed = math.max(0, Utils.getOrDefault(speed, self.frames_speed))
    self.loop = Utils.getOrDefault(loop, self.loop)
    self.keep_last_frame = Utils.getOrDefault(keep_last_frame, self.keep_last_frame)
    self.remove_when_done = Utils.getOrDefault(remove_when_done, self.remove_when_done)
    for i, frame in ipairs(sprites_names) do
      --- @type Dummy.Sprite.Image|nil
      local sprite
      if type(frame) == "string" then
        sprite = Sprite.loadImage(frame)
      else
        sprite = Sprite.loadSpriteFromImage(frame)
      end
      if sprite ~= nil then
        self.sprite_paths[i] = sprite.full_sprite_path
      end
    end

    if Utils.getOrDefault(play, true) then
      self:play()
    end
  else
    --- @type Dummy.Sprite.Image|nil
    local sprite
    if type(sprites_names) == "string" then
      sprite = Sprite.loadImage(sprites_names)
    else
      sprite = Sprite.loadSpriteFromImage(sprites_names)
    end
    if sprite ~= nil then
      self.sprite_paths[1] = sprite.full_sprite_path
    end
  end
end

--- Gets the sprite's love image
--- @return love.Image|nil
function Sprite:getImage()
  local sprite = self:getSprite()
  if sprite == nil then return end
  return sprite.image
end

--- Gets the sprite's image data
--- @return love.ImageData|nil
function Sprite:getImageData()
  if #self.sprite_paths > 0 then
    local sprite = self:getSprite()
    if sprite == nil then return end
    return sprite.image_data
  end
  local sprite = images[self.sprite_paths[1]]
  if sprite == nil then return end
  return sprite.image_data
end

--- Wether the sprite is flipped horizontally
--- @return boolean
function Sprite:getFlipX()
  return self.flip_x
end

--- Sets wether the sprite is flipped horizontally
--- @param flip_x boolean
function Sprite:setFlipX(flip_x)
  self.flip_x = flip_x
end

--- Wether the sprite is flipped vertically
--- @return boolean
function Sprite:getFlipY()
  return self.flip_y
end

--- Sets wether the sprite is flipped vertically
--- @param flip_y boolean
function Sprite:setFlipY(flip_y)
  self.flip_y = flip_y
end

--- Gets the sprite's frames
--- @return love.Image[]
function Sprite:getFrames()
  local frames = {}
  for i, full_sprite_paths in ipairs(self.sprite_paths) do
    frames[i] = images[full_sprite_paths].image
  end
  return frames
end

--- Gets the sprite's width
--- @return number
function Sprite:getWidth()
  local sprite = self:getImage()
  if sprite == nil then return 0 end
  return sprite:getWidth()
end

--- Gets the sprite's height
--- @return number
function Sprite:getHeight()
  local sprite = self:getImage()
  if sprite == nil then return 0 end
  return sprite:getHeight()
end

--- Plays the sprite's animation
function Sprite:play()
  if self.sprite_paths == nil or #self.sprite_paths <= 1 or self.frames_speed <= 0 then return end

  self:stop()
  local stopped = false

  self.frames_timer = Timer.every(self.frames_speed, function()
    if not self:isVisible() or stopped then return end
    if not self.loop and self.frame_index >= #self.sprite_paths then
      if self.keep_last_frame then
        self:setFrame(self.frame_index)
      else
        stopped = true
        self:stop()
        self.frame_index = 0

        if self.remove_when_done then
          self:remove()
        end
      end
    else
      self.frame_index = (self.frame_index % #self.sprite_paths) + 1
    end
  end)
end

--- Stops the sprite's animation
function Sprite:stop()
  if self.frames_timer ~= nil then
    Timer.cancel(self.frames_timer)
    self.frames_timer = nil
  end

  self.frame_index = 1
end

--- Wether the sprite's animation is playing
--- @return boolean
function Sprite:isPlaying()
  return self.frames_timer ~= nil
end

--- Gets the current sprite's animation frame
--- @return number
function Sprite:getFrame()
  return self.frame_index
end

--- Sets the current sprite's animation frame
--- @param index number
function Sprite:setFrame(index)
  self.frame_index = math.clamp(index, 1, #self.sprite_paths)
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
  self.frames_speed = math.max(0, speed)

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

  local sprite_image = self:getImage()
  if sprite_image == nil then return end

  local image_data = self:getImageData()
  if image_data == nil then return end

  Assets.playSound("vaporized")

  local sprite_x, sprite_y = self:getPosition()
  local sprite_origin_x, sprite_origin_y = self:getOrigin()
  local sprite_width, sprite_height = self:getWidth(), self:getHeight()

  local sprite_pixels_height = sprite_image:getPixelHeight()
  local sprite = self

  local particles = {}
  local j = 0

  local vaporize_drawable = Drawable:new()
  vaporize_drawable:setPosition(sprite_x, sprite_y)
  function vaporize_drawable.draw(_self)
    if not _self:isVisible() then return end

    local image = sprite:getImage()
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
  self.vaporize_dust_timer = Timer.every(interval, function()
    local following_count = 0
    local particle = {}
    for i = 0, (sprite_image:getPixelWidth() - 1), size do
      local r, g, b, a = image_data:getPixel(i, j)
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

  self.vaporize_update_timer = Timer.during(total_intervals * interval + 1, function(dt)
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

--- Removes the sprite from the current scene
function Sprite:remove()
  if self:isRemoved() then return end

  self:stop()
  self.sprite_paths = {}

  if self.vaporize_dust_timer ~= nil then
    Timer.cancel(self.vaporize_dust_timer)
    self.vaporize_dust_timer = nil
  end

  if self.vaporize_update_timer ~= nil then
    Timer.cancel(self.vaporize_update_timer)
    self.vaporize_update_timer = nil
  end

  Drawable.remove(self)
end

--- Draws the sprite
--- @param camera Dummy.Camera
function Sprite:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())
  love.graphics.setColor(self:getColor())

  local width, height = self:getWidth(), self:getHeight()
  local origin_x, origin_y = self:getOrigin()
  local sprite = self:getImage()
  local flip_x = self:getFlipX() and -1 or 1
  local flip_y = self:getFlipY() and -1 or 1
  if sprite ~= nil then
    love.graphics.draw(sprite, -width * origin_x * flip_x, -height * origin_y * flip_y, 0, flip_x, flip_y)
  end

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Draws the sprite's bounding box for debugging
--- @param camera Dummy.Camera
function Sprite:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() or not self:isVisibleOnScreen() then return end

  local width, height = self:getWidth(), self:getHeight()
  if width == 0 and height == 0 then return end

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle("rough")
  local bb = self:getBoundingBox()
  love.graphics.polygon("line",
    bb[1] + 0.5, bb[2] + 0.5,
    bb[3] - 0.5, bb[4] + 0.5,
    bb[5] - 0.5, bb[6] - 0.5,
    bb[7] + 0.5, bb[8] - 0.5
  )

  love.graphics.pop()
end

--- Creates a sprite
--- @overload fun(self: Dummy.Sprite, image?: love.Image): Dummy.Sprite
--- @overload fun(self: Dummy.Sprite, sprite_name?: string|love.Image): Dummy.Sprite
--- @overload fun(self: Dummy.Sprite, images: love.Image[], speed?: number, loop?: boolean, play?: boolean, keep_last_frame?: boolean, remove_when_done?: boolean): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @param remove_when_done? boolean removes the sprite when it's done playing (Defaults to `false`)
--- @return Dummy.Sprite
function Sprite:new(sprites_names, speed, loop, play, keep_last_frame, remove_when_done)
  self = Class:new(Sprite)

  self.flip_x = false
  self.flip_y = false
  self.frames_speed = math.max(0, Utils.getOrDefault(speed, 1 / 30))
  self.loop = Utils.getOrDefault(loop, true)
  self.keep_last_frame = Utils.getOrDefault(keep_last_frame, true)
  self.remove_when_done = Utils.getOrDefault(remove_when_done, false)
  self.frame_index = 1
  self.vaporize_type = nil
  self.vaporize_size = 2
  self.sprite_paths = {}

  if sprites_names ~= nil then
    self:setSprite(sprites_names, speed, loop, play, keep_last_frame, remove_when_done)
  end

  return self
end

return Sprite
