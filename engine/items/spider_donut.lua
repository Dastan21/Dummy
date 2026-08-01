--- @class Item.SpiderDonut : Dummy.Item.Consumable
local SpiderDonutItem = Class(ItemConsumable, "Item.SpiderDonut")

--- Creates a spider donut
--- @return Item.SpiderDonut
function SpiderDonutItem:new()
  self = Class:new(SpiderDonutItem, {
    "spider_donut",                                     -- item identifier
    "ITEM_SPIDER_DONUT_NAME",         -- item name
    "ITEM_SPIDER_DONUT_SHORTNAME",    -- item short name
    "ITEM_SPIDER_DONUT_DESCRIPTION",  -- item description
    12,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(7)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(30)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_SPIDER_DONUT_DESCRIPTION_SHOP")

  self.use_texts = {
    "BATTLE_ITEM_FOOD_USE"
  }

  -- Use Comments. Randomly selected. Discarded if empty.

  self.use_comments = {
    "BATTLE_SPIDER_DONUT_USE"
  }

  return self
end

function SpiderDonutItem:use()

  if type(self.onBeforeUse) == "function" then
    self:onBeforeUse()
  end

  local heal_text = Lang.translate("BATTLE_ITEM_HEAL", self:getHeal())
  if self:getHeal() + Player.getHP() >= Player.getMaxHP() then
    heal_text = Lang.translate("BATTLE_ITEM_HEAL_MAX")
  end

  local dialogue_text = heal_text
  local use_texts = self:getUseTexts()
  if #use_texts > 0 then
    dialogue_text = Lang.translate(use_texts[1], Lang.translate(self:getName())) .. "\n" .. heal_text
  end

  local rand = love.math.random(10)
  -- Random comments on use
  if #self.use_comments > 0 then -- Check nil
    if rand > 9 then
      dialogue_text = Lang.translate(self.use_comments[1])
    end
  end

  local texts = { dialogue_text, table.unpack(use_texts, 2) }
  if World.isInBattle() then
    Battle.playDialogueText(table.unpack(texts))
  else
    World.playDialogue(texts)
  end
  Player.removeItem(self)
  Assets.playSound("swallow")

  Soul.heal(self:getHeal(), true)
  Timer.after(0.5, function()
    Assets.playSound("heal")
  end)

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

return SpiderDonutItem
