--[[
  Generated from ..\engine\utils\utils.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/utils.lua
]]

---@meta

--- @class Dummy.Utils
---
--- @field private __hooks table<table, boolean>
Utils = {}

--- Requires a module from the current mod
--- @param modname string
--- @return unknown, unknown
function modRequire(modname) end

function table.tostring(node) end

--- @generic T : table
--- @param t T
--- @return T
function table.copy(t) end

function table.isarray(t) end

--- @generic T
--- @param t1 T[]
--- @param t2 T[]
--- @param replace_arrays? boolean
--- @return T[]
function table.merge(t1, t2, replace_arrays) end

--- @generic number
--- @param t number[]
--- @return number
function table.sum(t) end

--- @generic T
--- @param t T[]
--- @param value T
--- @param ... T
function table.insertall(t, value, ...) end

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
--- @param list T[]
--- @param value T
---@return T|nil
function table.removebyvalue(list, value) end

--- Finds an element in a table
---@generic T
---@param list T[]
---@param f fun(v: T, k: integer): boolean
---@return T|nil, integer|nil
function table.find(list, f) end

--- Returns the number of elements in a table
--- @generic T : table
--- @param t T
--- @return integer
function table.len(t) end

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

--- Gets the distance between two points
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
function math.dist(x1, y1, x2, y2) end

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

--- Whether a point is in a triangle
--- @param x number
--- @param y number
--- @param ax number
--- @param ay number
--- @param bx number
--- @param by number
--- @param cx number
--- @param cy number
--- @return boolean
function Utils.pointInTriangle(x, y, ax, ay, bx, by, cx, cy) end

--- Wether a point is in a rectangle
--- @param x number point x
--- @param y number point y
--- @param rx number rect x
--- @param ry number rect y
--- @param rw number rect width
--- @param rh number rect height
--- @return boolean
function Utils.isPointInRect(x, y, rx, ry, rw, rh) end

--- Wether a rectangle collides another rectangle, using AABB collision detection
--- @param rect1 [number, number, number, number] [x, y, width, height]
--- @param rect2 [number, number, number, number] [x, y, width, height]
--- @return boolean
function Utils.checkCollisionAABB(rect1, rect2) end

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

--- Unhooks a function
--- @param target table
--- @param name string
function Utils.unhook(target, name) end

