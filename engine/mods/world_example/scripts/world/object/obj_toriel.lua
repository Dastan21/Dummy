--- @class WorldExample.Object.Toriel : Dummy.Object.NPC
---
--- @field protected conversation number
--- @field protected talked boolean
--- @field protected solid Dummy.Object.Solid|nil
local TorielObject = Class(NPCObject, "WorldExample.Object.NPC.Toriel")

--- Creates a toriel
function TorielObject:new()
  self = Class:new(TorielObject, { "toriel" })

  -- complex NPC with multiple interactions and cutscenes

  self.conversation = 0;
  self.talked = false;
  self:setPosition(155, 110)
  self:setVoice("voice_toriel")

  if WorldExampleMod.plot <= 4 then
    self.solid = SolidObject:new(480, 140, 20, 40)

    if WorldExampleMod.plot == 4 then
      self.conversation = 2;
      self:setFacing("left")
      self:setPosition(450, 110)
    end
  elseif WorldExampleMod.plot == 4.5 then
    self.conversation = 3;
    self:setFacing("left")
    self:setPosition(670, 110)
  end

  self:updateSprite()

  return self
end

--- Called when the toriel is interacted by the player
function TorielObject:onInteract()
  NPCObject.onInteract(self)

  if self.conversation == 2 then
    if not self.talked then
      self:talk({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_3" })
    else
      self:talk({
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_4",
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_5"
      })
    end
  elseif self.conversation == 3 then
    if not self.talked then
      self:talk({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_8" })
    else
      self:talk({
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_9",
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_10"
      })
    end
  end

  self.talked = true
end

--- Updates the toriel's sprite
function TorielObject:updateSprite()
  --- @type string[]
  local frames = {}

  local facing = self:getFacing()
  if self:isSpeaking() then
    if facing == "down" then
      frames = {
        "world/npc/toriel/talk_down_1",
        "world/npc/toriel/talk_down_2",
      }
    elseif facing == "up" then
      frames = {
        "world/npc/toriel/talk_up_1",
        "world/npc/toriel/talk_up_2",
      }
    elseif facing == "left" then
      frames = {
        "world/npc/toriel/talk_left_1",
        "world/npc/toriel/talk_left_2",
      }
    elseif facing == "right" then
      frames = {
        "world/npc/toriel/talk_right_1",
        "world/npc/toriel/talk_right_2",
      }
    end
    self:setSprite(frames, 4 / 30, true, true, true)
  else
    if facing == "down" then
      frames = {
        "world/npc/toriel/move_down_1",
        "world/npc/toriel/move_down_2",
        "world/npc/toriel/move_down_3",
        "world/npc/toriel/move_down_4",
      }
    elseif facing == "up" then
      frames = {
        "world/npc/toriel/move_up_1",
        "world/npc/toriel/move_up_2",
        "world/npc/toriel/move_up_3",
        "world/npc/toriel/move_up_4",
      }
    elseif facing == "left" then
      frames = {
        "world/npc/toriel/move_left_1",
        "world/npc/toriel/move_left_2",
        "world/npc/toriel/move_left_3",
        "world/npc/toriel/move_left_4",
      }
    elseif facing == "right" then
      frames = {
        "world/npc/toriel/move_right_1",
        "world/npc/toriel/move_right_2",
        "world/npc/toriel/move_right_3",
        "world/npc/toriel/move_right_4",
      }
    end
    self:setSprite(frames, 5 / 30, true, self.moving, true)
  end
end

--- Updates the toriel, called on every game update
--- @param dt number
function TorielObject:update(dt)
  NPCObject.update(self, dt)

  if self:getFacing() == "down" then
    self:setHitbox(1, 35, 31, 19)
  else
    self:setHitbox(4, 35, 25, 19)
  end

  local obj_player = Player.getObject()
  local x, y = obj_player:getPosition()
  if self.conversation == 0 and (x > 155 or y < 180) then
    World.playCutscene(function(cutscene)
      self.conversation = 0.5
      cutscene:text({
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_1",
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_2"
      })
      cutscene:wait(cutscene:walkTo(self, 450, 110))
      self:setFacing("left")
      self:setPosition(450, 110)
      self.conversation = 1
    end)
  elseif self.conversation == 1 then
    self.conversation = 2
    WorldExampleMod.plot = math.max(WorldExampleMod.plot, 4)
  elseif self.conversation == 2 and WorldExampleMod.plot == 4.5 then
    self.conversation = 2.5
    self.solid:remove()
    self.talked = false
    World.playCutscene(function(cutscene)
      cutscene:wait(cutscene:walkTo(self, 670, 110))
      self:setFacing("left")
      self:setPosition(670, 110)
      self.conversation = 3
    end)
  elseif self.conversation == 3 and WorldExampleMod.plot == 5 then
    self.conversation = 3.5
    self:setFacing("right")
    World.playCutscene(function(cutscene)
      cutscene:text({
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_6",
        "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_DIALOGUE_7"
      })
      cutscene:wait(cutscene:walkTo(self, 820, 110))
      self:remove()
    end)
  end
end

return TorielObject
