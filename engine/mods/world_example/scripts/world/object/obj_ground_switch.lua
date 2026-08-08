--- @class WorldExample.Object.GroundSwitch : Dummy.Object
---
--- @field protected id string
--- @field protected active boolean
local GroundSwitchObject = Class(Object, "WorldExample.Object.GroundSwitch")

GroundSwitchObject.ALLOW_EDITOR = true

GroundSwitchObject.EDITOR_SPRITE = "world/object/ground_switch_1"

--- Creates a ground switch
--- @param x number
--- @param y number
function GroundSwitchObject:new(x, y)
  self = Class:new(GroundSwitchObject)

  self:setSprite({
    "world/object/ground_switch_1",
    "world/object/ground_switch_2"
  }, 0, false, false)
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setPosition(x, y)
  self:setHitbox(2, 5, 16, 11)

  self:setActive(false)

  if self.id == "plotswitch1" and WorldExampleMod.plot > 4 then
    self:setActive(true)
  elseif self.id == "plotswitch2" and WorldExampleMod.plot > 4.5 then
    self:setActive(true)
  end

  return self
end

--- Wether the ground switch is active
--- @param active boolean
function GroundSwitchObject:setActive(active)
  self.active = active
  self:setCollisionEnabled(not active)

  if active then
    self:setFrame(2)
  else
    self:setFrame(1)
  end
end

--- Called when the ground switch collides with another object
--- @param other Dummy.Object
function GroundSwitchObject:onCollision(other)
  if other:is(PlayerObject) and not self.active then
    self:setActive(true)
    Assets.playSound("noise")
  end
end

return GroundSwitchObject
