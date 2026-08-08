--- @class Dummy.Object.ShopTransition.Data : Dummy.Object.Data
---
--- @field shop_id string

--- @class Dummy.Object.ShopTransition : Dummy.Object
---
--- @field protected shop_id string
local ShopTransitionObject = Class(Object, "Dummy.Object.ShopTransition")

ShopTransitionObject.ALLOW_EDITOR = true

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

--- Initializes the shop transition's arguments before creating it
--- @param data Dummy.Object.ShopTransition.Data
function ShopTransitionObject.initArgs(data)
  return data.shop_id, data.x, data.y, data.width, data.height
end

--- Gets the shop transition metadata
--- @return Dummy.Editor.Metadata[]
function ShopTransitionObject.getMetadata()
  --- @type Dummy.Editor.Select.Option[]
  local shop_options = {}
  for _, shop in ipairs(love.filesystem.getDirectoryItems("mods/" .. Editor.getModId() .. "/scripts/world/shop")) do
    if Utils.checkExtension(shop, "lua") then
      local shop_id = Utils.getFilenameWithoutExt(shop)
      --- @type Dummy.Editor.Select.Option
      local option = {
        value = shop_id,
        label = shop_id
      }
      table.insert(shop_options, option)
    end
  end

  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "shop_id",
      label = "WORLD_OBJECT_SHOP_TRANSITION_METADATA_SHOP_ID",
      type = "string",
      options = shop_options,
    },
    {
      id = "width",
      label = "WORLD_OBJECT_SHOP_TRANSITION_METADATA_WIDTH",
      type = "integer",
      default = 20,
      validate = function(value)
        return value > 0
      end
    },
    {
      id = "height",
      label = "WORLD_OBJECT_SHOP_TRANSITION_METADATA_HEIGHT",
      type = "integer",
      default = 20,
      validate = function(value)
        return value > 0
      end
    }
  }
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

--- Draws the shop transition for the editor
--- @param data Dummy.Object.Solid.Data
function ShopTransitionObject.drawEditor(data)
  love.graphics.setColor(1, 0, 1)
  love.graphics.rectangle("line", data.x + 0.5, data.y + 0.5, data.width - 1, data.height - 1)
end

return ShopTransitionObject
