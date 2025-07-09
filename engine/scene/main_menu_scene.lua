--- @class Dummy.Scene.MainMenu : Dummy.Scene.Scene
---
--- @field protected options Dummy.Menu.Options
--- @field protected current_menu Dummy.MainMenu
--- @field protected logo_sprite Dummy.Sprite
--- @field protected credits_text Dummy.Text
--- @field protected background_sprite Dummy.Sprite
--- @field protected menu_music love.Source
local main_menu = {}

--- Loads the main menu
function main_menu.load()
  Fader.reset()
  ModList.load()

  local standalone = ModList.getStandalone()
  if standalone ~= nil then
    ModList.mountMod(standalone)
    if type(standalone.preview) == "function" then
      standalone:preview()
    end
  end

  main_menu.logo_sprite = Sprite:new("logo")
  main_menu.logo_sprite:setPosition(320, 120)
  main_menu.logo_sprite:setScale(6)

  main_menu.credits_text = Text:new(Constants.CREDITS.NAME ..
    " v" .. Constants.CREDITS.VERSION .. " " .. Constants.CREDITS.AUTHOR .. " " .. Constants.CREDITS.YEAR)
  main_menu.credits_text:setFont(Assets.getFont("small"))
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
        main_menu.changeMenu(ModList_menu)
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

    ModList.setWindowTitleAndIcon(Constants.CREDITS.NAME)
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        Scene.change("ENCOUNTER", standalone)
      end
    })

    ModList.setWindowTitleAndIcon(standalone:getTitle())
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
  main_menu.settings_menu = MainMenu:new({
    {
      text = Text:new(function() return { "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() } end),
      action = function()
        main_menu.switchLanguage()
      end,
    },
    {
      text = Text:new({ "MAIN_MENU_SETTINGS_FPS", Config["fps"] }),
      action = function(option)
        local fps = { 30, 60, 120, 144, 240 }
        local fps_index = 1
        for i, v in ipairs(fps) do
          if v == Config["fps"] then
            fps_index = i
            break
          end
        end
        Config["fps"] = fps[(fps_index % #fps) + 1]
        option.text:setText({ "MAIN_MENU_SETTINGS_FPS", Config["fps"] })
      end,
    },
    {
      text = Text:new({ "MAIN_MENU_SETTINGS_WINDOW_SCALE", Config["window_scale"] }),
      action = function(option)
        local scales = { 0.5, 1, 2, 3, 4 }
        local scale_index = 2
        for i, v in ipairs(scales) do
          if v == Config["window_scale"] then
            scale_index = i
            break
          end
        end
        Config["window_scale"] = scales[(scale_index % #scales) + 1]
        option.text:setText({ "MAIN_MENU_SETTINGS_WINDOW_SCALE", Config["window_scale"] })

        love.scale()
      end,
    }
  }, function()
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

  if ModList_menu ~= nil then
    ModList_menu:setOptions(options)
  else
    ModList_menu = MainMenu:new(options, function()
      main_menu.changeMenu(main_menu.main_menu)
    end)
  end
end

--- Changes menu
--- @param new_menu Dummy.MainMenu
function main_menu.changeMenu(new_menu)
  if main_menu.current_menu ~= nil then
    main_menu.current_menu:hide()
  end
  main_menu.current_menu = new_menu
  main_menu.current_menu:show()
end

--- Switches current language
function main_menu.switchLanguage()
  Lang.switchLanguage()
  main_menu.current_menu:show()
end

--- Updates the main menu
function main_menu.update()
  if main_menu.current_menu ~= nil then
    main_menu.current_menu:update()
  end
end

return main_menu
