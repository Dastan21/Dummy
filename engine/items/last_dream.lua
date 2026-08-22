--- @class Dummy.Item.LastDream : Dummy.Item.Consumable
local LastDreamItem = Class(ConsumableItem, "Dummy.Item.LastDream")

--- Creates a last dream
--- @return Dummy.Item.LastDream
function LastDreamItem:new()
  self = Class:new(LastDreamItem, {
    "last_dream",
    "ITEM_LAST_DREAM_NAME",
    "ITEM_LAST_DREAM_SHORTNAME",
    "ITEM_LAST_DREAM_DESCRIPTION",
    17,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(250)
  self:setShopDescription("ITEM_LAST_DREAM_DESCRIPTION_SHOP")
  self:setUseText("ITEM_LAST_DREAM_USE")

  return self
end

return LastDreamItem
