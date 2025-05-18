local self = {}

function self.load()
  self.enabled = false
  self.lines = {}
  self.max_lines = 5
end

function self.update()
  if Input.isPressed("f8") then
    self.enabled = not self.enabled
  elseif Input.isPressed(";") then
    love.audio.setVolume(love.audio.getVolume() > 0 and 0 or 1)
  elseif Input.isPressed("kp+") and Player ~= nil then
    Player.setLV(Player.getLV() + 1)
  elseif Input.isPressed("kp-") and Player ~= nil then
    Player.setLV(Player.getLV() - 1)
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
  local t = {}
  for _, v in pairs({ ... }) do
    table.insert(self.lines or {}, tostring(v))
    table.insert(t, tostring(v))
  end
  return _print(table.unpack(t))
end

return self
