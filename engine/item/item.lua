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
local Item = Class("Dummy.Item")

--- Gets the item's id
--- @return string
function Item:getId()
  return self.id
end

--- Gets the item's name
--- @return Dummy.Text.Text
function Item:getName()
  return self.name
end

--- Sets the item's name
--- @param name Dummy.Text.Text
function Item:setName(name)
  self.name = name
end

--- Gets the item's short name
--- @return Dummy.Text.Text
function Item:getShortName()
  return self.short_name
end

--- Sets the item's short name
--- @param short_name Dummy.Text.Text
function Item:setShortName(short_name)
  self.short_name = short_name
end

--- Gets the item's dialogue description
--- @return Dummy.Text.Text
function Item:getDescription()
  return self.description
end

--- Sets the item's dialogue description
--- @param description Dummy.Text.Text
function Item:setDescription(description)
  self.description = description
end

--- Gets the item's shop dialogue description
--- @return Dummy.Text.Text|nil
function Item:getShopDescription()
  return self.shop_description
end

--- Sets the item's shop dialogue description
--- @param description Dummy.Text.Text|nil
function Item:setShopDescription(description)
  self.shop_description = description
end

--- Gets the item's dialogue use texts
--- @return Dummy.Text.Text[]
function Item:getUseTexts()
  return self.use_texts
end

--- Sets the item's dialogue use text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Item:setUseText(text, ...)
  self.use_texts = { text, ... }
end

--- Gets the item's dialogue drop texts
--- @return Dummy.Text.Text[]
function Item:getDropTexts()
  return self.drop_texts
end

--- Sets the item's dialogue drop text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Item:setDropText(text, ...)
  self.drop_texts = { text, ... }
end

--- (Override) Gets the item's final dialogue text when used
--- @return Dummy.Text.Text[]
function Item:getDialogueTexts()
  return self:getUseTexts()
end

--- Gets the item's buy price
--- @return integer
function Item:getBuyPrice()
  return self.buy_price
end

--- Sets the item's buy price
--- @param price integer
function Item:setBuyPrice(price)
  self.buy_price = math.floor(price)
end

--- Gets the item's sell price
--- @return integer
function Item:getSellPrice()
  return self.sell_price
end

--- Sets the item's sell price
--- @param price integer
function Item:setSellPrice(price)
  self.sell_price = math.floor(price)
end

--- Uses the item
function Item:use()
  local can_use = true
  if type(self.onBeforeUse) == "function" then
    can_use = self:onBeforeUse()
  end

  if not can_use then return end

  local dialogue_texts = self:getDialogueTexts()
  if #dialogue_texts > 0 then
    if World.isInBattle() then
      Battle.playDialogueText(table.unpack(dialogue_texts))
    else
      World.playDialogue(dialogue_texts)
    end
  end

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called right before the item is used
---
--- Note: You can prevent the item from being used by returning `false`
--- @return boolean
function Item:onBeforeUse() return true end

--- Called when the item is used
---
--- Note: You can change the item dialogue text here
function Item:onUse() end

--- Drops the item
function Item:drop()
  local can_drop = true
  if type(self.onBeforeDrop) == "function" then
    can_drop = self:onBeforeDrop()
  end
  if not can_drop then return end

  if not World.isInBattle() then
    local text = "WORLD_ITEM_DROP_5"
    local rand = math.round(love.math.random(18))
    if rand == 0 then
      text = "WORLD_ITEM_DROP_1"
    elseif rand == 1 then
      text = "WORLD_ITEM_DROP_2"
    elseif rand == 2 then
      text = "WORLD_ITEM_DROP_3"
    elseif rand == 3 then
      text = "WORLD_ITEM_DROP_4"
    end

    local texts = self:getDropTexts()
    if #texts <= 0 then
      texts = { { text, self:getName() } }
    end
    World.playDialogue(texts)
  end

  Player.removeItem(self)

  if type(self.onDrop) == "function" then
    self:onDrop()
  end
end

--- Called right before the item is dropped
---
--- Note: You can prevent the item from being dropped by returning `false`
--- @return boolean
function Item:onBeforeDrop() return true end

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
function Item:new(id, name, short_name, description)
  self = Class:new(Item)

  self.id = id
  self.name = name
  self.short_name = short_name
  self.description = description
  self.use_texts = {}
  self.drop_texts = {}
  self.buy_price = 0
  self.sell_price = 0

  return self
end

return Item
