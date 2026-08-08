--- @alias Dummy.Hitbox [ number, number, number, number ]
--- @alias Dummy.Object.Facing "down" | "right" | "up" | "left"

--- @class Dummy.Object.Data
---
--- @field id integer
--- @field type string
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field mod_id? string

--- @class Dummy.Object.ExtraData
---
--- @field class Dummy.Object
--- @field [string] unknown

--- @class Dummy.Object.CollisionData
---
--- @field collider Dummy.Object
--- @field direction_x number
--- @field direction_y number
--- @field moved_x number
--- @field moved_y number
--- @field amount_x number
--- @field amount_y number

--- @class Dummy.Object : Dummy.Sprite
---
--- @field protected collision_enabled boolean
--- @field protected collision_solid boolean
--- @field protected hitbox Dummy.Hitbox
--- @field protected can_interact boolean
--- @field protected depth number
--- @field protected static boolean
--- @field EDITOR_SPRITE string|nil
--- @field ALLOW_EDITOR boolean|nil
local Object = Class(Sprite, "Dummy.Object")

--- Creates an object
function Object:new()
  self = Class:new(Object)

  self.collision_enabled = false
  self.collision_solid = false
  self.can_interact = false
  self.hitbox = { 0, 0, 0, 0 }
  self.depth = 0
  self.static = false

  self:setOrigin(0, 0)
  self:setLayer(Constants.LAYERS.WORLD_OBJECT)

  local room = World.getCurrentRoom()
  assert(room ~= nil, "Objects cannot be added outside of a room")

  room:addObject(self)

  return self
end

--- Initializes the object's arguments before creating it
---
--- Note: This function is called for objects provided by the editor
--- @param data Dummy.Object.Data
function Object.initArgs(data)
  return data.x, data.y, data.width, data.height
end

--- Gets the object's metadata
--- @return Dummy.Editor.Metadata[]
function Object.getMetadata()
  return {}
end

--- Called when the object form is confirmed in the editor
---
--- Note: Useful for modifying the object's data before it is added to the room
--- @param data Dummy.Object.Data
function Object.onFormConfirm(data) end

--- Updates the object's transform
function Object:updateTransform()
  local x, y = self:getPosition()
  local angle = self:getAngle()
  local scale_x, scale_y = self:getScale()

  self.transform:setTransformation(math.round(x), math.round(y), angle, scale_x, scale_y)

  self:updateAbsoluteTransform()
end

--- Updates the object's absolute transform
function Object:updateAbsoluteTransform()
  local parent = self:getParent()
  if parent ~= nil then
    self.absolute_transform:reset()
    self.absolute_transform:apply(parent:getAbsoluteTransform()):apply(self:getTransform())
  else
    local x, y = self:getPosition()
    local angle = self:getAngle()
    local scale_x, scale_y = self:getScale()
    self.absolute_transform:setTransformation(math.round(x), math.round(y), angle, scale_x, scale_y)
  end

  for _, child in ipairs(self.children) do
    child:updateAbsoluteTransform()
  end
end

--- Wether the object is static
--- @return boolean
function Object:isStatic()
  return self.static
end

--- Sets wether the object is static
--- @param static boolean
function Object:setStatic(static)
  self.static = static
end

--- Wether the object is collision enabled
--- @return boolean
function Object:isCollisionEnabled()
  return self.collision_enabled
end

--- Sets wether the object is collision enabled
--- @param enabled boolean
function Object:setCollisionEnabled(enabled)
  self.collision_enabled = enabled
end

--- Wether the object's collisions are solid
--- @return boolean
function Object:isCollisionSolid()
  return self.collision_solid
end

--- Sets wether the object's collisions are solid
--- @param solid boolean
function Object:setCollisionSolid(solid)
  self.collision_solid = solid
end

--- Gets the object's hitbox
--- @return number, number, number, number
function Object:getHitbox()
  return self.hitbox[1], self.hitbox[2], self.hitbox[3], self.hitbox[4]
end

--- Sets the object's hitbox
--- @param left number
--- @param top number
--- @param width number
--- @param height number
function Object:setHitbox(left, top, width, height)
  self.hitbox[1] = left
  self.hitbox[2] = top
  self.hitbox[3] = width
  self.hitbox[4] = height
end

--- Gets the object's left position
--- @return number
function Object:getLeft()
  local left = self:getHitbox()
  local x = self:getPosition()
  local origin_x = self:getOrigin()
  local scale_x = self:getScale()
  return x + (-origin_x * self:getWidth() + left) * scale_x
end

--- Gets the object's right position
--- @return number
function Object:getRight()
  local _, _, width = self:getHitbox()
  local scale_x = self:getScale()
  return self:getLeft() + width * scale_x
end

--- Gets the object's left position
--- @return number
function Object:getTop()
  local _, top = self:getHitbox()
  local _, y = self:getPosition()
  local _, origin_y = self:getOrigin()
  local _, scale_y = self:getScale()
  return y + (-origin_y * self:getHeight() + top) * scale_y
end

--- Gets the object's right position
--- @return number
function Object:getBottom()
  local _, _, _, height = self:getHitbox()
  local _, scale_y = self:getScale()
  return self:getTop() + height * scale_y
end

--- Wether the object can be interacted by the player
--- @return boolean
function Object:canInteract()
  return self.can_interact
end

--- Sets wether the object can be interacted by the player
--- @param can_interact boolean
function Object:setCanInteract(can_interact)
  self.can_interact = can_interact
end

--- Gets the object's depth
--- @return number
function Object:getDepth()
  return self.depth
end

--- Moves the object
--- @param dx number
--- @param dy number
--- @return number, number
function Object:move(dx, dy)
  return self:moveExact("x", dx), self:moveExact("y", dy)
end

--- Moves the object along an axis
--- @param axis "x" | "y"
--- @param amount number
--- @return number
function Object:moveExact(axis, amount)
  local x, y = self:getPosition()
  local moved = 0
  local sign = math.sign(amount)
  for i = 1, math.ceil(math.abs(amount)) do
    local move = sign
    if (i > math.abs(amount)) then
      move = (math.abs(amount) % 1) * sign
    end

    if axis == "x" then
      x = x + move
    elseif axis == "y" then
      y = y + move
    end

    local collided, obj = World.checkCollision(self, x, y)
    if collided then
      if obj ~= nil then
        if type(self.onCollisionSolid) == "function" then
          self:onCollisionSolid({
            collider = obj,
            direction_x = axis == "x" and sign or 0,
            direction_y = axis == "y" and sign or 0,
            moved_x = axis == "x" and moved or 0,
            moved_y = axis == "y" and moved or 0,
            amount_x = axis == "x" and amount or 0,
            amount_y = axis == "y" and amount or 0,
          })
        end
        if type(obj.onCollisionSolid) == "function" then
          obj:onCollisionSolid({
            collider = self,
            direction_x = axis == "x" and sign or 0,
            direction_y = axis == "y" and sign or 0,
            moved_x = axis == "x" and moved or 0,
            moved_y = axis == "y" and moved or 0,
            amount_x = axis == "x" and amount or 0,
            amount_y = axis == "y" and amount or 0,
          })
        end
      end

      return moved
    end

    moved = moved + move
    self:setPosition(x, y)
  end

  return moved
end

--- Called when the object collides with a solid object
--- @param data Dummy.Object.CollisionData
function Object:onCollisionSolid(data) end

--- Called when the object collides with another object
--- @param other Dummy.Object
function Object:onCollision(other) end

--- Called when the object is interacted by the player
function Object:onInteract() end

--- Removes the object from the current scene
function Object:remove()
  if self:isRemoved() then return end

  local room = World.getCurrentRoom()
  if room ~= nil then
    room:removeObject(self)
  end

  Sprite.remove(self)
end

--- Updates the object's depth
function Object:updateDepth()
  if self:isStatic() then return end

  local bottom = math.round(self:getBottom())
  if self:getDepth() ~= bottom then
    self.depth = math.round(bottom)

    local parent = self:getParent()
    if parent ~= nil then
      parent:sortChildren()
    end
  end
end

--- Draws the object's hitbox for debugging
--- @param camera Dummy.Camera
function Object:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() then return end

  local width, height = self:getWidth(), self:getHeight()
  local hitbox_left, hitbox_top, hitbox_width, hitbox_height = self:getHitbox()
  if width == 0 and height == 0 and hitbox_width == 0 and hitbox_height == 0 then return end

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  if width ~= 0 or height ~= 0 then
    -- draw outline
    love.graphics.setColor(0, 0, 1)
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")
    local bb = self:getBoundingBox()
    love.graphics.polygon("line",
      bb[1] + 0.5, bb[2] + 0.5,
      bb[3] - 0.5, bb[4] + 0.5,
      bb[5] - 0.5, bb[6] - 0.5,
      bb[7] + 0.5, bb[8] - 0.5
    )
  end

  if (hitbox_width ~= 0 or hitbox_height ~= 0) and (self:isCollisionEnabled() or self:canInteract()) then
    -- draw hitbox
    local absolute_transform = self:getAbsoluteTransform()
    local origin_x, origin_y = self:getOrigin()
    local x = hitbox_left - origin_x * width
    local y = hitbox_top - origin_y * height
    local x1, y1 = absolute_transform:transformPoint(x, y)
    local x2, y2 = absolute_transform:transformPoint(x + hitbox_width, y)
    local x3, y3 = absolute_transform:transformPoint(x + hitbox_width, y + hitbox_height)
    local x4, y4 = absolute_transform:transformPoint(x, y + hitbox_height)
    love.graphics.setColor(0, 1, 0)
    love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)
  end

  love.graphics.pop()
end

--- Draws the solid object for the editor
--- @param data Dummy.Object.Data
function Object.drawEditor(data)
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", data.x + 0.5, data.y + 0.5, data.width - 1, data.height - 1)
end

--- Updates the object, called on every game update
--- @param dt number
function Object:update(dt)
  if not self:isVisible() then return end

  Sprite.update(self, dt)

  self:updateDepth()
end

return Object
