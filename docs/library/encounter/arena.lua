--[[
  Generated from ..\engine\encounter\arena.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/arena.lua
]]

---@meta

--- @class Dummy.Arena
---
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
--- @field protected target_x number
--- @field protected target_y number
--- @field protected target_width number
--- @field protected target_height number
--- @field protected resize_callback fun()|nil
--- @field protected move_callback fun()|nil
--- @field protected arena_background_drawable Dummy.Drawable
--- @field protected arena_border_drawable Dummy.Drawable
Arena = {}

--- Loads the arena
function Arena.load() end

--- Updates the arena
function Arena.update(dt) end

--- Resizes the arena
--- @param width number target width of the arena
--- @param height number target height of the arena
--- @param instant? boolean resizes the arena instantly (Defaults to `false`)
--- @param resize_callback? fun() called when the resize is done
function Arena.resize(width, height, instant, resize_callback) end

--- Moves the arena relative from the center-bottom
--- @param x number target x position of the arena
--- @param y number target y position of the arena
--- @param instant? boolean moves the arena instantly (Defaults to `false`)
--- @param move_callback? fun() called when the move is done
function Arena.move(x, y, instant, move_callback) end

--- Moves the arena absolute
--- @param x number target x position of the arena
--- @param y number target y position of the arena
--- @param instant? boolean moves the arena instantly (Defaults to `false`)
--- @param move_callback? fun() called when the move is done
function Arena.moveAbsolute(x, y, instant, move_callback) end

--- Resets the arena's bounds
--- @param reset_callback? fun() called when the reset is done
function Arena.reset(reset_callback) end

--- Gets the arena's position
--- @return number, number
function Arena.getPosition() end

--- Gets the arena's width
--- @return number
function Arena.getWidth() end

--- Gets the arena's height
--- @return number
function Arena.getHeight() end

--- Wether the point is in the arena bounds
--- @param x number
--- @param y number
--- @return boolean
function Arena.isInBounds(x, y) end

--- Creates a mask for the arena
--- @return Dummy.Mask
function Arena.createMask() end

--- Gets the arena's background drawable
--- @return Dummy.Drawable
function Arena.getBackgroundDrawable() end

--- Gets the arena's border drawable
--- @return Dummy.Drawable
function Arena.getBorderDrawable() end

