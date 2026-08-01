--- @class Item.CinnamonBunny : Dummy.Item.Consumable
local CinnamonBunnyItem = Class(ItemConsumable, "Item.CinnamonBunny")

--- Creates a cinnamon bunny
--- @return Item.CinnamonBunny
function CinnamonBunnyItem:new()
  self = Class:new(CinnamonBunnyItem, {
    "cinnamon_bunny",                                     -- item identifier
    "ITEM_CINNAMON_BUNNY_NAME",         -- item name
    "ITEM_CINNAMON_BUNNY_SHORTNAME",    -- item short name
    "ITEM_CINNAMON_BUNNY_DESCRIPTION",  -- item description
    22,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(25)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(8)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_CINNAMON_BUNNY_DESCRIPTION_SHOP")

  return self
end

return CinnamonBunnyItem
