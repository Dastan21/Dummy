--- @class Dummy.Item.GlamBurger : Dummy.Item.Consumable
local GlamBurgerItem = Class(ConsumableItem, "Dummy.Item.GlamBurger")

--- Creates a glamburger
--- @return Dummy.Item.GlamBurger
function GlamBurgerItem:new()
  self = Class:new(GlamBurgerItem, {
    "glamburger",
    "ITEM_GLAMBURGER_NAME",
    "ITEM_GLAMBURGER_SHORTNAME",
    "ITEM_GLAMBURGER_DESCRIPTION",
    27,
    "food"
  })

  self:setBuyPrice(120)
  self:setSellPrice(15)
  self:setShopDescription("ITEM_GLAMBURGER_DESCRIPTION_SHOP")
  self:setUseText("ITEM_GLAMBURGER_USE")

  return self
end

return GlamBurgerItem
