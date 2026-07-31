--[[
  Generated from ..\engine\class.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/class.lua
]]

---@meta

--- @class Dummy.Class
---
--- @field private __extend Dummy.Class
--- @field private __classname string
--- @field private __address string
Class = {}

--- Extends a class
--- @generic T : Dummy.Class
--- @param extend? T|string the class to extend
--- @param name? string the class name
--- @return T
function Class:extend(extend, name) end

--- Creates a new instance of a class
--- @generic T : Dummy.Class
--- @param c T the class to instantiate
--- @param p? any[] the data to pass to the parent constructor
--- @return T
function Class:new(c, p) end

--- Checks wether a class is an instance of another class
--- @generic T : Dummy.Class
--- @param c T the class to check
--- @return boolean
function Class:is(c) end

--- Gets the class name
--- @return string
function Class:getClassName() end

