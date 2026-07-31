--- @class Dummy.Object.ShopTransition : Dummy.Object
---
--- @field protected shop_id string
local ShopTransitionObject = Class(Object, "Dummy.Object.ShopTransition")

--- Creates a shop transition
--- @param shop_id string
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
function ShopTransitionObject:new(shop_id, x, y, width, height)
  self = Class:new(ShopTransitionObject)

  self.shop_id = shop_id
  self.width = Utils.getOrDefault(width, 20)
  self.height = Utils.getOrDefault(height, 20)

  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setOrigin(0, 0)
  self:setPosition(x, y)
  self:setHitbox(0, 0, self.width, self.height)
  self:setAlpha(0)

  return self
end

--- Called when the shop transition collides with another object
--- @param data Dummy.Object.CollisionData
function ShopTransitionObject:onCollisionSolid(data)
  if data.collider:is(PlayerObject) then
    local obj_player = Player.getObject()
    if obj_player:getInteraction() == "shop_transition" then return end

    obj_player:setInteraction("shop_transition")

    World.transitionShop(self.shop_id)
  end
end

--- Draws the shop transition's hitbox for debugging
--- @param camera Dummy.Camera
function ShopTransitionObject:drawDebug(camera)
  if not Debug.shouldDisplayHitbox() or not self:isCollisionEnabled() then return end

  local hitbox_left, hitbox_top, hitbox_width, hitbox_height = self:getHitbox()
  if hitbox_width == 0 and hitbox_height == 0 then return end

  local absolute_transform = self:getAbsoluteTransform()

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  -- draw hitbox
  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getWidth(), self:getHeight()
  local x = hitbox_left - origin_x * width
  local y = hitbox_top - origin_y * height
  local x1, y1 = absolute_transform:transformPoint(x, y)
  local x2, y2 = absolute_transform:transformPoint(x + hitbox_width, y)
  local x3, y3 = absolute_transform:transformPoint(x + hitbox_width, y + hitbox_height)
  local x4, y4 = absolute_transform:transformPoint(x, y + hitbox_height)
  love.graphics.setColor(1, 0, 1, 1)
  love.graphics.polygon("line", x1 + 0.5, y1 + 0.5, x2 - 0.5, y2 + 0.5, x3 - 0.5, y3 - 0.5, x4 + 0.5, y4 - 0.5)

  love.graphics.pop()
end

return ShopTransitionObject
