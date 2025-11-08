--- @class Dummy.Item : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected short_name Dummy.Text.Text
--- @field protected texts Dummy.Text.Text[]
local Item = Class()

--- Gets the class name
--- @return string
function Item.getClassName()
  return "Dummy.Item"
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

--- Gets the item's dialogue texts
--- @return Dummy.Text.Text[]
function Item:getTexts()
  return self.texts
end

--- Sets the item's dialogue text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Item:setText(text, ...)
  self.texts = { text, ... }
end

--- Uses the item
function Item:use()
  if type(self.onBeforeUse) == "function" then
    self:onBeforeUse()
  end

  if #self.texts > 0 then
    Encounter.playDialogueText(table.unpack(self.texts))
  end

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called right before the item is used
function Item:onBeforeUse() end

--- Called when the item is used
---
--- Note: you can change the item dialogue text here
function Item:onUse() end

--- Creates an item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @return Dummy.Item
function Item:new(name, short_name)
  self = Class:new(Item)
  self.name = name
  self.short_name = short_name
  self.texts = {}

  return self
end

return Item
