--- @class Item.CrabApple : Dummy.Item.Consumable
local CrabAppleItem = Class(ItemConsumable, "Item.CrabApple")

--- Creates a crab apple
--- @return Item.CrabApple
function CrabAppleItem:new()
  self = Class:new(CrabAppleItem, {
    "crab_apple",                                     -- item identifier
    "ITEM_CRAB_APPLE_NAME",         -- item name
    "ITEM_CRAB_APPLE_SHORTNAME",       -- item short name
    "ITEM_CRAB_APPLE_DESCRIPTION", -- item description
    18,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(25)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(5)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_CRAB_APPLE_DESCRIPTION_SHOP")

  return self
end

return CrabAppleItem
