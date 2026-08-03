--- @class Item.ButterScotchPie : Dummy.Item.Consumable
local ButterScotchPieItem = Class(ItemConsumable, "Item.ButterScotchPie")

--- Creates a butterscotch pie
--- @return Item.ButterScotchPie
function ButterScotchPieItem:new()
  self = Class:new(ButterScotchPieItem, {
    "butterscotch_pie",                                     -- item identifier
    "ITEM_BUTTERSCOTCH_PIE_NAME",         -- item name
    "ITEM_BUTTERSCOTCH_PIE_SHORTNAME",    -- item short name
    "ITEM_BUTTERSCOTCH_PIE_DESCRIPTION",  -- item description
    Player.getMaxHP(),
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(180)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_BUTTERSCOTCH_PIE_DESCRIPTION_SHOP")

  return self
end

return ButterScotchPieItem
