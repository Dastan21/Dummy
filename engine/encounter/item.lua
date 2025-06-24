--- @class Dummy.Item : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected short_name Dummy.Text.Text
--- @field protected text Dummy.Text.Text|nil
local Item = Class()

--- Gets the class name
--- @return string
function Item:getClass()
  return "Dummy.Item"
end

--- Gets the item's name
--- @return Dummy.Text.Text
function Item:getName()
  return self.name
end

--- Gets the item's short name
--- @return Dummy.Text.Text
function Item:getShortName()
  return self.short_name
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
  if self.text ~= nil then
    Encounter.playTextbox(self.text)
    local dialogue = Encounter.getTextbox()
    dialogue:setCanSkip(true)
  end

  self:onUse()
end

--- Called when the item is used
function Item:onUse() end

--- Creates an item
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @return Dummy.Item
function Item:new(name, short_name)
  return Class:new(Item, {
    name = name,
    short_name = short_name,
  })
end

return Item
