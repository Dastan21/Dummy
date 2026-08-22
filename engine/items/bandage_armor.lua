--- @class Dummy.Item.BandageArmor : Dummy.Item.Armor
local BandageArmorItem = Class(ArmorItem, "Dummy.Item.BandageArmor")

--- Creates a bandage
--- @return Dummy.Item.BandageArmor
function BandageArmorItem:new()
  self = Class:new(BandageArmorItem, {
    "bandage_armor",
    "ITEM_BANDAGE_NAME",
    "ITEM_BANDAGE_SHORTNAME",
    "ITEM_BANDAGE_DESCRIPTION",
    0
  })

  self:setBuyPrice(1)
  self:setSellPrice(150)
  self:setShopDescription("ITEM_BANDAGE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_BANDAGE_USE")

  return self
end

--- Called when the bandage armor is unequipped
function BandageArmorItem:onUnequip()
  Player.removeItem(self)
  Player.addItem(require("items.bandage"):new())
end

return BandageArmorItem
