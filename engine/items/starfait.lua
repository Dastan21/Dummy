--- @class Dummy.Item.Starfait : Dummy.Item.Consumable
local StarfaitItem = Class(ConsumableItem, "Dummy.Item.Starfait")

--- Creates a starfait
--- @return Dummy.Item.Starfait
function StarfaitItem:new()
  self = Class:new(StarfaitItem, {
    "starfait",
    "ITEM_STARFAIT_NAME",
    "ITEM_STARFAIT_SHORTNAME",
    "ITEM_STARFAIT_DESCRIPTION",
    14,
    "drink"
  })

  self:setBuyPrice(60)
  self:setSellPrice(10)
  self:setShopDescription("ITEM_STARFAIT_DESCRIPTION_SHOP")

  return self
end

return StarfaitItem
