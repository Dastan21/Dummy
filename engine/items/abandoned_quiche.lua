--- @class Item.AbandonedQuiche : Dummy.Item.Consumable
local AbandonedQuicheItem = Class(ItemConsumable, "Item.AbandonedQuiche")

--- Creates an abandoned quiche
--- @return Item.AbandonedQuiche
function AbandonedQuicheItem:new()
  self = Class:new(AbandonedQuicheItem, {
    "abandoned_quiche",                                     -- item identifier
    "ITEM_ABANDONED_QUICHE_NAME",         -- item name
    "ITEM_ABANDONED_QUICHE_SHORTNAME",    -- item short name
    "ITEM_ABANDONED_QUICHE_DESCRIPTION",  -- item description
    34,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(76)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_ABANDONED_QUICHE_DESCRIPTION_SHOP")
  -- the text that will appear when the item is dropped on the ground
  self:setDropText("ITEM_ABANDONED_QUICHE_DROP")
  -- the text that will appear when the item is used
  self:setUseText("ITEM_ABANDONED_QUICHE_USE")

  return self
end

return AbandonedQuicheItem
