--[[
  Generated from ..\engine\item\equipment.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/item/equipment.lua
]]

---@meta

--- @class Dummy.Item.Equipment : Dummy.Item
---
--- @field protected value number
--- @field protected type "weapon" | "armor"
ItemEquipment = {}

--- Gets the item's value
--- @return number
function ItemEquipment:getValue() end

--- Sets the item's value
--- @param value number
function ItemEquipment:setValue(value) end

--- Gets the item's type
--- @return "weapon" | "armor"
function ItemEquipment:getType() end

--- Sets the item's type
--- @param type "weapon" | "armor"
function ItemEquipment:setType(type) end

--- Uses the equipment item
function ItemEquipment:use() end

--- Creates a weapon item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @param type "weapon" | "armor"
--- @return Dummy.Item.Equipment
function ItemEquipment:new(id, name, short_name, description, value, type) end

