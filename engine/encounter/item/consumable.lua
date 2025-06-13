--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
local ItemConsumable = Class:extend(Item)

--- Gets the class name
--- @return string
function ItemConsumable:getClass()
  return "Dummy.Item.Consumable"
end

--- Uses the item
function ItemConsumable:use()
  local heal_text = Lang.translate("ENCOUNTER_ITEM_HEAL", self.heal)
  if self.heal + Player.getHP() >= Player.getMaxHP() then
    heal_text = Lang.translate("ENCOUNTER_ITEM_HEAL_MAX")
  end

  local dialogue_text = heal_text
  if self.text ~= nil then
    dialogue_text = Lang.translate(self.text, self.name) .. "\n" .. heal_text
  end

  Encounter.playDialogue(dialogue_text)
  Player.removeItem(self)

  Assets.playSound("swallow")
  Timer.after(0.5, function()
    Player.heal(self.heal)
  end)
end

--- Creates a consumable item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ItemConsumable:new(name, short_name, heal, type)
  return Class:new(ItemConsumable, {
    heal = heal,
    text = type == "drink" and "ENCOUNTER_ITEM_DRINK_USE" or "ENCOUNTER_ITEM_FOOD_USE",
  }, { name, short_name })
end

return ItemConsumable
