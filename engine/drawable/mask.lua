--- @class Dummy.Mask : Dummy.Drawable
local Mask = Class:extend(Drawable)

--- Gets the class name
--- @return string
function Mask.getClassName()
  return "Dummy.Mask"
end

--- Draws the mask
function Mask:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())
  love.graphics.setBlendMode("alpha", "premultiplied")

  if type(self.drawMask) == "function" then
    love.graphics.stencil(self.drawMask, "replace", 1)
  end
  love.graphics.setStencilTest("greater", 0)

  self:drawChildren()

  love.graphics.setStencilTest()
  love.graphics.setBlendMode("alpha", "alphamultiply")
end

--- Draws to the mask
function Mask:drawMask() end

--- Creates a mask
--- @return Dummy.Mask
function Mask:new()
  return Class:new(Mask)
end

return Mask
