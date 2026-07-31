--- @class Dummy.Tileset.TileData
---
--- @field index number
--- @field x number
--- @field y number

--- @class Dummy.Tileset : Dummy.Drawable
---
--- @field protected tile_name string
--- @field protected room_width number
--- @field protected room_height number
--- @field protected batch love.SpriteBatch
--- @field protected quads table<number, love.Quad>
--- @field protected tiles table<number, Dummy.Tileset.TileData>
local Tileset = Class(Drawable, "Dummy.Tileset")

--- Creates a tile set
--- @param tile_name string
--- @param room_width number
--- @param room_height number
--- @return Dummy.Tileset
function Tileset:new(tile_name, room_width, room_height)
  self = Class:new(Tileset)

  self.room_width = Utils.getOrDefault(room_width, 320)
  self.room_height = Utils.getOrDefault(room_height, 240)

  self.tile_name = tile_name
  local image = Sprite.loadImage("world/tileset/" .. self.tile_name).image
  if image ~= nil then
    self:build(image)
  end

  --- @param reloaded_image Dummy.Sprite.Image
  Signal.on("hot_reload_sprite", function(reloaded_image)
    local sprite_path = "world/tileset/" .. self.tile_name
    if reloaded_image.sprite_path ~= sprite_path then return end

    self:build(reloaded_image.image, table.copy(self.tiles))
  end)

  return self
end

--- Builds the tileset
--- @param image love.Image
--- @param tiles? table<number, Dummy.Tileset.TileData>
function Tileset:build(image, tiles)
  self:clean()

  self.width, self.height = image:getDimensions()
  self.batch = love.graphics.newSpriteBatch(image)

  local size = Constants.TILE_SIZE
  local cols = math.ceil(self.width / size)
  local rows = math.ceil(self.height / size)
  for y = 0, (rows - 1) do
    for x = 0, cols do
      local quad = love.graphics.newQuad(x * size, y * size, size, size, self.width, self.height)
      self.quads[x + y * cols] = quad
    end
  end

  if tiles ~= nil and #tiles > 0 then
    for _, tile in ipairs(tiles) do
      self:setTile(tile.index, tile.x, tile.y)
    end
  end
end

--- Sets the tile at a position
--- @param index integer
--- @param x number
--- @param y number
function Tileset:setTile(index, x, y)
  local quad = self.quads[index]
  assert(quad ~= nil, "Tile " .. index .. " in " .. self.tile_name .. " not found")

  self.batch:add(quad, math.ceil(x), math.ceil(y))
  table.insert(self.tiles, {
    index = index,
    x = x,
    y = y
  })
end

--- Cleans the tileset
function Tileset:clean()
  if self.batch ~= nil then
    self.batch:clear()
    self.batch:release()
    self.batch = nil
  end

  if self.quads ~= nil then
    for _, quad in pairs(self.quads) do
      quad:release()
    end
  end
  self.quads = {}

  self.tiles = {}
end

--- Removes the tile set from the scene
function Tileset:remove()
  if self:isRemoved() then return end

  self:clean()

  Drawable.remove(self)
end

--- Draws the tile set
function Tileset:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.batch)
end

return Tileset
