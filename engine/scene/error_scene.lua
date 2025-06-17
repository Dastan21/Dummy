--- @class Dummy.Scene.Error : Dummy.Scene.Scene
---
--- @field private traceback string
--- @field private error_text Dummy.Text
--- @field private back_main_menu_text Dummy.Text
--- @field private copy_traceback_text Dummy.Text
--- @field private copied_delay number
--- @field private copied_timer number
--- @field private escape boolean
local error = {}

--- Loads the error scene
function error.load(err)
  error.traceback = Lang.translate("ERROR_LABEL") .. " " .. err

  local main_text_font = Assets.getFont("main_text")
  local _, wrapped_error = main_text_font:getWrap(error.traceback, Constants.WIDTH - 10)
  error.error_text = Text:new(table.concat(wrapped_error, "\n"))
  error.error_text:setPosition(5, 5)
  error.error_text:setOrigin(0, 0)
  error.error_text:setFont(main_text_font)

  Drawable:new(function()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, Constants.HEIGHT - 45, Constants.WIDTH, 45)
  end):setLayer(Constants.LAYERS.ABOVE_UI)

  error.back_main_menu_text = Text:new("ERROR_BACK_MAIN_MENU")
  error.back_main_menu_text:setPosition(5, Constants.HEIGHT - 25)
  error.back_main_menu_text:setOrigin(0, 1)
  error.back_main_menu_text:setFont(main_text_font)
  error.back_main_menu_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.copy_traceback_text = Text:new("ERROR_COPY_TRACEBACK")
  error.copy_traceback_text:setPosition(5, Constants.HEIGHT - 5)
  error.copy_traceback_text:setOrigin(0, 1)
  error.copy_traceback_text:setFont(main_text_font)
  error.copy_traceback_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.copied_delay = 1
  error.copied_timer = 0
  error.escape = false
end

--- Updates the error scene
function error.update(dt)
  if error.escape then
    Scene.change("MAIN_MENU")
  end

  if Input.isPressed("escape") then
    error.escape = true
  end

  if Input.isDown({ "lctrl", "rctrl" }) and Input.isPressed("c") then
    love.system.setClipboardText(error.traceback)
    error.copied_timer = error.copied_delay
  end

  if error.copied_timer > 0 then
    error.copied_timer = error.copied_timer - dt * 3
    error.copy_traceback_text:setColor(1, 1, error.copied_delay - error.copied_timer)
  end
end

return error
