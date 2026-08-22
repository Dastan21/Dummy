--- @class Dummy.Item.SpiderDonut : Dummy.Item.Consumable
local SpiderDonutItem = Class(ConsumableItem, "Dummy.Item.SpiderDonut")

--- Creates a spider donut
--- @return Dummy.Item.SpiderDonut
function SpiderDonutItem:new()
  self = Class:new(SpiderDonutItem, {
    "spider_donut",
    "ITEM_SPIDER_DONUT_NAME",
    "ITEM_SPIDER_DONUT_SHORTNAME",
    "ITEM_SPIDER_DONUT_DESCRIPTION",
    12,
    "food"
  })

  self:setBuyPrice(7)
  self:setSellPrice(30)
  self:setShopDescription("ITEM_SPIDER_DONUT_DESCRIPTION_SHOP")
  self:setUseText("ITEM_SPIDER_DONUT_USE")

  return self
end

--- Gets the spider donut's dialogue texts
--- @return Dummy.Text.Text[]
function SpiderDonutItem:getDialogueTexts()
  local dialogue_text = Lang.translate("ITEM_SPIDER_DONUT_USE")
  if World.isInBattle() then
    local rand = love.math.random(0, 10)
    if rand > 9 then
      dialogue_text = Lang.translate("ITEM_SPIDER_DONUT_USE_DIDNT")
    end
  end
  dialogue_text = dialogue_text .. "\n" .. self:getHealText()
  return { dialogue_text }
end

return SpiderDonutItem
