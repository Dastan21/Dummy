--- @class Item.Blanket : Dummy.Item.Consumable
local BlanketItem = Class(ItemEquipment, "Item.Blanket")

--- Creates a blanket
--- @return Item.Blanket
function BlanketItem:new()
  self = Class:new(BlanketItem, {
    "blanket",                                    -- item identifier
    "ITEM_BLANKET_NAME",        -- item name
    "ITEM_BLANKET_SHORTNAME",   -- item short name
    "ITEM_BLANKET_DESCRIPTION", -- item description
    1,
    "armor"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(10)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(1)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_BLANKET_DESCRIPTION_SHOP")

  return self
end

return BlanketItem
