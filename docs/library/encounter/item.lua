--[[
  Generated from ..\engine\encounter\item.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/item.lua
]]

---@meta

--- @class Dummy.Item : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected short_name Dummy.Text.Text
--- @field protected text Dummy.Text.Text|nil
Item = {}

--- Gets the class name
--- @return string
function Item.getClassName() end

--- Gets the item's name
--- @return Dummy.Text.Text
function Item:getName() end

--- Sets the item's name
--- @param name Dummy.Text.Text
function Item:setName(name) end

--- Gets the item's short name
--- @return Dummy.Text.Text
function Item:getShortName() end

--- Sets the item's short name
--- @param short_name Dummy.Text.Text
function Item:setShortName(short_name) end

--- Gets the item's dialogue text
--- @return Dummy.Text.Text
function Item:getText() end

--- Sets the item's dialogue text
--- @param text Dummy.Text.Text
function Item:setText(text) end

--- Uses the item
function Item:use() end

--- Called when the item is used
function Item:onUse() end

--- Creates an item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @return Dummy.Item
function Item:new(name, short_name) end

