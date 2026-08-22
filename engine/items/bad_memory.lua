--- @class Dummy.Item.BadMemory : Dummy.Item.Consumable
local BadMemoryItem = Class(ConsumableItem, "Dummy.Item.BadMemory")

--- Creates a bad memory
--- @return Dummy.Item.BadMemory
function BadMemoryItem:new()
  self = Class:new(BadMemoryItem, {
    "bad_memory",
    "ITEM_BAD_MEMORY_NAME",
    "ITEM_BAD_MEMORY_SHORTNAME",
    "ITEM_BAD_MEMORY_DESCRIPTION",
    -1,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(300)
  self:setShopDescription("ITEM_BAD_MEMORY_DESCRIPTION_SHOP")
  self:setUseText("ITEM_BAD_MEMORY_USE")

  return self
end

--- Gets the bad memory's heal amount
--- @return number
function BadMemoryItem:getHeal()
  if Player.getHP() <= 2 then
    return Player.getMaxHP()
  end

  return -1
end

--- Gets the bad memory's heal sound
--- @return string|nil
function BadMemoryItem:getHealSound()
  return Player.getHP() <= 2 and "heal" or "hurt"
end

return BadMemoryItem
