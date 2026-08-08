--- @class WorldExample.Item.SmallCandy : Dummy.Item.Consumable
local SmallCandyItem = Class(ItemConsumable, "WorldExample.Item.SmallCandy")

--- Creates a small candy
--- @return WorldExample.Item.SmallCandy
function SmallCandyItem:new()
  self = Class:new(SmallCandyItem, {
    "small_candy",                                    -- item identifier
    "WORLD_EXAMPLE_MOD_ITEM_SMALL_CANDY_NAME",        -- item name
    "WORLD_EXAMPLE_MOD_ITEM_SMALL_CANDY_SHORTNAME",   -- item short name
    "WORLD_EXAMPLE_MOD_ITEM_SMALL_CANDY_DESCRIPTION", -- item description
    3,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(6)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(3)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("WORLD_EXAMPLE_MOD_ITEM_SMALL_CANDY_DESCRIPTION_SHOP")

  return self
end

return SmallCandyItem
