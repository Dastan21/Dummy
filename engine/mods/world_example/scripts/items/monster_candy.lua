--- @class WorldExample.Item.MonsterCandy : Dummy.Item.Consumable
local MonsterCandyItem = Class(ItemConsumable, "WorldExample.Item.MonsterCandy")

--- Creates a monster candy
--- @return WorldExample.Item.MonsterCandy
function MonsterCandyItem:new()
  self = Class:new(MonsterCandyItem, {
    "monster_candy",                                    -- item identifier
    "WORLD_EXAMPLE_MOD_ITEM_MONSTER_CANDY_NAME",        -- item name
    "WORLD_EXAMPLE_MOD_ITEM_MONSTER_CANDY_SHORTNAME",   -- item short name
    "WORLD_EXAMPLE_MOD_ITEM_MONSTER_CANDY_DESCRIPTION", -- item description
    10,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(5)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("WORLD_EXAMPLE_MOD_ITEM_MONSTER_CANDY_DESCRIPTION_SHOP")

  return self
end

return MonsterCandyItem
