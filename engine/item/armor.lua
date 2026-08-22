--- @class Dummy.Item.Armor : Dummy.Item
---
--- @field protected value number
--- @field protected equip_sound string|nil
local ArmorItem = Class(Item, "Dummy.Item.Armor")

--- Creates an armor item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @return Dummy.Item.Armor
function ArmorItem:new(id, name, short_name, description, value)
  self = Class:new(ArmorItem, { id, name, short_name, description })

  self.value = value
  self.equip_sound = "equip"

  return self
end

--- Gets the armor's value
--- @return number
function ArmorItem:getValue()
  return self.value
end

--- Sets the armor's value
--- @param value number
function ArmorItem:setValue(value)
  self.value = value
end

--- Gets the armor's equip sound
--- @return string|nil
function ArmorItem:getEquipSound()
  return self.equip_sound
end

--- Sets the armor's equip sound
--- @param equip_sound string|nil
function ArmorItem:setEquipSound(equip_sound)
  self.equip_sound = equip_sound
end

--- Gets the armor's dialogue texts
--- @return Dummy.Text.Text[]
function ArmorItem:getDialogueTexts()
  local texts = self:getUseTexts()
  if #texts <= 0 then
    texts = { { "ITEM_ACTION_EQUIPMENT_USE", Lang.translate(self:getName()) } }
  end
  return texts
end

--- Uses the armor item
function ArmorItem:use()
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

  local armor = Player.getArmor()
  Player.addItem(armor)
  if type(armor.onUnequip) == "function" then
    armor:onUnequip()
  end

  Player.setArmor(self)

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called when the armor is unequipped
function ArmorItem:onUnequip() end

return ArmorItem
