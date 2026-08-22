--- @class Dummy.Item.AbandonedQuiche : Dummy.Item.Consumable
local AbandonedQuicheItem = Class(ConsumableItem, "Dummy.Item.AbandonedQuiche")

--- Creates an abandoned quiche
--- @return Dummy.Item.AbandonedQuiche
function AbandonedQuicheItem:new()
  self = Class:new(AbandonedQuicheItem, {
    "abandoned_quiche",
    "ITEM_ABANDONED_QUICHE_NAME",
    "ITEM_ABANDONED_QUICHE_SHORTNAME",
    "ITEM_ABANDONED_QUICHE_DESCRIPTION",
    34,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(76)
  self:setShopDescription("ITEM_ABANDONED_QUICHE_DESCRIPTION_SHOP")
  self:setDropText("ITEM_ABANDONED_QUICHE_DROP")
  self:setUseText("ITEM_ABANDONED_QUICHE_USE")

  return self
end

return AbandonedQuicheItem
