--- @class Item.Starfait : Dummy.Item.Consumable
local StarfaitItem = Class(ItemConsumable, "Item.Starfait")

--- Creates a starfait
--- @return Item.Starfait
function StarfaitItem:new()
  self = Class:new(StarfaitItem, {
    "starfait",                                     -- item identifier
    "ITEM_STARFAIT_NAME",         -- item name
    "ITEM_STARFAIT_SHORTNAME",   -- item short name
    "ITEM_STARFAIT_DESCRIPTION", -- item description
    14,
    "drink"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(60)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(10)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_STARFAIT_DESCRIPTION_SHOP")

  return self
end

return StarfaitItem
