--- @class Dummy.Item.PopatoChisps : Dummy.Item.Consumable
local PopatoChispsItem = Class(ConsumableItem, "Dummy.Item.PopatoChisps")

--- Creates a popato chisps
--- @return Dummy.Item.PopatoChisps
function PopatoChispsItem:new()
  self = Class:new(PopatoChispsItem, {
    "popato_chisps",
    "ITEM_POPATO_CHISPS_NAME",
    "ITEM_POPATO_CHISPS_SHORTNAME",
    "ITEM_POPATO_CHISPS_DESCRIPTION",
    13,
    "food"
  })

  self:setBuyPrice(25)
  self:setSellPrice(35)
  self:setShopDescription("ITEM_POPATO_CHISPS_DESCRIPTION_SHOP")
  self:setUseText("ITEM_POPATO_CHISPS_USE")

  return self
end

return PopatoChispsItem
