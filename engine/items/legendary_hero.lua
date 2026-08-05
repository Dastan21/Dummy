--- @class Item.LegendaryHero : Dummy.Item.Consumable
local LegendaryHeroItem = Class(ItemConsumable, "Item.LegendaryHero")

--- Creates a legendary hero
--- @return Item.LegendaryHero
function LegendaryHeroItem:new()
  self = Class:new(LegendaryHeroItem, {
    "legendary_hero",                                     -- item identifier
    "ITEM_LEGENDARY_HERO_NAME",         -- item name
    "ITEM_LEGENDARY_HERO_SHORTNAME",  -- item short name
    "ITEM_LEGENDARY_HERO_DESCRIPTION", -- item description
    40,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(300)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(40)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_LEGENDARY_HERO_DESCRIPTION_SHOP")

  return self
end

function LegendaryHeroItem:onUse()
  if Player.getAT() < 150 then
    Player.setAT(Player.getAT() + 4)
  end
end

function LegendaryHeroItem:getDialogueTexts()
  local usecomment = "ITEM_LEGENDARY_HERO_USE"
  if Player.getAT() < 150 then
  return { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" ..
  Lang.translate(usecomment) .. "\n" .. self:getHealText() }
  else
    return { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" .. self:getHealText() }
  end
end

return LegendaryHeroItem
