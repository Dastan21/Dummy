--[[
  Generated from ..\engine\editor\ui\object_add_modal.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/object_add_modal.lua
]]

---@meta

Editor = {}

--- @class Dummy.Editor.ObjectAddModal.Object
---
--- @field id string
--- @field key string
--- @field mod_id string|nil
--- @field class Dummy.Object
--- @field button Dummy.Editor.Button

--- Creates an entity window
--- @return Dummy.Editor.ObjectAddModal
function ObjectAddModal:new() end

--- Initializes the object add modal
function ObjectAddModal:initObjectAddWindow() end

--- Loads objects from a folder
--- @param folder string
--- @param mod_id? string
function ObjectAddModal:loadObjectsFromFolder(folder, mod_id) end

--- Loads objects
--- @param mod_id string
function ObjectAddModal:loadObjects(mod_id) end

--- Filters objects by id
function ObjectAddModal:filterObjects() end

--- Updates the object add modal's UI elements
function ObjectAddModal:updateUIElements() end

--- Gets the objects
--- @return table<string, Dummy.Editor.ObjectAddModal.Object>
function ObjectAddModal:getObjects() end

--- Opens the object add modal
function ObjectAddModal:open() end

--- Closes the object add modal
function ObjectAddModal:close() end

--- Called when the object add modal is canceled
function ObjectAddModal:onCancel() end

--- Called when the object add modal is confirmed
--- @param object_id string
function ObjectAddModal:onConfirm(object_id) end

--- Called when the object add modal is closed
function ObjectAddModal:onClose() end

--- Updates the object add modal
function ObjectAddModal:update(dt) end

