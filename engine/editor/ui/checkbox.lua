local Button = require "editor.ui.button"

--- @class Dummy.Editor.Checkbox : Dummy.Editor.Button
---
--- @field protected value boolean
--- @field protected prev_value boolean
local Checkbox = Class(Button, "Dummy.Editor.Checkbox")

--- Creates a checkbox
--- @param value? boolean
--- @return Dummy.Editor.Checkbox
function Checkbox:new(value)
  self = Class:new(Checkbox)

  self:setSprite(Sprite:new({
    "editor/check",
    "editor/cross"
  }, 0, false, false))

  self:setValue(Utils.getOrDefault(value, false) == true)

  return self
end

--- Sets the checkbox's icons
--- @param checked string
--- @param unchecked string
function Checkbox:setIcons(checked, unchecked)
  self:setSprite(Sprite:new({ checked, unchecked }, 0, false, false))
end

--- Gets the checkbox's value
--- @return boolean
function Checkbox:getValue()
  return self.value
end

--- Sets the checkbox's value
--- @param value boolean
function Checkbox:setValue(value)
  if self.value == value then return end

  self.value = value

  if value then
    self:getSprite():setFrame(1)
  else
    self:getSprite():setFrame(2)
  end

  if type(self.onChange) == "function" then
    self:onChange()
  end
end

--- Toggles the checkbox's value
function Checkbox:toggle()
  self:setValue(not self:getValue())
end

--- Called when the checkbox's value has changed
function Checkbox:onChange() end

--- Updates the input, called on every frame
--- @param dt number
function Checkbox:update(dt)
  Button.update(self, dt)

  if not self:isVisible() then return end

  if self:isPressed() then
    self:toggle()
  end
end

return Checkbox
