--- @class Dummy.Object.NPC : Dummy.Object
---
--- @field protected id string
--- @field protected facing Dummy.Object.Facing
--- @field protected facing_before_talk Dummy.Object.Facing
--- @field protected moving boolean
--- @field protected talking boolean
--- @field protected speaking boolean
--- @field protected voice string
--- @field protected blink_timer Dummy.Timer.Handle|nil
local NPCObject = Class(Object, "Dummy.Object.NPC")

--- Creates an NPC
--- @param id string
function NPCObject:new(id)
  self = Class:new(NPCObject)

  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setCanInteract(true)
  self:setOrigin(0, 0)

  self.id = id
  self.moving = false
  self.talking = false
  self.speaking = false
  self.voice = "voice_dialogue"

  self:setFacing("down")

  return self
end

--- Gets the NPC's id
--- @return string
function NPCObject:getId()
  return self.id
end

--- Gets the NPC's facing
--- @return Dummy.Object.Facing
function NPCObject:getFacing()
  return self.facing
end

--- Sets the NPC's facing
--- @param facing Dummy.Object.Facing
function NPCObject:setFacing(facing)
  if self.facing == facing then return end

  self.facing = facing

  self:updateSprite()
end

--- Gets the NPC's voice
--- @return string
function NPCObject:getVoice()
  return self.voice
end

--- Sets the NPC's voice
--- @param voice string
function NPCObject:setVoice(voice)
  self.voice = voice
end

--- Wether the NPC is talking
---
--- Note: `true` until the end of the dialogue interaction
--- @return boolean
function NPCObject:isTalking()
  return self.talking
end

--- Wether the NPC is speaking
---
--- Note: `true` until the end of the dialogue current text
--- @return boolean
function NPCObject:isSpeaking()
  return self.speaking
end

--- Called when the NPC is interacted by the player
function NPCObject:onInteract()
  self:facePlayer()
end

--- Talk to the NPC
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText)
function NPCObject:talk(texts, on_done)
  self.talking = true

  local textbox = World.playDialogue(texts, function(_self)
    self.talking = false
    self:setLoop(false)
    self:stop()

    if self.facing_before_talk ~= nil then
      self:setFacing(self.facing_before_talk)
    end

    if type(on_done) == "function" then
      on_done(_self)
    end
  end)
  local dialogue = textbox:getDialogue()
  dialogue:setVoice(self:getVoice())

  self:updateSprite()
end

--- Makes the NPC's face the player
function NPCObject:facePlayer()
  self.facing_before_talk = self:getFacing()

  local obj_player = Player.getObject()
  if obj_player == nil then return end

  local player_facing = obj_player:getFacing()
  local facing = "down"
  if player_facing == "down" then
    facing = "up"
  elseif player_facing == "right" then
    facing = "left"
  elseif player_facing == "up" then
    facing = "down"
  elseif player_facing == "left" then
    facing = "right"
  end
  self:setFacing(facing)
end

--- Moves the NPC
--- @param dx number
--- @param dy number
--- @param keep_facing? boolean
--- @return number, number
function NPCObject:move(dx, dy, keep_facing)
  local moved_x = self:moveExact("x", dx)
  local moved_y = self:moveExact("y", dy)

  if keep_facing ~= true then
    local facing = self:getFacing()
    if math.abs(moved_x) > math.abs(moved_y) then
      if moved_x > 0 then
        facing = "right"
      elseif moved_x < 0 then
        facing = "left"
      end
    else
      if moved_y > 0 then
        facing = "down"
      elseif moved_y < 0 then
        facing = "up"
      end
    end
    self:setFacing(facing)
  end

  if not self.moving then
    self:stop()
  elseif not self:isPlaying() then
    self:updateSprite()
    self:play()
  end

  self.moving = moved_x ~= 0 or moved_y ~= 0

  return moved_x, moved_y
end

--- Walks to a position
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
--- @param on_walked? fun()
function NPCObject:walkTo(target_x, target_y, speed, keep_facing, on_walked)
  speed = Utils.getOrDefault(speed, 90)

  local x, y = self:getPosition()
  local dx = target_x - x
  local dy = target_y - y
  local dist = math.dist(x, y, target_x, target_y)
  self:setCollisionEnabled(false)

  Timer.during(dist / speed, function(dt)
    if dt <= 0 then return end
    self:move(dx / dist * speed * dt, dy / dist * speed * dt, keep_facing)
  end, function()
    self.moving = false
    self:setCollisionEnabled(true)
    if type(on_walked) == "function" then
      on_walked()
    end
  end)
end

--- Slides to a position
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
--- @param on_slided? fun()
function NPCObject:slideTo(target_x, target_y, speed, keep_facing, on_slided)
  speed = Utils.getOrDefault(speed, 90)

  local x, y = self:getPosition()
  local dx = target_x - x
  local dy = target_y - y
  local dist = math.dist(x, y, target_x, target_y)
  self:setCollisionEnabled(false)

  Timer.during(dist / speed, function(dt)
    if dt <= 0 then return end
    x, y = self:getPosition()
    self:setPosition(x + dx / dist * speed * dt, y + dy / dist * speed * dt)
  end, function()
    self.moving = false
    self:setCollisionEnabled(true)
    if type(on_slided) == "function" then
      on_slided()
    end
  end)
end

--- Updates the NPC's sprite
function NPCObject:updateSprite() end

--- Updates the NPC, called on every game update
--- @param dt number
function NPCObject:update(dt)
  if not self:isVisible() then return end

  Object.update(self, dt)

  if self:isTalking() or World.getTextbox():getActivePortrait() == self:getId() then
    if self:isSpeaking() and World.getTextbox():getDialogue():isCurrentDone() then
      self.speaking = false
      self:updateSprite()
    elseif not self:isSpeaking() and not World.getTextbox():getDialogue():isCurrentDone() then
      self.speaking = true
      self:updateSprite()
    end
  elseif self:isSpeaking() then
    self.speaking = false
    self:updateSprite()
  end
end

return NPCObject
