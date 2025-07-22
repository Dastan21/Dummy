--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected value number
--- @field protected type "weapon" | "armor"
local ItemEquipment = Class:extend(Item)

--- Gets the class name
--- @return string
function ItemEquipment.getClassName()
  return "Dummy.Item.Equipment"
end

--- Gets the item's value
--- @return number
function ItemEquipment:getValue()
  return self.value
end

--- Sets the item's value
--- @param value number
function ItemEquipment:setValue(value)
  self.value = value
end

--- Gets the item's type
--- @return "weapon" | "armor"
function ItemEquipment:getType()
  return self.type
end

--- Sets the item's type
--- @param type "weapon" | "armor"
function ItemEquipment:setType(type)
  self.type = type
end

--- Uses the equipment item
function ItemEquipment:use()
  Encounter.playDialogueText({ "ENCOUNTER_ITEM_EQUIPMENT_USE", Lang.translate(self.name) })
  Player.removeItem(self)
  Assets.playSound("item")

  if self.type == "weapon" then
    local weapon = Player.getWeapon()

    Player.setAT(Player.getAT() + self.value)
    Player.setWeapon(self)

    if weapon:getName() == "ENCOUNTER_ITEM_NAME_STICK" then
      local stick = Item:new("ENCOUNTER_ITEM_NAME_STICK", "ENCOUNTER_ITEM_SHORTNAME_STICK")
      stick:setText("ENCOUNTER_ITEM_USE_STICK")

      Player.addItem(stick)
    else
      Player.addItem(weapon)
    end
  elseif self.type == "armor" then
    local armor = Player.getArmor()

    Player.setDF(Player.getDF() + self.value)
    Player.setArmor(self)

    if armor:getName() == "ENCOUNTER_ITEM_NAME_BANDAGE" then
      local bandage = ItemConsumable:new("ENCOUNTER_ITEM_NAME_BANDAGE", "ENCOUNTER_ITEM_SHORTNAME_BANDAGE", 10, "food")
      bandage:setText("ENCOUNTER_ITEM_USE_BANDAGE")

      Player.addItem(bandage)
    else
      Player.addItem(armor)
    end
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
  self = Class:new(ItemEquipment, { name, short_name })
  self.value = value
  self.type = type

  return self
end

return ItemEquipment
