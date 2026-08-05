--- @class Item.HushPuppy : Dummy.Item.Consumable
local HushPuppyItem = Class(ItemConsumable, "Item.HushPuppy")

--- Creates hush puppy
--- @return Item.HushPuppy
function HushPuppyItem:new()
  self = Class:new(HushPuppyItem, {
    "butterscotch_pie",                                     -- item identifier
    "ITEM_HUSH_PUPPY_NAME",         -- item name
    "ITEM_HUSH_PUPPY_SHORTNAME",  -- item short name
    "ITEM_HUSH_PUPPY_DESCRIPTION", -- item description
    65,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(150)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_HUSH_PUPPY_DESCRIPTION_SHOP")

  return self
end

function HushPuppyItem:getDialogueTexts()
  return {Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) ..
      Lang.translate("ITEM_HUSH_PUPPY_USE") .. "\n" .. self:getHealText()}
end

return HushPuppyItem
