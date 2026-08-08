--- @class Dummy.Room.Data
---
--- @field id string
--- @field width number
--- @field height number
--- @field tileset string
--- @field music string
--- @field tiles table<integer, Dummy.Tileset.TileData[]>
--- @field objects table<integer, Dummy.Object.Data[]>

--- @class Dummy.Room.Data.Form
---
--- @field width number
--- @field height number
--- @field tileset string
--- @field music string

--- @class Dummy.Room : Dummy.Class
---
--- @field protected id string
--- @field protected name string
--- @field protected width number
--- @field protected height number
--- @field protected music string|nil
--- @field protected music_seek number
--- @field protected tileset Dummy.Tileset
--- @field protected objects Dummy.Object.Data[]
--- @field protected objects_container Dummy.Drawable
--- @field protected need_to_sort_children boolean
local Room = Class("Dummy.Room")

--- Creates a room
--- @param room_id string
--- @param room_name string
--- @param width number
--- @param height number
--- @return Dummy.Room
function Room:new(room_id, room_name, width, height)
  self = Class:new(Room)

  self.id = room_id
  self.name = room_name
  self.width = width
  self.height = height

  self.music_seek = 0

  self.objects = {}

  self.need_to_sort_children = false

  self:setTileset("default")
  self:initContainer()

  return self
end

--- Initializes the room's container
function Room:initContainer()
  self.objects_container = Drawable:new()
  self.objects_container:setLayer(Constants.LAYERS.WORLD_OBJECT)

  function self.objects_container.sortChildren()
    self.need_to_sort_children = true
  end

  function self.objects_container.drawDebug(_, camera)
    if not Debug.shouldDisplayHitbox() then return end

    love.graphics.push()
    love.graphics.origin()

    camera:apply()

    love.graphics.setColor(0, 1, 0, 1)
    for _, obj in ipairs(self:getObjectsByType(SolidObject)) do
      if obj:is(SolidTriangleObject) then
        local obj_tri = obj --[[@as Dummy.Object.SolidTriangle]]
        local x, y = obj_tri:getHitbox()
        local ax, ay, bx, by, cx, cy = table.unpack(obj_tri.hitbox_triangle_debug)
        love.graphics.polygon("line", x + ax, y + ay, x + bx, y + by, x + cx, y + cy)
      else
        local _, _, hitbox_width, hitbox_height = obj:getHitbox()
        love.graphics.rectangle("line", obj:getLeft() + 0.5, obj:getTop() + 0.5, hitbox_width - 1, hitbox_height - 1)
      end
    end

    love.graphics.pop()
  end
end

--- Gets the room's id
--- @return string
function Room:getId()
  return self.id
end

--- Gets the room's name
--- @return string
function Room:getName()
  if self.name == nil or self.name == "" then return "--" end
  return self.name
end

--- Gets the room's width
--- @return number
function Room:getWidth()
  return self.width
end

--- Gets the room's height
--- @return number
function Room:getHeight()
  return self.height
end

--- Gets the room's tileset
--- @return Dummy.Tileset
function Room:getTileset()
  return self.tileset
end

--- Sets the room's tileset
--- @param tileset_name string
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
function Room:setTileset(tileset_name, tiles)
  if self.tileset ~= nil then
    self.tileset:remove()
  end

  local image = Sprite.loadImage("world/tileset/" .. tileset_name, false)
  assert(image.image ~= nil, "Tileset \"" .. tileset_name .. "\" not found")

  self.tileset = Tileset:new(image, self:getWidth(), self:getHeight(), tiles)
  self.tileset:setLayer(Constants.LAYERS.WORLD_BACKGROUND)
  self.tileset:setVisible(false)
end

--- Sets the tile from a tileset at a position
--- @param index integer
--- @param x number
--- @param y number
function Room:setTile(index, x, y)
  self.tileset:setTile(index, x, y)
end

--- Gets the room's music
--- @return string|nil
function Room:getMusic()
  return self.music
end

--- Sets the room's music
--- @param music string|nil
function Room:setMusic(music)
  self.music = music
end

--- Gets the room's music seek
--- @return number
function Room:getMusicSeek()
  return self.music_seek
end

--- Sets the room's music seek
--- @param music_seek number
function Room:setMusicSeek(music_seek)
  self.music_seek = music_seek
end

--- Gets the room's objects
--- @return Dummy.Object[]
function Room:getObjects()
  return self.objects_container:getChildren()
end

--- Gets the room objects by type
--- @generic T : Dummy.Object
--- @param object T
--- @return T[]
function Room:getObjectsByType(object)
  --- @type Dummy.Object[]
  local objs = {}
  for _, obj in ipairs(self:getObjects()) do
    if obj:is(object) then
      table.insert(objs, obj)
    end
  end
  return objs
end

--- Adds an object to the room
--- @param obj Dummy.Object
function Room:addObject(obj)
  self.objects_container:addChild(obj)
end

--- Removes an object from the room
--- @param obj Dummy.Object
function Room:removeObject(obj)
  self.objects_container:removeChild(obj)
end

--- Gets the room's interactable objects
--- @return Dummy.Object[]
function Room:getInteractableObjects()
  local objects = self:getObjects()
  --- @type Dummy.Object[]
  local objs = {}
  for _, obj in ipairs(objects) do
    if obj:isVisible() and obj:canInteract() then
      table.insert(objs, obj)
    end
  end
  return objs
end

--- Wether the room is active
--- @return boolean
function Room:isActive()
  return World.getCurrentRoom() == self
end

--- Enters the room
--- @param spawn_x number
--- @param spawn_y number
--- @param player_facing? Dummy.Object.Facing
--- @param instant? boolean wether the room transition is instant (Defaults to `false`)
function Room:enter(spawn_x, spawn_y, player_facing, instant)
  if not instant then
    Fader.fadeOut(12 / 30, "linear")
  end

  self.tileset:setVisible(true)

  local obj_player = PlayerObject:new()
  obj_player:setPosition(spawn_x + obj_player:getWidth() / 2, spawn_y + obj_player:getHeight() / 2)
  if player_facing ~= nil then
    obj_player:setFacing(player_facing)
  end

  local world_scene = Scene.getCurrentScene() --[[@as Dummy.Scene.World]]
  world_scene:getCamera():setTarget(obj_player)

  for _, obj_data in ipairs(self.objects or {}) do
    --- @type Dummy.Object
    local Object
    if obj_data.mod_id ~= nil then
      Object = modRequire("scripts.world.object." .. obj_data.type)
    else
      Object = require("world.object." .. obj_data.type) --[[@as Dummy.Object]]
    end

    local args = {}
    if type(Object.initArgs) == "function" then
      args = { Object.initArgs(obj_data) }
    end
    ---@diagnostic disable-next-line: redundant-parameter
    Object:new(table.unpack(args))
  end

  Timer.next(function()
    if self.onEnter ~= nil then
      self:onEnter()
    end

    local mod = ModList.getCurrentMod()
    if mod ~= nil and type(mod.onRoomEnter) == "function" then
      mod:onRoomEnter(self)
    end
  end)
end

--- Leaves the room
function Room:leave()
  self.objects_container:remove()
  self.tileset:remove()

  World.getTextbox():setVisible(false)

  if self.onLeave ~= nil then
    self:onLeave()
  end

  local mod = ModList.getCurrentMod()
  if mod ~= nil and type(mod.onRoomLeave) == "function" then
    mod:onRoomLeave(self)
  end
end

--- Parses a room data
--- @param mod_id string
--- @param room_id string
--- @return Dummy.Room.Data|nil
function Room.parseRoomData(mod_id, room_id)
  local success = false
  local room_data

  local filename = "mods/" .. mod_id .. "/scripts/world/room/" .. UTF8.lower(Utils.sanitizeFilename(room_id)) .. ".json"
  success, room_data = pcall(love.filesystem.read, filename)
  if not success or room_data == nil then return end

  success, room_data = pcall(JSON.decode, room_data)
  if not success or room_data == nil then return end

  return room_data --[[@as Dummy.Room.Data]]
end

--- Loads the room data
--- @param room_id? string
function Room:loadData(room_id)
  room_id = Utils.getOrDefault(room_id, self:getId())

  local mod = ModList.getCurrentMod()
  assert(mod ~= nil, "Cannot load room outside of a mod")

  local room_data = Room.parseRoomData(mod:getId(), room_id)
  assert(room_data ~= nil, "Failed to load room \"" .. room_id .. "\"")

  self.width = room_data.width
  self.height = room_data.height

  --- @type string|nil
  local music = room_data.music
  if music == "none" then music = nil end
  self:setMusic(music)

  self:setTileset(room_data.tileset, room_data.tiles)

  self.objects = room_data.objects
end

--- Called when the room is entered
function Room:onEnter() end

--- Called when the room is left
function Room:onLeave() end

--- Called when the room is paused
function Room:onPause() end

--- Called when the room is resumed
function Room:onResume() end

--- Updates the room, called on every game update
--- @param dt number
function Room:update(dt)
  if self.need_to_sort_children then
    local children = self.objects_container:getChildren() --[[@as table<number, Dummy.Object>]]
    if #children > 0 then
      table.stable_sort(children, function(a, b)
        local a_layer = a:getLayer() or 0
        local b_layer = b:getLayer() or 0
        if a_layer == b_layer then
          return (a:getDepth() or 0) < (b:getDepth() or 0)
        end

        return (a_layer or 0) < (b_layer or 0)
      end)
    end

    self.need_to_sort_children = false
  end
end

return Room
