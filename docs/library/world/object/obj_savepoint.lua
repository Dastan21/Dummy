--[[
  Generated from ..\engine\world\object\obj_savepoint.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_savepoint.lua
]]

---@meta

--- @class WorldExample.Object.Savepoint : Dummy.Object.NPC
---
--- @field protected texts Dummy.Text.Text[]
SavepointObject = {}

--- Creates a savepoint
--- @param x number
--- @param y number
--- @param text Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
function SavepointObject:new(x, y, text, ...) end

--- Called when the savepoint is interacted by the player
function SavepointObject:onInteract() end

