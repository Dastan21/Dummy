--- @class Dummy.Room : Dummy.Class
---
--- @field protected id string
--- @field protected name string
--- @field protected width number
--- @field protected height number
--- @field protected music string|nil
--- @field protected music_seek number
--- @field protected tile_set Dummy.Tileset
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

--- Gets the room's tile set
--- @return Dummy.Tileset
function Room:getTileset()
  return self.tile_set
end

--- Sets the room's tile set
--- @param tileset_name string
function Room:setTileset(tileset_name)
  if self.tile_set ~= nil then
    self.tile_set:remove()
  end

  self.tile_set = Tileset:new(tileset_name, self:getWidth(), self:getHeight())
  self.tile_set:setLayer(Constants.LAYERS.WORLD_BACKGROUND)
  self.tile_set:setVisible(false)
end

--- Sets the tile from a tile set at a position
--- @param index integer
--- @param x number
--- @param y number
function Room:setTile(index, x, y)
  self.tile_set:setTile(index, x, y)
end

--- Gets the room's music
--- @return string|nil
function Room:getMusic()
  return self.music
end

--- Sets the room's music
--- @param music string
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

  self.tile_set:setVisible(true)

  local obj_player = PlayerObject:new()
  obj_player:setPosition(spawn_x + obj_player:getWidth() / 2, spawn_y + obj_player:getHeight() / 2)
  if player_facing ~= nil then
    obj_player:setFacing(player_facing)
  end

  local world_scene = Scene.getCurrentScene() --[[@as Dummy.Scene.World]]
  world_scene:getCamera():setTarget(obj_player)

  if self.onEnter ~= nil then
    self:onEnter()
  end

  local mod = ModList.getCurrentMod()
  if mod ~= nil and type(mod.onRoomEnter) == "function" then
    mod:onRoomEnter(self)
  end
end

--- Leaves the room
function Room:leave()
  self.objects_container:remove()
  self.tile_set:remove()

  if self.onLeave ~= nil then
    self:onLeave()
  end

  local mod = ModList.getCurrentMod()
  if mod ~= nil and type(mod.onRoomLeave) == "function" then
    mod:onRoomLeave(self)
  end
end

--- Called when the room is entered
---
--- Note: Initialize all he room's objects here
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
    local children = self.objects_container:getChildren()
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
