--[[
  Generated from ..\engine\encounter\arena.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/arena.lua
]]

---@meta

--- @class Dummy.Arena
---
--- @field private x number
--- @field private y number
--- @field private width number
--- @field private height number
--- @field private target_x number
--- @field private target_y number
--- @field private target_width number
--- @field private target_height number
--- @field private resize_callback fun()|nil
--- @field private move_callback fun()|nil
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
---@param x number target x position of the arena
---@param y number target y position of the arena
--- @param instant? boolean moves the arena instantly (Defaults to `false`)
--- @param move_callback? fun() called when the move is done
function Arena.move(x, y, instant, move_callback) end

--- Resets the arena bounds
--- @param reset_callback? fun() called when the reset is done
function Arena.reset(reset_callback) end

--- Gets the arena position
--- @return number, number
function Arena.getPosition() end

--- Gets the arena width
--- @return number
function Arena.getWidth() end

--- Gets the arena height
--- @return number
function Arena.getHeight() end

