--[[
  Generated from ..\engine\world\tileset.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/tileset.lua
]]

---@meta

--- @class Dummy.Tileset : Dummy.Drawable
---
--- @field protected room_width number
--- @field protected room_height number
--- @field protected image Dummy.Sprite.Image
--- @field protected batches table<integer, love.SpriteBatch>
--- @field protected quads table<number, love.Quad>
--- @field protected tiles table<integer, Dummy.Tileset.TileData[]>
Tileset = {}

--- @class Dummy.Tileset.TileData
---
--- @field index number
--- @field x number
--- @field y number

--- Creates a tileset
--- @param image Dummy.Sprite.Image
--- @param room_width number
--- @param room_height number
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
--- @return Dummy.Tileset
function Tileset:new(image, room_width, room_height, tiles) end

--- Loads the tileset
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
--- @return table<integer, Dummy.Tileset.TileData[]>
function Tileset:loadTileset(tiles) end

--- Builds the tileset
--- @param tiles? Dummy.Tileset.TileData[]
--- @param layer? integer
--- @return Dummy.Tileset.TileData[]|nil
function Tileset:build(tiles, layer) end

--- Sets the tile at a position
--- @param index integer
--- @param x number
--- @param y number
--- @param layer? number
--- @return boolean
function Tileset:setTile(index, x, y, layer) end

--- Gets the total number of tiles
--- @return integer
function Tileset:getTotalTiles() end

--- Gets the tileset's image
--- @return love.Image
function Tileset:getImage() end

--- Gets the quad for a tile
--- @param index integer
--- @return love.Quad|nil
function Tileset:getQuad(index) end

--- Gets the batch for a layer
--- @param layer integer
--- @return love.SpriteBatch|nil
function Tileset:getBatch(layer) end

--- Cleans the tileset
function Tileset:clean() end

--- Removes the tileset from the scene
function Tileset:remove() end

--- Draws the tileset
function Tileset:draw() end

