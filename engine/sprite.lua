local self = {}

local function initSprite()
  local sprite = {}

  local mt = {}
  function mt.__index(_, key) return mt[key] end

  function mt.__newindex(_, key, value)
    mt[key] = value
    if key == "scale" and type(value) == "number" then
      mt[key] = { value, value }
    end
  end

  setmetatable(sprite, mt)

  return sprite
end

local function getSprite(sprite_path)
  local sprite_lang_path = "assets/sprites/" .. Lang.getLanguage() .. "/" .. sprite_path .. ".png"
  local success, drawable = pcall(love.graphics.newImage, sprite_lang_path)
  if not success then
    success, drawable = pcall(love.graphics.newImage, "assets/sprites/" .. sprite_path .. ".png")
    assert(success, "Sprite \"" .. sprite_path .. "\" not found")
  end

  return drawable
end

function self.createSprite(sprite_path)
  local sprite_data = initSprite()
  sprite_data.x = 0
  sprite_data.y = 0
  sprite_data.rotation = 0
  sprite_data.scale = { 1, 1 }
  sprite_data.origin = { 0.5, 0.5 }
  sprite_data.alpha = 1
  sprite_data.active = true
  sprite_data.sprite = getSprite(sprite_path)

  Scene.drawables[sprite_data.sprite] = sprite_data

  return sprite_data
end

return self
