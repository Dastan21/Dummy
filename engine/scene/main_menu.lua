local mod_list = require "engine.mod.mod_list"

--- @alias Dummy.Menu table<number, Dummy.Menu.Option>

--- @class Dummy.Menu.Option
---
--- @field text Dummy.Text text to display
--- @field action fun(self: Dummy.Text)|nil callback when the option is confirmed
--- @field draw fun(self: Dummy.Text)|nil draw along the option
--- @field drawable Dummy.Drawable|nil option drawable created from `option.draw`
--- @field disabled boolean|nil wether the option is disabled
--- @field selected boolean|nil wether the option is selected
--- @field menu Dummy.Menu|nil option children menu
--- @field parent Dummy.Menu.Option|nil option parent menu

--- @class Dummy.MainMenu
---
--- @field private options Dummy.Menu
--- @field private current_menu Dummy.Menu
--- @field private logo_sprite Dummy.Sprite
local self = {}

function self.load()
  mod_list.load()

  self.logo_sprite = Sprite:new("logo")
  self.logo_sprite:setPosition(320, 120)
  self.logo_sprite:setScale(6)

  self.credits_text = Text:new(Constants.CREDITS.NAME ..
    " v" .. Constants.CREDITS.VERSION .. " " .. Constants.CREDITS.AUTHOR .. " " .. Constants.CREDITS.YEAR)
  self.credits_text:setFont(Font.FONTS.SMALL)
  self.credits_text:setAlpha(0.707)
  self.credits_text:setPosition(320, 476)
  self.credits_text:setOrigin(0.5, 1)
  self.credits_text:setScale(2)
  self.background_sprite = Sprite:new("background")
  self.background_sprite:setOrigin(0, 0)
  self.background_sprite:setLayer(Constants.LAYERS.BOTTOM)

  --- @type Dummy.Menu
  self.options = {}

  if not mod_list.standalone then
    table.insert(self.options, {
      text = Text:new("MAIN_MENU_PLAY"),
      action = function()
        self.prepareModListMenu()
      end
    })

    table.insert(self.options, {
      text = Text:new("MAIN_MENU_OPEN_MOD_FOLDER"),
      action = function()
        love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/mods")
      end
    })

    love.window.setTitle(Constants.CREDITS.NAME)
    love.window.setIcon(love.image.newImageData("assets/icon.png"))
  else
    table.insert(self.options, {
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

  table.insert(self.options, {
    text = Text:new("MAIN_MENU_SETTINGS"),
    menu = {
      {
        text = Text:new(function() return { "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() } end),
        action = function() self.switchLanguage() end,
      },
      {
        text = Text:new({ "MAIN_MENU_SETTINGS_FPS", Config["fps"] }),
        action = function(txt)
          if Config["fps"] == 30 then
            Config["fps"] = 60
          elseif Config["fps"] == 60 then
            Config["fps"] = 120
          elseif Config["fps"] == 120 then
            Config["fps"] = 144
          elseif Config["fps"] == 144 then
            Config["fps"] = 240
          elseif Config["fps"] == 240 then
            Config["fps"] = 30
          end
          txt:setText({ "MAIN_MENU_SETTINGS_FPS", Config["fps"] })
        end,
      },
      {
        text = Text:new("MAIN_MENU_BACK"),
        action = function()
          self.changeMenu(self.options)
        end,
      }
    }
  })

  table.insert(self.options, {
    text = Text:new("MAIN_MENU_QUIT"),
    action = function()
      love.event.quit()
    end
  })

  self.current_menu = self.options
  self.selected_index = 1

  self.prepareMenu(self.options)

  self.menu_music = Audio.playMusic("main_menu")
  self.menu_music:setVolume(0.5)

  if mod_list.standalone and type(mod_list.standalone.preview) == "function" then
    mod_list.standalone.preview()
  end
end

--- Prepare mod list menu options
--- @return Dummy.Menu
function self.prepareModListMenu()
  local play_menu_item = self.options[1]
  play_menu_item.menu = {}

  for i, mod in ipairs(mod_list.mods) do
    local mod_text = Text:new(mod.name)
    mod_text:setPosition(320, 260 + ((i - 1) * 40))
    table.insert(play_menu_item.menu, {
      text = mod_text,
      action = function()
        if mod.error then return end

        mod_list.loadMod(mod)
        Scene.change("ENCOUNTER", mod)
      end,
    })
  end

  -- no mod
  if #mod_list.mods <= 0 then
    local empty_text = Text:new("MAIN_MENU_MODLIST_EMPTY")
    empty_text:setPosition(320, 260)
    table.insert(play_menu_item.menu, {
      text = empty_text
    })
  end

  self.prepareMenu(play_menu_item.menu, self.options, false)

  return play_menu_item.menu
end

--- Prepare menu options
--- @param menu Dummy.Menu
--- @param parent? Dummy.Menu
--- @param visible? boolean
function self.prepareMenu(menu, parent, visible)
  visible = Utils.getOrDefault(visible, true)

  for i, menu_item in ipairs(menu) do
    menu_item.parent = parent

    if menu_item.menu ~= nil then
      self.prepareMenu(menu_item.menu, menu, false)
    end

    if menu_item.text ~= nil then
      local is_selected = i == self.selected_index and (menu_item.action ~= nil or menu_item.menu ~= nil)
      menu_item.text:setColor(1, 1, is_selected and 0 or 1)
      menu_item.text:setPosition(320, 260 + ((i - 1) * 40))
      menu_item.text:setVisible(visible)
    end
  end
end

--- Select a menu option
--- @param index number
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function self.select(index, silent)
  if index == self.selected_index then return end

  -- Previously selected menu item
  local menu_item = self.current_menu[self.selected_index]
  if menu_item ~= nil then
    menu_item.text:setColor(1, 1, 1)
  end

  self.selected_index = index

  -- Newly selected menu item
  menu_item = self.current_menu[index]
  if menu_item ~= nil and (menu_item.action ~= nil or menu_item.menu ~= nil) then
    menu_item.text:setColor(1, 1, 0)
  end

  if not silent then
    Audio.playSound("menu_move")
  end
end

--- Change menu
--- @param new_menu Dummy.Menu
function self.changeMenu(new_menu)
  self.select(1, true)
  for _, menu_item in ipairs(self.current_menu) do menu_item.text:setVisible(false) end
  self.current_menu = new_menu
  for _, menu_item in ipairs(self.current_menu) do menu_item.text:setVisible(true) end
end

--- Update menu texts
--- @param menu Dummy.Menu
function self.updateMenuTexts(menu)
  for _, data in pairs(menu) do
    if data.menu ~= nil then
      self.updateMenuTexts(data.menu)
    end

    if data.text ~= nil then
      data.text:setText(data.text:getText())
    end
  end
end

--- Switch current language
function self.switchLanguage()
  Lang.switchLanguage()
  self.updateMenuTexts(self.options)
end

--- Confirm menu option
function self.confirm()
  local selected_menu = self.current_menu[self.selected_index]
  if type(selected_menu.action) == "function" then
    selected_menu.action(selected_menu.text)
  end
  if type(selected_menu.menu) == "table" then
    self.changeMenu(selected_menu.menu)
  end

  Audio.playSound("menu_select")
end

--- Confirm menu
function self.cancel()
  if self.current_menu[1].parent ~= nil then
    self.changeMenu(self.current_menu[1].parent)
  end
end

function self.update()
  if Input.isPressed(Input.Up) then
    if self.selected_index <= 1 then
      self.select(#self.current_menu)
    else
      self.select(self.selected_index - 1)
    end
  elseif Input.isPressed(Input.Down) then
    if self.selected_index >= #self.current_menu then
      self.select(1)
    else
      self.select(self.selected_index + 1)
    end
  elseif Input.isPressed(Input.Confirm) then
    self.confirm()
  elseif Input.isPressed(Input.Cancel) then
    self.cancel()
  end
end

return self
