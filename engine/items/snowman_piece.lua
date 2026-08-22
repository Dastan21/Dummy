--- @class Item.SnowManPiece : Dummy.Item.Consumable
local SnowManPieceItem = Class(ItemConsumable, "Item.SnowManPiece")

--- Creates a snowman piece
--- @return Item.SnowManPiece
function SnowManPieceItem:new()
  self = Class:new(SnowManPieceItem, {
    "snowman_piece",                                     -- item identifier
    "ITEM_SNOWMAN_PIECE_NAME",         -- item name
    "ITEM_SNOWMAN_PIECE_SHORTNAME",    -- item short name
    "ITEM_SNOWMAN_PIECE_DESCRIPTION",  -- item description
    45,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(40)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_SNOWMAN_PIECE_DESCRIPTION_SHOP")

  return self
end

return SnowManPieceItem
