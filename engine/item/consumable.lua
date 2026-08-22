--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
local ConsumableItem = Class(Item, "Dummy.Item.Consumable")

--- Creates a consumable item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ConsumableItem:new(id, name, short_name, description, heal, type)
  self = Class:new(ConsumableItem, { id, name, short_name, description })

  self.heal = heal
  self.swallow_sound = "swallow"
  self.heal_sound = "heal"

  self:setType(type)

  return self
end

--- Gets the consumable's heal amount
--- @return number
function ConsumableItem:getHeal()
  return self.heal
end

--- Sets the consumable's heal amount
--- @param heal number
function ConsumableItem:setHeal(heal)
  self.heal = heal
end

--- Gets the consumable's type
--- @return "food" | "drink"
function ConsumableItem:getType()
  return self.type
end

--- Sets the consumable's type
--- @param type "food" | "drink"
function ConsumableItem:setType(type)
  if self.type == type then return end

  self.type = type

  self:setUseText(type == "drink" and "ITEM_ACTION_DRINK_USE" or "ITEM_ACTION_FOOD_USE")
end

--- Gets the consumable's swallow sound
--- @return string|nil
function ConsumableItem:getSwallowSound()
  return self.swallow_sound
end

--- Sets the consumable's swallow sound
--- @param swallow_sound string|nil
function ConsumableItem:setSwallowSound(swallow_sound)
  self.swallow_sound = swallow_sound
end

--- Gets the consumable's heal sound
--- @return string|nil
function ConsumableItem:getHealSound()
  return self.heal_sound
end

--- Sets the consumable's heal sound
--- @param heal_sound string|nil
function ConsumableItem:setHealSound(heal_sound)
  self.heal_sound = heal_sound
end

--- Gets the consumable's heal text
--- @return string
function ConsumableItem:getHealText()
  local heal_amount = self:getHeal()
  local heal_text = Lang.translate("ITEM_ACTION_HEAL", heal_amount)

  if heal_amount < 0 then
    heal_text = Lang.translate("ITEM_ACTION_HURT", math.abs(heal_amount))
  elseif heal_amount + Player.getHP() >= Player.getMaxHP() then
    heal_text = Lang.translate("ITEM_ACTION_HEAL_MAX")
  end

  return heal_text
end

--- Gets the consumable's dialogue texts
--- @return Dummy.Text.Text[]
function ConsumableItem:getDialogueTexts()
  local heal_text = self:getHealText()
  local dialogue_text = heal_text

  local use_texts = self:getUseTexts()
  if #use_texts > 0 then
    dialogue_text = Lang.translate(use_texts[1], Lang.translate(self:getName())) .. "\n" .. heal_text
  end

  return { dialogue_text, table.unpack(use_texts, 2) }
end

--- Uses the consumable item
function ConsumableItem:use()
  local can_use = true
  if type(self.onBeforeUse) == "function" then
    can_use = self:onBeforeUse()
  end
  if not can_use then return end

  local texts = self:getDialogueTexts()
  if World.isInBattle() then
    Battle.playDialogueText(table.unpack(texts))
  else
    World.playDialogue(texts)
  end
  Player.removeItem(self)

  local swallow_sound = self:getSwallowSound()
  if swallow_sound ~= nil then
    Assets.playSound(swallow_sound)
  end

  local heal_sound = self:getHealSound()
  if heal_sound ~= nil then
    Timer.after(0.5, function()
      Assets.playSound(heal_sound)
    end)
  end

  Soul.heal(self:getHeal(), true)

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

return ConsumableItem
