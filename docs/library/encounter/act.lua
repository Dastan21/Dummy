--[[
  Generated from ..\engine\encounter\act.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/act.lua
]]

---@meta

--- @class Dummy.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected enemy Dummy.Enemy
ACT = {}

--- Gets the class name
--- @return string
function ACT.getClassName() end

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName() end

--- Gets the enemy the ACT is from
--- @return Dummy.Enemy
function ACT:getEnemy() end

--- Does the ACT
function ACT:use() end

--- Called when the ACT is used
function ACT:onUse() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.ACT
function ACT:new(name) end

