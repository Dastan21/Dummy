local constants = require "engine.constants"
local mod_list = require "mod.mod_list"

local self = {}

function self.prepareModListMenu()
  mod_list.load()

  local play_menu_item = self.options[1]
  play_menu_item.menu = {}
  local index = 0
  for mod_dir, mod in pairs(mod_list.mods) do
    local mod_title = mod and mod.name or { "MAIN_MENU_MODLIST_MOD_ERROR", mod_dir }
    local mod_text = Text.createText(mod_title)
    mod_text.x = 320
    mod_text.y = 240 + (index * 40)
    table.insert(play_menu_item.menu, {
      text = mod_text,
      action = function(_)
        if mod then
          mod.load()
          Scene.load("battle")
        end
      end,
    })

    index = index + 1
  end

  -- no mod
  if index == 0 then
    local empty_text = Text.createText("MAIN_MENU_MODLIST_EMPTY")
    empty_text.x = 320
    empty_text.y = 240
    table.insert(play_menu_item.menu, {
      text = empty_text
    })
  end

  self.prepareMenu(play_menu_item.menu, self.options, false)

  return play_menu_item.menu
end

function self.prepareMenu(menu, parent, active)
  active = active == nil and true or active
  menu.parent_menu = parent

  for i, menu_item in ipairs(menu) do
    if menu_item.menu ~= nil then
      self.prepareMenu(menu_item.menu, menu, false)
    end

    if menu_item.text ~= nil then
      local is_selected = i == self.selected_index and (menu_item.action ~= nil or menu_item.menu ~= nil)
      menu_item.text.color = is_selected and { 1, 1, 0 } or { 1, 1, 1 }
      menu_item.text.x = 320
      menu_item.text.y = 240 + (i - 1) * 40
      menu_item.text.active = active
    end
  end
end

function self.load()
  self.logo = Sprite.createSprite("logo")
  self.logo.x = 320
  self.logo.y = 80
  self.logo.scale = 6

  self.credits = Text.createText(constants.credits)
  self.credits.font = Font.fonts.small
  self.credits.color = { 0.5, 0.5, 0.5 }
  self.credits.x = 320
  self.credits.y = 476
  self.credits.origin = { 0.5, 1 }
  self.credits.scale = 2

  self.options = {
    {
      text = Text.createText("MAIN_MENU_PLAY"),
      action = function(_)
        self.prepareModListMenu()
      end
    },
    {
      text = Text.createText("MAIN_MENU_OPEN_MOD_FOLDER"),
      action = function(_)
        love.system.openURL("file://" .. love.filesystem.getSaveDirectory() .. "/mods")
      end
    },
    {
      text = Text.createText("MAIN_MENU_SETTINGS"),
      menu = {
        {
          text = Text.createText(function() return { "MAIN_MENU_SETTINGS_LANGUAGE", Lang.getLanguageName() } end),
          action = function(_) self.switchLanguage() end,
        },
        {
          text = Text.createText({ "MAIN_MENU_SETTINGS_FPS", Config["fps"] }),
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
            txt.text = { "MAIN_MENU_SETTINGS_FPS", Config["fps"] }
          end,
        }
      }
    },
  }

  self.current_menu = self.options
  self.selected_index = 1

  self.prepareMenu(self.options)

  Audio.playMusic("main_menu")
end

function self.unload()
  Audio.stop()
end

function self.select(index)
  if index == self.selected_index then return end

  -- Previously selected menu item
  local menu_item = self.current_menu[self.selected_index]
  if menu_item ~= nil then
    menu_item.text.color = { 1, 1, 1 }
  end

  self.selected_index = index

  -- Newly selected menu item
  menu_item = self.current_menu[index]
  if menu_item ~= nil and (menu_item.action ~= nil or menu_item.menu ~= nil) then
    menu_item.text.color = { 1, 1, 0 }
  end
end

function self.changeMenu(new_menu)
  self.select(1)
  for _, menu_item in ipairs(self.current_menu) do menu_item.text.active = false end
  self.current_menu = new_menu
  for _, menu_item in ipairs(self.current_menu) do menu_item.text.active = true end
end

function self.updateMenuTexts(menu)
  for _, data in pairs(menu) do
    if data.menu ~= nil then
      self.updateMenuTexts(data.menu)
    end

    if data.text ~= nil then
      data.text.text = data.text.text
    end
  end
end

function self.switchLanguage()
  Lang.switchLanguage()
  self.updateMenuTexts(self.options)
end

function self.confirm()
  local selected_menu = self.current_menu[self.selected_index]
  if type(selected_menu.action) == "function" then
    selected_menu.action(selected_menu.text)
  end
  if type(selected_menu.menu) == "table" then
    self.changeMenu(selected_menu.menu)
  end
end

function self.cancel()
  if self.current_menu.parent_menu ~= nil then
    self.changeMenu(self.current_menu.parent_menu)
  end
end

function self.update()
  if Input.Up.isPressed() then
    self.select(math.max(1, self.selected_index - 1))
  elseif Input.Down.isPressed() then
    self.select(math.min(#self.current_menu, self.selected_index + 1))
  elseif Input.Confirm.isPressed() then
    self.confirm()
  elseif Input.Cancel.isPressed() then
    self.cancel()
  elseif Input.isKeyPressed("escape") then
    love.event.quit()
  end
end

return self
