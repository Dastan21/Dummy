--- @class Dummy.Item.SeaTea : Dummy.Item.Consumable
local SeaTeaItem = Class(ConsumableItem, "Dummy.Item.SeaTea")

--- Creates a sea tea
--- @return Dummy.Item.SeaTea
function SeaTeaItem:new()
  self = Class:new(SeaTeaItem, {
    "sea_tea",
    "ITEM_SEA_TEA_NAME",
    "ITEM_SEA_TEA_SHORTNAME",
    "ITEM_SEA_TEA_DESCRIPTION",
    10,
    "drink"
  })

  self:setBuyPrice(18)
  self:setSellPrice(5)
  self:setShopDescription("ITEM_SEA_TEA_DESCRIPTION_SHOP")

  return self
end

--- Called when the sea tea is used
function SeaTeaItem:onUse()
  if World.isInBattle() and Soul.getSpeed() < 8 then
    Soul.setSpeed(Soul.getSpeed() + 1)
  end
end

--- Gets the sea tea's dialogue texts
--- @return Dummy.Text.Text[]
function SeaTeaItem:getDialogueTexts()
  local dialogue_text = Lang.translate("ITEM_SEA_TEA_USE")
  if World.isInBattle() and Soul.getSpeed() < 8 then
    dialogue_text = dialogue_text .. "\n" .. Lang.translate("ITEM_SEA_TEA_USE_EFFECT")
  end
  dialogue_text = dialogue_text .. "\n" .. self:getHealText()
  return { dialogue_text }
end

return SeaTeaItem
