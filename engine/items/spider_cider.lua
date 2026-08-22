--- @class Dummy.Item.SpiderCider : Dummy.Item.Consumable
local SpiderCiderItem = Class(ConsumableItem, "Dummy.Item.SpiderCider")

--- Creates a spider Cider
--- @return Dummy.Item.SpiderCider
function SpiderCiderItem:new()
  self = Class:new(SpiderCiderItem, {
    "spider_cider",
    "ITEM_SPIDER_CIDER_NAME",
    "ITEM_SPIDER_CIDER_SHORTNAME",
    "ITEM_SPIDER_CIDER_DESCRIPTION",
    24,
    "drink"
  })

  self:setBuyPrice(18)
  self:setSellPrice(60)
  self:setShopDescription("ITEM_SPIDER_CIDER_DESCRIPTION_SHOP")

  return self
end

return SpiderCiderItem
