--- @class Item.PopatoChisps : Dummy.Item.Consumable
local PopatoChispsItem = Class(ItemConsumable, "Item.PopatoChisps")

--- Creates a popato chisps
--- @return Item.PopatoChisps
function PopatoChispsItem:new()
  self = Class:new(PopatoChispsItem, {
    "popato_chisps",                                     -- item identifier
    "ITEM_POPATO_CHISPS_NAME",         -- item name
    "ITEM_POPATO_CHISPS_SHORTNAME", -- item short name
    "ITEM_POPATO_CHISPS_DESCRIPTION", -- item description
    13,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(25)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(35)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_POPATO_CHISPS_DESCRIPTION_SHOP")

  return self
end

return PopatoChispsItem
