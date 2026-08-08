--- @class Dummy.Tileset.TileData
---
--- @field index number
--- @field x number
--- @field y number

--- @class Dummy.Tileset : Dummy.Drawable
---
--- @field protected room_width number
--- @field protected room_height number
--- @field protected image Dummy.Sprite.Image
--- @field protected batches table<integer, love.SpriteBatch>
--- @field protected quads table<number, love.Quad>
--- @field protected tiles table<integer, Dummy.Tileset.TileData[]>
local Tileset = Class(Drawable, "Dummy.Tileset")

--- Creates a tileset
--- @param image Dummy.Sprite.Image
--- @param room_width number
--- @param room_height number
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
--- @return Dummy.Tileset
function Tileset:new(image, room_width, room_height, tiles)
  self = Class:new(Tileset)

  self.room_width = Utils.getOrDefault(room_width, 320)
  self.room_height = Utils.getOrDefault(room_height, 240)

  self.image = image
  self.batches = {}

  self:loadTileset(tiles)

  --- @param reloaded_image Dummy.Sprite.Image
  Signal.on("hot_reload_sprite", function(reloaded_image)
    if reloaded_image.sprite_path ~= self.image.sprite_path then return end

    self:loadTileset(table.copy(self.tiles))
  end)

  return self
end

--- Loads the tileset
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
--- @return table<integer, Dummy.Tileset.TileData[]>
function Tileset:loadTileset(tiles)
  self:clean()

  self.width, self.height = self.image.image:getDimensions()
  self.batches = { love.graphics.newSpriteBatch(self.image.image) }

  local size = Constants.TILE_SIZE
  local cols = math.ceil(self.width / size)
  local rows = math.ceil(self.height / size)
  for y = 0, (rows - 1) do
    for x = 0, (cols - 1) do
      local quad = love.graphics.newQuad(x * size, y * size, size, size, self.width, self.height)
      self.quads[x + y * cols] = quad
    end
  end

  --- @type table<integer, Dummy.Tileset.TileData[]>
  local ret_tiles = {}

  if tiles ~= nil then
    for layer in pairs(tiles) do
      ret_tiles[layer] = self:build(tiles[layer], layer)
    end
  end

  return ret_tiles
end

--- Builds the tileset
--- @param tiles? Dummy.Tileset.TileData[]
--- @param layer? integer
--- @return Dummy.Tileset.TileData[]|nil
function Tileset:build(tiles, layer)
  if layer == nil then
    self.batches[1]:clear()
  else
    for l, batch in pairs(self.batches) do
      if l == layer then
        batch:clear()
        break
      end
    end
  end

  if tiles ~= nil then
    layer = math.max(1, Utils.getOrDefault(layer, 1))

    --- @type Dummy.Tileset.TileData[]
    local ret_tiles = {}
    for key, tile in pairs(tiles) do
      local added = self:setTile(tile.index, tile.x, tile.y, layer)
      if added then
        ret_tiles[key] = tile
      end
    end

    return ret_tiles
  end
end

--- Sets the tile at a position
--- @param index integer
--- @param x number
--- @param y number
--- @param layer? number
--- @return boolean
function Tileset:setTile(index, x, y, layer)
  layer = math.max(1, Utils.getOrDefault(layer, 1))

  local quad = self:getQuad(index)
  if quad == nil then return false end

  local batch = self.batches[layer]
  if batch == nil then
    batch = love.graphics.newSpriteBatch(self.image.image)
    self.batches[layer] = batch
  end

  batch:add(quad, math.ceil(x), math.ceil(y))

  if self.tiles[layer] == nil then
    self.tiles[layer] = {}
  end

  table.insert(self.tiles[layer], {
    index = index,
    x = x,
    y = y
  })

  return true
end

--- Gets the total number of tiles
--- @return integer
function Tileset:getTotalTiles()
  return #self.quads + 1
end

--- Gets the tileset's image
--- @return love.Image
function Tileset:getImage()
  return self.image.image
end

--- Gets the quad for a tile
--- @param index integer
--- @return love.Quad|nil
function Tileset:getQuad(index)
  return self.quads[index]
end

--- Gets the batch for a layer
--- @param layer integer
--- @return love.SpriteBatch|nil
function Tileset:getBatch(layer)
  return self.batches[layer]
end

--- Cleans the tileset
function Tileset:clean()
  for _, batch in pairs(self.batches) do
    batch:clear()
    batch:release()
  end
  self.batches = {}

  if self.quads ~= nil then
    for _, quad in pairs(self.quads) do
      quad:release()
    end
  end
  self.quads = {}

  self.tiles = {}
end

--- Removes the tileset from the scene
function Tileset:remove()
  if self:isRemoved() then return end

  self:clean()

  Drawable.remove(self)
end

--- Draws the tileset
function Tileset:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  love.graphics.setColor(self:getColor())
  for _, batch in pairs(self.batches) do
    love.graphics.draw(batch)
  end
end

return Tileset
