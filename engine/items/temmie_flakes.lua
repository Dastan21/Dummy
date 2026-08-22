--- @class Dummy.Item.TemmieFlakes : Dummy.Item.Consumable
local TemmieFlakesItem = Class(ConsumableItem, "Dummy.Item.TemmieFlakes")

--- Creates a temmie flakes
--- @return Dummy.Item.TemmieFlakes
function TemmieFlakesItem:new()
  self = Class:new(TemmieFlakesItem, {
    "temmie_flakes",
    "ITEM_TEMMIE_FLAKES_NAME",
    "ITEM_TEMMIE_FLAKES_SHORTNAME",
    "ITEM_TEMMIE_FLAKES_DESCRIPTION",
    2,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(2)
  self:setShopDescription("ITEM_TEMMIE_FLAKES_DESCRIPTION_SHOP")

  return self
end

return TemmieFlakesItem
