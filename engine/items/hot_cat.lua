--- @class Dummy.Item.HotCat : Dummy.Item.Consumable
local HotCatItem = Class(ConsumableItem, "Dummy.Item.HotCat")

--- Creates a hot cat
--- @return Dummy.Item.HotCat
function HotCatItem:new()
  self = Class:new(HotCatItem, {
    "hot_cat",
    "ITEM_HOT_CAT_NAME",
    "ITEM_HOT_CAT_SHORTNAME",
    "ITEM_HOT_CAT_DESCRIPTION",
    21,
    "food"
  })

  self:setBuyPrice(30)
  self:setSellPrice(11)
  self:setShopDescription("ITEM_HOT_CAT_DESCRIPTION_SHOP")
  self:setUseText("ITEM_HOT_CAT_USE")
  self:setHealSound("catsalad")

  return self
end

return HotCatItem
