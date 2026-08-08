--[[
  Generated from ..\engine\editor\ui\form\list_form.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/form/list_form.lua
]]

---@meta

Form = {}

--- Creates a list form
--- @return Dummy.Editor.ListForm
function ListForm:new() end

--- Initializes the form
function ListForm:initForm() end

--- Opens the list form
--- @param data Dummy.Object.Data
--- @param metadata Dummy.Editor.Metadata
function ListForm:open(data, metadata) end

--- Builds the list form's metadata inputs
--- @param texts string[]
function ListForm:buildInputs(texts) end

--- Builds the list list
function ListForm:buildList() end

--- Closes the list form
function ListForm:close() end

--- Cleans the list form's list
function ListForm:cleanList() end

--- Cleans the list form's metadata inputs
function ListForm:cleanInputs() end

--- Called when the list form is confirmed
--- @param texts string[]
function ListForm:onConfirm(texts) end

