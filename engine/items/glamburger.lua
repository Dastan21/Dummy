--- @class Item.GlamBurger : Dummy.Item.Consumable
local GlamBurgerItem = Class(ItemConsumable, "Item.GlamBurger")

--- Creates a glamburger
--- @return Item.GlamBurger
function GlamBurgerItem:new()
  self = Class:new(GlamBurgerItem, {
    "glamburger",                                     -- item identifier
    "ITEM_GLAMBURGER_NAME",         -- item name
    "ITEM_GLAMBURGER_SHORTNAME",         -- item short name
    "ITEM_GLAMBURGER_DESCRIPTION", -- item description
    27,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(120)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(15)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_GLAMBURGER_DESCRIPTION_SHOP")

  return self
end

return GlamBurgerItem
