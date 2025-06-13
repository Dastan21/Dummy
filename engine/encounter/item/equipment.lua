--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected value number
--- @field protected type "weapon" | "armor"
local ItemEquipment = Class:extend(Item)

--- Gets the class name
--- @return string
function ItemEquipment:getClass()
  return "Dummy.Item.Equipment"
end

function ItemEquipment:getType()
  return self.type
end

--- Uses the item
function ItemEquipment:use()
  Encounter.playDialogue({ "ENCOUNTER_ITEM_EQUIPMENT_USE", self.name })
  Player.removeItem(self)

  Assets.playSound("item")
end

--- Creates a weapon item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param value number
--- @param type "weapon" | "armor"
--- @return Dummy.Item.Equipment
function ItemEquipment:new(name, short_name, value, type)
  return Class:new(ItemEquipment, {
    value = value,
    type = type
  }, { name, short_name })
end

return ItemEquipment
