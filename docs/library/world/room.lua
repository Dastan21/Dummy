--[[
  Generated from ..\engine\world\room.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/room.lua
]]

---@meta

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
Room = {}

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

--- Creates a room
--- @param room_id string
--- @param room_name string
--- @param width number
--- @param height number
--- @return Dummy.Room
function Room:new(room_id, room_name, width, height) end

--- Initializes the room's container
function Room:initContainer() end

--- Gets the room's id
--- @return string
function Room:getId() end

--- Gets the room's name
--- @return string
function Room:getName() end

--- Gets the room's width
--- @return number
function Room:getWidth() end

--- Gets the room's height
--- @return number
function Room:getHeight() end

--- Gets the room's tileset
--- @return Dummy.Tileset
function Room:getTileset() end

--- Sets the room's tileset
--- @param tileset_name string
--- @param tiles? table<integer, Dummy.Tileset.TileData[]>
function Room:setTileset(tileset_name, tiles) end

--- Sets the tile from a tileset at a position
--- @param index integer
--- @param x number
--- @param y number
function Room:setTile(index, x, y) end

--- Gets the room's music
--- @return string|nil
function Room:getMusic() end

--- Sets the room's music
--- @param music string|nil
function Room:setMusic(music) end

--- Gets the room's music seek
--- @return number
function Room:getMusicSeek() end

--- Sets the room's music seek
--- @param music_seek number
function Room:setMusicSeek(music_seek) end

--- Gets the room's objects
--- @return Dummy.Object[]
function Room:getObjects() end

--- Gets the room objects by type
--- @generic T : Dummy.Object
--- @param object T
--- @return T[]
function Room:getObjectsByType(object) end

--- Adds an object to the room
--- @param obj Dummy.Object
function Room:addObject(obj) end

--- Removes an object from the room
--- @param obj Dummy.Object
function Room:removeObject(obj) end

--- Gets the room's interactable objects
--- @return Dummy.Object[]
function Room:getInteractableObjects() end

--- Wether the room is active
--- @return boolean
function Room:isActive() end

--- Enters the room
--- @param spawn_x number
--- @param spawn_y number
--- @param player_facing? Dummy.Object.Facing
--- @param instant? boolean wether the room transition is instant (Defaults to `false`)
function Room:enter(spawn_x, spawn_y, player_facing, instant) end

--- Leaves the room
function Room:leave() end

--- Parses a room data
--- @param mod_id string
--- @param room_id string
--- @return Dummy.Room.Data|nil
function Room.parseRoomData(mod_id, room_id) end

--- Loads the room data
--- @param room_id? string
function Room:loadData(room_id) end

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
function Room:update(dt) end

