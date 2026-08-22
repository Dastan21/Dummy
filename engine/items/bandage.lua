--- @class Dummy.Item.Bandage : Dummy.Item.Consumable
local BandageItem = Class(ConsumableItem, "Dummy.Item.Bandage")

--- Creates a bandage
--- @return Dummy.Item.Bandage
function BandageItem:new()
  self = Class:new(BandageItem, {
    "bandage",
    "ITEM_BANDAGE_NAME",
    "ITEM_BANDAGE_SHORTNAME",
    "ITEM_BANDAGE_DESCRIPTION",
    10,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(150)
  self:setShopDescription("ITEM_BANDAGE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_BANDAGE_USE")

  return self
end

return BandageItem
