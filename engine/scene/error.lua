local self = {}

function self.load(err)
  self.traceback = Lang.translate("ERROR_SCENE_ERROR") .. " " .. err

  local _, wrapped_error = Font.FONTS.MAIN_TEXT:getWrap(self.traceback, 630)
  self.error_text = Text:new(table.concat(wrapped_error, "\n"))
  self.error_text:setPosition(5, 5)
  self.error_text:setOrigin(0, 0)
  self.error_text:setFont(Font.FONTS.MAIN_TEXT)

  local black_rectangle_draw = Drawable:new(function()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 435, 640, 45)
  end)
  black_rectangle_draw:setLayer(Constants.LAYERS.ABOVE_UI)

  self.back_main_menu_text = Text:new("ERROR_SCENE_BACK_MAIN_MENU")
  self.back_main_menu_text:setPosition(5, 455)
  self.back_main_menu_text:setOrigin(0, 1)
  self.back_main_menu_text:setFont(Font.FONTS.MAIN_TEXT)
  self.back_main_menu_text:setLayer(Constants.LAYERS.ABOVE_UI)

  self.copy_traceback_text = Text:new("ERROR_SCENE_COPY_TRACEBACK")
  self.copy_traceback_text:setPosition(5, 475)
  self.copy_traceback_text:setOrigin(0, 1)
  self.copy_traceback_text:setFont(Font.FONTS.MAIN_TEXT)
  self.copy_traceback_text:setLayer(Constants.LAYERS.ABOVE_UI)

  self.copied_delay = 1
  self.copied_timer = 0
  self.escape = false
end

function self.update(dt)
  if self.escape then
    Scene.change("MAIN_MENU")
  end

  if Input.isPressed("escape") then
    self.escape = true
  end

  if (Input.isDown("lctrl") or Input.isDown("rctrl")) and Input.isPressed("c") then
    love.system.setClipboardText(self.traceback)
    self.copied_timer = self.copied_delay
  end

  if self.copied_timer > 0 then
    self.copied_timer = self.copied_timer - dt * 3
    self.copy_traceback_text:setColor(1, 1, self.copied_delay - self.copied_timer)
  end
end

return self
