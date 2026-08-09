--- @class Dummy.Mask : Dummy.Drawable
local Mask = Class(Drawable, "Dummy.Mask")

--- Draws the mask
--- @param camera Dummy.Camera
function Mask:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  if type(self.drawMask) == "function" then
    love.graphics.stencil(function()
      self:drawMask(camera)
    end, "replace", 1)
  end
  love.graphics.setStencilTest("greater", 0)

  self:drawChildren(camera)

  love.graphics.setStencilTest()
end

--- Draws to the mask
--- @param camera Dummy.Camera
function Mask:drawMask(camera) end

--- Creates a mask
--- @return Dummy.Mask
function Mask:new()
  return Class:new(Mask)
end

return Mask
