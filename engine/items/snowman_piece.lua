--- @class Dummy.Item.SnowManPiece : Dummy.Item.Consumable
local SnowManPieceItem = Class(ConsumableItem, "Dummy.Item.SnowManPiece")

--- Creates a snowman piece
--- @return Dummy.Item.SnowManPiece
function SnowManPieceItem:new()
  self = Class:new(SnowManPieceItem, {
    "snowman_piece",
    "ITEM_SNOWMAN_PIECE_NAME",
    "ITEM_SNOWMAN_PIECE_SHORTNAME",
    "ITEM_SNOWMAN_PIECE_DESCRIPTION",
    45,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(40)
  self:setShopDescription("ITEM_SNOWMAN_PIECE_DESCRIPTION_SHOP")

  return self
end

return SnowManPieceItem
