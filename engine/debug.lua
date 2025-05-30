local self = {}

function self.load()
  self.logs = {}
  self.margin = 5
  self.scale = 1

  self.show_hitbox = false

  self.log_bg_sprite = Sprite:new("black")
  self.log_bg_sprite:setPosition(0, 0)
  self.log_bg_sprite:setOrigin(0, 0)
  self.log_bg_sprite:setLayer(Constants.LAYERS.DEBUG)
  self.log_bg_sprite:setAlpha(0.4)
  self.log_bg_sprite:setVisible(false)
  self.log_bg_sprite:setPersistent(true)

  self.log_text = Text:new("")
  self.log_text:setPosition(self.margin, 480 - self.margin)
  self.log_text:setOrigin(0, 1)
  self.log_text:setScale(self.scale)
  self.log_text:setLayer(Constants.LAYERS.DEBUG)
  self.log_text:setFont(Font.FONTS.MAIN_TEXT)
  self.log_text:setVisible(false)
  self.log_text:setPersistent(true)

  self.fps_text = Text:new("")
  self.fps_text:setPosition(640 - self.margin, self.margin)
  self.fps_text:setOrigin(1, 0)
  self.fps_text:setScale(self.scale)
  self.fps_text:setLayer(Constants.LAYERS.DEBUG)
  self.fps_text:setFont(Font.FONTS.MAIN_TEXT)
  self.fps_text:setVisible(false)
  self.fps_text:setPersistent(true)
end

function self.saveLogs()
  if #self.logs <= 0 then return end

  love.filesystem.write("logs.txt", table.concat(self.logs, "\n"))
end

function self.update()
  self.fps_text:setText(tostring(love.timer.getFPS()))
  self.log_text:setText(table.concat(self.logs or {}, "\n"))

  if Input.isPressed("f6") then
    self.fps_text:setVisible(not self.fps_text:isVisible())
  elseif Input.isPressed("f7") then
    self.show_hitbox = not self.show_hitbox
  elseif Input.isPressed("f8") then
    local visible = not self.log_bg_sprite:isVisible()
    self.log_bg_sprite:setVisible(visible)
    self.log_text:setVisible(visible)
  elseif Input.isPressed(";") then
    love.audio.setVolume(love.audio.getVolume() > 0 and 0 or 1)
  end
end

local _print = print
function print(...)
  local t = {}
  for _, v in pairs({ ... }) do
    table.insert(t, tostring(v))
  end

  if self.logs ~= nil then
    local _, w = love.graphics.getFont():getWrap(table.concat(t, "	"), (600 / self.scale) - (self.margin * 2))
    local len = #self.logs
    for i, s in ipairs(w) do
      self.logs[len + i] = "> " .. s
    end
  end

  return _print(...)
end

return self
