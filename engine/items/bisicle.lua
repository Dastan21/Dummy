--- @class Item.Bisicle : Dummy.Item.Consumable
local BisicleItem = Class(ItemConsumable, "Item.Bisicle")

--- Creates a bisicle
--- @return Item.Bisicle
function BisicleItem:new()
  self = Class:new(BisicleItem, {
    "bisicle",                                     -- item identifier
    "ITEM_BISICLE_NAME",         -- item name
    "ITEM_BISICLE_SHORTNAME",    -- item short name
    "ITEM_BISICLE_DESCRIPTION",  -- item description
    11,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(5)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_BISICLE_DESCRIPTION_SHOP")
  -- the main text that will appear when the item is used.
  self.use_texts = {
    "ITEM_BISICLE_USE"
  }

  return self
end

function BisicleItem:onUse()
  -- Add a unisicle to the player's inventory when the bisicle is used.
  local unisicle = require("items.unisicle"):new()
  Player.addItem(unisicle)
end

return BisicleItem
