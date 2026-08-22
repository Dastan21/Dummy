--- @class Dummy.Item.HotDog : Dummy.Item.Consumable
local HotDogItem = Class(ConsumableItem, "Dummy.Item.HotDog")

--- Creates a hot dog...? Maybe.
--- @return Dummy.Item.HotDog
function HotDogItem:new()
  self = Class:new(HotDogItem, {
    "hot_dog",
    "ITEM_HOT_DOG_NAME",
    "ITEM_HOT_DOG_SHORTNAME",
    "ITEM_HOT_DOG_DESCRIPTION",
    20,
    "food"
  })

  self:setBuyPrice(30)
  self:setSellPrice(10)
  self:setShopDescription("ITEM_HOT_DOG_DESCRIPTION_SHOP")
  self:setUseText("ITEM_HOT_DOG_USE")
  self:setHealSound("dogsalad")

  return self
end

return HotDogItem
