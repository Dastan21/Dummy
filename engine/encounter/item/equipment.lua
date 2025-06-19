--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected super Dummy.Item
--- @field protected value number
--- @field protected type "weapon" | "armor"
local ItemEquipment = Class:extend(Item)

--- Gets the class name
--- @return string
function ItemEquipment:getClass()
  return "Dummy.Item.Equipment"
end

--- Gets the item's value
--- @return number
function ItemEquipment:getValue()
  return self.value
end

--- Gets the item's type
--- @return "weapon" | "armor"
function ItemEquipment:getType()
  return self.type
end

--- Uses the equipment item
function ItemEquipment:use()
  local armor = Player.getArmor()
  if armor:getName() == "Bandage" then
    local bandage = ItemConsumable:new("Bandage", "Bandage", 10, "food")
    bandage:setText("ENCOUNTER_ITEM_USE_BANDAGE")

    Player.addItem(bandage)
  end

  Encounter.playDialogue({ "ENCOUNTER_ITEM_EQUIPMENT_USE", self.name })
  Player.removeItem(self)
  Assets.playSound("item")

  if self.type == "weapon" then
    Player.setAT(Player.getAT() + self.value)
    Player.setWeapon(self)
  elseif self.type == "armor" then
    Player.setDF(Player.getDF() + self.value)
    Player.setArmor(self)
  end


  if (type(self.onUse) == "function") then
    self:onUse()
  end
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
