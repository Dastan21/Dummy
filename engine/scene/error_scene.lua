--- @class Dummy.Scene.Error : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected traceback string
--- @field protected error_text Dummy.Text
--- @field protected back_main_menu_text Dummy.Text
--- @field protected copy_traceback_text Dummy.Text
--- @field protected copied_data table<string, number>
--- @field protected escape boolean
local ErrorScene = {}

local MARGIN_ERROR = 15
local MARGIN_INFO = 5

--- Loads the error scene
function ErrorScene.load(err)
  ErrorScene.camera = GameCamera:new()
  ErrorScene.traceback = Lang.translate("ERROR_LABEL") .. " " .. err

  local main_text_font = Assets.getFont("main")
  local _, wrapped_error = main_text_font:getWrap(ErrorScene.traceback, (Constants.GAME_WIDTH - 2 * MARGIN_ERROR) * 2)
  ErrorScene.error_text = Text:new(table.concat(wrapped_error, "\n"))
  ErrorScene.error_text:setPosition(MARGIN_ERROR, MARGIN_ERROR)
  ErrorScene.error_text:setOrigin(0, 0)
  ErrorScene.error_text:setFont(main_text_font)
  ErrorScene.error_text:setScale(0.5)

  local text_overlay_drawable = Drawable:new()
  text_overlay_drawable:setLayer(Constants.LAYERS.UI)
  function text_overlay_drawable.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, Constants.GAME_HEIGHT - 40 - MARGIN_INFO, Constants.GAME_WIDTH, 40 + MARGIN_INFO)
  end

  ErrorScene.back_main_menu_text = Text:new("ERROR_BACK_MAIN_MENU")
  ErrorScene.back_main_menu_text:setPosition(MARGIN_INFO, Constants.GAME_HEIGHT - 20 - MARGIN_INFO)
  ErrorScene.back_main_menu_text:setOrigin(0, 1)
  ErrorScene.back_main_menu_text:setFont(main_text_font)
  ErrorScene.back_main_menu_text:setScale(0.5)
  ErrorScene.back_main_menu_text:setLayer(Constants.LAYERS.ABOVE_UI)

  ErrorScene.copy_traceback_text = Text:new("ERROR_COPY_TRACEBACK")
  ErrorScene.copy_traceback_text:setPosition(MARGIN_INFO, Constants.GAME_HEIGHT - MARGIN_INFO)
  ErrorScene.copy_traceback_text:setOrigin(0, 1)
  ErrorScene.copy_traceback_text:setFont(main_text_font)
  ErrorScene.copy_traceback_text:setScale(0.5)
  ErrorScene.copy_traceback_text:setLayer(Constants.LAYERS.ABOVE_UI)

  ErrorScene.engine_info = Constants.CREDITS.NAME .. " v" .. Constants.CREDITS.VERSION
  ErrorScene.engine_info_text = Text:new(ErrorScene.engine_info)
  ErrorScene.engine_info_text:setPosition(Constants.GAME_WIDTH - MARGIN_INFO, Constants.GAME_HEIGHT - MARGIN_INFO)
  ErrorScene.engine_info_text:setOrigin(1, 1)
  ErrorScene.engine_info_text:setFont(main_text_font)
  ErrorScene.engine_info_text:setScale(0.5)
  ErrorScene.engine_info_text:setLayer(Constants.LAYERS.ABOVE_UI)

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    local mod_version = mod:getVersion()
    mod_version = mod_version ~= nil and " v" .. mod_version or ""
    ErrorScene.mod_info = Lang.translate({ "ERROR_MOD_INFO", mod:getName() .. mod_version })
    ErrorScene.mod_info_text = Text:new(ErrorScene.mod_info)
    ErrorScene.mod_info_text:setPosition(Constants.GAME_WIDTH - MARGIN_INFO, Constants.GAME_HEIGHT - 20 - MARGIN_INFO)
    ErrorScene.mod_info_text:setOrigin(1, 1)
    ErrorScene.mod_info_text:setFont(main_text_font)
    ErrorScene.mod_info_text:setScale(0.5)
    ErrorScene.mod_info_text:setLayer(Constants.LAYERS.ABOVE_UI)
  end

  ErrorScene.copied_data = { color = 1 }
  ErrorScene.escape = false
end

--- Updates the error scene, called on every game update
function ErrorScene.update()
  if ErrorScene.escape then
    Scene.change("MAIN_MENU")
  end

  if Input.isPressed(Input.Escape) then
    ErrorScene.escape = true
  end

  if Input.isDown("ctrl") and Input.isPressed("c") then
    local mod_info = ErrorScene.mod_info ~= nil and (ErrorScene.mod_info .. "\n") or ""
    love.system.setClipboardText(ErrorScene.traceback .. "\n\n" .. mod_info .. ErrorScene.engine_info)

    ErrorScene.copied_data.color = 0
    Timer.tween(1 / 3, ErrorScene.copied_data, { color = 1 }, "out-sine")
  end

  ErrorScene.copy_traceback_text:setColor(1, 1, ErrorScene.copied_data.color)
end

return ErrorScene
