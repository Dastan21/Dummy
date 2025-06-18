--[[
  Generated from ..\engine\drawable\sprite.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/sprite.lua
]]

---@meta

--- @class Dummy.Sprite : Dummy.Drawable
---
--- @field protected sprite love.Image
--- @field protected frames table
--- @field protected speed number
--- @field protected loop boolean
--- @field protected keep_last_frame boolean
--- @field protected frame_index number
--- @field protected timer table|nil
Sprite = {}

--- Gets the class name
--- @return string
function Sprite:getClass() end

--- Clears the cache
function Sprite.clear() end

--- Gets the sprite's value
--- @return love.Image
function Sprite:getSprite() end

--- Sets the sprite's value
--- @overload fun(self: Dummy.Sprite, sprite_name: string): Dummy.Sprite
--- @param sprites_names string[]
function Sprite:setSprite(sprites_names) end

--- Gets the sprite's width
---@return number
function Sprite:getWidth() end

--- Gets the sprite's height
---@return number
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

--- Transforms the sprite into dust
function Sprite:dust() end

--- Creates a sprite
--- @overload fun(self: Dummy.Sprite, sprite_name: string): Dummy.Sprite
--- @param sprites_names string[]
--- @param speed? number time between frames, in seconds (Defaults to 1/30)
--- @param loop? boolean loops the animation (Defaults to `true`)
--- @param play? boolean wether the animation should start playing instantly (Defaults to `true`)
--- @param keep_last_frame? boolean stays on the last frame in oneshot animation (Defaults to `true`)
--- @return Dummy.Sprite
function Sprite:new(sprites_names, speed, loop, play, keep_last_frame) end

