--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
local ItemConsumable = Class:extend(Item)

--- Gets the class name
--- @return string
function ItemConsumable.getClassName()
  return "Dummy.Item.Consumable"
end

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
  local heal_text = Lang.translate("ENCOUNTER_ITEM_HEAL", self.heal)
  if self.heal + Player.getHP() >= Player.getMaxHP() then
    heal_text = Lang.translate("ENCOUNTER_ITEM_HEAL_MAX")
  end

  local dialogue_text = heal_text
  if self.text ~= nil then
    dialogue_text = Lang.translate(self.text, Lang.translate(self.name)) .. "\n" .. heal_text
  end

  Encounter.playDialogueText(dialogue_text)
  Player.removeItem(self)
  Assets.playSound("swallow")

  Player.heal(self.heal, true)
  Timer.after(0.5, function()
    Assets.playSound("heal")
  end)

  if (type(self.onUse) == "function") then
    self:onUse()
  end
end

--- Creates a consumable item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ItemConsumable:new(name, short_name, heal, type)
  self = Class:new(ItemConsumable, { name, short_name })
  self.heal = heal
  self.text = type == "drink" and "ENCOUNTER_ITEM_DRINK_USE" or "ENCOUNTER_ITEM_FOOD_USE"

  return self
end

return ItemConsumable
