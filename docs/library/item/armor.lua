--[[
  Generated from ..\engine\item\armor.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/item/armor.lua
]]

---@meta

--- @class Dummy.Item.Armor : Dummy.Item
---
--- @field protected value number
--- @field protected equip_sound string|nil
ArmorItem = {}

--- Creates an armor item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @return Dummy.Item.Armor
function ArmorItem:new(id, name, short_name, description, value) end

--- Gets the armor's value
--- @return number
function ArmorItem:getValue() end

--- Sets the armor's value
--- @param value number
function ArmorItem:setValue(value) end

--- Gets the armor's equip sound
--- @return string|nil
function ArmorItem:getEquipSound() end

--- Sets the armor's equip sound
--- @param equip_sound string|nil
function ArmorItem:setEquipSound(equip_sound) end

--- Gets the armor's dialogue texts
--- @return Dummy.Text.Text[]
function ArmorItem:getDialogueTexts() end

--- Uses the armor item
function ArmorItem:use() end

--- Called when the armor is unequipped
function ArmorItem:onUnequip() end

