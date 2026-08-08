local Window = require "editor.ui.window"
local Button = require "editor.ui.button"
local InputText = require "editor.ui.input_text"
local Checkbox = require "editor.ui.checkbox"
local Select = require "editor.ui.select"

--- @class Dummy.Editor.Form : Dummy.Editor.Window
---
--- @field protected data table
--- @field protected confirm_btn Dummy.Editor.Button
--- @field protected cancel_btn Dummy.Editor.Button
--- @field protected title Dummy.Text
--- @field protected separator Dummy.Drawable
--- @field protected labels table<string, Dummy.Drawable>
--- @field protected inputs table<string, Dummy.Drawable>
--- @field protected valid_inputs table<string, boolean>
--- @field protected forms table<string, Dummy.Editor.Form>
--- @field protected is_valid boolean
--- @field protected closing boolean
local Form = Class(Window, "Dummy.Editor.Form")

Form.WINDOW_WIDTH = 256
Form.WINDOW_HEIGHT = 160
Form.HEADER_HEIGHT = 18
Form.LABEL_WIDTH_RATIO = 0.55
Form.TEXT_PADDING = 4
Form.INPUT_GAP = 2
Form.INPUT_HEIGHT = 18

--- Creates an entity window
--- @return Dummy.Editor.Form
function Form:new()
  self = Class:new(Form)

  self:initForm()

  return self
end

--- Initializes the form
function Form:initForm()
  self:setVisible(false)

  self:setWidth(Form.WINDOW_WIDTH)
  self:setHeight(Form.WINDOW_HEIGHT)
  self:setPadding(0, 0, 2, 0)
  self:setControlInputs(
    nil,
    { "up", "gamepad:1:dpup" },
    { "down", "gamepad:1:dpdown" },
    { "left", "gamepad:1:dpleft" },
    { "right", "gamepad:1:dpright" }
  )

  local window_x = (Constants.WORLD_WIDTH - Form.WINDOW_WIDTH) / 2
  local window_y = (Constants.WORLD_HEIGHT - Form.WINDOW_HEIGHT) / 2
  self:setPosition(window_x, window_y)

  self.labels = {}
  self.inputs = {}
  self.valid_inputs = {}
  self.forms = {}
  self.data = nil
  self.closing = false
  self.is_valid = true

  self.cancel_btn = Button:new()
  self.cancel_btn:setParent(self)
  self.cancel_btn:setWidth(Form.HEADER_HEIGHT)
  self.cancel_btn:setHeight(Form.HEADER_HEIGHT)
  self.cancel_btn:setSprite(Sprite:new("editor/cross"))
  self.cancel_btn:setBorder(0)
  self.cancel_btn:setColor(0, 0, 0, 0)
  self.cancel_btn:setHoverColor(1, 1, 1, 0.2)
  self.cancel_btn:setPosition(self:getWidth() - Form.HEADER_HEIGHT / 2, Form.HEADER_HEIGHT / 2)
  self.cancel_btn:setTooltip("EDITOR_FORM_CANCEL")
  self.cancel_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)
  function self.cancel_btn.onClick()
    self.closing = true

    if type(self.onCancel) == "function" then
      self:onCancel()
    end
  end

  self.confirm_btn = Button:new()
  self.confirm_btn:setParent(self)
  self.confirm_btn:setWidth(Form.HEADER_HEIGHT)
  self.confirm_btn:setHeight(Form.HEADER_HEIGHT)
  self.confirm_btn:setSprite(Sprite:new("editor/check"))
  self.confirm_btn:setBorder(0)
  self.confirm_btn:setColor(0, 0, 0, 0)
  self.confirm_btn:setHoverColor(1, 1, 1, 0.2)
  self.confirm_btn:setPosition(self:getWidth() - 3 * Form.HEADER_HEIGHT / 2, Form.HEADER_HEIGHT / 2)
  self.confirm_btn:setTooltip("EDITOR_FORM_SAVE")
  self.confirm_btn:getTooltip():setOffset(Form.HEADER_HEIGHT / 2 - 2)
  function self.confirm_btn.onClick()
    self.closing = true

    if type(self.onConfirm) == "function" then
      self:onConfirm(table.copy(self.data))
    end
  end

  self.title = Text:new("")
  self.title:setParent(self)
  self.title:setFont("main_text")
  self.title:setOrigin(0, 0)
  self.title:setMaxWidth(Form.WINDOW_WIDTH - (Form.HEADER_HEIGHT + Form.TEXT_PADDING) * 2)
  self.title:setOverflow("ellipsis")
  self.title:setPosition(Form.TEXT_PADDING, 0)

  self.separator = Drawable:new()
  self.separator:setParent(self)
  function self.separator.draw()
    if not self:isVisible() then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.line(0, Form.HEADER_HEIGHT + 0.5, self:getWidth(), Form.HEADER_HEIGHT + 0.5)
  end
end

--- Wether the form is open
--- @return boolean
function Form:isOpen()
  if self:isVisible() then return true end

  for _, form in pairs(self.forms) do
    if form:isOpen() then return true end
  end

  return false
end

--- Opens the form
--- @param data table
--- @param metadata? Dummy.Editor.Metadata metadata, set only if it is an embed form
function Form:open(data, metadata)
  self:buildInputs(data)
end

--- Closes the form
function Form:close()
  self.closing = false

  self.cancel_btn:getTooltip():setVisible(false)
  self.confirm_btn:getTooltip():setVisible(false)

  self:cleanInputs()

  self:setVisible(false)

  if type(self.onClose) == "function" then
    self:onClose()
  end
end

--- Gets the form's metadata
--- @return Dummy.Editor.Metadata[]
function Form:getMetadata()
  return {}
end

--- Builds the form's metadata inputs
--- @generic D : table
--- @param data D
function Form:buildInputs(data)
  self.data = table.copy(data)

  local metadatas = self:getMetadata()
  if metadatas == nil then return end

  local input_offset_y = Form.HEADER_HEIGHT + 1.5 + Form.INPUT_GAP
  for _, metadata in ipairs(metadatas) do
    local input = self:buildInput(metadata) --[[@as Dummy.Editor.InputText|Dummy.Editor.Select|Dummy.Editor.Checkbox|nil]]
    if input ~= nil then
      local max_width = math.floor(Form.WINDOW_WIDTH * Form.LABEL_WIDTH_RATIO) - Form.TEXT_PADDING * 2 - Form.INPUT_GAP

      local label = Text:new(metadata.label)
      label:setParent(self)
      label:setFont("main_text")
      label:setOrigin(0, 0)
      label:setOverflow("ellipsis")
      label:setMaxWidth(max_width)
      self.labels[metadata.id] = label

      local input_x, input_y = input:getPosition()
      input:setPosition(input_x - Form.INPUT_GAP, input_y + input_offset_y)
      label:setPosition(Form.TEXT_PADDING, input_offset_y)
      self.inputs[metadata.id] = input

      input_offset_y = input_offset_y + input:getHeight() + Form.INPUT_GAP
    end
  end

  --- @type Dummy.Editor.Button[][]
  local elements = { { self.confirm_btn, self.cancel_btn } }
  for _, metadata in ipairs(metadatas) do
    table.insert(elements, { self.inputs[metadata.id] })
  end
  self:setUIElements(elements)
  self:setVisible(true, 2, 1)
end

--- Builds an input
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.InputText|Dummy.Editor.Select|Dummy.Editor.Checkbox|Dummy.Editor.Button|nil
function Form:buildInput(metadata)
  if metadata.type == "string" or metadata.type == "number" or metadata.type == "integer" then
    if type(metadata.options) == "table" then
      return self:buildSelect(metadata)
    end
    return self:buildInputText(metadata)
  elseif metadata.type == "boolean" then
    return self:buildCheckbox(metadata)
  elseif metadata.type == "button" then
    return self:buildButton(metadata)
  elseif metadata.type == "list" then
    return self:buildFormButton(metadata)
  elseif metadata.type == "form" then
    return self:buildFormButton(metadata)
  end
end

--- Builds a select
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Select
function Form:buildSelect(metadata)
  local input_width = math.floor(Form.WINDOW_WIDTH * (1 - Form.LABEL_WIDTH_RATIO))
  local select = Select:new(metadata.options, self.data[metadata.id] or metadata.default)
  select:setParent(self)
  select:setBorder(1)
  select:setMinWidth(input_width)
  select:setWidth(input_width)
  select:setHeight(Form.INPUT_HEIGHT)
  select:setPosition(self:getWidth() - select:getWidth(), 0)
  select:setOptionsMaxWidth(self:getWidth() - Form.INPUT_GAP * 2 - 2)
  select:getText():setPosition(select:getPadding(), -1)
  function select.onChange(input)
    self.data[metadata.id] = input:getValue()

    if type(self.onChange) == "function" then
      self:onChange()
    end
  end

  select:onChange()

  return select
end

--- Builds an input text
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.InputText
function Form:buildInputText(metadata)
  local input_width = math.floor(Form.WINDOW_WIDTH * (1 - Form.LABEL_WIDTH_RATIO))
  local input = InputText:new(self.data[metadata.id] or (metadata.default ~= nil and tostring(metadata.default) or ""))
  input:setParent(self)
  input:setBorder(1)
  input:setAlpha(1)
  input:setMinWidth(input_width)
  input:setWidth(input_width)
  input:setHeight(Form.INPUT_HEIGHT)
  input:setPadding(Form.TEXT_PADDING)
  input:setPosition(self:getWidth() - input:getWidth(), 0)
  input:setPlaceholder(metadata.placeholder)
  local text = input:getText()
  text:setPosition(input:getPadding(), -1)
  text:setAlign("right")
  text:setMaxWidth(input_width - Form.TEXT_PADDING * 2)
  input:setFilter(function(v)
    if metadata.type == "number" or metadata.type == "integer" then
      if v == "" then return v end
      if v == "-" then return v end
      local num = tonumber(v)
      if num == nil then return nil end
      if metadata.type == "integer" and (string.find(v, "%.") or not math.isinteger(num)) then return nil end
      return v
    end
    if type(metadata.formatter) == "function" then
      return metadata.formatter(v)
    end
    return v
  end)

  function input.onInput(input_text)
    self:validate(input_text, metadata)

    if type(self.onChange) == "function" then
      self:onChange()
    end
  end

  function input.onBlur(input_text)
    Button.onBlur(input_text)

    self:validate(input_text, metadata)
  end

  input:onInput(input:getValue())

  return input
end

--- Builds a checkbox
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Checkbox
function Form:buildCheckbox(metadata)
  local input = Checkbox:new(Utils.getOrDefault(self.data[metadata.id], metadata.default == true))
  input:setParent(self)
  input:setBorder(1)
  input:setWidth(Form.INPUT_HEIGHT)
  input:setHeight(Form.INPUT_HEIGHT)
  input:setPosition(self:getWidth() - input:getWidth() / 2, input:getHeight() / 2)
  function input.onChange()
    self.data[metadata.id] = input:getValue()

    if type(self.onChange) == "function" then
      self:onChange()
    end
  end

  input:onChange()

  return input
end

--- Builds a button
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Button
function Form:buildButton(metadata)
  local button = Button:new()
  button:setParent(self)
  button:setBorder(1)
  button:setHeight(Form.INPUT_HEIGHT)
  local text = Text:new(metadata.text or "")
  text:setAlign("right")
  text:setMaxWidth(math.floor(Form.WINDOW_WIDTH * (1 - Form.LABEL_WIDTH_RATIO)) - Form.TEXT_PADDING * 2)
  text:setPosition(0, -2)
  button:setText(text)
  button:setWidth(text:getWidth() + Form.TEXT_PADDING * 2)
  button:setPosition(self:getWidth() - button:getWidth() / 2, button:getHeight() / 2)

  function button.onClick()
    if type(metadata.onclick) == "function" then
      metadata.onclick(metadata, button)
    end
  end

  return button
end

--- Builds a form button
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Button
function Form:buildFormButton(metadata)
  local form = self.forms[metadata.id]
  if form == nil then
    if metadata.type == "list" then
      metadata.form = "list_form"
    end
    local FormModule = require("editor.ui.form." .. metadata.form)
    form = FormModule:new()

    function form.onConfirm(_, data)
      self.data[metadata.id] = data

      if type(self.onChange) == "function" then
        self:onChange()
      end
    end

    function form.onClose()
      self:setVisible(true, 2, 1)
    end

    self.forms[metadata.id] = form
  end

  local button = Button:new()
  button:setParent(self)
  button:setBorder(1)
  button:setHeight(Form.INPUT_HEIGHT)
  local text = Text:new("EDITOR_FORM_BUTTON_OPEN")
  text:setAlign("right")
  text:setMaxWidth(math.floor(Form.WINDOW_WIDTH * (1 - Form.LABEL_WIDTH_RATIO)) - Form.TEXT_PADDING * 2)
  text:setPosition(0, -2)
  button:setText(text)
  button:setWidth(text:getWidth() + Form.TEXT_PADDING * 2)
  button:setPosition(self:getWidth() - button:getWidth() / 2, button:getHeight() / 2)

  function button.onClick()
    self:setVisible(false)
    Timer.next(function()
      self.forms[tostring(metadata.id)]:open(self.data, metadata)
    end)
  end

  return button
end

--- Validates an input text
--- @param input_text Dummy.Editor.InputText
--- @param metadata Dummy.Editor.Metadata
function Form:validate(input_text, metadata)
  local is_valid = true

  --- @type string|number
  local value = input_text:getValue()
  if metadata.type == "number" or metadata.type == "integer" then
    if value == "-" then value = -0 end
    value = tonumber(value) or 0
  end

  if is_valid and type(metadata.validate) == "function" then
    is_valid = metadata.validate(value)
  end

  if is_valid then
    self.data[metadata.id] = value
    input_text:setBorderColor(1, 1, 1)
  else
    input_text:setBorderColor(1, 0, 0)
  end

  self.valid_inputs[metadata.id] = is_valid

  local form_valid = self:isValid()
  self.confirm_btn:getSprite():setAlpha(form_valid and 1 or 0.5)
  self.confirm_btn:setDisabled(not form_valid)
end

--- Wether the form is valid
--- @return boolean
function Form:isValid()
  for _, valid in pairs(self.valid_inputs) do
    if not valid then
      return false
    end
  end

  return true
end

--- Cleans the form's metadata inputs
function Form:cleanInputs()
  self.data = nil

  for id in pairs(self.labels) do
    self.labels[id]:remove()
    self.inputs[id]:remove()
  end

  self.labels = {}
  self.inputs = {}
  self.valid_inputs = {}

  for _, form in pairs(self.forms) do
    form:close()
  end
end

--- Called when the form's data has changed
function Form:onChange() end

--- Called when the form is confirmed
--- @generic D : table
--- @param data D
function Form:onConfirm(data) end

--- Called when the form is canceled
function Form:onCancel() end

--- Called when the form is closed
function Form:onClose() end

--- Updates the form
function Form:update(dt)
  if not self:isVisible() then return end

  if self.closing then
    self:close()
    return
  end

  if Input.isPressed(Input.Escape) then
    self.closing = true
  end

  Window.update(self, dt)
end

return Form
