--- @class Dummy.Item.Bisicle : Dummy.Item.Consumable
local BisicleItem = Class(ConsumableItem, "Dummy.Item.Bisicle")

--- Creates a bisicle
--- @return Dummy.Item.Bisicle
function BisicleItem:new()
  self = Class:new(BisicleItem, {
    "bisicle",
    "ITEM_BISICLE_NAME",
    "ITEM_BISICLE_SHORTNAME",
    "ITEM_BISICLE_DESCRIPTION",
    11,
    "food"
  })

  self:setBuyPrice(15)
  self:setSellPrice(5)
  self:setShopDescription("ITEM_BISICLE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_BISICLE_USE")

  return self
end

--- Called when the bisicle is used
function BisicleItem:onUse()
  local unisicle = require("items.unisicle"):new()
  Player.addItem(unisicle)
end

return BisicleItem
