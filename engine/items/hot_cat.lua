--- @class Item.HotCat : Dummy.Item.Consumable
local HotCatItem = Class(ItemConsumable, "Item.HotCat")

--- Creates a hot cat
--- @return Item.HotCat
function HotCatItem:new()
  self = Class:new(HotCatItem, {
    "hot_cat",                                     -- item identifier
    "ITEM_HOT_CAT_NAME",         -- item name
    "ITEM_HOT_CAT_SHORTNAME",   -- item short name
    "ITEM_HOT_CAT_DESCRIPTION", -- item description
    21,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(30)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(11)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_HOT_CAT_DESCRIPTION_SHOP")

  return self
end

function HotCatItem:onUse()
  Assets.playSound("catsalad")
end

return HotCatItem
