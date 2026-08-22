--- @class Dummy.Item.JunkFood : Dummy.Item.Consumable
local JunkFoodItem = Class(ConsumableItem, "Dummy.Item.JunkFood")

--- Creates junk food
--- @return Dummy.Item.JunkFood
function JunkFoodItem:new()
  self = Class:new(JunkFoodItem, {
    "butterscotch_pie",
    "ITEM_JUNK_FOOD_NAME",
    "ITEM_JUNK_FOOD_SHORTNAME",
    "ITEM_JUNK_FOOD_DESCRIPTION",
    17,
    "food"
  })

  self:setBuyPrice(25)
  self:setSellPrice(1)
  self:setShopDescription("ITEM_JUNK_FOOD_DESCRIPTION_SHOP")
  self:setUseText("ITEM_JUNK_FOOD_USE")

  return self
end

return JunkFoodItem
