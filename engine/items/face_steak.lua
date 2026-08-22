--- @class Dummy.Item.FaceSteak : Dummy.Item.Consumable
local FaceSteakItem = Class(ConsumableItem, "Dummy.Item.FaceSteak")

--- Creates a face steak
--- @return Dummy.Item.FaceSteak
function FaceSteakItem:new()
  self = Class:new(FaceSteakItem, {
    "face_steak",
    "ITEM_FACE_STEAK_NAME",
    "ITEM_FACE_STEAK_SHORTNAME",
    "ITEM_FACE_STEAK_DESCRIPTION_1",
    60,
    "food"
  })

  self:setBuyPrice(500)
  self:setSellPrice(14)
  self:setDescriptions("ITEM_FACE_STEAK_DESCRIPTION_1", "ITEM_FACE_STEAK_DESCRIPTION_2")
  self:setShopDescription("ITEM_FACE_STEAK_DESCRIPTION_SHOP")
  self:setUseText("ITEM_FACE_STEAK_USE")

  return self
end

return FaceSteakItem
