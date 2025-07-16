--[[
  Generated from ..\engine\drawable\sprite.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/sprite.lua
]]

---@meta

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
Sprite = {}

--- Gets the class name
--- @return string
function Sprite.getClassName() end

--- Clears the cache
function Sprite.clear() end

--- Loads a sprite
--- @param sprite_path string
--- @return love.Image
function Sprite.loadSprite(sprite_path) end

--- Gets the sprite's value
--- @return love.Image
function Sprite:getSprite() end

--- Sets the sprite's value
--- @overload fun(self: Dummy.Sprite, sprite_name: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
function Sprite:setSprite(sprites_names) end

--- Gets the sprite's image data
--- @return love.ImageData
function Sprite:getSpriteData() end

--- Gets the sprite's frames
--- @return love.Image[]
function Sprite:getFrames() end

--- Gets the sprite's width
--- @return number
function Sprite:getWidth() end

--- Gets the sprite's height
--- @return number
function Sprite:getHeight() end

--- Plays the sprite's animation
function Sprite:play() end

--- Stops the sprite's animation
function Sprite:stop() end

--- Wether the sprite's animation is playing
--- @return boolean
function Sprite:isPlaying() end

--- Sets the current sprite's animation frame
--- @param index number
function Sprite:setFrame(index) end

--- Gets the sprite's animation speed
--- @return number
function Sprite:getSpeed() end

--- Sets the sprite's animation speed
--- @param speed number
function Sprite:setSpeed(speed) end

--- Wether the sprite's animation loops
--- @return boolean
function Sprite:getLoop() end

--- Sets wether the sprite's animation loops
--- @param loop boolean
function Sprite:setLoop(loop) end

--- Gets the sprite's vaporize type
--- @return "pixel" | "line" | nil
function Sprite:getVaporizeType() end

--- Sets the sprite's vaporize type
--- @param type "pixel" | "line" | nil
function Sprite:setVaporizeType(type) end

--- Gets the sprite's vaporize size
--- @return number
function Sprite:getVaporizeSize() end

--- Sets the sprite's vaporize size
--- @param size number
function Sprite:setVaporizeSize(size) end

--- Makes the sprite vaporize
--- @param type? "pixel" | "line" wether the particles are pixels or lines (Defaults to `vaporize_type` if set, `"line"` if the sprite's width is greater than 120px, else `"pixel"`)
--- @param size? number size of the particles (Defaults to `vaporize_size` if set, else `2`)
function Sprite:vaporize(type, size) end

--- Draws the sprite
function Sprite:draw() end

--- Draws for debugging
function Sprite:drawDebug() end

--- Creates a sprite
--- @overload fun(self: Dummy.Sprite, sprite_name?: string|love.Image): Dummy.Sprite
--- @param sprites_names string[]|love.Image[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @return Dummy.Sprite
function Sprite:new(sprites_names, speed, loop, play, keep_last_frame) end

