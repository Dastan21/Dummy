local Form = require "editor.ui.form.form"
local Button = require "editor.ui.button"
local InputText = require "editor.ui.input_text"
local Select = require "editor.ui.select"

--- @class Dummy.Editor.ListForm : Dummy.Editor.Form
---
--- @field protected type Dummy.Editor.Metadata.Type
--- @field protected data string[]
--- @field protected add_btn Dummy.Editor.Button
--- @field protected actions Dummy.Drawable[][]
local ListForm = Class(Form, "Editor.ListForm")

ListForm.LABEL_WIDTH_RATIO = 0.2

--- Creates a list form
--- @return Dummy.Editor.ListForm
function ListForm:new()
  self = Class:new(ListForm)

  self:initForm()

  return self
end

--- Initializes the form
function ListForm:initForm()
  self.actions = {}

  self.title:setText("EDITOR_LIST_FORM_TITLE")
  self.title:setMaxWidth(Form.WINDOW_WIDTH - (Form.HEADER_HEIGHT + Form.TEXT_PADDING) * 3)

  self.add_btn = Button:new()
  self.add_btn:setParent(self)
  self.add_btn:setWidth(Form.HEADER_HEIGHT)
  self.add_btn:setHeight(Form.HEADER_HEIGHT)
  self.add_btn:setSprite(Sprite:new("editor/add"))
  self.add_btn:setBorder(0)
  self.add_btn:setColor(0, 0, 0, 0)
  self.add_btn:setHoverColor(1, 1, 1, 0.2)
  self.add_btn:setPosition(self:getWidth() - 5 * Form.HEADER_HEIGHT / 2, Form.HEADER_HEIGHT / 2)
  self.add_btn:setTooltip("EDITOR_LIST_FORM_ADD")
  self.add_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)

  function self.add_btn.onClick()
    self.data[#self.data + 1] = ""

    self:buildList()
  end
end

--- Opens the list form
--- @param data Dummy.Object.Data
--- @param metadata Dummy.Editor.Metadata
function ListForm:open(data, metadata)
  self.type = metadata.list_type or "string"
  self:buildInputs(data[metadata.id] or {})
end

--- Builds the list form's metadata inputs
--- @param texts string[]
function ListForm:buildInputs(texts)
  Form.buildInputs(self, {})

  self.data = table.copy(texts)
  self:buildList()

  --- @type Dummy.Editor.Button[][]
  local elements = { { self.add_btn, self.confirm_btn, self.cancel_btn } }
  for i = 1, #self.data do
    local inputs = { self.inputs[i] }
    for a = 1, #self.actions do
      table.insert(inputs, self.actions[i][a])
    end
    table.insert(elements, inputs)
  end
  self:setUIElements(elements)
  self:setVisible(true, 1, 1)
end

--- Builds the list list
function ListForm:buildList()
  self:cleanList()

  --- @type Dummy.Drawable[][]
  local actions = {}

  local input_offset_y = Form.HEADER_HEIGHT + 1.5 + Form.INPUT_GAP
  local action_offset_x = self:getWidth() - Form.INPUT_GAP / 2

  for i, text in ipairs(self.data) do
    if self.labels[i] == nil then
      local max_width = Form.WINDOW_WIDTH * ListForm.LABEL_WIDTH_RATIO - Form.TEXT_PADDING * 2 - Form.INPUT_GAP

      local label = Text:new("#" .. i, true)
      label:setParent(self)
      label:setFont("main_text")
      label:setOrigin(0, 0)
      label:setOverflow("ellipsis")
      label:setMaxWidth(max_width)
      label:setPosition(Form.TEXT_PADDING, input_offset_y)
      self.labels[i] = label

      local input = self:buildInput({
        id = i,
        label = "",
        type = self.type,
        default = text,
        validate = function(value)
          if self.type == "string" then
            return value ~= ""
          elseif self.type == "number" then
            return value ~= "" and value ~= "-" and value ~= "." and not tonumber(value)
          end
          return true
        end
      })
      if input ~= nil then
        local input_width = math.floor(Form.WINDOW_WIDTH * (1 - ListForm.LABEL_WIDTH_RATIO)) - Form.INPUT_GAP -
            Form.INPUT_HEIGHT
        if input:is(InputText) or input:is(Select) then
          (input --[[@as Dummy.Editor.InputText|Dummy.Editor.Select]]):setMinWidth(input_width)
        end
        input:setWidth(input_width)
        input:setPosition(self:getWidth() - input_width - Form.INPUT_GAP * 2 - Form.INPUT_HEIGHT, input_offset_y)
        input:getText():setMaxWidth(input_width - Form.TEXT_PADDING * 2)
        self.inputs[i] = input

        local delete_btn = Button:new()
        delete_btn:setParent(self)
        delete_btn:setBorder(1)
        delete_btn:setWidth(Form.INPUT_HEIGHT)
        delete_btn:setHeight(Form.INPUT_HEIGHT)
        delete_btn:setSprite(Sprite:new("editor/bin"))
        delete_btn:getSprite():setColor(0.9, 0.2, 0.2)
        delete_btn:setTooltip("EDITOR_LIST_FORM_ACTION_DELETE")
        delete_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)
        delete_btn:getTooltip():setDirection("left")
        delete_btn:setPosition(action_offset_x - (Form.INPUT_HEIGHT + Form.INPUT_GAP) / 2,
          input_offset_y + Form.INPUT_HEIGHT / 2)
        delete_btn["index"] = i

        function delete_btn.onClick(btn)
          table.remove(self.data, btn["index"])
          self.valid_inputs[btn["index"]] = nil

          self:buildList()
        end

        self.actions[i] = { delete_btn }
      end
    end

    input_offset_y = input_offset_y + Form.INPUT_HEIGHT + Form.INPUT_GAP
  end

  --- @type Dummy.Editor.Button[][]
  local elements = { { self.add_btn, self.confirm_btn, self.cancel_btn } }
  for i = 1, #actions do
    table.insert(elements, actions[i])
  end
  self:setUIElements(elements)
  self:setVisible(true, 1, 1)
end

--- Closes the list form
function ListForm:close()
  self.add_btn:getTooltip():setVisible(false)

  Form.close(self)
end

--- Cleans the list form's list
function ListForm:cleanList()
  for id in pairs(self.labels) do
    self.labels[id]:remove()
    self.inputs[id]:remove()
  end
  self.labels = {}
  self.inputs = {}

  for _, actions in ipairs(self.actions) do
    for _, action in pairs(actions) do
      action:remove()
    end
  end
  self.actions = {}
end

--- Cleans the list form's metadata inputs
function ListForm:cleanInputs()
  self:cleanList()
  Form.cleanInputs(self)
end

--- Called when the list form is confirmed
--- @param texts string[]
function ListForm:onConfirm(texts) end

return ListForm
