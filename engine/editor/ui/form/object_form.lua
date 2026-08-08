local Form = require "editor.ui.form.form"
local Button = require "editor.ui.button"

--- @class Editor.ObjectForm : Dummy.Editor.Form
---
--- @field protected data Dummy.Object.Data
--- @field protected object Dummy.Editor.ObjectAddModal.Object
--- @field protected delete_btn Dummy.Editor.Button
--- @field protected duplicate_btn Dummy.Editor.Button
local ObjectForm = Class(Form, "Dummy.Editor.ObjectForm")

--- Creates a object form
--- @return Editor.ObjectForm
function ObjectForm:new()
  self = Class:new(ObjectForm)

  self.delete_btn = Button:new()
  self.delete_btn:setParent(self)
  self.delete_btn:setWidth(Form.HEADER_HEIGHT)
  self.delete_btn:setHeight(Form.HEADER_HEIGHT)
  self.delete_btn:setSprite(Sprite:new("editor/bin"))
  self.delete_btn:getSprite():setColor(0.9, 0.2, 0.2)
  self.delete_btn:setBorder(0)
  self.delete_btn:setColor(0, 0, 0, 0)
  self.delete_btn:setHoverColor(1, 1, 1, 0.2)
  self.delete_btn:setPosition(self:getWidth() - 7 * Form.HEADER_HEIGHT / 2, Form.HEADER_HEIGHT / 2)
  self.delete_btn:setTooltip("EDITOR_OBJECT_FORM_DELETE")
  self.delete_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)
  function self.delete_btn.onClick()
    self.closing = true

    if type(self.onDelete) == "function" then
      self:onDelete(self.data)
    end
  end

  self.duplicate_btn = Button:new()
  self.duplicate_btn:setParent(self)
  self.duplicate_btn:setWidth(Form.HEADER_HEIGHT)
  self.duplicate_btn:setHeight(Form.HEADER_HEIGHT)
  self.duplicate_btn:setSprite(Sprite:new("editor/duplicate"))
  self.duplicate_btn:setBorder(0)
  self.duplicate_btn:setColor(0, 0, 0, 0)
  self.duplicate_btn:setHoverColor(1, 1, 1, 0.2)
  self.duplicate_btn:setPosition(self:getWidth() - 5 * Form.HEADER_HEIGHT / 2, Form.HEADER_HEIGHT / 2)
  self.duplicate_btn:setTooltip("EDITOR_OBJECT_FORM_DUPLICATE")
  self.duplicate_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)
  function self.duplicate_btn.onClick()
    self.closing = true

    if type(self.onDuplicate) == "function" then
      self:onDuplicate(self.data)
    end
  end

  return self
end

--- Gets the object form's metadata
--- @return Dummy.Editor.Metadata[]
function ObjectForm:getMetadata()
  return self.object.class.getMetadata()
end

--- Builds the object form's metadata inputs
--- @param data Dummy.Object.Data
function ObjectForm:buildInputs(data)
  Form.buildInputs(self, data)

  --- @type Dummy.Editor.Button[][]
  local elements = { { self.delete_btn, self.duplicate_btn, self.confirm_btn, self.cancel_btn } }
  local metadata = self:getMetadata()
  for _, md in ipairs(metadata) do
    table.insert(elements, { self.inputs[md.id] })
  end
  self:setUIElements(elements)

  if #metadata > 0 then
    self:setVisible(true, 2, 1)
  else
    self:setVisible(true, 1, 1)
  end
end

--- Opens the object form
--- @param object Dummy.Editor.ObjectAddModal.Object
--- @param obj_data Dummy.Object.Data
function ObjectForm:open(object, obj_data)
  self.object = object

  Form.open(self, obj_data)

  self.title:setText(string.format("%s (%d)", object.key, obj_data.id))
end

--- Closes the form
function ObjectForm:close()
  self.delete_btn:getTooltip():setVisible(false)
  self.duplicate_btn:getTooltip():setVisible(false)

  Form.close(self)
end

--- Called when the object form is confirmed
--- @param data Dummy.Object.Data
function ObjectForm:onConfirm(data) end

--- Called when the object is duplicated
--- @param data Dummy.Object.Data
function ObjectForm:onDuplicate(data) end

--- Called when the object is deleted
--- @param data Dummy.Object.Data
function ObjectForm:onDelete(data) end

return ObjectForm
