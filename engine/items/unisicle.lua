--- @class Dummy.Item.Unisicle : Dummy.Item.Consumable
local UnisicleItem = Class(ConsumableItem, "Dummy.Item.Unisicle")

--- Creates an unisicle
--- @return Dummy.Item.Unisicle
function UnisicleItem:new()
  self = Class:new(UnisicleItem, {
    "unisicle",
    "ITEM_UNISICLE_NAME",
    "ITEM_UNISICLE_SHORTNAME",
    "ITEM_UNISICLE_DESCRIPTION",
    11,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(2)
  self:setShopDescription("ITEM_UNISICLE_DESCRIPTION_SHOP")

  return self
end

return UnisicleItem
