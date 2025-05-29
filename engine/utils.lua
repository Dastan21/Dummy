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

function table.isarray(t)
  for k in pairs(t) do
    if type(k) ~= "number" then
      return false
    end
  end
  return true
end

function table.merge(t1, t2)
  if table.isarray(t2) then
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

-- string --

--- @param self string
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

function math.sign(x)
  if x > 0 then
    return 1
  elseif x < 0 then
    return -1
  end
  return 0
end

function math.clamp(x, min, max)
  return math.max(math.min(x, max), min)
end

function math.round(x)
  return math.floor(x + 0.5)
end

-- other --

local self = {}

--- Get value or default
--- @generic T
--- @param value T|nil
--- @param default_value T
--- @return T
function self.getOrDefault(value, default_value)
  return value == nil and default_value or value
end

function self.checkExtension(path, ...)
  for _, v in ipairs({ ... }) do
    if path:sub(- #v - 1):lower() == "." .. v then
      return path:sub(1, - #v - 2), v
    end
  end
end

return self
