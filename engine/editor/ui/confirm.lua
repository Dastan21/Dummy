local Window = require "editor.ui.window"
local Button = require "editor.ui.button"

--- @class Dummy.Editor.Confirm : Dummy.Editor.Window
---
--- @field protected message_text Dummy.Text
--- @field protected cancel_btn Dummy.Editor.Button
--- @field protected confirm_btn Dummy.Editor.Button
--- @field protected middle_btn Dummy.Editor.Button
--- @field protected separator Dummy.Drawable
--- @field protected closing boolean
local Confirm = Class(Window, "Dummy.Editor.Confirm")

Confirm.WINDOW_WIDTH = 288
Confirm.WINDOW_HEIGHT = 80
Confirm.FOOTER_HEIGHT = 20
Confirm.TEXT_PADDING = 4

--- Creates an entity window
--- @return Dummy.Editor.Confirm
function Confirm:new()
  self = Class:new(Confirm)

  self:initConfirm()

  return self
end

--- Initializes the confirm modal
function Confirm:initConfirm()
  self:setVisible(false)
  self:setLayer(Constants.LAYERS.WINDOW + 1)

  self:setWidth(Confirm.WINDOW_WIDTH)
  self:setHeight(Confirm.WINDOW_HEIGHT)

  local window_x = (Constants.WORLD_WIDTH - Confirm.WINDOW_WIDTH) / 2
  local window_y = (Constants.WORLD_HEIGHT - Confirm.WINDOW_HEIGHT) / 2
  self:setPosition(window_x, window_y)

  self.closing = false

  self.message_text = Text:new("")
  self.message_text:setParent(self)
  self.message_text:setFont("main_text")
  self.message_text:setAlign("center")
  self.message_text:setWrapLimit(self:getWidth() - Confirm.TEXT_PADDING * 2)
  self.message_text:setPosition(self:getWidth() / 2, self:getHeight() / 2 - Confirm.FOOTER_HEIGHT / 2)

  self.cancel_btn = Button:new()
  self.cancel_btn:setParent(self)
  self.cancel_btn:setHeight(Confirm.FOOTER_HEIGHT)
  self.cancel_btn:setText(Text:new(""))
  self.cancel_btn:setBorder(0)
  self.cancel_btn:setColor(0, 0, 0, 0)
  self.cancel_btn:setHoverColor(1, 1, 1, 0.2)
  function self.cancel_btn.onClick()
    self.closing = true

    if type(self.onCancel) == "function" then
      self:onCancel()
    end
  end

  self.confirm_btn = Button:new()
  self.confirm_btn:setParent(self)
  self.confirm_btn:setHeight(Confirm.FOOTER_HEIGHT)
  self.confirm_btn:setText(Text:new(""))
  self.confirm_btn:setBorder(0)
  self.confirm_btn:setColor(0, 0, 0, 0)
  self.confirm_btn:setHoverColor(1, 1, 1, 0.2)
  function self.confirm_btn.onClick()
    self.closing = true

    if type(self.onConfirm) == "function" then
      self:onConfirm(1)
    end
  end

  self.middle_btn = Button:new()
  self.middle_btn:setParent(self)
  self.middle_btn:setWidth(self:getWidth() / 3)
  self.middle_btn:setHeight(Confirm.FOOTER_HEIGHT)
  self.middle_btn:setText(Text:new(""))
  self.middle_btn:setBorder(0)
  self.middle_btn:setColor(0, 0, 0, 0)
  self.middle_btn:setHoverColor(1, 1, 1, 0.2)
  self.middle_btn:setPosition(self:getWidth() * 3 / 6, self:getHeight() - Confirm.FOOTER_HEIGHT / 2)
  function self.middle_btn.onClick()
    self.closing = true

    if type(self.onConfirm) == "function" then
      self:onConfirm(2)
    end
  end

  self.separator = Drawable:new()
  self.separator:setParent(self)
  function self.separator.draw()
    if not self:isVisible() then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.line(0, self:getHeight() - Confirm.FOOTER_HEIGHT - 0.5, self:getWidth(),
      self:getHeight() - Confirm.FOOTER_HEIGHT - 0.5)
  end

  self:updateButtons(false)
end

--- Opens the confirm modal
--- @param message string
--- @param confirm_text? Dummy.Text.Text
--- @param cancel_text? Dummy.Text.Text
--- @param middle_text? Dummy.Text.Text
function Confirm:open(message, confirm_text, cancel_text, middle_text)
  self.message_text:setText(message)

  self.confirm_btn:getText():setText(confirm_text or "EDITOR_CONFIRM_MODAL_CONFIRM")
  self.cancel_btn:getText():setText(cancel_text or "EDITOR_CONFIRM_MODAL_CANCEL")
  self.middle_btn:getText():setText(middle_text or "")

  local elements = { { self.cancel_btn, self.confirm_btn } }

  if middle_text ~= nil then
    table.insert(elements[1], 2, self.middle_btn)
  end

  self:updateButtons(middle_text ~= nil)

  self:setUIElements(elements)
  self:setVisible(true, 1, 1)
end

--- Updates the modal buttons
--- @param has_middle boolean
function Confirm:updateButtons(has_middle)
  if has_middle then
    self.cancel_btn:setPosition(self:getWidth() * 1 / 6, self:getHeight() - Confirm.FOOTER_HEIGHT / 2)
    self.cancel_btn:setWidth(self:getWidth() / 3)

    self.confirm_btn:setPosition(self:getWidth() * 5 / 6, self:getHeight() - Confirm.FOOTER_HEIGHT / 2)
    self.confirm_btn:setWidth(self:getWidth() / 3)

    self.middle_btn:setVisible(true)
  else
    self.cancel_btn:setPosition(self:getWidth() * 1 / 4, self:getHeight() - Confirm.FOOTER_HEIGHT / 2)
    self.cancel_btn:setWidth(self:getWidth() / 2)

    self.confirm_btn:setPosition(self:getWidth() * 3 / 4, self:getHeight() - Confirm.FOOTER_HEIGHT / 2)
    self.confirm_btn:setWidth(self:getWidth() / 2)

    self.middle_btn:setVisible(false)
  end
end

--- Closes the confirm modal
function Confirm:close()
  self.closing = false

  self:setVisible(false)

  if type(self.onClose) == "function" then
    self:onClose()
  end
end

--- Called when the confirm modal is canceled
function Confirm:onCancel() end

--- Called when the confirm modal is confirmed
--- @param button_index number
function Confirm:onConfirm(button_index) end

--- Called when the middle button modal is pressed
function Confirm:onMiddle() end

--- Called when the confirm modal is closed
function Confirm:onClose() end

--- Updates the confirm modal
function Confirm:update(dt)
  if not self:isVisible() then return end

  if self.closing then
    self:close()
    return
  end

  Window.update(self, dt)
end

return Confirm
