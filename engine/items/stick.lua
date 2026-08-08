--- @class Item.Stick : Dummy.Item.Equipment
local StickItem = Class(ItemEquipment, "Item.Stick")

--- Creates a stick
--- @return Item.Stick
function StickItem:new()
  self = Class:new(StickItem, {
    "stick", -- item identifier
    "ITEM_STICK_NAME", -- item name
    "ITEM_STICK_SHORTNAME", -- item short name
    "ITEM_STICK_DESCRIPTION", -- item descriptions
    0, -- item value (ATK or DEF)
    "weapon" -- item type (armor or weapon)
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(150)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_STICK_DESCRIPTION_SHOP")
  -- the text that will appear when the item is used
  self:setUseText("ITEM_STICK_USE")

  return self
end

return StickItem
