--[[
  Generated from ..\engine\class.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/class.lua
]]

---@meta

--- @class Dummy.Class
---
--- @field private __extend Dummy.Class
Class = {}

--- Extends a class
--- @generic T : Dummy.Class
--- @param extend? T the class to extend
--- @return T
function Class:extend(extend) end

--- Creates a new instance of a class
--- @generic T : Dummy.Class
--- @param c T the class to instantiate
--- @param p? any[] the data to pass to the parent constructor
--- @return T
function Class:new(c, p) end

