--[[
  Generated from ..\engine\item\item.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/item/item.lua
]]

---@meta

--- @class Dummy.Item : Dummy.Class
---
--- @field protected id string
--- @field protected name Dummy.Text.Text
--- @field protected short_name Dummy.Text.Text
--- @field protected description Dummy.Text.Text
--- @field protected shop_description Dummy.Text.Text|nil
--- @field protected use_texts Dummy.Text.Text[]
--- @field protected drop_texts Dummy.Text.Text[]
--- @field protected buy_price integer
--- @field protected sell_price integer
Item = {}

--- Gets the item's id
--- @return string
function Item:getId() end

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

--- Gets the item's dialogue description
--- @return Dummy.Text.Text
function Item:getDescription() end

--- Sets the item's dialogue description
--- @param description Dummy.Text.Text
function Item:setDescription(description) end

--- Gets the item's shop dialogue description
--- @return Dummy.Text.Text|nil
function Item:getShopDescription() end

--- Sets the item's shop dialogue description
--- @param description Dummy.Text.Text|nil
function Item:setShopDescription(description) end

--- Gets the item's dialogue use texts
--- @return Dummy.Text.Text[]
function Item:getUseTexts() end

--- Sets the item's dialogue use text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Item:setUseText(text, ...) end

--- Gets the item's dialogue drop texts
--- @return Dummy.Text.Text[]
function Item:getDropTexts() end

--- Sets the item's dialogue drop text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Item:setDropText(text, ...) end

--- Gets the item's buy price
--- @return integer
function Item:getBuyPrice() end

--- Sets the item's buy price
--- @param price integer
function Item:setBuyPrice(price) end

--- Gets the item's sell price
--- @return integer
function Item:getSellPrice() end

--- Sets the item's sell price
--- @param price integer
function Item:setSellPrice(price) end

--- Uses the item
function Item:use() end

--- Called right before the item is used
---
--- Note: You can prevent the item from being used by returning `false`
--- @return boolean
function Item:onBeforeUse() end

--- Called when the item is used
---
--- Note: You can change the item dialogue text here
function Item:onUse() end

--- Drops the item
function Item:drop() end

--- Called right before the item is dropped
---
--- Note: You can prevent the item from being dropped by returning `false`
--- @return boolean
function Item:onBeforeDrop() end

--- Called when the item is dropped
---
--- Note: You can change the item dialogue text here
function Item:onDrop() end

--- Creates an item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @return Dummy.Item
function Item:new(id, name, short_name, description) end

