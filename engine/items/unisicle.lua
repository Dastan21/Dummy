--- @class Item.Unisicle : Dummy.Item.Consumable
local UnisicleItem = Class(ItemConsumable, "Item.Unisicle")

--- Creates a spider Cider
--- @return Item.Unisicle
function UnisicleItem:new()
  self = Class:new(UnisicleItem, {
    "unisicle",                                     -- item identifier
    "ITEM_UNISICLE_NAME",         -- item name
    "ITEM_UNISICLE_SHORTNAME",    -- item short name
    "ITEM_UNISICLE_DESCRIPTION",  -- item description
    11,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(2)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_UNISICLE_DESCRIPTION_SHOP")

  return self
end

return UnisicleItem
