--[[
  Generated from ..\engine\editor\ui\form\object_form.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/form/object_form.lua
]]

---@meta

Form = {}

--- Creates a object form
--- @return Editor.ObjectForm
function ObjectForm:new() end

--- Gets the object form's metadata
--- @return Dummy.Editor.Metadata[]
function ObjectForm:getMetadata() end

--- Builds the object form's metadata inputs
--- @param data Dummy.Object.Data
function ObjectForm:buildInputs(data) end

--- Opens the object form
--- @param object Dummy.Editor.ObjectAddModal.Object
--- @param obj_data Dummy.Object.Data
function ObjectForm:open(object, obj_data) end

--- Closes the form
function ObjectForm:close() end

--- Called when the object form is confirmed
--- @param data Dummy.Object.Data
function ObjectForm:onConfirm(data) end

--- Called when the object is duplicated
--- @param data Dummy.Object.Data
function ObjectForm:onDuplicate(data) end

--- Called when the object is deleted
--- @param data Dummy.Object.Data
function ObjectForm:onDelete(data) end

