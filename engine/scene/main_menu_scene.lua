--- @class Dummy.Scene.MainMenu : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected options Dummy.Menu.Options
--- @field protected current_menu Dummy.MainMenu
--- @field protected mod_list_menu Dummy.MainMenu
--- @field protected editor_menu Dummy.MainMenu
--- @field protected settings_menu Dummy.MainMenu
--- @field protected reset_save_menu Dummy.MainMenu
--- @field protected reset_selected_save_menu Dummy.MainMenu
--- @field protected reset_selected_save_mod { id: string, name: string }|nil
--- @field protected reset_selected_save_text Dummy.Text
--- @field protected logo_sprite Dummy.Sprite
--- @field protected credits_text Dummy.Text
--- @field protected background_sprite Dummy.Sprite
--- @field protected menu_music love.Source
--- @field protected was_fullscreen boolean
--- @field protected input_hold_time number
--- @field protected input_hold_delay number
local MainMenuScene = {}

--- Loads the main menu
function MainMenuScene.load()
  MainMenuScene.camera = GameCamera:new()

  Cursor.setVisible(false)
  Input.setGamepadDeadzone(0.2)
  Input.setTriggerTreshold(0.5)

  Config.save()
  ModList.load()
  Scene.release("WORLD")

  local standalone = ModList.getStandalone()
  if standalone ~= nil then
    Lang.loadLanguages()
    ---@diagnostic disable-next-line: invisible
    standalone.config = Config.loadConfig("configs/" .. standalone:getId())
  end

  MainMenuScene.logo_sprite = Sprite:new("logo")
  MainMenuScene.logo_sprite:setPosition(320, 80)
  MainMenuScene.logo_sprite:setScale(6)

  MainMenuScene.credits_text = Text:new(Constants.CREDITS.NAME ..
    " v" .. Constants.CREDITS.VERSION .. " " .. Constants.CREDITS.AUTHOR .. " " .. Constants.CREDITS.YEAR)
  MainMenuScene.credits_text:setFont("small")
  MainMenuScene.credits_text:setAlpha(0.707)
  MainMenuScene.credits_text:setPosition(320, 476)
  MainMenuScene.credits_text:setOrigin(0.5, 1)
  MainMenuScene.credits_text:setScale(2)

  MainMenuScene.reset_selected_save_text = Text:new("")
  MainMenuScene.reset_selected_save_text:setPosition(320, 220)
  MainMenuScene.reset_selected_save_text:setWrapLimit(600)
  MainMenuScene.reset_selected_save_text:setAlign("center")
  MainMenuScene.reset_selected_save_text:setVisible(false)

  MainMenuScene.background_sprite = Sprite:new("background")
  MainMenuScene.background_sprite:setOrigin(0, 0)
  MainMenuScene.background_sprite:setLayer(Constants.LAYERS.BOTTOM)

  MainMenuScene.loadMenus()
  MainMenuScene.changeMenu(MainMenuScene.main_menu)

  MainMenuScene.menu_music = Assets.playMusic("main_menu")
  MainMenuScene.menu_music:setVolume(0.5)

  MainMenuScene.was_fullscreen = love.window.getFullscreen()

  MainMenuScene.input_hold_time = 0
  MainMenuScene.input_hold_delay = 0.1

  if standalone ~= nil then
    if type(standalone.preview) == "function" then
      standalone:preview()
    end
  end

  ModList.setWindowTitleAndIcon()
end

--- Loads menus
function MainMenuScene.loadMenus()
  MainMenuScene.loadMainMenu()
  MainMenuScene.loadSettingsMenu()
end

--- Loads main menu
function MainMenuScene.loadMainMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  local standalone = ModList.getStandalone()
  if standalone == nil then
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        MainMenuScene.loadModListMenu()
        MainMenuScene.changeMenu(MainMenuScene.mod_list_menu, 1)
      end
    })

    if love.system.getOS() ~= "Web" then
      table.insert(options, {
        text = Text:new("MAIN_MENU_EDITOR"),
        action = function()
          MainMenuScene.loadEditorMenu()
          MainMenuScene.changeMenu(MainMenuScene.editor_menu, 1)
        end
      })

      table.insert(options, {
        text = Text:new("MAIN_MENU_OPEN_MOD_FOLDER"),
        action = function()
          love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/mods")
        end
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        Scene.change("WORLD", ModList.getStandalone())
      end
    })
  end

  table.insert(options, {
    text = Text:new("MAIN_MENU_SETTINGS"),
    action = function()
      MainMenuScene.changeMenu(MainMenuScene.settings_menu)
    end
  })

  if love.system.getOS() ~= "Web" then
    table.insert(options, {
      text = Text:new("MAIN_MENU_QUIT"),
      action = function()
        love.event.quit()
      end
    })
  end

  MainMenuScene.main_menu = MainMenu:new(options, "")
end

--- Loads editor menu
function MainMenuScene.loadEditorMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  ModList.load()
  local mods = ModList.getMods()
  if #mods >= 1 then
    for _, mod in ipairs(mods) do
      table.insert(options, {
        text = Text:new(mod:getName()),
        action = function()
          Scene.change("EDITOR", mod:getId())
        end
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_EDITOR_EMPTY")
    })
  end

  if MainMenuScene.editor_menu ~= nil then
    MainMenuScene.editor_menu:setOptions(options)
  else
    MainMenuScene.editor_menu = MainMenu:new(options, "MAIN_MENU_EDITOR_TITLE", function()
      MainMenuScene.changeMenu(MainMenuScene.main_menu)
    end)
  end
end

--- Loads settings menu
function MainMenuScene.loadSettingsMenu()
  --- @type Dummy.Menu.Options
  local options = {
    {
      id = "LANGUAGE_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() }),
      action = function(option)
        Lang.switchLanguage()
        ModList.setWindowTitleAndIcon()

        MainMenuScene.current_menu:show()
        option.text:setText({ "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() })
      end,
    },
    {
      id = "FPS_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_FPS", Config.getSettings()["fps"] ~= -1 and Config.getSettings()["fps"] or
      "MAIN_MENU_SETTINGS_FPS_UNLIMITED" }),
      action = function(option)
        local settings = Config.getSettings()
        local fps = { 30, 60, 120, 144, 240, -1 }
        local fps_index = 1
        for i, v in ipairs(fps) do
          if v == settings.fps then
            fps_index = i
            break
          end
        end
        settings.fps = fps[(fps_index % #fps) + 1]
        local fps_text = tostring(settings.fps)
        if settings.fps == -1 then
          fps_text = "MAIN_MENU_SETTINGS_FPS_UNLIMITED"
        end
        option.text:setText({ "MAIN_MENU_SETTINGS_FPS", fps_text })
      end,
    },
    {
      id = "VSYNC_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_VSYNC", Config.getSettings()["vsync"] and
      "MAIN_MENU_SETTINGS_SWITCH_ON" or "MAIN_MENU_SETTINGS_SWITCH_OFF" }),
      action = function(option)
        local vsync = not Config.getSettings()["vsync"]
        option.text:setText({ "MAIN_MENU_SETTINGS_VSYNC", vsync and "MAIN_MENU_SETTINGS_SWITCH_ON" or
        "MAIN_MENU_SETTINGS_SWITCH_OFF" })

        Config.getSettings()["vsync"] = vsync
        love.scale()
      end,
    },
    {
      id = "VOLUME_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_VOLUME", Config.getSettings()["volume"] }),
      action = function() end,
      silent = true
    },
    {
      id = "FULLSCREEN_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_FULLSCREEN", Config.getSettings()["fullscreen"] and
      "MAIN_MENU_SETTINGS_SWITCH_ON" or "MAIN_MENU_SETTINGS_SWITCH_OFF" }),
      action = function(option)
        local fullscreen = not Config.getSettings()["fullscreen"]
        option.text:setText({ "MAIN_MENU_SETTINGS_FULLSCREEN", fullscreen and "MAIN_MENU_SETTINGS_SWITCH_ON" or
        "MAIN_MENU_SETTINGS_SWITCH_OFF" })

        Config.getSettings()["fullscreen"] = fullscreen
        love.scale()
      end,
    }
  }

  if love.system.getOS() ~= "Web" then
    --- @type Dummy.Menu.Option
    local window_scale_option = {
      id = "WINDOW_SCALE_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_WINDOW_SCALE", Config.getSettings()["window_scale"] }),
      action = function(option)
        local settings = Config.getSettings()
        local scales = { 0.5, 1, 2, 3, 4 }
        local scale_index = 2
        for i, v in ipairs(scales) do
          if v == settings["window_scale"] then
            scale_index = i
            break
          end
        end
        settings["window_scale"] = scales[(scale_index % #scales) + 1]
        option.text:setText({ "MAIN_MENU_SETTINGS_WINDOW_SCALE", settings["window_scale"] })

        local opt = MainMenuScene.settings_menu:getOptionById("FULLSCREEN_SETTING")
        if opt ~= nil then
          opt.text:setText({ "MAIN_MENU_SETTINGS_FULLSCREEN", "MAIN_MENU_SETTINGS_SWITCH_OFF" })
        end

        Config.getSettings()["fullscreen"] = false
        love.scale()
      end,
    }
    table.insert(options, window_scale_option)
  end

  --- @type Dummy.Menu.Option
  local reset_save_option = {
    id = "RESET_SAVE_SETTING",
    text = Text:new("MAIN_MENU_SETTINGS_RESET_SAVE"),
    action = function()
      local standalone = ModList.getStandalone()
      if standalone ~= nil then
        MainMenuScene.reset_selected_save_mod = {
          id = standalone:getId(),
          name = standalone:getName()
        }
        MainMenuScene.changeMenu(MainMenuScene.reset_selected_save_menu, 2)
      else
        MainMenuScene.loadResetSavesMenu()
        MainMenuScene.changeMenu(MainMenuScene.reset_save_menu)
      end
    end
  }
  table.insert(options, reset_save_option)

  MainMenuScene.settings_menu = MainMenu:new(options, "MAIN_MENU_SETTINGS_TITLE", function()
    Config.save()
    MainMenuScene.changeMenu(MainMenuScene.main_menu)
  end)
end

--- Loads reset save menu
function MainMenuScene.loadResetSavesMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  local mods_savepoints = MainMenuScene.getModsSavepoints()
  if #mods_savepoints >= 1 then
    for _, mod_info in ipairs(mods_savepoints) do
      table.insert(options, {
        text = Text:new(mod_info.name),
        action = function()
          MainMenuScene.loadResetSelectedSaveMenu()
          MainMenuScene.reset_selected_save_mod = mod_info
          MainMenuScene.changeMenu(MainMenuScene.reset_selected_save_menu, 2)
        end
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_SETTINGS_RESET_SAVE_EMPTY")
    })
  end

  if MainMenuScene.reset_save_menu ~= nil then
    MainMenuScene.reset_save_menu:setOptions(options)
  else
    MainMenuScene.reset_save_menu = MainMenu:new(options, "MAIN_MENU_SETTINGS_RESET_SAVE_TITLE", function()
      MainMenuScene.changeMenu(MainMenuScene.settings_menu)
    end)
  end
end

--- Loads reset selected save menu
function MainMenuScene.loadResetSelectedSaveMenu()
  --- @type Dummy.Menu.Options
  local options = {
    {
      id = "RESET_SELECTED_SAVE_YES",
      text = Text:new("MAIN_MENU_SETTINGS_RESET_SELECTED_SAVE_YES"),
      action = function()
        if MainMenuScene.reset_selected_save_mod == nil then return end

        local config = Config.loadConfig("configs/" .. MainMenuScene.reset_selected_save_mod.id)
        config.savepoint = nil
        Config.save()
        Scene.fullReload()
      end
    },
    {
      id = "RESET_SELECTED_SAVE_NO",
      text = Text:new("MAIN_MENU_SETTINGS_RESET_SELECTED_SAVE_NO"),
      action = function()
        if ModList.getStandalone() ~= nil then
          MainMenuScene.changeMenu(MainMenuScene.settings_menu)
        else
          MainMenuScene.changeMenu(MainMenuScene.reset_save_menu)
        end
      end
    },
  }

  if MainMenuScene.reset_selected_save_menu ~= nil then
    MainMenuScene.reset_selected_save_menu:setOptions(options)
  else
    MainMenuScene.reset_selected_save_menu = MainMenu:new(options, "", function()
      if ModList.getStandalone() ~= nil then
        MainMenuScene.changeMenu(MainMenuScene.settings_menu)
      else
        MainMenuScene.changeMenu(MainMenuScene.reset_save_menu)
      end
    end)
    MainMenuScene.reset_selected_save_menu:setControlInputs(Input.Left, Input.Right)
  end

  options[1].text:setPosition(220, 320)
  options[2].text:setPosition(420, 320)
end

--- Loads mod list menu
function MainMenuScene.loadModListMenu()
  ModList.load()

  --- @type Dummy.Menu.Options
  local options = {}

  if #ModList.getMods() > 0 then
    for _, mod in ipairs(ModList.getMods()) do
      table.insert(options, {
        text = Text:new(mod:getName()),
        action = function()
          Scene.change("WORLD", mod)
        end,
        disabled = mod["error"] ~= nil
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_MODLIST_EMPTY")
    })
  end

  if MainMenuScene.mod_list_menu ~= nil then
    MainMenuScene.mod_list_menu:setOptions(options)
  else
    MainMenuScene.mod_list_menu = MainMenu:new(options, "MAIN_MENU_MODLIST_TITLE", function()
      MainMenuScene.changeMenu(MainMenuScene.main_menu)
    end)
  end
end

--- Gets the mods savepoints
--- @return { id: string, name: string }[]
function MainMenuScene.getModsSavepoints()
  ModList.load()

  --- @type { id: string, name: string }[]
  local savepoints = {}
  for _, mod in ipairs(ModList.getMods()) do
    if mod["error"] == nil then
      local config = Config.loadConfig("configs/" .. mod:getId()) --[[@as Dummy.Mod.Config]]
      if config ~= nil and config.savepoint ~= nil then
        table.insert(savepoints, {
          id = mod:getId(),
          name = mod:getName()
        })
      end
    end
  end

  return savepoints
end

--- Changes menu
--- @param new_menu Dummy.MainMenu
--- @param index? integer
function MainMenuScene.changeMenu(new_menu, index)
  if MainMenuScene.current_menu ~= nil then
    MainMenuScene.current_menu:hide()
  end
  MainMenuScene.current_menu = new_menu
  MainMenuScene.current_menu:show()

  if index ~= nil then
    MainMenuScene.current_menu:select(index, true)
  end
end

--- Sets the logo sprite
--- @param sprite_name string
function MainMenuScene.setLogo(sprite_name)
  MainMenuScene.logo_sprite:setSprite(sprite_name)
end

--- Sets the background sprite
--- @param sprite_name string
function MainMenuScene.setBackground(sprite_name)
  MainMenuScene.background_sprite:setSprite(sprite_name)
end

--- Sets the menu music
--- @param music_name string
function MainMenuScene.setMenuMusic(music_name)
  MainMenuScene.menu_music = Assets.playMusic(music_name)
  MainMenuScene.menu_music:setVolume(0.5)
end

--- Updates the main menu, called on every game update
--- @param dt number
function MainMenuScene.update(dt)
  if MainMenuScene.current_menu ~= nil then
    MainMenuScene.current_menu:update()
  end

  if MainMenuScene.current_menu == MainMenuScene.settings_menu then
    local option = MainMenuScene.settings_menu:getSelectedOption()
    if option ~= nil and option.text:getText()[1] == "MAIN_MENU_SETTINGS_VOLUME" then
      local settings = Config.getSettings()
      local volume = settings["volume"]
      local old_volume = volume
      if Input.isDown(Input.Right) or Input.isDown(Input.Left) then
        MainMenuScene.input_hold_time = MainMenuScene.input_hold_time + dt
      else
        MainMenuScene.input_hold_time = 0
      end
      if Input.isPressed(Input.Right) or (Input.isDown(Input.Right) and MainMenuScene.input_hold_time >= MainMenuScene.input_hold_delay) then
        volume = math.min(volume + 5, 100)
        MainMenuScene.input_hold_time = 0
      elseif Input.isPressed(Input.Left) or (Input.isDown(Input.Left) and MainMenuScene.input_hold_time >= MainMenuScene.input_hold_delay) then
        volume = math.max(volume - 5, 0)
        MainMenuScene.input_hold_time = 0
      end
      if old_volume ~= volume then
        love.audio.setVolume(volume / 100)
        settings["volume"] = volume
        option.text:setText({ "MAIN_MENU_SETTINGS_VOLUME", volume })
        Assets.playSound("menu_select")
      end
    end

    if MainMenuScene.was_fullscreen ~= love.window.getFullscreen() then
      MainMenuScene.was_fullscreen = love.window.getFullscreen()
      local opt = MainMenuScene.settings_menu:getOptionById("FULLSCREEN_SETTING")
      if opt ~= nil then
        opt.text:setText({ "MAIN_MENU_SETTINGS_FULLSCREEN", MainMenuScene.was_fullscreen and
        "MAIN_MENU_SETTINGS_SWITCH_ON" or "MAIN_MENU_SETTINGS_SWITCH_OFF" })
      end
    end
  end

  local show_reset_selected_save_text = MainMenuScene.current_menu == MainMenuScene.reset_selected_save_menu
  if not MainMenuScene.reset_selected_save_text:isVisible() and show_reset_selected_save_text then
    local text = { "MAIN_MENU_SETTINGS_RESET_SELECTED_SAVE_TITLE", MainMenuScene.reset_selected_save_mod.name }
    MainMenuScene.reset_selected_save_text:setText(text, true)
  end
  MainMenuScene.reset_selected_save_text:setVisible(show_reset_selected_save_text)
end

return MainMenuScene
