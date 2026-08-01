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

function MonsterCandyItem:use()
  local rand = love.math.random(1, 15)
  -- Random comments on use
  local usecomment = "" -- Default
  if #self.use_comments > 0 then -- Check nil
    if rand <= 2 then
      usecomment = self.use_comments[1]
    elseif rand == 15 then
      usecomment = self.use_comments[2]
    end
  end

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
    if usecomment ~= "" then
      dialogue_text = Lang.translate(use_texts[1], Lang.translate(self:getName())) .. Lang.translate(usecomment) .. "\n" .. heal_text
    else
      dialogue_text = Lang.translate(use_texts[1], Lang.translate(self:getName())) .. "\n" .. heal_text
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

return MonsterCandyItem
