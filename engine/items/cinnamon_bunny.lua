--- @class Dummy.Item.CinnamonBunny : Dummy.Item.Consumable
local CinnamonBunnyItem = Class(ConsumableItem, "Dummy.Item.CinnamonBunny")

--- Creates a cinnamon bunny
--- @return Dummy.Item.CinnamonBunny
function CinnamonBunnyItem:new()
  self = Class:new(CinnamonBunnyItem, {
    "cinnamon_bunny",
    "ITEM_CINNAMON_BUNNY_NAME",
    "ITEM_CINNAMON_BUNNY_SHORTNAME",
    "ITEM_CINNAMON_BUNNY_DESCRIPTION",
    22,
    "food"
  })

  self:setBuyPrice(25)
  self:setSellPrice(8)
  self:setShopDescription("ITEM_CINNAMON_BUNNY_DESCRIPTION_SHOP")
  self:setUseText("ITEM_CINNAMON_BUNNY_USE")

  return self
end

return CinnamonBunnyItem
