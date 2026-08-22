--[[
  Generated from ..\engine\item\consumable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/item/consumable.lua
]]

---@meta

--- @class Dummy.Item.Consumable : Dummy.Item
---
--- @field protected heal number
--- @field protected type "food" | "drink"
ConsumableItem = {}

--- Creates a consumable item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param heal number
--- @param type "food" | "drink"
--- @return Dummy.Item.Consumable
function ConsumableItem:new(id, name, short_name, description, heal, type) end

--- Gets the consumable's heal amount
--- @return number
function ConsumableItem:getHeal() end

--- Sets the consumable's heal amount
--- @param heal number
function ConsumableItem:setHeal(heal) end

--- Gets the consumable's type
--- @return "food" | "drink"
function ConsumableItem:getType() end

--- Sets the consumable's type
--- @param type "food" | "drink"
function ConsumableItem:setType(type) end

--- Gets the consumable's swallow sound
--- @return string|nil
function ConsumableItem:getSwallowSound() end

--- Sets the consumable's swallow sound
--- @param swallow_sound string|nil
function ConsumableItem:setSwallowSound(swallow_sound) end

--- Gets the consumable's heal sound
--- @return string|nil
function ConsumableItem:getHealSound() end

--- Sets the consumable's heal sound
--- @param heal_sound string|nil
function ConsumableItem:setHealSound(heal_sound) end

--- Gets the consumable's heal text
--- @return string
function ConsumableItem:getHealText() end

--- Gets the consumable's dialogue texts
--- @return Dummy.Text.Text[]
function ConsumableItem:getDialogueTexts() end

--- Uses the consumable item
function ConsumableItem:use() end

