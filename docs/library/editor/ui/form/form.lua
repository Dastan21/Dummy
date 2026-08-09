--[[
  Generated from ..\engine\editor\ui\form\form.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/form/form.lua
]]

---@meta

Window = {}

--- Creates an entity window
--- @return Dummy.Editor.Form
function Form:new() end

--- Initializes the form
function Form:initForm() end

--- Wether the form is open
--- @return boolean
function Form:isOpen() end

--- Opens the form
--- @param data table
--- @param metadata? Dummy.Editor.Metadata metadata, set only if it is an embed form
function Form:open(data, metadata) end

--- Closes the form
function Form:close() end

--- Gets the form's metadata
--- @return Dummy.Editor.Metadata[]
function Form:getMetadata() end

--- Builds the form's metadata inputs
--- @generic D : table
--- @param data D
function Form:buildInputs(data) end

--- Builds an input
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.InputText|Dummy.Editor.Select|Dummy.Editor.Checkbox|Dummy.Editor.Button|nil
function Form:buildInput(metadata) end

--- Builds a select
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Select
function Form:buildSelect(metadata) end

--- Builds an input text
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.InputText
function Form:buildInputText(metadata) end

--- Builds a checkbox
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Checkbox
function Form:buildCheckbox(metadata) end

--- Builds a button
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Button
function Form:buildButton(metadata) end

--- Builds a form button
--- @param metadata Dummy.Editor.Metadata
--- @return Dummy.Editor.Button
function Form:buildFormButton(metadata) end

--- Validates an input text
--- @param input_text Dummy.Editor.InputText
--- @param metadata Dummy.Editor.Metadata
function Form:validate(input_text, metadata) end

--- Wether the form is valid
--- @return boolean
function Form:isValid() end

--- Cleans the form's metadata inputs
function Form:cleanInputs() end

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
function Form:update(dt) end

