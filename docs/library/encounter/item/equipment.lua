--[[
  Generated from ..\engine\encounter\item\equipment.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/item/equipment.lua
]]

---@meta

--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected value number
--- @field protected type "weapon" | "armor"
ItemEquipment = {}

--- Gets the class name
--- @return string
function ItemEquipment:getClass() end

--- Gets the item's value
--- @return number
function ItemEquipment:getValue() end

--- Gets the item's type
--- @return "weapon" | "armor"
function ItemEquipment:getType() end

--- Uses the equipment item
function ItemEquipment:use() end

--- Creates a weapon item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param value number
--- @param type "weapon" | "armor"
--- @return Dummy.Item.Equipment
function ItemEquipment:new(name, short_name, value, type) end

