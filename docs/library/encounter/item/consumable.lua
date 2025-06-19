--[[
  Generated from ..\engine\encounter\item\consumable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/item/consumable.lua
]]

---@meta

--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
ItemConsumable = {}

--- Gets the class name
--- @return string
function ItemConsumable:getClass() end

--- Gets the item's heal amount
--- @return number
function ItemConsumable:getHeal() end

--- Gets the item's type
--- @return "food" | "drink"
function ItemConsumable:getType() end

--- Uses the consumable item
function ItemConsumable:use() end

--- Creates a consumable item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ItemConsumable:new(name, short_name, heal, type) end

