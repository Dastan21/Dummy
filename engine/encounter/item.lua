--- @class Dummy.Item : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected short_name Dummy.Text.Text
--- @field protected text Dummy.Text.Text|nil
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

--- Gets the item's dialogue text
--- @return Dummy.Text.Text
function Item:getText()
  return self.text
end

--- Sets the item's dialogue text
--- @param text Dummy.Text.Text
function Item:setText(text)
  self.text = text
end

--- Uses the item
function Item:use()
  if type(self.onBeforeUse) == "function" then
    self:onBeforeUse()
  end

  if self.text ~= nil then
    Encounter.playDialogueText(self.text)
  end

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called right before the item is used
---
--- Note: you can change the item dialogue text here
function Item:onBeforeUse() end

--- Called when the item is used
function Item:onUse() end

--- Creates an item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @return Dummy.Item
function Item:new(name, short_name)
  self = Class:new(Item)
  self.name = name
  self.short_name = short_name

  return self
end

return Item
