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

-- https://gist.github.com/tylerneylon/81333721109155b2d244
function table.clone(obj, seen)
  -- Handle non-tables and previously-seen tables.
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  -- New table; mark it as seen and copy recursively.
  local s = seen or {}
  local res = {}
  s[obj] = res
  for k, v in pairs(obj) do res[table.clone(k, s)] = table.clone(v, s) end
  return setmetatable(res, getmetatable(obj))
end

function table.isArray(t)
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
--- @return T[]
function table.merge(t1, t2)
  if table.isArray(t2) then
    for _, v in ipairs(t2) do
      table.insert(t1, v)
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
--- @param list table
--- @param value T
---@return T|nil
function table.removeByValue(list, value)
  if type(list) ~= "table" then return end
  for i, v in ipairs(list) do
    if v == value then
      return table.remove(list, i)
    end
  end
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
  return filename:gsub("%.[^.]*$", "")
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

return Utils
