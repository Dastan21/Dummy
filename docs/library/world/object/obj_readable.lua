--[[
  Generated from ..\engine\world\object\obj_readable.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_readable.lua
]]

---@meta

--- @class WorldExample.Object.Readable : Dummy.Object
---
--- @field protected texts Dummy.Text.Text[]
ReadableObject = {}

--- @class Dummy.Object.Readable.Data : Dummy.Object.Data
---
--- @field texts string[]

--- Creates a readable
--- @param x number
--- @param y number
--- @param text string
--- @param ... Dummy.Text.Text
function ReadableObject:new(x, y, text, ...) end

--- Initializes the readable's arguments before creating it
--- @param data Dummy.Object.Readable.Data
function ReadableObject.initArgs(data) end

--- Gets the readable metadata
--- @return Dummy.Editor.Metadata[]
function ReadableObject.getMetadata() end

--- Called when the readable is interacted by the player
function ReadableObject:onInteract() end

--- Draws the readable for the editor
--- @param data Dummy.Object.Solid.Data
function ReadableObject.drawEditor(data) end

