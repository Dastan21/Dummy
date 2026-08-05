--- @class Item.FaceSteak : Dummy.Item.Consumable
local FaceSteakItem = Class(ItemConsumable, "Item.FaceSteak")

--- Creates a face steak
--- @return Item.FaceSteak
function FaceSteakItem:new()
  self = Class:new(FaceSteakItem, {
    "face_steak",                                     -- item identifier
    "ITEM_FACE_STEAK_NAME",         -- item name
    "ITEM_FACE_STEAK_SHORTNAME",         -- item short name
    "ITEM_FACE_STEAK_DESCRIPTION", -- item description
    60,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(500)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(14)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_FACE_STEAK_DESCRIPTION_SHOP")
  -- the text that will appear when the item is used
  self:setUseText("ITEM_FACE_STEAK_USE")

  return self
end

return FaceSteakItem
