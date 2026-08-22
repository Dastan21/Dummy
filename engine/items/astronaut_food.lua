--- @class Dummy.Item.AstronautFood : Dummy.Item.Consumable
local AstronautFoodItem = Class(ConsumableItem, "Dummy.Item.AstronautFood")

--- Creates an astronaut food
--- @return Dummy.Item.AstronautFood
function AstronautFoodItem:new()
  self = Class:new(AstronautFoodItem, {
    "astronaut_food",
    "ITEM_ASTRONAUT_FOOD_NAME",
    "ITEM_ASTRONAUT_FOOD_SHORTNAME",
    "ITEM_ASTRONAUT_FOOD_DESCRIPTION",
    21,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(25)
  self:setShopDescription("ITEM_ASTRONAUT_FOOD_DESCRIPTION_SHOP")
  self:setUseText("ITEM_ASTRONAUT_FOOD_USE")

  return self
end

return AstronautFoodItem
