--- Requires a module from the current mod
--- @param modname string
--- @return unknown, unknown
function modRequire(modname)
  local mod = ModList.getCurrentMod()
  assert(mod ~= nil, "Cannot require outside of a mod")
  return require("mods." .. mod:getId() .. "." .. modname)
end

--- Tries to require a module from the current mod, or the base game if it fails.
--- @param modname string
--- @param altname string
--- @return unknown
function tryRequire(modname, altname)
  local mod = ModList.getCurrentMod()
  local success, result = pcall(modRequire, modname)
  if success then
    return result
  else
    return require(altname)
  end
end
-- table --

-- https://gist.github.com/revolucas/dd1ecccfca32d558fddf70ddb39eb8a6
function table.tostring(node)
  local s = 0
  for _ in pairs(node) do s = s + 1 end
  if s <= 0 then return "{}" end

  -- to make output beautiful
  local function tab(amt)
    local str = ""
    for i = 1, amt do
      str = str .. "  "
    end
    return str
  end

  local cache, stack, output = {}, {}, {}
  local depth = 1
  local output_str = "{\n"

  while true do
    local size = 0
    for k, v in pairs(node) do
      size = size + 1
    end

    local cur_index = 1
    for k, v in pairs(node) do
      if (cache[node] == nil) or (cur_index >= cache[node]) then
        if (string.find(output_str, "}", output_str:len())) then
          output_str = output_str .. ",\n"
        elseif not (string.find(output_str, "\n", output_str:len())) then
          output_str = output_str .. "\n"
        end

        -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
        table.insert(output, output_str)
        output_str = ""

        local key
        if (type(k) == "number" or type(k) == "boolean") then
          key = "[" .. tostring(k) .. "]"
        else
          key = "['" .. tostring(k) .. "']"
        end

        if (type(v) == "number" or type(v) == "boolean") then
          output_str = output_str .. tab(depth) .. key .. " = " .. tostring(v)
        elseif (type(v) == "table") then
          output_str = output_str .. tab(depth) .. key .. " = {\n"
          table.insert(stack, node)
          table.insert(stack, v)
          cache[node] = cur_index + 1
          break
        else
          output_str = output_str .. tab(depth) .. key .. " = '" .. tostring(v) .. "'"
        end

        if (cur_index == size) then
          output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
        else
          output_str = output_str .. ","
        end
      else
        -- close the table
        if (cur_index == size) then
          output_str = output_str .. "\n" .. tab(depth - 1) .. "}"
        end
      end

      cur_index = cur_index + 1
    end

    if (#stack > 0) then
      node = stack[#stack]
      stack[#stack] = nil
      depth = cache[node] == nil and depth + 1 or depth - 1
    else
      break
    end
  end

  -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
  table.insert(output, output_str)
  output_str = table.concat(output)

  return output_str
end

--- @generic T : table
--- @param t T
--- @return T
function table.copy(t)
  local c = {}
  for k, v in pairs(t) do
    if type(v) == "table" and getmetatable(v) == nil then
      c[k] = table.copy(v)
    else
      c[k] = v
    end
  end
  return c
end

function table.isarray(t)
  for k in pairs(t) do
    if type(k) ~= "number" then
      return false
    end
  end
  return true
end

--- @generic T
--- @param t1 T[]
--- @param t2 T[]
--- @param replace_arrays? boolean
--- @return T[]
function table.merge(t1, t2, replace_arrays)
  if table.isarray(t2) then
    if replace_arrays then
      t1 = {}
      for _, v in ipairs(t2) do
        table.insert(t1, v)
      end
    end
  else
    for k, v in pairs(t2) do
      if type(t1[k]) == "table" and type(v) == "table" then
        table.merge(t1[k], v)
      else
        t1[k] = v
      end
    end
  end
  return t1
end

--- @generic number
--- @param t number[]
--- @return number
function table.sum(t)
  local s = 0
  for _, v in ipairs(t) do
    s = s + v
  end
  return s
end

--- @generic T
--- @param t T[]
--- @param value T
--- @param ... T
function table.insertall(t, value, ...)
  table.insert(t, value)
  for _, v in ipairs({ ... }) do
    table.insert(t, v)
  end
end

if table.unpack == nil then
  --- @diagnostic disable-next-line: deprecated
  table.unpack = unpack
end

table.stable_sort = table.stable_sort or function(array, less) return array end

--- @generic T
--- @param t T[]
--- @param f? integer
--- @param l? integer
--- @param s? integer
--- @return T[]
function table.slice(t, f, l, s)
  local r = {}
  for i = f or 1, l or #t, s or 1 do
    r[#r + 1] = t[i]
  end
  return r
end

--- @generic T
--- @param t T[]
--- @param value T
--- @return boolean
function table.contains(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

--- Removes from `list` the element with value `value`, returning the value of the removed element.
--- @generic T
--- @param list T[]
--- @param value T
---@return T|nil
function table.removebyvalue(list, value)
  if type(list) ~= "table" then return end
  for i, v in ipairs(list) do
    if v == value then
      return table.remove(list, i)
    end
  end
end

--- Finds an element in a table
---@generic T
---@param list T[]
---@param f fun(v: T, k: integer): boolean
---@return T|nil, integer|nil
function table.find(list, f)
  for k, v in pairs(list) do
    if f(v, k) then
      return v, k
    end
  end
end

--- Returns the number of elements in a table
--- @generic T : table
--- @param t T
--- @return integer
function table.len(t)
  local c = 0
  for _ in pairs(t) do
    c = c + 1
  end
  return c
end

-- string --

--- @param self string
--- @return string
function string:trim()
  return (string.gsub(self, "^%s*(.-)%s*$", "%1"))
end

-- https://gist.github.com/GabrielBdeC/b055af60707115cbc954b0751d87ec23
--- @param self string
function string:split(delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(self, delimiter, from, true)
  while delim_from do
    if (delim_from ~= 1) then
      table.insert(result, string.sub(self, from, delim_from - 1))
    end
    from = delim_to + 1
    delim_from, delim_to = string.find(self, delimiter, from, true)
  end
  if (from <= #self) then table.insert(result, string.sub(self, from)) end
  return result
end

-- math --

--- Returns the sign of `x`.
--- @param x number
--- @return number
function math.sign(x)
  if x > 0 then
    return 1
  elseif x < 0 then
    return -1
  end
  return 0
end

--- Clamps `x` between `min` and `max`.
--- @param x number
--- @param min number
--- @param max number
--- @return number
function math.clamp(x, min, max)
  return math.max(math.min(x, max), min)
end

--- Returns the nearest integer value to `x`.
--- @param x number
--- @return integer
function math.round(x)
  return math.floor(x + 0.5)
end

--- Linearly interpolates between `a` and `b` by `t`.
--- @param a number
--- @param b number
--- @param t number
--- @return number
function math.lerp(a, b, t)
  return a + (b - a) * t
end

--- Sums all values.
--- @param ... number
--- @return number
function math.sum(...)
  local s = 0
  for _, v in pairs({ ... }) do
    s = s + v
  end
  return s
end

--- Gets the distance between two points
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number
function math.dist(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  return math.sqrt(dx * dx + dy * dy)
end

-- other --

--- @class Dummy.Utils
---
--- @field private __hooks table<table, boolean>
local Utils = {}

--- Get value or default
--- @generic T
--- @param value T|nil
--- @param default_value T
--- @return T
function Utils.getOrDefault(value, default_value)
  return value == nil and default_value or value
end

--- Checks if a file has an extension
--- @param path string
--- @param ... string
function Utils.checkExtension(path, ...)
  for _, v in ipairs({ ... }) do
    if path:sub(- #v - 1):lower() == "." .. v then
      return path:sub(1, - #v - 2), v
    end
  end
end

--- Gets a filename without extension
--- @param filename string
function Utils.getFilenameWithoutExt(filename)
  return (filename:gsub("%.[^.]*$", ""))
end

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
function Utils.pointInTriangle(x, y, ax, ay, bx, by, cx, cy)
  local function sign(x1, y1, x2, y2, x3, y3)
    return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3)
  end

  local d1 = sign(x, y, ax, ay, bx, by)
  local d2 = sign(x, y, bx, by, cx, cy)
  local d3 = sign(x, y, cx, cy, ax, ay)

  local has_negative = (d1 < 0) or (d2 < 0) or (d3 < 0)
  local has_positive = (d1 > 0) or (d2 > 0) or (d3 > 0)

  return not (has_negative and has_positive)
end

--- Wether a point is in a rectangle
--- @param x number point x
--- @param y number point y
--- @param rx number rect x
--- @param ry number rect y
--- @param rw number rect width
--- @param rh number rect height
--- @return boolean
function Utils.isPointInRect(x, y, rx, ry, rw, rh)
  return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

--- Wether a rectangle collides another rectangle, using AABB collision detection
--- @param rect1 [number, number, number, number] [x, y, width, height]
--- @param rect2 [number, number, number, number] [x, y, width, height]
--- @return boolean
function Utils.checkCollisionAABB(rect1, rect2)
  return rect1[1] < rect2[1] + rect2[3] and
      rect2[1] < rect1[1] + rect1[3] and
      rect1[2] < rect2[2] + rect2[4] and
      rect2[2] < rect1[2] + rect1[4]
end

--- Checks if two rectangles collide, using SAT-based rectangle collision
--- @param rect1 [number, number, number, number]
--- @param rect2 [number, number, number, number]
--- @return boolean
function Utils.checkCollision(rect1, rect2)
  local function dot(a, b)
    return a[1] * b[1] + a[2] * b[2]
  end

  local function getNormals(polygon)
    local normals = {}
    for i = 1, #polygon do
      local p1 = polygon[i]
      local p2 = polygon[(i % #polygon) + 1]
      local edge = { p2[1] - p1[1], p2[2] - p1[2] }
      table.insert(normals, { -edge[2], edge[1] })
    end
    return normals
  end

  local function projectPolygon(polygon, axis)
    local min = dot(polygon[1], axis)
    local max = min
    for i = 2, #polygon do
      local projection = dot(polygon[i], axis)
      if projection < min then min = projection end
      if projection > max then max = projection end
    end
    return min, max
  end

  local function overlap(minA, maxA, minB, maxB)
    return maxA >= minB and maxB >= minA
  end

  local normals1 = getNormals(rect1)
  local normals2 = getNormals(rect2)

  for _, axis in ipairs(normals1) do
    local minA, maxA = projectPolygon(rect1, axis)
    local minB, maxB = projectPolygon(rect2, axis)
    if not overlap(minA, maxA, minB, maxB) then
      return false
    end
  end

  for _, axis in ipairs(normals2) do
    local minA, maxA = projectPolygon(rect1, axis)
    local minB, maxB = projectPolygon(rect2, axis)
    if not overlap(minA, maxA, minB, maxB) then
      return false
    end
  end

  return true
end

Utils.__hooks = {}

--- Replaces a function
--- @param target table
--- @param name string
--- @param func fun(orig:fun(...), ...)
function Utils.hook(target, name, func)
  local orig = target[name]

  Utils.__hooks[{
    target = target,
    name = name,
    func = func,
    original = orig
  }] = true

  local orig_func = orig or function() end
  target[name] = function(...)
    return func(orig_func, ...)
  end
end

--- Unhooks a function
--- @param target table
--- @param name string
function Utils.unhook(target, name)
  for hook in pairs(Utils.__hooks) do
    if hook.target == target and hook.name == name then
      hook.target[hook.name] = hook.original
      Utils.__hooks[hook] = nil
      return
    end
  end
end

return Utils
