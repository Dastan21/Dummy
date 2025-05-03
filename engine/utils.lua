-- https://gist.github.com/revolucas/dd1ecccfca32d558fddf70ddb39eb8a6
local function table_tostring(node)
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

local _tostring = tostring
function tostring(v)
  if type(v) == "table" then
    s, r = pcall(function() return table_tostring(v) end)
    if s then return r end
  end
  return _tostring(v)
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

function string.trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

if table.unpack == nil then
  ---@diagnostic disable-next-line: deprecated
  table.unpack = unpack
end
