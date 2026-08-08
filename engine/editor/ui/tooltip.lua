--- @alias Dummy.Editor.Tooltip.Direction "top" | "bottom" | "left" | "right"

--- @class Dummy.Editor.Tooltip : Dummy.Drawable
---
--- @field protected target Dummy.Drawable
--- @field protected background Dummy.Drawable
--- @field protected text Dummy.Text
--- @field protected direction Dummy.Editor.Tooltip.Direction
--- @field protected offset number
local Tooltip = Class(Drawable, "Dummy.Editor.Tooltip")

Tooltip.PADDING_X = 12
Tooltip.PADDING_Y = 4
Tooltip.MARGIN = 4

--- Creates a tooltip
--- @param target Dummy.Drawable
--- @return Dummy.Editor.Tooltip
function Tooltip:new(target)
  self = Class:new(Tooltip)

  self:setVisible(false)
  self:setTarget(target)
  self:setTag("UI")

  self.background = Drawable:new()
  self.background:setParent(self)
  function self.background.draw()
    if not self:isVisible() then return end

    local width, height = self:getWidth(), self:getHeight()
    local origin_x, origin_y = self.text:getOrigin()
    local x, y = self.text:getPosition()
    x = x - width * origin_x - 0.5
    y = y - height * origin_y - 0.5
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", x, y, width + 1, height + 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, width + 1, height + 1)
  end

  self.text = Text:new("")
  self.text:setParent(self)
  self.text:setFont("main_text")

  self.direction = "top"
  self.offset = 4

  return self
end

--- Gets the tooltip's width
--- @return number
function Tooltip:getWidth()
  return self.text:getWidth() + Tooltip.PADDING_X
end

--- Gets the tooltip's height
--- @return number
function Tooltip:getHeight()
  return self.text:getHeight() + Tooltip.PADDING_Y
end

--- Gets the tooltip's target
--- @return Dummy.Drawable
function Tooltip:getTarget()
  return self.target
end

--- Sets the tooltip's target
--- @param target Dummy.Drawable
function Tooltip:setTarget(target)
  if self.target == target then return end
  if self.target ~= nil then
    self.target:removeChild(self)
    self.target.onRemoved = nil
  end

  self.target = target
  self:setLayer(target:getLayer())
end

--- Gets the tooltip's text
--- @return Dummy.Text.Text
function Tooltip:getText()
  return self.text:getText()
end

--- Sets the tooltip's text
--- @param text? Dummy.Text.Text
function Tooltip:setText(text)
  self.text:setText(text or "")
end

--- Gets the tooltip's direction
--- @return Dummy.Editor.Tooltip.Direction
function Tooltip:getDirection()
  return self.direction
end

--- Sets the tooltip's direction
--- @param direction Dummy.Editor.Tooltip.Direction
function Tooltip:setDirection(direction)
  self.direction = direction
end

--- Gets the tooltip's offset
--- @return number
function Tooltip:getOffset()
  return self.offset
end

--- Sets the tooltip's offset
--- @param offset number
function Tooltip:setOffset(offset)
  self.offset = offset
end

--- Updates the tooltip
--- @param dt number
function Tooltip:update(dt)
  Drawable.update(self, dt)

  if not self:isVisible() then return end

  local target = self:getTarget()
  local target_width, target_height = target:getWidth(), target:getHeight()
  local target_x, target_y = target:getAbsoluteTransform():transformPoint(0, 0)
  local width, height = self:getWidth(), self:getHeight()

  local direction = self:getDirection() or "bottom"
  local offset = self:getOffset()

  local x, y

  if direction == "top" then
    x = target_x
    y = target_y - height / 2 - target_height / 2 - offset / 2
  elseif direction == "bottom" then
    x = target_x
    y = target_y + height / 2 + target_height / 2 + offset / 2
  elseif direction == "left" then
    x = target_x - width / 2 - target_width / 2 - offset / 2
    y = target_y
  elseif direction == "right" then
    x = target_x + width / 2 + target_width / 2 + offset / 2
    y = target_y
  end

  if x - width / 2 < Tooltip.MARGIN and direction ~= "left" then
    x = Tooltip.MARGIN + width / 2
  elseif x + width / 2 > Constants.WORLD_WIDTH - Tooltip.MARGIN and direction ~= "right" then
    x = Constants.WORLD_WIDTH - Tooltip.MARGIN - width / 2
  end

  if y - height / 2 < Tooltip.MARGIN and direction ~= "top" then
    y = height / 2 + Tooltip.MARGIN
  elseif y + height / 2 > Constants.WORLD_HEIGHT - Tooltip.MARGIN and direction ~= "bottom" then
    y = Constants.WORLD_HEIGHT - height / 2 - Tooltip.MARGIN
  end

  self:setPosition(x, y)
end

return Tooltip
