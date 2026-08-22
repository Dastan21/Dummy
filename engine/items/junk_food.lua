--- @class Item.JunkFood : Dummy.Item.Consumable
local JunkFoodItem = Class(ItemConsumable, "Item.JunkFood")

--- Creates junk food
--- @return Item.JunkFood
function JunkFoodItem:new()
  self = Class:new(JunkFoodItem, {
    "butterscotch_pie",                                     -- item identifier
    "ITEM_JUNK_FOOD_NAME",         -- item name
    "ITEM_JUNK_FOOD_SHORTNAME",          -- item short name
    "ITEM_JUNK_FOOD_DESCRIPTION", -- item description
    17,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(25)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(1)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_JUNK_FOOD_DESCRIPTION_SHOP")

  return self
end

return JunkFoodItem
