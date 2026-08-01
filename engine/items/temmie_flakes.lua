--- @class Item.TemmieFlakes : Dummy.Item.Consumable
local TemmieFlakesItem = Class(ItemConsumable, "Item.TemmieFlakes")

--- Creates a spider Cider
--- @return Item.TemmieFlakes
function TemmieFlakesItem:new()
  self = Class:new(TemmieFlakesItem, {
    "temmie_flakes",                                     -- item identifier
    "ITEM_TEMMIE_FLAKES_NAME",        -- item name
    "ITEM_TEMMIE_FLAKES_SHORTNAME",    -- item short name
    "ITEM_TEMMIE_FLAKES_DESCRIPTION",  -- item description
    2,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(2)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_TEMMIE_FLAKES_DESCRIPTION_SHOP")

  return self
end

return TemmieFlakesItem
