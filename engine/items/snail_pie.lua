--- @class Item.SnailPie : Dummy.Item.Consumable
local SnailPieItem = Class(ItemConsumable, "Item.SnailPie")

--- Creates a snail pie
--- @return Item.SnailPie
function SnailPieItem:new()
  self = Class:new(SnailPieItem, {
    "snail_pie",                                     -- item identifier
    "ITEM_SNAIL_PIE_NAME",         -- item name
    "ITEM_SNAIL_PIE_SHORTNAME",    -- item short name
    "ITEM_SNAIL_PIE_DESCRIPTION",  -- item description
    math.pi,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(350)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_SNAIL_PIE_DESCRIPTION_SHOP")

  return self
end

function SnailPieItem:getHeal()
  if Player.getHP() < Player.getMaxHP() then
    return (Player.getMaxHP() - Player.getHP()) - 1
  else
    return 0
  end
end

function SnailPieItem:getHealText()
  return Lang.translate("ITEM_SNAIL_PIE_HEAL")
end

return SnailPieItem
