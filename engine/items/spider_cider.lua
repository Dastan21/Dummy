--- @class Item.SpiderCider : Dummy.Item.Consumable
local SpiderCiderItem = Class(ItemConsumable, "Item.SpiderCider")

--- Creates a spider Cider
--- @return Item.SpiderCider
function SpiderCiderItem:new()
  self = Class:new(SpiderCiderItem, {
    "spider_cider",                                     -- item identifier
    "ITEM_SPIDER_CIDER_NAME",         -- item name
    "ITEM_SPIDER_CIDER_SHORTNAME",    -- item short name
    "ITEM_SPIDER_CIDER_DESCRIPTION",  -- item description
    24,
    "drink"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(18)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(60)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_SPIDER_CIDER_DESCRIPTION_SHOP")

  return self
end

return SpiderCiderItem
