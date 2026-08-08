--[[
  Generated from ..\engine\world\object\obj_solid.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_solid.lua
]]

---@meta

--- @class Dummy.Object.Solid : Dummy.Object
SolidObject = {}

--- @class Dummy.Object.Solid.Data : Dummy.Object.Data

--- Creates a solid
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
function SolidObject:new(x, y, width, height) end

--- Gets the solid object's metadata
--- @return Dummy.Editor.Metadata[]
function SolidObject.getMetadata() end

--- Draws the solid object's hitbox for debugging
function SolidObject:drawDebug() end

--- Draws the solid object for the editor
--- @param data Dummy.Object.Solid.Data
function SolidObject.drawEditor(data) end

