--- @class WorldExample.Object.Spike : Dummy.Object
---
--- @field protected active boolean
local SpikeObject = Class(Object, "WorldExample.Object.Spike")

SpikeObject.ALLOW_EDITOR = true

SpikeObject.EDITOR_SPRITE = "world/object/spike_1"
--- Creates a spike
--- @param x number
--- @param y number
function SpikeObject:new(x, y)
  self = Class:new(SpikeObject)

  self:setSprite({
    "world/object/spike_1",
    "world/object/spike_2"
  }, 0, false, false)
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setPosition(x, y)
  self:setHitbox(0, 0, 20, 20)

  self:setActive(true)

  local room_name = World.getCurrentRoom():getId()
  if room_name == "ruins2" and WorldExampleMod.plot > 4.5 then
    self:setActive(false)
  end

  return self
end

--- Wether the spike is active
--- @return boolean
function SpikeObject:isActive()
  return self.active
end

--- Sets wether the spike is active
--- @param active boolean
function SpikeObject:setActive(active)
  self.active = active

  if active then
    self:setCollisionEnabled(true)
    self:setFrame(1)
  else
    self:setCollisionEnabled(false)
    self:setFrame(2)
  end
end

return SpikeObject
