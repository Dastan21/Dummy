--[[
  Generated from ..\engine\utils.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils.lua
]]

---@meta

Utils = {}

function table.tostring(node) end

function table.clone(obj, seen) end

function table.isarray(t) end

function table.merge(t1, t2) end

--- @param self string
function string:trim() end

--- @param self string
function string:split(delimiter) end

function math.sign(x) end

function math.clamp(x, min, max) end

function math.round(x) end

--- Get value or default
--- @generic T
--- @param value T|nil
--- @param default_value T
--- @return T
function Utils.getOrDefault(value, default_value) end

function Utils.checkExtension(path, ...) end

function Utils.getFilenameWithoutExt(filename) end

