--- @class Dummy.Item.SnailPie : Dummy.Item.Consumable
local SnailPieItem = Class(ConsumableItem, "Dummy.Item.SnailPie")

--- Creates a snail pie
--- @return Dummy.Item.SnailPie
function SnailPieItem:new()
  self = Class:new(SnailPieItem, {
    "snail_pie",
    "ITEM_SNAIL_PIE_NAME",
    "ITEM_SNAIL_PIE_SHORTNAME",
    "ITEM_SNAIL_PIE_DESCRIPTION",
    math.pi,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(350)
  self:setShopDescription("ITEM_SNAIL_PIE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_SNAIL_PIE_USE")

  return self
end

--- Gets the snail pie's heal amount
--- @return number
function SnailPieItem:getHeal()
  if Player.getHP() < Player.getMaxHP() - 1 then
    return (Player.getMaxHP() - Player.getHP()) - 1
  end
  return 0
end

--- Gets the snail pie's heal text
--- @return string
function SnailPieItem:getHealText()
  return Lang.translate("ITEM_ACTION_HEAL_MAX")
end

return SnailPieItem
