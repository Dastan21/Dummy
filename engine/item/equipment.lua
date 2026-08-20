--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected value number
--- @field protected type "weapon" | "armor"
local ItemEquipment = Class(Item, "Dummy.Item.Equipment")

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

--- (Override) Do something when attacking in a battle with the currently equipped weapon.
---
--- Note: Setting this to true will override the standard Battle attack function.
--- @return boolean
function ItemEquipment:GetAttackEffect() return false end
--- Gets the currently equipped weapon's crit rate
--- @return number
function ItemEquipment:GetWeaponCrit() return 2.2 end
--- (Override) Gets the item's final dialogue text when used
--- @return Dummy.Text.Text[]
function ItemEquipment:getDialogueTexts()
  local texts = self:getUseTexts()
  if #texts <= 0 then
    texts = { { "BATTLE_ITEM_EQUIPMENT_USE", Lang.translate(self:getName()) } }
  end
  return texts
end

--- Uses the equipment item
function ItemEquipment:use()
  if type(self.onBeforeUse) == "function" then
    self:onBeforeUse()
  end

  local texts = self:getDialogueTexts()
  if World.isInBattle() then
    Battle.playDialogueText(table.unpack(texts))
  else
    World.playDialogue(texts)
  end
  Player.removeItem(self)
  Assets.playSound("item")

  if self:getType() == "weapon" then
    local weapon = Player.getWeapon()

    Player.setWeapon(self)

    if weapon:getId() == "stick" then
      local stick = Item:new(
        "stick",
        "ITEM_STICK_NAME",
        "ITEM_STICK_SHORTNAME",
        "ITEM_STICK_DESCRIPTION"
      )
      stick:setUseText("ITEM_STICK_USE")
      stick:setSellPrice(150)

      Player.addItem(stick)
    else
      Player.addItem(weapon)
    end
  elseif self:getType() == "armor" then
    local armor = Player.getArmor()

    Player.setArmor(self)

    if armor:getId() == "bandage" then
      local bandage = ItemConsumable:new(
        "bandage",
        "ITEM_BANDAGE_NAME",
        "ITEM_BANDAGE_SHORTNAME",
        "ITEM_BANDAGE_DESCRIPTION",
        10,
        "food"
      )
      bandage:setUseText("ITEM_BANDAGE_USE")
      bandage:setSellPrice(150)

      Player.addItem(bandage)
    else
      Player.addItem(armor)
    end
  end

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Creates a weapon item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @param type "weapon" | "armor"
--- @return Dummy.Item.Equipment
function ItemEquipment:new(id, name, short_name, description, value, type)
  self = Class:new(ItemEquipment, { id, name, short_name, description })

  self.value = value
  self.type = type

  return self
end

return ItemEquipment
