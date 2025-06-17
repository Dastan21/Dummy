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

local MARGIN_ERROR = 15
local MARGIN_INFO = 5

--- Loads the error scene
function error.load(err)
  error.traceback = Lang.translate("ERROR_LABEL") .. " " .. err

  local main_text_font = Assets.getFont("main")
  local _, wrapped_error = main_text_font:getWrap(error.traceback, (Constants.WIDTH - 2 * MARGIN_ERROR) * 2)
  error.error_text = Text:new(table.concat(wrapped_error, "\n"))
  error.error_text:setPosition(MARGIN_ERROR, MARGIN_ERROR)
  error.error_text:setOrigin(0, 0)
  error.error_text:setFont(main_text_font)
  error.error_text:setScale(0.5)

  Drawable:new(function()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, Constants.HEIGHT - 40 - MARGIN_INFO, Constants.WIDTH, 40 + MARGIN_INFO)
  end):setLayer(Constants.LAYERS.ABOVE_UI)

  error.back_main_menu_text = Text:new("ERROR_BACK_MAIN_MENU")
  error.back_main_menu_text:setPosition(MARGIN_INFO, Constants.HEIGHT - 20 - MARGIN_INFO)
  error.back_main_menu_text:setOrigin(0, 1)
  error.back_main_menu_text:setFont(main_text_font)
  error.back_main_menu_text:setScale(0.5)
  error.back_main_menu_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.copy_traceback_text = Text:new("ERROR_COPY_TRACEBACK")
  error.copy_traceback_text:setPosition(MARGIN_INFO, Constants.HEIGHT - MARGIN_INFO)
  error.copy_traceback_text:setOrigin(0, 1)
  error.copy_traceback_text:setFont(main_text_font)
  error.copy_traceback_text:setScale(0.5)
  error.copy_traceback_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.engine_info_text = Text:new(Constants.CREDITS.NAME .. " v" .. Constants.CREDITS.VERSION)
  error.engine_info_text:setPosition(Constants.WIDTH - MARGIN_INFO, Constants.HEIGHT - MARGIN_INFO)
  error.engine_info_text:setOrigin(1, 1)
  error.engine_info_text:setFont(main_text_font)
  error.engine_info_text:setScale(0.5)
  error.engine_info_text:setLayer(Constants.LAYERS.ABOVE_UI)

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    error.mod_info_text = Text:new({ "ERROR_MOD_INFO", mod:getName() .. " " .. mod:getVersion() })
    error.mod_info_text:setPosition(Constants.WIDTH - MARGIN_INFO, Constants.HEIGHT - 20 - MARGIN_INFO)
    error.mod_info_text:setOrigin(1, 1)
    error.mod_info_text:setFont(main_text_font)
    error.mod_info_text:setScale(0.5)
    error.mod_info_text:setLayer(Constants.LAYERS.ABOVE_UI)
  end

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
