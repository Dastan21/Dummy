--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
local ItemConsumable = Class(Item, "Dummy.Item.Consumable")

--- Gets the item's heal amount
--- @return number
function ItemConsumable:getHeal()
  return self.heal
end

--- Sets the item's heal amount
--- @param heal number
function ItemConsumable:setHeal(heal)
  self.heal = heal
end

--- Gets the item's type
--- @return "food" | "drink"
function ItemConsumable:getType()
  return self.type
end

--- Sets the item's type
--- @param type "food" | "drink"
function ItemConsumable:setType(type)
  self.type = type
end

--- Uses the consumable item
function ItemConsumable:use()
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

--- Creates a consumable item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ItemConsumable:new(id, name, short_name, description, heal, type)
  self = Class:new(ItemConsumable, { id, name, short_name, description })

  self.heal = heal
  self.use_texts = { type == "drink" and "BATTLE_ITEM_DRINK_USE" or "BATTLE_ITEM_FOOD_USE" }

  return self
end

return ItemConsumable
