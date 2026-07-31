--- @class Dummy.Object.RoomTransition : Dummy.Object
---
--- @field protected room_id string
--- @field protected spawn_x number
--- @field protected spawn_y number
--- @field protected instant boolean
--- @field protected enabled boolean
local RoomTransitionObject = Class(Object, "Dummy.Object.RoomTransition")

--- Creates a room transition
--- @param room_id string
--- @param spawn_x number
--- @param spawn_y number
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
--- @param instant? boolean wether the room transition is instant (Defaults to `false`)
function RoomTransitionObject:new(room_id, spawn_x, spawn_y, x, y, width, height, instant)
  self = Class:new(RoomTransitionObject)

  self.room_id = room_id
  self.spawn_x = spawn_x
  self.spawn_y = spawn_y
  self.width = Utils.getOrDefault(width, 20)
  self.height = Utils.getOrDefault(height, 20)
  self.instant = Utils.getOrDefault(instant, false)
  self.enabled = true

  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setOrigin(0, 0)
  self:setPosition(x, y)
  self:setHitbox(0, 0, self.width, self.height)
  self:setAlpha(0)

  return self
end

--- Gets wether the room transition is enabled
--- @return boolean
function RoomTransitionObject:isEnabled()
  return self.enabled
end

--- Sets wether the room transition is enabled
--- @param enabled boolean
function RoomTransitionObject:setEnabled(enabled)
  self.enabled = enabled
end

--- Called when the room transition collides with another object
--- @param data Dummy.Object.CollisionData
function RoomTransitionObject:onCollisionSolid(data)
  if not self:isEnabled() then return end

  if data.collider:is(PlayerObject) then
    local obj_player = Player.getObject()
    if obj_player:getInteraction() == "room_transition" then return end

    obj_player:setInteraction("room_transition")

    World.transitionRoom(self.room_id, self.spawn_x, self.spawn_y, self.instant)
  end
end

--- Draws the room transition's hitbox for debugging
--- @param camera Dummy.Camera
function RoomTransitionObject:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() or not self:isCollisionEnabled() then return end

  local hitbox_left, hitbox_top, hitbox_width, hitbox_height = self:getHitbox()
  if hitbox_width == 0 and hitbox_height == 0 then return end

  local absolute_transform = self:getAbsoluteTransform()

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  -- draw hitbox
  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getWidth(), self:getHeight()
  local x = hitbox_left - origin_x * width
  local y = hitbox_top - origin_y * height
  local x1, y1 = absolute_transform:transformPoint(x, y)
  local x2, y2 = absolute_transform:transformPoint(x + hitbox_width, y)
  local x3, y3 = absolute_transform:transformPoint(x + hitbox_width, y + hitbox_height)
  local x4, y4 = absolute_transform:transformPoint(x, y + hitbox_height)
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)

  love.graphics.pop()
end

return RoomTransitionObject
