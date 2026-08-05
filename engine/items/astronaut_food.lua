--- @class Item.AstronautFood : Dummy.Item.Consumable
local AstronautFoodItem = Class(ItemConsumable, "Item.AstronautFood")

--- Creates a astronaut food
--- @return Item.AstronautFood
function AstronautFoodItem:new()
  self = Class:new(AstronautFoodItem, {
    "astronaut_food",                                     -- item identifier
    "ITEM_ASTRONAUT_FOOD_NAME",         -- item name
    "ITEM_ASTRONAUT_FOOD_SHORTNAME",     -- item short name
    "ITEM_ASTRONAUT_FOOD_DESCRIPTION", -- item description
    21,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(25)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_ASTRONAUT_FOOD_DESCRIPTION_SHOP")

  return self
end

return AstronautFoodItem
