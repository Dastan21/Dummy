--- @class Dummy.Scene.MainMenu : Dummy.Scene.Scene
---
--- @field protected options Dummy.Menu.Options
--- @field protected current_menu Dummy.MainMenu
--- @field protected mod_list_menu Dummy.MainMenu
--- @field protected logo_sprite Dummy.Sprite
--- @field protected credits_text Dummy.Text
--- @field protected background_sprite Dummy.Sprite
--- @field protected menu_music love.Source
--- @field protected was_fullscreen boolean
--- @field protected input_hold_time number
--- @field protected input_hold_delay number
local main_menu = {}

--- Loads the main menu
function main_menu.load()
  Config.save()
  ModList.load()

  local standalone = ModList.getStandalone()
  if standalone ~= nil then
    Lang.loadLanguages()
    ---@diagnostic disable-next-line: invisible
    standalone.config = Config.loadConfig("configs/" .. standalone:getId())
  end

  main_menu.logo_sprite = Sprite:new("logo")
  main_menu.logo_sprite:setPosition(320, 120)
  main_menu.logo_sprite:setScale(6)

  main_menu.credits_text = Text:new(Constants.CREDITS.NAME ..
    " v" .. Constants.CREDITS.VERSION .. " " .. Constants.CREDITS.AUTHOR .. " " .. Constants.CREDITS.YEAR)
  main_menu.credits_text:setFont("small")
  main_menu.credits_text:setAlpha(0.707)
  main_menu.credits_text:setPosition(320, 476)
  main_menu.credits_text:setOrigin(0.5, 1)
  main_menu.credits_text:setScale(2)

  main_menu.background_sprite = Sprite:new("background")
  main_menu.background_sprite:setOrigin(0, 0)
  main_menu.background_sprite:setLayer(Constants.LAYERS.BOTTOM)

  main_menu.loadMenus()
  main_menu.changeMenu(main_menu.main_menu)

  main_menu.menu_music = Assets.playMusic("main_menu")
  main_menu.menu_music:setVolume(0.5)

  main_menu.was_fullscreen = love.window.getFullscreen()

  main_menu.input_hold_time = 0
  main_menu.input_hold_delay = 0.1

  if standalone ~= nil then
    if type(standalone.preview) == "function" then
      standalone:preview()
    end
  end

  ModList.setWindowTitleAndIcon()
end

--- Loads menus
function main_menu.loadMenus()
  main_menu.loadMainMenu()
  main_menu.loadSettingsMenu()
end

--- Loads main menu
function main_menu.loadMainMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  local standalone = ModList.getStandalone()
  if not standalone then
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        main_menu.loadModListMenu()
        main_menu.changeMenu(main_menu.mod_list_menu, 1)
      end
    })

    if love.system.getOS() ~= "Web" then
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
        Scene.change("ENCOUNTER", standalone)
      end
    })
  end

  table.insert(options, {
    text = Text:new("MAIN_MENU_SETTINGS"),
    action = function()
      main_menu.changeMenu(main_menu.settings_menu)
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

  main_menu.main_menu = MainMenu:new(options)
end

--- Loads settings menu
function main_menu.loadSettingsMenu()
  --- @type Dummy.Menu.Options
  local options = {
    {
      id = "LANGUAGE_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() }),
      action = function(option)
        Lang.switchLanguage()
        ModList.setWindowTitleAndIcon()

        main_menu.current_menu:show()
        option.text:setText({ "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() })
      end,
    },
    {
      id = "FPS_SETTING",
      text = Text:new({ "MAIN_MENU_SETTINGS_FPS", Config.getSettings()["fps"] }),
      action = function(option)
        local settings = Config.getSettings()
        local fps = { 30, 60, 120, 144, 240 }
        local fps_index = 1
        for i, v in ipairs(fps) do
          if v == settings.fps then
            fps_index = i
            break
          end
        end
        settings.fps = fps[(fps_index % #fps) + 1]
        option.text:setText({ "MAIN_MENU_SETTINGS_FPS", settings.fps })
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
    table.insert(options, {
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

        local opt = main_menu.settings_menu:getOptionById("FULLSCREEN_SETTING")
        if opt ~= nil then
          opt.text:setText({ "MAIN_MENU_SETTINGS_FULLSCREEN", "MAIN_MENU_SETTINGS_SWITCH_OFF" })
        end

        Config.getSettings()["fullscreen"] = false
        love.scale()
      end,
    })
  end

  main_menu.settings_menu = MainMenu:new(options, function()
    main_menu.changeMenu(main_menu.main_menu)
  end)
end

--- Loads mod list menu
function main_menu.loadModListMenu()
  ModList.load()

  --- @type Dummy.Menu.Options
  local options = {}

  if #ModList.getMods() > 0 then
    for _, mod in ipairs(ModList.getMods()) do
      table.insert(options, {
        text = Text:new(mod:getName()),
        action = function()
          Scene.change("ENCOUNTER", mod)
        end,
        disabled = mod["error"] ~= nil
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_MODLIST_EMPTY")
    })
  end

  if main_menu.mod_list_menu ~= nil then
    main_menu.mod_list_menu:setOptions(options)
  else
    main_menu.mod_list_menu = MainMenu:new(options, function()
      main_menu.changeMenu(main_menu.main_menu)
    end)
  end
end

--- Changes menu
--- @param new_menu Dummy.MainMenu
--- @param index? integer
function main_menu.changeMenu(new_menu, index)
  if main_menu.current_menu ~= nil then
    main_menu.current_menu:hide()
  end
  main_menu.current_menu = new_menu
  main_menu.current_menu:show()

  if index ~= nil then
    main_menu.current_menu:select(index, true)
  end
end

--- Sets the logo sprite
--- @param sprite_name string
function main_menu.setLogo(sprite_name)
  main_menu.logo_sprite:setSprite(sprite_name)
end

--- Sets the background sprite
--- @param sprite_name string
function main_menu.setBackground(sprite_name)
  main_menu.background_sprite:setSprite(sprite_name)
end

--- Sets the menu music
--- @param music_name string
function main_menu.setMenuMusic(music_name)
  main_menu.menu_music = Assets.playMusic(music_name)
  main_menu.menu_music:setVolume(0.5)
end

--- Updates the main menu
function main_menu.update(dt)
  if main_menu.current_menu ~= nil then
    main_menu.current_menu:update()
  end

  if main_menu.current_menu == main_menu.settings_menu then
    local option = main_menu.settings_menu:getSelectedOption()
    if option ~= nil and option.text:getText()[1] == "MAIN_MENU_SETTINGS_VOLUME" then
      local settings = Config.getSettings()
      local volume = settings["volume"]
      local old_volume = volume
      if Input.isDown(Input.Right) or Input.isDown(Input.Left) then
        main_menu.input_hold_time = main_menu.input_hold_time + dt
      else
        main_menu.input_hold_time = 0
      end
      if Input.isPressed(Input.Right) or (Input.isDown(Input.Right) and main_menu.input_hold_time >= main_menu.input_hold_delay) then
        volume = math.min(volume + 5, 100)
        main_menu.input_hold_time = 0
      elseif Input.isPressed(Input.Left) or (Input.isDown(Input.Left) and main_menu.input_hold_time >= main_menu.input_hold_delay) then
        volume = math.max(volume - 5, 0)
        main_menu.input_hold_time = 0
      end
      if old_volume ~= volume then
        love.audio.setVolume(volume / 100)
        settings["volume"] = volume
        option.text:setText({ "MAIN_MENU_SETTINGS_VOLUME", volume })
        Assets.playSound("menu_select")
      end
    end

    if main_menu.was_fullscreen ~= love.window.getFullscreen() then
      main_menu.was_fullscreen = love.window.getFullscreen()
      local opt = main_menu.settings_menu:getOptionById("FULLSCREEN_SETTING")
      if opt ~= nil then
        opt.text:setText({ "MAIN_MENU_SETTINGS_FULLSCREEN", main_menu.was_fullscreen and
        "MAIN_MENU_SETTINGS_SWITCH_ON" or "MAIN_MENU_SETTINGS_SWITCH_OFF" })
      end
    end
  end
end

return main_menu
