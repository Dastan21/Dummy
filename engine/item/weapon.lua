--- @class Dummy.Item.Weapon : Dummy.Item
---
--- @field protected value number
--- @field protected equip_sound string|nil
local WeaponItem = Class(Item, "Dummy.Item.Weapon")

--- Creates a weapon item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @return Dummy.Item.Weapon
function WeaponItem:new(id, name, short_name, description, value)
  self = Class:new(WeaponItem, { id, name, short_name, description })

  self.value = value
  self.equip_sound = "equip"

  return self
end

--- Gets the weapon's value
--- @return number
function WeaponItem:getValue()
  return self.value
end

--- Sets the weapon's value
--- @param value number
function WeaponItem:setValue(value)
  self.value = value
end

--- Gets the weapon's equip sound
--- @return string|nil
function WeaponItem:getEquipSound()
  return self.equip_sound
end

--- Sets the weapon's equip sound
--- @param equip_sound string|nil
function WeaponItem:setEquipSound(equip_sound)
  self.equip_sound = equip_sound
end

--- Gets the weapon's dialogue texts
--- @return Dummy.Text.Text[]
function WeaponItem:getDialogueTexts()
  local texts = self:getUseTexts()
  if #texts <= 0 then
    texts = { { "ITEM_ACTION_EQUIPMENT_USE", Lang.translate(self:getName()) } }
  end
  return texts
end

--- Uses the weapon item
function WeaponItem:use()
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

  local equip_sound = self:getEquipSound()
  if equip_sound ~= nil then
    Assets.playSound(equip_sound)
  end

  local weapon = Player.getWeapon()
  Player.addItem(weapon)
  if type(weapon.onUnequip) == "function" then
    weapon:onUnequip()
  end

  Player.setWeapon(self)

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called when the weapon is unequipped
function WeaponItem:onUnequip() end

return WeaponItem
