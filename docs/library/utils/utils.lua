--[[
  Generated from ..\engine\utils\utils.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/utils.lua
]]

---@meta

--- @class Dummy.Utils
---
--- @field private __hooks table<table, boolean>
Utils = {}

function table.tostring(node) end

function table.clone(obj, seen) end

function table.isArray(t) end

--- @generic T
--- @param t1 T[]
--- @param t2 T[]
--- @return T[]
function table.merge(t1, t2) end

--- @generic T
--- @param t T[]
--- @param f? integer
--- @param l? integer
--- @param s? integer
--- @return T[]
function table.slice(t, f, l, s) end

--- @generic T
--- @param t T[]
--- @param value T
--- @return boolean
function table.contains(t, value) end

--- Removes from `list` the element with value `value`, returning the value of the removed element.
--- @generic T
--- @param list table
--- @param value T
---@return T|nil
function table.removeByValue(list, value) end

--- @param self string
--- @return string
function string:trim() end

--- @param self string
function string:split(delimiter) end

--- Returns the sign of `x`.
--- @param x number
--- @return number
function math.sign(x) end

--- Clamps `x` between `min` and `max`.
--- @param x number
--- @param min number
--- @param max number
--- @return number
function math.clamp(x, min, max) end

--- Returns the nearest integer value to `x`.
--- @param x number
--- @return integer
function math.round(x) end

--- Linearly interpolates between `a` and `b` by `t`.
--- @param a number
--- @param b number
--- @param t number
--- @return number
function math.lerp(a, b, t) end

--- Sums all values.
--- @param ... number
--- @return number
function math.sum(...) end

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

--- Checks if two rectangles collide, using SAT-based rectangle collision
--- @param rect1 [number, number, number, number]
--- @param rect2 [number, number, number, number]
--- @return boolean
function Utils.checkCollision(rect1, rect2) end

--- Replaces a function
--- @param target table
--- @param name string
--- @param func fun(orig:fun(...), ...)
function Utils.hook(target, name, func) end

