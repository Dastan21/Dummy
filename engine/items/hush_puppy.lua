--- @class Dummy.Item.HushPuppy : Dummy.Item.Consumable
local HushPuppyItem = Class(ConsumableItem, "Dummy.Item.HushPuppy")

--- Creates a hush puppy
--- @return Dummy.Item.HushPuppy
function HushPuppyItem:new()
  self = Class:new(HushPuppyItem, {
    "hush_puppy",
    "ITEM_HUSH_PUPPY_NAME",
    "ITEM_HUSH_PUPPY_SHORTNAME",
    "ITEM_HUSH_PUPPY_DESCRIPTION",
    65,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(150)
  self:setShopDescription("ITEM_HUSH_PUPPY_DESCRIPTION_SHOP")
  self:setUseText("ITEM_HUSH_PUPPY_USE")

  return self
end

return HushPuppyItem
