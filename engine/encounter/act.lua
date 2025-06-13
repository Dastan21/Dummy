--- @class Dummy.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected text Dummy.Text.Text|nil
local ACT = Class()

--- Gets the class name
--- @return string
function ACT:getClass()
  return "Dummy.ACT"
end

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName()
  return self.name
end

--- Gets the ACT's dialogue text
--- @return Dummy.Text.Text
function ACT:getText()
  return self.text
end

--- Sets the ACT's dialogue text
--- @param text Dummy.Text.Text
function ACT:setText(text)
  self.text = text
end

--- Called when the ACT is used
function ACT:use()
  if self.text ~= nil then
    Encounter.playDialogue(self.text)
  end
end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.ACT
function ACT:new(name)
  return Class:new(ACT, {
    name = name
  })
end

return ACT
