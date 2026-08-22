--- @class Item.SeaTea : Dummy.Item.Consumable
local SeaTeaItem = Class(ItemConsumable, "Item.SeaTea")

--- Creates a sea tea
--- @return Item.SeaTea
function SeaTeaItem:new()
  self = Class:new(SeaTeaItem, {
    "seatea",                                     -- item identifier
    "ITEM_SEATEA_NAME",         -- item name
    "ITEM_SEATEA_SHORTNAME",   -- item short name
    "ITEM_SEATEA_DESCRIPTION", -- item description
    10,
    "drink"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(18)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(5)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_SEATEA_DESCRIPTION_SHOP")

  return self
end

function SeaTeaItem:onUse()
  if Soul.getSpeed() < 2 then
  Soul.setSpeed(Soul.getSpeed() + 0.25)
  print(Soul.getSpeed())
  end
end

function SeaTeaItem:getDialogueTexts()
  local usecomment = "ITEM_SEATEA_USE"
  if Soul.getSpeed() < 2 then
  return { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" ..
  Lang.translate(usecomment) .. "\n" .. self:getHealText() }
  else
    return { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" .. self:getHealText() }
  end
end

return SeaTeaItem
