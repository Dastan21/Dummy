--- @alias Dummy.Object.Player.Interaction "none" | "interact" | "menu" | "room_transition" | "shop_transition" | "cutscene"

--- @class Dummy.Object.Player : Dummy.Object.NPC
---
--- @field protected prev_facing Dummy.Object.Facing
--- @field protected can_move boolean
--- @field protected moving boolean
--- @field protected facing Dummy.Object.Facing
--- @field protected interaction Dummy.Object.Player.Interaction
--- @field protected phasing boolean
--- @field protected debug_text Dummy.Text|nil
local PlayerObject = Class(NPCObject, "Dummy.Object.Player")

--- Creates a player
--- @return Dummy.Object.Player
function PlayerObject:new()
  self = Class:new(PlayerObject)

  self:setCollisionEnabled(true)
  self:setOrigin(0.5, 0.5)

  self.hitbox = { 0, 19, 20, 11 }
  self.collision_enabled = true
  self.interaction = "none"
  self.facing = "down"
  self.phasing = false

  local old_obj = Player.getObject()
  if old_obj ~= nil then
    old_obj:remove()
  end
  Player.setObject(self)

  if Constants.DEBUG then
    self.debug_text = Text:new("", true)
    self.debug_text:setOrigin(0.5, 1)
    self.debug_text:setFont("small")
    self.debug_text:setLayer(self:getLayer() + 0.1)
    self.debug_text:setVisible(false)
    function self.debug_text.drawDebug() end
  end

  self:updateSprite()

  return self
end

--- Gets the player's facing direction
--- @return Dummy.Object.Facing
function PlayerObject:getFacing()
  return self.facing
end

--- Sets the player's facing direction
--- @param facing Dummy.Object.Facing
function PlayerObject:setFacing(facing)
  if self.facing == facing then return end

  self.facing = facing

  self:updateSprite()
end

--- Wether the player is interacting
--- @return boolean
function PlayerObject:isInteracting()
  return self.interaction ~= "none"
end

--- Gets the player's interaction
--- @return Dummy.Object.Player.Interaction
function PlayerObject:getInteraction()
  return self.interaction
end

--- Sets the player's interaction
--- @param interaction Dummy.Object.Player.Interaction
function PlayerObject:setInteraction(interaction)
  if self.interaction == interaction then return end

  self.interaction = interaction

  if self.interaction == "cutscene" then
    self:stop()
  end
end

--- Wether the player is phasing
--- @return boolean
function PlayerObject:isPhasing()
  return self.phasing
end

--- Sets wether the player is phasing
--- @param phasing boolean
function PlayerObject:setPhasing(phasing)
  self.phasing = phasing
end

--- Updates the player's sprite
function PlayerObject:updateSprite()
  local facing = self:getFacing()
  if self.prev_facing == facing then return end

  self.prev_facing = facing

  --- @type string[]
  local frames = {}
  if facing == "down" then
    frames = {
      "world/object/player/move_down_1",
      "world/object/player/move_down_2",
      "world/object/player/move_down_3",
      "world/object/player/move_down_4",
    }
  elseif facing == "right" then
    frames = {
      "world/object/player/move_right_1",
      "world/object/player/move_right_2",
    }
  elseif facing == "up" then
    frames = {
      "world/object/player/move_up_1",
      "world/object/player/move_up_2",
      "world/object/player/move_up_3",
      "world/object/player/move_up_4",
    }
  elseif facing == "left" then
    frames = {
      "world/object/player/move_left_1",
      "world/object/player/move_left_2",
    }
  end
  self:setSprite(frames, 5 / 30, true, self.moving, true)
end

--- Moves the player
--- @param dx number
--- @param dy number
--- @param keep_facing? boolean
--- @return number, number
function PlayerObject:move(dx, dy, keep_facing)
  if self:getInteraction() == "cutscene" then
    return NPCObject.move(self, dx, dy, keep_facing)
  end

  -- TODO: Frisk Dance
  local moved_x = self:moveExact("x", dx)
  local moved_y = self:moveExact("y", dy)

  keep_facing = Utils.getOrDefault(keep_facing, false)

  local facing = self:getFacing()
  if moved_y == 0 then
    if moved_x > 0 then
      facing = "right"
      self.moving = true
    elseif moved_x < 0 then
      facing = "left"
      self.moving = true
    end
  end
  if not keep_facing then
    self:setFacing(facing)
  end

  facing = self:getFacing()
  if moved_x == 0 then
    if moved_y > 0 then
      facing = "down"
      self.moving = true
    elseif moved_y < 0 then
      facing = "up"
      self.moving = true
    end
  end
  if not keep_facing then
    self:setFacing(facing)
  end

  if not self.moving then
    self:stop()
  end

  return moved_x, moved_y
end

--- Handles the player's movement
--- @param dt number
function PlayerObject:handleMovement(dt)
  if self:getInteraction() == "cutscene" then return end

  local x, y = self:getPosition()
  local new_x, new_y = x, y
  local facing = self:getFacing()
  local base_speed = 82.5
  if Constants.DEBUG and Input.isDown("shift") then
    base_speed = 256
  end
  local move_speed = base_speed * dt
  local input_up = Input.isDown(Input.Up)
  local input_down = Input.isDown(Input.Down)
  local input_left = Input.isDown(Input.Left)
  local input_right = Input.isDown(Input.Right)

  if self.can_move then
    if self.moving and not self:isPlaying() then
      local frame = self:getFrame()
      self:play()
      self:setFrame(frame)
    end

    if input_left then
      new_x = new_x - move_speed

      if not self.moving then
        self:setFrame(2)
      end

      if not (input_up and facing == "up") and not (input_down and facing == "down") then
        facing = "left"
      end
    end

    if input_up then
      new_y = new_y - move_speed

      if not self.moving then
        self:setFrame(2)
      end

      if not (input_right and facing == "right") and not (input_left and facing == "left") then
        facing = "up"
      end
    end

    if input_right and not input_left then
      new_x = new_x + move_speed

      if not (input_up and facing == "up") and not (input_down and facing == "down") then
        facing = "right"
      end
    end

    if input_down and not input_up then
      new_y = new_y + move_speed

      if not self.moving then
        self:setFrame(2)
      end

      if not (input_right and facing == "right") and not (input_left and facing == "left") then
        facing = "down"
      end
    end
  end

  if not input_left and not input_right and not input_up and not input_down then
    self.moving = false
  end

  if self:isInteracting() then
    self.moving = false
    self.can_move = false
  else
    self.can_move = true
  end

  if (math.abs(x - new_x) > 0.01 or math.abs(y - new_y) > 0.01) then
    self.moving = true;
  end

  local move = self.moving
  if not self:isPhasing() then
    local collided, obj = World.checkCollision(self, new_x, new_y)
    if collided and obj ~= nil and obj:is(NPCObject) then
      move = false
    end
  end

  self:setFacing(facing)
  if move then
    self:move(new_x - x, new_y - y)
  else
    self:stop()
  end
end

--- Gets the player's interact box
--- @return number, number, number, number
function PlayerObject:getInteractBox()
  local x, y = self:getPosition()
  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getWidth(), self:getHeight()
  x = x - origin_x * width
  y = y - origin_y * height
  local interact_x, interact_y = 0, 0
  local interact_width, interact_height = 0, 0
  if self:getFacing() == "right" then
    interact_x = x + width / 2
    interact_y = y + 19
    interact_width = width / 2 + 15
    interact_height = height - 19
  elseif self:getFacing() == "left" then
    interact_x = x - 15
    interact_y = y + 19
    interact_width = width / 2 + 15
    interact_height = height - 19
  elseif self:getFacing() == "down" then
    interact_x = x + 4
    interact_y = y + 20
    interact_width = width - 8
    interact_height = height - 5
  elseif self:getFacing() == "up" then
    interact_x = x + 4
    interact_y = y + 6
    interact_width = width - 8
    interact_height = height - 10
  end

  return math.round(interact_x), math.round(interact_y), interact_width, interact_height
end

--- Handles the player's interaction
function PlayerObject:handleInteration()
  if not self:isInteracting() and Input.isPressed(Input.Confirm) then
    local objects = World.getCurrentRoom():getInteractableObjects()
    local x, y, width, height = self:getInteractBox()
    local collides, obj = self:collides(x, y, width, height, objects)
    if collides and obj ~= nil and obj:canInteract() then
      if type(obj.onInteract) == "function" then
        obj:onInteract()
      end
    end
  end
end

--- Handles the player's collisions
function PlayerObject:handleCollisions()
  if not self:isCollisionEnabled() then return end

  local objects = World.getCurrentRoom():getObjects()
  --- @type Dummy.Object[]
  local objs = {}
  for _, obj in ipairs(objects) do
    if obj:isVisible() and obj:isCollisionEnabled() and not obj:isCollisionSolid() then
      table.insert(objs, obj)
    end
  end

  local left, top = self:getLeft(), self:getTop()
  local _, _, hitbox_width, hitbox_height = self:getHitbox()
  for _, obj in ipairs(objs) do
    if self ~= obj then
      local _, _, obj_hitbox_width, obj_hitbox_height = obj:getHitbox()
      if Utils.checkCollisionAABB({ left, top, hitbox_width, hitbox_height }, { obj:getLeft(), obj:getTop(), obj_hitbox_width, obj_hitbox_height }) then
        self:onCollision(obj)
        if type(obj.onCollision) == "function" then
          obj:onCollision(self)
        end
      end
    end
  end
end

--- Wether the player collides with an object
---@param x number
---@param y number
---@param width number
---@param height number
---@param objects? Dummy.Object[]
---@return boolean, Dummy.Object|nil
function PlayerObject:collides(x, y, width, height, objects)
  if objects == nil then objects = World.getCurrentRoom():getObjects() end
  for _, obj in pairs(objects) do
    if self ~= obj then
      local _, _, obj_hitbox_width, obj_hitbox_height = obj:getHitbox()
      if Utils.checkCollisionAABB({ x, y, width, height }, { obj:getLeft(), obj:getTop(), obj_hitbox_width, obj_hitbox_height }) then
        return true, obj
      end
    end
  end

  return false
end

--- Called when the player collides with a solid object
--- @param data Dummy.Object.CollisionData
function PlayerObject:onCollisionSolid(data)
  if not data.collider:is(SolidTriangleObject) then
    self.moving = false
    return
  end
  if self:isPhasing() or self:getInteraction() ~= "none" then return end

  local solid_triangle = data.collider --[[@as Dummy.Object.SolidTriangle]]
  local side = solid_triangle:getSide()
  local moved = false
  local facing = self:getFacing()
  local factor = math.sqrt(2)
  if side == "top-left" then
    if not Input.isDown(Input.Left) or not Input.isDown(Input.Up) then
      if facing == "left" then
        self:moveExact("y", -data.amount_x)
        self:moveExact("x", data.amount_x / factor)
        moved = true
      elseif facing == "up" then
        self:moveExact("x", -data.amount_y)
        self:moveExact("y", data.amount_y / factor)
        moved = true
      end
    end
  elseif side == "top-right" then
    if not Input.isDown(Input.Right) or not Input.isDown(Input.Up) then
      if facing == "right" then
        self:moveExact("y", data.amount_x)
        self:moveExact("x", data.amount_x / factor)
        moved = true
      elseif facing == "up" then
        self:moveExact("x", data.amount_y)
        self:moveExact("y", data.amount_y / factor)
        moved = true
      end
    end
  elseif side == "bottom-left" then
    if not Input.isDown(Input.Left) or not Input.isDown(Input.Down) then
      if facing == "left" then
        self:moveExact("y", data.amount_x)
        self:moveExact("x", data.amount_x / factor)
        moved = true
      elseif facing == "down" then
        self:moveExact("x", data.amount_y)
        self:moveExact("y", data.amount_y / factor)
        moved = true
      end
    end
  elseif side == "bottom-right" then
    if not Input.isDown(Input.Right) or not Input.isDown(Input.Down) then
      if facing == "right" then
        self:moveExact("y", -data.amount_x)
        self:moveExact("x", data.amount_x / factor)
        moved = true
      elseif facing == "down" then
        self:moveExact("x", -data.amount_y)
        self:moveExact("y", data.amount_y / factor)
        moved = true
      end
    end
  end

  self.moving = moved
end

--- Removes the player from the current scene
function PlayerObject:remove()
  if Constants.DEBUG then
    self.debug_text:remove()
  end

  NPCObject.remove(self)
  ---@diagnostic disable-next-line: param-type-mismatch
  Player.setObject(nil)
end

--- Draws the player's hitbox for debugging
--- @param camera Dummy.Camera
function PlayerObject:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() then return end

  NPCObject.drawDebug(self, camera)

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  -- draw interact
  local x, y, interact_width, interact_height = self:getInteractBox()
  love.graphics.setColor(1, 1, 0)
  love.graphics.rectangle("line", x + 0.5, y + 0.5, interact_width - 1, interact_height - 1)

  love.graphics.pop()
end

--- Updates the player, called on every game update
--- @param dt number
function PlayerObject:update(dt)
  self:updateSprite()
  self:handleMovement(dt)
  self:handleInteration()
  self:handleCollisions()

  if self:getInteraction() == "none" and Input.isPressed(Input.Menu) then
    World.openPlayerMenu()
  end

  NPCObject.update(self, dt)

  if Constants.DEBUG then
    local x, y = self:getPosition()
    self.debug_text:setPosition(x, y - self:getHeight() / 2)
    self.debug_text:setVisible(Debug.shouldDisplayHitbox())
    local debug_text = ""
    debug_text = debug_text .. string.format("%s, %s\n", math.floor(x), math.floor(y))
    self.debug_text:setText(debug_text)
  end
end

return PlayerObject
