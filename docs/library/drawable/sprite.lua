--[[
  Generated from ..\engine\drawable\sprite.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/sprite.lua
]]

---@meta

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
Sprite = {}

--- @class Dummy.Sprite.Image
---
--- @field image love.Image|nil
--- @field image_data love.ImageData|nil
--- @field timestamp number
--- @field sprite_path string
--- @field full_sprite_path string

--- Clears the cache
function Sprite.clear() end

--- Loads a sprite
--- @param sprite_path string
--- @param force? boolean
--- @param base_folder? string
--- @return Dummy.Sprite.Image
function Sprite.loadImage(sprite_path, force, base_folder) end

--- Loads a sprite from a folder
--- @param sprite_path string
--- @param force? boolean
--- @return Dummy.Sprite.Image|string
--- @private
function Sprite.loadImageFromFolder(base_sprites_path, sprite_path, force) end

--- Loads the sprite cached from an image
--- @param image love.Image|nil
function Sprite.loadSpriteFromImage(image) end

--- Reloads the sprite if it has changed
function Sprite.hotReload() end

--- Gets the sprite's image
--- @return Dummy.Sprite.Image|nil
function Sprite:getSprite() end

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
function Sprite:setSprite(sprites_names, speed, loop, play, keep_last_frame, remove_when_done) end

--- Gets the sprite's love image
--- @return love.Image|nil
function Sprite:getImage() end

--- Gets the sprite's image data
--- @return love.ImageData|nil
function Sprite:getImageData() end

--- Wether the sprite is flipped horizontally
--- @return boolean
function Sprite:getFlipX() end

--- Sets wether the sprite is flipped horizontally
--- @param flip_x boolean
function Sprite:setFlipX(flip_x) end

--- Wether the sprite is flipped vertically
--- @return boolean
function Sprite:getFlipY() end

--- Sets wether the sprite is flipped vertically
--- @param flip_y boolean
function Sprite:setFlipY(flip_y) end

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

--- Gets the current sprite's animation frame
--- @return number
function Sprite:getFrame() end

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

--- Removes the sprite from the current scene
function Sprite:remove() end

--- Draws the sprite
--- @param camera Dummy.Camera
function Sprite:draw(camera) end

--- Draws the sprite's bounding box for debugging
--- @param camera Dummy.Camera
function Sprite:drawDebug(camera) end

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
function Sprite:new(sprites_names, speed, loop, play, keep_last_frame, remove_when_done) end

