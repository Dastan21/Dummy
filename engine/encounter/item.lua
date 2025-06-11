--- @class Dummy.Item : Dummy.Class
---
--- @field protected name Dummy.Text.Text
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

--- Called when the item is used
function Item:use() end

--- Creates an item
--- @param name Dummy.Text.Text
--- @return Dummy.Item
function Item:new(name)
  return Class:new(Item, {
    name = name
  })
end

return Item
