--- @class Item.BadMemory : Dummy.Item.Consumable
local BadMemoryItem = Class(ItemConsumable, "Item.BadMemory")

--- Creates a ???
--- @return Item.BadMemory
function BadMemoryItem:new()
  self = Class:new(BadMemoryItem, {
    "bad_memory",                                     -- item identifier
    "ITEM_BAD_MEMORY_NAME",         -- item name
    "ITEM_BAD_MEMORY_SHORTNAME",   -- item short name
    "ITEM_BAD_MEMORY_DESCRIPTION", -- item description
    -1,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(300)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_BAD_MEMORY_DESCRIPTION_SHOP")
  -- the text that will appear when the item is used
  self:setUseText("ITEM_BAD_MEMORY_USE")

  return self
end

function BadMemoryItem:getHeal()
  -- Heal the player fully if they're below 3 HP, hurt them otherwise.
  if Player.getHP() <=2 then
    return Player.getMaxHP()
  else
    return -1
  end
end

return BadMemoryItem
