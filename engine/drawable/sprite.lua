local self = {}

local function getSprite(sprite_path)
  local sprite_lang_path = "assets/sprites/" .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  local success, result = pcall(love.graphics.newImage, sprite_lang_path)
  if not success then
    success, result = pcall(love.graphics.newImage, "assets/sprites/" .. sprite_path .. ".png")
    assert(success, "Sprite \"" .. sprite_path .. "\" not found: ")
  end

  return result
end

--- Creates a sprite
---@overload fun(sprite: string): Dummy.Sprite
---@param frames table<number, string>
---@param speed? number time between frames, in seconds (Defaults to 1/30)
---@param loop? boolean loops the animation (Defaults to `true`)
---@return Dummy.Sprite
function self.new(frames, speed, loop)
  ---@class Dummy.Sprite : Dummy.Drawable
  ---
  ---@field private sprite love.Image
  ---@field private frames table
  ---@field private speed number
  ---@field private loop boolean
  ---@field private frame_index number
  ---@field private timer table
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
  ---@param sprite_name string|table<number, string>
  function sprite:setSprite(sprite_name)
    if sprite.sprite ~= nil then
      Scene.removeDrawable(sprite)
    end

    sprite.sprite = getSprite(sprite_name)
    sprite.sprite_name = sprite_name

    Scene.addDrawable(sprite)
  end

  if type(frames) == "table" then
    sprite.frames = {}
    sprite.frame_index = 1
    for _, frame in ipairs(frames) do
      table.insert(sprite.frames, getSprite(frame))
    end

    sprite.speed = Utils.getOrDefault(speed, 1 / 30)
    sprite.loop = Utils.getOrDefault(loop, true)

    Timer.every(sprite.speed, function()
      sprite.frame_index = (sprite.frame_index % #sprite.frames) + 1
    end)

    Scene.addDrawable(sprite)
  else
    sprite:setSprite(frames)
  end

  return sprite
end

return self
