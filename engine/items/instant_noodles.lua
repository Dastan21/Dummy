--- @class Item.InstantNoodles : Dummy.Item.Consumable
local InstantNoodlesItem = Class(ItemConsumable, "Item.InstantNoodles")

--- Creates an instant noodles
--- @return Item.InstantNoodles
function InstantNoodlesItem:new()
  self = Class:new(InstantNoodlesItem, {
    "instant_noodles",                                     -- item identifier
    "ITEM_INSTANT_NOODLES_NAME",         -- item name
    "ITEM_INSTANT_NOODLES_SHORTNAME",    -- item short name
    "ITEM_INSTANT_NOODLES_DESCRIPTION", -- item description
    15,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(50)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_INSTANT_NOODLES_DESCRIPTION_SHOP")
  --self:setUseText("ITEM_INSTANT_NOODLES_USE")
  return self
end

function InstantNoodlesItem:getHeal()
  if World.isInBattle() then
    --TODO: Serious Mode Check?
    return 4
  else
    return 15
  end
end

function InstantNoodlesItem:getDialogueTexts()
  -- TODO: Make this accurate. Stop music and delay use sounds. Override use function?
  local usetext = { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) ..
  "\n" .. self:getHealText() }
  local dialogue_text = usetext
  if World.isInBattle() then
    dialogue_text = {
      Lang.translate("ITEM_INSTANT_NOODLES_USE"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_2"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_3"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_4"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_5"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_6"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_7"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_8"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_9"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_10"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_11"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_12"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_13"),
      Lang.translate("ITEM_INSTANT_NOODLES_USE_14"),
    }
    table.insert(dialogue_text, usetext)
  end
  return dialogue_text
end


return InstantNoodlesItem
