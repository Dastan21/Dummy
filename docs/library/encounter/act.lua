--[[
  Generated from ..\engine\encounter\act.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/act.lua
]]

---@meta

--- @class Dummy.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
ACT = {}

--- Gets the class name
--- @return string
function ACT:getClass() end

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName() end

--- [INTERNAL] Called when the ACT is used
--- @private
function ACT:__use() end

--- Called when the ACT is used
function ACT:use() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.ACT
function ACT:new(name) end

