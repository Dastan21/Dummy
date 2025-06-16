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

--- Checks if a file has an extension
--- @param path string
--- @param ... string
function Utils.checkExtension(path, ...) end

--- Gets a filename without extension
--- @param filename string
function Utils.getFilenameWithoutExt(filename) end

--- Gets the points of a rectangle
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param scale_x? number
--- @param scale_y? number
--- @param origin_x? number
--- @param origin_y? number
--- @param angle? number
--- @return table
function Utils.getPolygonPoints(x, y, width, height, scale_x, scale_y, origin_x, origin_y, angle) end

