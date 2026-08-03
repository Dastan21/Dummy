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

function SpiderDonutItem:getDialogueTexts()
  local rand = love.math.random(10)
  local dialogue_text = Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" .. self:getHealText()
  if rand > 9 then
    dialogue_text = Lang.translate(self.use_comments[1])
  end
  return { dialogue_text, table.unpack(self:getUseTexts(), 2) }
end

return SpiderDonutItem
