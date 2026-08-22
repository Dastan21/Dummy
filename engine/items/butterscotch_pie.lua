--- @class Dummy.Item.ButterScotchPie : Dummy.Item.Consumable
local ButterScotchPieItem = Class(ConsumableItem, "Dummy.Item.ButterScotchPie")

--- Creates a butterscotch pie
--- @return Dummy.Item.ButterScotchPie
function ButterScotchPieItem:new()
  self = Class:new(ButterScotchPieItem, {
    "butterscotch_pie",
    "ITEM_BUTTERSCOTCH_PIE_NAME",
    "ITEM_BUTTERSCOTCH_PIE_SHORTNAME",
    "ITEM_BUTTERSCOTCH_PIE_DESCRIPTION",
    Player.getMaxHP(),
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(180)
  self:setShopDescription("ITEM_BUTTERSCOTCH_PIE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_BUTTERSCOTCH_PIE_USE")

  return self
end

return ButterScotchPieItem
