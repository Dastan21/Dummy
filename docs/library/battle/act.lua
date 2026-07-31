--[[
  Generated from ..\engine\battle\act.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/act.lua
]]

---@meta

--- @class Dummy.Battle.ACT : Dummy.Class
---
--- @field protected name Dummy.Text.Text
--- @field protected enemy Dummy.Battle.Enemy
ACT = {}

--- Gets the ACT's name
--- @return Dummy.Text.Text
function ACT:getName() end

--- Gets the enemy the ACT is from
--- @return Dummy.Battle.Enemy
function ACT:getEnemy() end

--- Does the ACT
function ACT:use() end

--- Called when the ACT is used
function ACT:onUse() end

--- Creates an enemy ACTing
--- @param name Dummy.Text.Text
--- @return Dummy.Battle.ACT
function ACT:new(name) end

