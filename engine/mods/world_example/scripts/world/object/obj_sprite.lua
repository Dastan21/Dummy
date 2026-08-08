--- @class Dummy.Object.Sprite.Data : Dummy.Object.Data
---
--- @field frames string[]
--- @field speed number
--- @field loop boolean
--- @field play boolean
--- @field keep_last_frame boolean
--- @field static boolean

--- @class WorldExample.Object.Sprite : Dummy.Object
local SpriteObject = Class(Object, "WorldExample.Object.Sprite")

SpriteObject.ALLOW_EDITOR = true

--- Creates a sprite object
--- @overload fun(self: WorldExample.Object.Sprite, x: number, y: number, sprite_name?: string|love.Image)
--- @param x number
--- @param y number
--- @param sprites_names string[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @param static? boolean wether the sprite is static (Defaults to `true`)
function SpriteObject:new(x, y, sprites_names, speed, loop, play, keep_last_frame, static)
  self = Class:new(SpriteObject)

  self:setSprite(sprites_names, speed, loop, play, keep_last_frame)
  self:setPosition(x, y)
  self:setStatic(Utils.getOrDefault(static, true))

  return self
end

--- Initializes the sprite object's arguments before creating it
--- @param data Dummy.Object.Sprite.Data
function SpriteObject.initArgs(data)
  --- @type string|string[]
  local sprite_names = data.frames or {}
  if #sprite_names == 1 then
    sprite_names = data.frames[1]
  end
  return data.x, data.y, sprite_names, data.speed, data.loop, data.play, data.keep_last_frame, data.static
end

--- Gets the sprite object metadata
--- @return Dummy.Editor.Metadata[]
function SpriteObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "frames",
      label = "WORLD_OBJECT_SPRITE_METADATA_FRAMES",
      type = "list",
      list_type = "string"
    },
    {
      id = "speed",
      label = "WORLD_OBJECT_SPRITE_METADATA_SPEED",
      type = "number",
      default = 0.03333,
      validate = function(value)
        return value >= 0
      end
    },
    {
      id = "loop",
      label = "WORLD_OBJECT_SPRITE_METADATA_LOOP",
      type = "boolean",
      default = true,
    },
    {
      id = "play",
      label = "WORLD_OBJECT_SPRITE_METADATA_PLAY",
      type = "boolean",
      default = true,
    },
    {
      id = "keep_last_frame",
      label = "WORLD_OBJECT_SPRITE_METADATA_KEEP_LAST_FRAME",
      type = "boolean",
      default = true,
    },
    {
      id = "static",
      label = "WORLD_OBJECT_SPRITE_METADATA_STATIC",
      type = "boolean",
      default = true,
    }
  }
end

--- Called when the sprite object form is confirmed in the editor
---
--- Note: Useful for modifying the object's data before it is added to the room
--- @param data Dummy.Object.Sprite.Data
function SpriteObject.onFormConfirm(data)
  if data.frames == nil or #data.frames <= 0 then return end

  local image = Sprite.loadImage(data.frames[1])
  if image.image ~= nil then
    data.width = math.max(Constants.TILE_SIZE, image.image:getWidth())
    data.height = math.max(Constants.TILE_SIZE, image.image:getHeight())
  end
end

--- Gets the sprite object's left position
--- @return number
function SpriteObject:getLeft()
  return Sprite.getLeft(self)
end

--- Gets the sprite object's right position
--- @return number
function SpriteObject:getRight()
  return Sprite.getRight(self)
end

--- Gets the sprite object's left position
--- @return number
function SpriteObject:getTop()
  return Sprite.getTop(self)
end

--- Gets the sprite object's right position
--- @return number
function SpriteObject:getBottom()
  return Sprite.getBottom(self)
end

--- @type table<string, Dummy.Sprite.Image|boolean>
local images_cache = {}

--- Draws the sprite object object for the editor
--- @param data Dummy.Object.Sprite.Data
function SpriteObject.drawEditor(data)
  local image_path = (data.frames or {})[1]
  if image_path == nil or image_path == "" then
    image_path = "editor/missing"
  end
  local success = true
  local image = images_cache[image_path]
  if image == nil then
    success, image = pcall(Sprite.loadImage, image_path)
    if not success then
      images_cache[image_path] = Sprite.loadImage("editor/missing")
      return
    end
    images_cache[image_path] = image
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(image.image, data.x, data.y)
end

return SpriteObject
