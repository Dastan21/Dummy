--- @class Dummy.Item.LegendaryHero : Dummy.Item.Consumable
local LegendaryHeroItem = Class(ConsumableItem, "Dummy.Item.LegendaryHero")

--- Creates a legendary hero
--- @return Dummy.Item.LegendaryHero
function LegendaryHeroItem:new()
  self = Class:new(LegendaryHeroItem, {
    "legendary_hero",
    "ITEM_LEGENDARY_HERO_NAME",
    "ITEM_LEGENDARY_HERO_SHORTNAME",
    "ITEM_LEGENDARY_HERO_DESCRIPTION",
    40,
    "food"
  })

  self:setBuyPrice(300)
  self:setSellPrice(40)
  self:setShopDescription("ITEM_LEGENDARY_HERO_DESCRIPTION_SHOP")
  self:setHealSound("hero")

  return self
end

--- Called when the legendary hero is used
function LegendaryHeroItem:onUse()
  if World.isInBattle() and Player.getAT() < 150 then
    Player.setAT(Player.getAT() + 4)
  end
end

--- Gets the legendary hero's dialogue texts
--- @return Dummy.Text.Text[]
function LegendaryHeroItem:getDialogueTexts()
  local dialogue_text = Lang.translate("ITEM_LEGENDARY_HERO_USE")
  if World.isInBattle() and Player.getAT() < 150 then
    dialogue_text = dialogue_text .. "\n" .. Lang.translate("ITEM_LEGENDARY_HERO_USE_EFFECT")
  end
  dialogue_text = dialogue_text .. "\n" .. self:getHealText()
  return { dialogue_text }
end

return LegendaryHeroItem
