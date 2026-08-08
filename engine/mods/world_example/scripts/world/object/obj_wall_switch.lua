--- @class Dummy.Object.WallSwitch.Data : Dummy.Object.Data
---
--- @field switch_id string

--- @class WorldExample.Object.WallSwitch : Dummy.Object
---
--- @field protected id string
--- @field protected active boolean
local WallSwitchObject = Class(Object, "WorldExample.Object.WallSwitch")

WallSwitchObject.ALLOW_EDITOR = true

WallSwitchObject.EDITOR_SPRITE = "world/object/wall_switch_1"

--- Creates a wall switch
--- @param x number
--- @param y number
--- @param id string
function WallSwitchObject:new(x, y, id)
  self = Class:new(WallSwitchObject)

  self:setSprite({
    "world/object/wall_switch_1",
    "world/object/wall_switch_2"
  }, 0, false, false)
  self:setCanInteract(true)
  self:setPosition(x, y)
  self:setHitbox(2, 5, 15, 15)

  self.id = id
  self:setActive(false)

  -- you can make an object per switch, or write all the logic into one object
  if self.id == "wallswitchcut1" then
  elseif self.id == "plotswitch1" and WorldExampleMod.plot > 4 then
    self:setActive(true)
  elseif self.id == "plotswitch2" and WorldExampleMod.plot > 4.5 then
    self:setActive(true)
  end

  return self
end

--- Initializes the wall switch's arguments before creating it
--- @param data Dummy.Object.WallSwitch.Data
function WallSwitchObject.initArgs(data)
  return data.x, data.y, data.switch_id
end

--- Gets the wall switch metadata
--- @return Dummy.Editor.Metadata[]
function WallSwitchObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "switch_id",
      label = "WORLD_OBJECT_WALL_SWITCH_METADATA_ID",
      type = "string",
    }
  }
end

--- Wether the wall switch is active
--- @param active boolean
function WallSwitchObject:setActive(active)
  self.active = active
  self:setCanInteract(not active)

  if active then
    self:setFrame(2)
  else
    self:setFrame(1)
  end
end

--- Called when the wall switch is interacted by the player
function WallSwitchObject:onInteract()
  if self.active then return end

  if self.id == "wallswitchcut1" then
    -- special cutscene to show camera offset
    World.playCutscene(function(cutscene)
      Player.getObject():setInteraction("cutscene")
      cutscene:detachCamera()
      cutscene:moveCamera(280, 120, 1)
      cutscene:wait(1.5)
      cutscene:targetObject(Player.getObject(), 1)
      Player.getObject():setInteraction("none")
    end)
  elseif self.id == "plotswitch1" and WorldExampleMod.plot <= 4 then
    WorldExampleMod.plot = 4.5
    self:setActive(true)
    self:setCanInteract(false)
  elseif self.id == "plotswitch2" and WorldExampleMod.plot <= 4.5 then
    self:setActive(true)
    Assets.playSound("screenshake")
    Player.getObject():setInteraction("interact")

    local SpikeObject = modRequire("scripts.world.object.obj_spike") --[[@as WorldExample.Object.Spike]]
    local obj_spikes = World.getCurrentRoom():getObjectsByType(SpikeObject)
    for _, obj_spike in ipairs(obj_spikes) do
      if obj_spike:isActive() then
        obj_spike:setActive(false)
      end
    end

    Shaker.shakeDecrease(0.25, 2 / 30, 4, 0, function()
      WorldExampleMod.plot = 5
      Player.getObject():setInteraction("none")
    end)
  elseif self.id == "readable_switch1" then
    if WorldExampleMod.plot < 5 then
      local TorielObject = modRequire("scripts.world.object.obj_toriel") --[[@as WorldExample.Object.Toriel]]
      local obj_toriel = World.getCurrentRoom():getObjectsByType(TorielObject)[1] --[[@as WorldExample.Object.Toriel]]
      if obj_toriel ~= nil then
        local texts = {
          "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_TEXT_1",
          "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_TEXT_2",
          "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_TEXT_3",
        }
        if WorldExampleMod.flag["6"] == 1 then
          texts = { "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_TEXT_4" }
        end

        obj_toriel:talk(texts)
      end
    else
      World.playDialogue({ "WORLD_EXAMPLE_MOD_WORLD_OBJECT_WALL_SWITCH_TORIEL_TEXT_6" })
    end
  end
end

return WallSwitchObject
