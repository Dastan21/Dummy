--- @class Item.LastDream : Dummy.Item.Consumable
local LastDreamItem = Class(ItemConsumable, "Item.LastDream")

--- Creates a last dream
--- @return Item.LastDream
function LastDreamItem:new()
  self = Class:new(LastDreamItem, {
    "last_dream",                                     -- item identifier
    "ITEM_LAST_DREAM_NAME",         -- item name
    "ITEM_LAST_DREAM_SHORTNAME",   -- item short name
    "ITEM_LAST_DREAM_DESCRIPTION", -- item description
    17,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(250)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_LAST_DREAM_DESCRIPTION_SHOP")
  self:setUseText("ITEM_LAST_DREAM_USE")

  return self
end

return LastDreamItem
