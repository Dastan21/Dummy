--- @class WorldExample.Object.Sprite : Dummy.Object
local SpriteObject = Class(Object, "WorldExample.Object.Sprite")

--- Creates a sprite
--- @overload fun(self: WorldExample.Object.Sprite, x: number, y: number, sprite_name?: string|love.Image)
--- @param x number
--- @param y number
--- @param sprites_names string[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
function SpriteObject:new(x, y, sprites_names, speed, loop, play, keep_last_frame)
  self = Class:new(SpriteObject)

  self:setSprite(sprites_names, speed, loop, play, keep_last_frame)
  self:setOrigin(0, 0)
  self:setPosition(x, y)
  self:setStatic(true)

  return self
end

return SpriteObject
