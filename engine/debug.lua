local self = {}

function self.load()
  self.enabled = false
  self.lines = {}
  self.max_lines = 5
end

function self.update()
  if Input.isKeyPressed("f9") then
    self.enabled = not self.enabled
  end
end

function self.draw()
  if self.enabled then
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    love.graphics.setColor(1, 1, 1, 1)
    local i = 0
    for l = #self.lines, 1, -1 do
      love.graphics.print(self.lines[l], 0, 20 * i, 0, 0.75, 0.75)
      i = i + 1
    end
  end
end

local _print = print
function print(...)
  local val = ""
  for _, v in ipairs({ ... }) do
    table.insert(self.lines or {}, tostring(v))
    val = val .. tostring(v) .. " "
  end
  return _print(val)
end

return self
