--- @class Dummy.Scene.MainMenu
---
--- @field private menu Dummy.MainMenu
--- @field private options Dummy.Menu.Options
--- @field private current_menu Dummy.MainMenu
--- @field private logo_sprite Dummy.Sprite
--- @field private credits_text Dummy.Text
--- @field private background_sprite Dummy.Sprite
--- @field private menu_music love.Source
local main_menu = {}

local mod_list = require "mod.mod_list"

function main_menu.load()
  mod_list.load()

  main_menu.logo_sprite = Sprite:new("logo")
  main_menu.logo_sprite:setPosition(320, 120)
  main_menu.logo_sprite:setScale(6)

  main_menu.credits_text = Text:new(Constants.CREDITS.NAME ..
    " v" .. Constants.CREDITS.VERSION .. " " .. Constants.CREDITS.AUTHOR .. " " .. Constants.CREDITS.YEAR)
  main_menu.credits_text:setFont(Font.FONTS.SMALL)
  main_menu.credits_text:setAlpha(0.707)
  main_menu.credits_text:setPosition(320, 476)
  main_menu.credits_text:setOrigin(0.5, 1)
  main_menu.credits_text:setScale(2)
  main_menu.background_sprite = Sprite:new("background")
  main_menu.background_sprite:setOrigin(0, 0)
  main_menu.background_sprite:setLayer(Constants.LAYERS.BOTTOM)

  main_menu.loadMenus()
  main_menu.changeMenu(main_menu.main_menu)

  main_menu.menu_music = Audio.playMusic("main_menu")
  main_menu.menu_music:setVolume(0.5)

  if mod_list.standalone and type(mod_list.standalone.preview) == "function" then
    mod_list.standalone.preview()
  end
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

  if not mod_list.standalone then
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        main_menu.loadModListMenu()
        main_menu.changeMenu(main_menu.mod_list_menu)
      end
    })

    table.insert(options, {
      text = Text:new("MAIN_MENU_OPEN_MOD_FOLDER"),
      action = function()
        love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/mods")
      end
    })

    love.window.setTitle(Constants.CREDITS.NAME)
    love.window.setIcon(love.image.newImageData("assets/icon.png"))
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        mod_list.standalone.load()
        Scene.change("ENCOUNTER", mod_list.standalone)
      end
    })

    if mod_list.standalone.title ~= nil then
      love.window.setTitle(mod_list.standalone.title)
    end
    love.window.setIcon(love.image.newImageData("assets/icon.png"))
  end

  table.insert(options, {
    text = Text:new("MAIN_MENU_SETTINGS"),
    action = function()
      main_menu.changeMenu(main_menu.settings_menu)
    end
  })

  table.insert(options, {
    text = Text:new("MAIN_MENU_QUIT"),
    action = function()
      love.event.quit()
    end
  })

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
  }, function()
    main_menu.changeMenu(main_menu.main_menu)
  end)
end

--- Loads mod list menu
function main_menu.loadModListMenu()
  mod_list.load()

  --- @type Dummy.Menu.Options
  local options = {}

  if #mod_list.mods > 0 then
    for _, mod in ipairs(mod_list.mods) do
      table.insert(options, {
        text = Text:new(mod.name),
        action = function()
          if mod.error then return end

          mod_list.loadMod(mod)
          Scene.change("ENCOUNTER", mod)
        end,
      })
    end
  else
    table.insert(options, {
      text = Text:new("MAIN_MENU_MODLIST_EMPTY")
    })
  end

  for i = 1, 5 do
    table.insert(options, {
      text = Text:new("MOD_" .. i),
      action = function() end
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

function main_menu.update()
  if main_menu.current_menu ~= nil then
    main_menu.current_menu:update()
  end
end

return main_menu
