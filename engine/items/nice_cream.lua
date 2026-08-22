--- @class Dummy.Item.NiceCream : Dummy.Item.Consumable
local NiceCreamItem = Class(ConsumableItem, "Dummy.Item.NiceCream")

--- Creates a nice cream
--- @return Dummy.Item.NiceCream
function NiceCreamItem:new()
  self = Class:new(NiceCreamItem, {
    "nice_cream",
    "ITEM_NICE_CREAM_NAME",
    "ITEM_NICE_CREAM_SHORTNAME",
    "ITEM_NICE_CREAM_DESCRIPTION",
    15,
    "food"
  })

  self:setBuyPrice(15)
  self:setSellPrice(2)
  self:setShopDescription("ITEM_NICE_CREAM_DESCRIPTION_SHOP")

  local rand = love.math.random(8)
  self:setUseText("ITEM_NICE_CREAM_USE_" .. rand)

  return self
end

return NiceCreamItem
