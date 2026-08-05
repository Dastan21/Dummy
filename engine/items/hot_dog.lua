--- @class Item.HotDog : Dummy.Item.Consumable
local HotDogItem = Class(ItemConsumable, "Item.HotDog")

--- Creates a hot dog...? Maybe.
--- @return Item.HotDog
function HotDogItem:new()
  self = Class:new(HotDogItem, {
    "hot_dog",                                     -- item identifier
    "ITEM_HOT_DOG_NAME",         -- item name
    "ITEM_HOT_DOG_SHORTNAME",      -- item short name
    "ITEM_HOT_DOG_DESCRIPTION", -- item description
    20,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(30)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(10)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_HOT_DOG_DESCRIPTION_SHOP")

  return self
end

function HotDogItem:onUse()
  Assets.playSound("dogsalad")
end

return HotDogItem
