--- @class Dummy.Item.CrabApple : Dummy.Item.Consumable
local CrabAppleItem = Class(ConsumableItem, "Dummy.Item.CrabApple")

--- Creates a crab apple
--- @return Dummy.Item.CrabApple
function CrabAppleItem:new()
  self = Class:new(CrabAppleItem, {
    "crab_apple",
    "ITEM_CRAB_APPLE_NAME",
    "ITEM_CRAB_APPLE_SHORTNAME",
    "ITEM_CRAB_APPLE_DESCRIPTION",
    18,
    "food"
  })

  self:setBuyPrice(25)
  self:setSellPrice(5)
  self:setShopDescription("ITEM_CRAB_APPLE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_CRAB_APPLE_USE")

  return self
end

return CrabAppleItem
