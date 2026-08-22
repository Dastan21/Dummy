--[[
  Generated from ..\engine\item\weapon.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/item/weapon.lua
]]

---@meta

--- @class Dummy.Item.Weapon : Dummy.Item
---
--- @field protected value number
--- @field protected equip_sound string|nil
WeaponItem = {}

--- Creates a weapon item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @return Dummy.Item.Weapon
function WeaponItem:new(id, name, short_name, description, value) end

--- Gets the weapon's value
--- @return number
function WeaponItem:getValue() end

--- Sets the weapon's value
--- @param value number
function WeaponItem:setValue(value) end

--- Gets the weapon's equip sound
--- @return string|nil
function WeaponItem:getEquipSound() end

--- Sets the weapon's equip sound
--- @param equip_sound string|nil
function WeaponItem:setEquipSound(equip_sound) end

--- Gets the weapon's dialogue texts
--- @return Dummy.Text.Text[]
function WeaponItem:getDialogueTexts() end

--- Uses the weapon item
function WeaponItem:use() end

--- Called when the weapon is unequipped
function WeaponItem:onUnequip() end

