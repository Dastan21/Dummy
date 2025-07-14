--- @class Dummy.Scene.Error : Dummy.Scene.Scene
---
--- @field protected traceback string
--- @field protected error_text Dummy.Text
--- @field protected back_main_menu_text Dummy.Text
--- @field protected copy_traceback_text Dummy.Text
--- @field protected copied_delay number
--- @field protected copied_timer number
--- @field protected escape boolean
local error = {}

local MARGIN_ERROR = 15
local MARGIN_INFO = 5

--- Loads the error scene
function error.load(err)
  error.traceback = Lang.translate("ERROR_LABEL") .. " " .. err

  local main_text_font = Assets.getFont("main")
  local _, wrapped_error = main_text_font:getWrap(error.traceback, (Constants.SCREEN_WIDTH - 2 * MARGIN_ERROR) * 2)
  error.error_text = Text:new(table.concat(wrapped_error, "\n"))
  error.error_text:setPosition(MARGIN_ERROR, MARGIN_ERROR)
  error.error_text:setOrigin(0, 0)
  error.error_text:setFont(main_text_font)
  error.error_text:setScale(0.5)

  local text_overlay_drawable = Drawable:new()
  text_overlay_drawable:setLayer(Constants.LAYERS.ABOVE_UI)
  function text_overlay_drawable.draw()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, Constants.SCREEN_HEIGHT - 40 - MARGIN_INFO, Constants.SCREEN_WIDTH,
      40 + MARGIN_INFO)
  end

  error.back_main_menu_text = Text:new("ERROR_BACK_MAIN_MENU")
  error.back_main_menu_text:setPosition(MARGIN_INFO, Constants.SCREEN_HEIGHT - 20 - MARGIN_INFO)
  error.back_main_menu_text:setOrigin(0, 1)
  error.back_main_menu_text:setFont(main_text_font)
  error.back_main_menu_text:setScale(0.5)
  error.back_main_menu_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.copy_traceback_text = Text:new("ERROR_COPY_TRACEBACK")
  error.copy_traceback_text:setPosition(MARGIN_INFO, Constants.SCREEN_HEIGHT - MARGIN_INFO)
  error.copy_traceback_text:setOrigin(0, 1)
  error.copy_traceback_text:setFont(main_text_font)
  error.copy_traceback_text:setScale(0.5)
  error.copy_traceback_text:setLayer(Constants.LAYERS.ABOVE_UI)

  error.engine_info = Constants.CREDITS.NAME .. " v" .. Constants.CREDITS.VERSION
  error.engine_info_text = Text:new(error.engine_info)
  error.engine_info_text:setPosition(Constants.SCREEN_WIDTH - MARGIN_INFO, Constants.SCREEN_HEIGHT - MARGIN_INFO)
  error.engine_info_text:setOrigin(1, 1)
  error.engine_info_text:setFont(main_text_font)
  error.engine_info_text:setScale(0.5)
  error.engine_info_text:setLayer(Constants.LAYERS.ABOVE_UI)

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    local mod_version = mod:getVersion()
    mod_version = mod_version ~= nil and " v" .. mod_version or ""
    error.mod_info = Lang.translate({ "ERROR_MOD_INFO", mod:getName() .. mod_version })
    error.mod_info_text = Text:new(error.mod_info)
    error.mod_info_text:setPosition(Constants.SCREEN_WIDTH - MARGIN_INFO, Constants.SCREEN_HEIGHT - 20 - MARGIN_INFO)
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

  if Input.isDown("ctrl") and Input.isPressed("c") then
    love.system.setClipboardText(error.traceback .. "\n\n" .. error.mod_info .. "\n" .. error.engine_info)
    error.copied_timer = error.copied_delay
  end

  if error.copied_timer > 0 then
    error.copied_timer = error.copied_timer - dt * 3
    error.copy_traceback_text:setColor(1, 1, error.copied_delay - error.copied_timer)
  end
end

return error
