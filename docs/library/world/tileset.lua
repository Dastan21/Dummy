--[[
  Generated from ..\engine\world\tileset.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/tileset.lua
]]

---@meta

--- @class Dummy.Tileset : Dummy.Drawable
---
--- @field protected tile_name string
--- @field protected room_width number
--- @field protected room_height number
--- @field protected batch love.SpriteBatch
--- @field protected quads table<number, love.Quad>
--- @field protected tiles table<number, Dummy.Tileset.TileData>
Tileset = {}

--- @class Dummy.Tileset.TileData
---
--- @field index number
--- @field x number
--- @field y number

--- Creates a tile set
--- @param tile_name string
--- @param room_width number
--- @param room_height number
--- @return Dummy.Tileset
function Tileset:new(tile_name, room_width, room_height) end

--- Builds the tileset
--- @param image love.Image
--- @param tiles? table<number, Dummy.Tileset.TileData>
function Tileset:build(image, tiles) end

--- Sets the tile at a position
--- @param index integer
--- @param x number
--- @param y number
function Tileset:setTile(index, x, y) end

--- Cleans the tileset
function Tileset:clean() end

--- Removes the tile set from the scene
function Tileset:remove() end

--- Draws the tile set
function Tileset:draw() end

