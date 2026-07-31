--- @class Dummy.Object.Solid : Dummy.Object
local SolidObject = Class(Object, "Dummy.Object.Solid")

--- Creates a solid
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
function SolidObject:new(x, y, width, height)
  self = Class:new(SolidObject)

  self.depth = 99999999
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setOrigin(0, 0)
  self:setHitbox(x, y, Utils.getOrDefault(width, 20), Utils.getOrDefault(height, 20))
  self:setLayer(Constants.LAYERS.WORLD_SOLID)

  return self
end

--- Draws the solid object's hitbox for debugging
function SolidObject:drawDebug() end

return SolidObject
