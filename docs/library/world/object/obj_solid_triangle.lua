--[[
  Generated from ..\engine\world\object\obj_solid_triangle.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_solid_triangle.lua
]]

---@meta

--- @class Dummy.Object.SolidTriangle : Dummy.Object.Solid
---
--- @field protected side Dummy.Object.SolidTriangle.Side
--- @field protected hitbox_triangle [number, number, number, number, number, number]
SolidTriangleObject = {}

--- @alias Dummy.Object.SolidTriangle.Side "top-left" | "top-right" | "bottom-left" | "bottom-right"

--- @class Dummy.Object.SolidTriangle.Data : Dummy.Object.Data
---
--- @field side Dummy.Object.SolidTriangle.Side
--- @field size number

--- Creates a solid triangle
--- @param side Dummy.Object.SolidTriangle.Side
--- @param x number
--- @param y number
--- @param size? number
function SolidTriangleObject:new(side, x, y, size) end

--- Initializes the solid triangle object's arguments before creating it
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.initArgs(data) end

--- Gets the solid triangle object's metadata
--- @return Dummy.Editor.Metadata[]
function SolidTriangleObject.getMetadata() end

--- Called when the solid triangle form is confirmed in the editor
---
--- Note: Useful for modifying the object's data before it is added to the room
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.onFormConfirm(data) end

--- Gets the solid triangle side
--- @return Dummy.Object.SolidTriangle.Side
function SolidTriangleObject:getSide() end

--- Gets the solid triangle hitbox
--- @return number, number, number, number, number, number
function SolidTriangleObject:getHitboxTriangle() end

--- Creates the solid triangle hitbox
--- @param side Dummy.Object.SolidTriangle.Side
--- @param ox1? number
--- @param oy1? number
--- @param ox2? number
--- @param oy2? number
--- @return [number, number, number, number, number, number]
function SolidTriangleObject.newHitboxTriangle(side, width, height, ox1, oy1, ox2, oy2) end

--- Draws the solid triangle object's hitbox for debugging
function SolidTriangleObject:drawDebug() end

--- Draws the solid triangle object for the editor
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.drawEditor(data) end

