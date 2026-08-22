--- @class Dummy.Item.Stick : Dummy.Item.Weapon
local StickItem = Class(WeaponItem, "Dummy.Item.Stick")

--- Creates a bandage
--- @return Dummy.Item.Stick
function StickItem:new()
  self = Class:new(StickItem, {
    "stick",
    "ITEM_STICK_NAME",
    "ITEM_STICK_SHORTNAME",
    "ITEM_STICK_DESCRIPTION",
    0
  })

  self:setBuyPrice(1)
  self:setSellPrice(150)
  self:setShopDescription("ITEM_STICK_DESCRIPTION_SHOP")
  self:setUseText("ITEM_STICK_USE")

  return self
end

--- Uses the stick item
function StickItem:use()
  Item.use(self)
end

return StickItem
