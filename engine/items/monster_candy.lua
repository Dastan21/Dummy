--- @class Item.MonsterCandy : Dummy.Item.Consumable
local MonsterCandyItem = Class(ItemConsumable, "Item.MonsterCandy")

--- Creates a monster candy
--- @return Item.MonsterCandy
function MonsterCandyItem:new()
  self = Class:new(MonsterCandyItem, {
    "monster_candy",                                    -- item identifier
    "ITEM_MONSTER_CANDY_NAME",        -- item name
    "ITEM_MONSTER_CANDY_SHORTNAME",   -- item short name
    "ITEM_MONSTER_CANDY_DESCRIPTION", -- item description
    10,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(25)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_MONSTER_CANDY_DESCRIPTION_SHOP")

  self.use_texts = {
    "BATTLE_ITEM_FOOD_USE"
  }

  -- Use Comments. Randomly selected. Discarded if empty.

  self.use_comments = {
    "BATTLE_MONSTER_CANDY_USE",
    "BATTLE_MONSTER_CANDY_USE_2"
  }

  return self
end

function MonsterCandyItem:getDialogueTexts()
  local rand = love.math.random(1, 15)
  local usecomment = ""
  local dialogue_text = { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) ..
  "\n" .. self:getHealText() }
  -- Random comments on use
  if rand <= 2 then
    usecomment = self.use_comments[1]
  elseif rand == 15 then
    usecomment = self.use_comments[2]
  end
  if usecomment ~= "" then
    dialogue_text = { Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. Lang.translate(usecomment) .. "\n" .. self:getHealText() }
  end
  return { dialogue_text, table.unpack(self:getUseTexts(), 2) }
end

return MonsterCandyItem
