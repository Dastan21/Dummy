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

  return self
end

function SpiderDonutItem:getDialogueTexts()
  -- Set Default Dialogue Text
  local dialogue_text = Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" .. self:getHealText()
  -- Check if the player is in a battle
  if World.isInBattle() then
    -- Generate a random number
    local rand = love.math.random(0, 10)
    -- Override dialogue text with a comment based on the random number
    if rand > 9 then
      dialogue_text = Lang.translate("ITEM_SPIDER_DONUT_USE")
    end
  end
  return { dialogue_text, table.unpack(self:getUseTexts(), 2) }
end

return SpiderDonutItem
