--- @class Item.NiceCream : Dummy.Item.Consumable
local NiceCreamItem = Class(ItemConsumable, "Item.NiceCream")

--- Creates a spider donut
--- @return Item.NiceCream
function NiceCreamItem:new()
  self = Class:new(NiceCreamItem, {
    "nice_cream",                                     -- item identifier
    "ITEM_NICE_CREAM_NAME",         -- item name
    "ITEM_NICE_CREAM_SHORTNAME",    -- item short name
    "ITEM_NICE_CREAM_DESCRIPTION",  -- item description
    15,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(2)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_NICE_CREAM_DESCRIPTION_SHOP")

  self.use_texts = {
    "BATTLE_ITEM_FOOD_USE"
  }

  -- Use Comments. Randomly selected. Discarded if empty.

  self.use_comments = {
    "BATTLE_NICE_CREAM_USE",
    "BATTLE_NICE_CREAM_USE_2",
    "BATTLE_NICE_CREAM_USE_3",
    "BATTLE_NICE_CREAM_USE_4",
    "BATTLE_NICE_CREAM_USE_5",
    "BATTLE_NICE_CREAM_USE_6",
    "BATTLE_NICE_CREAM_USE_7",
    "BATTLE_NICE_CREAM_USE_8"
  }

  return self
end

function NiceCreamItem:use()

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

  local rand = love.math.random(8)
  -- Random comments on use
  if #self.use_comments > 0 then -- Check nil
    if rand == 0 then
      dialogue_text = Lang.translate(self.use_comments[1])
    end
    if rand == 1 then
      dialogue_text = Lang.translate(self.use_comments[2])
    end
    if rand == 2 then
      dialogue_text = Lang.translate(self.use_comments[3])
    end
    if rand == 3 then
      dialogue_text = Lang.translate(self.use_comments[4])
    end
    if rand == 4 then
      dialogue_text = Lang.translate(self.use_comments[5])
    end
    if rand == 5 then
      dialogue_text = Lang.translate(self.use_comments[6])
    end
    if rand == 6 then
      dialogue_text = Lang.translate(self.use_comments[7])
    end
    if rand == 7 then
      dialogue_text = Lang.translate(self.use_comments[8])
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

return NiceCreamItem
