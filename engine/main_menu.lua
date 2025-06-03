--- @alias Dummy.Menu.Options table<number, Dummy.Menu.Option>

--- @class Dummy.Menu.Option
---
--- @field text Dummy.Text text to display
--- @field action fun(self: Dummy.Menu.Option)|nil callback when the option is confirmed
--- @field draw fun(self: Dummy.Menu.Option)|nil draw along the option
--- @field drawable Dummy.Drawable|nil option drawable created from `option.draw`
--- @field disabled boolean|nil wether the option is disabled
--- @field selected boolean|nil wether the option is selected
--- @field menu Dummy.MainMenu|nil sub menu

--- @class Dummy.MainMenu : Dummy.Class
---
--- @field protected options Dummy.Menu.Options
--- @field protected onBack fun()|nil
local MainMenu = Class()

local MAX_DISPLAYED_OPTIONS = 4

--- Select a menu option
--- @param index number options index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function MainMenu:select(index, silent)
  if index == self.selected_index then return end

  -- previously selected menu item
  local menu_item = self.options[self.selected_index]
  if menu_item ~= nil then
    menu_item.text:setColor(1, 1, 1)
  end

  self.selected_index = index

  -- newly selected menu item
  menu_item = self.options[index]
  if menu_item ~= nil and (menu_item.action ~= nil or menu_item.menu ~= nil) then
    menu_item.text:setColor(1, 1, 0)
  end

  for i, option in ipairs(self.options) do
    local visible = math.floor((self.selected_index - 1) / MAX_DISPLAYED_OPTIONS) ==
        math.floor((i - 1) / MAX_DISPLAYED_OPTIONS)
    option.text:setVisible(visible)
  end

  local page = math.floor((self.selected_index - 1) / MAX_DISPLAYED_OPTIONS) + 1
  self.arrow_up:setVisible(page > 1)
  self.arrow_down:setVisible(page < math.ceil(#self.options / MAX_DISPLAYED_OPTIONS))
  self.page_text:setText({ "MAIN_MENU_PAGE", page })

  if not silent then
    Audio.playSound("menu_move")
  end
end

--- Shows the menu
function MainMenu:show()
  for i, option in ipairs(self.options) do
    option.text:setVisible((i - 1) < MAX_DISPLAYED_OPTIONS)
    option.text:setText(option.text:getText())
  end

  local has_pagination = #self.options > MAX_DISPLAYED_OPTIONS
  self.arrow_down:setVisible(has_pagination)
  self.page_text:setVisible(has_pagination)
end

--- Hides the menu
function MainMenu:hide()
  for _, option in ipairs(self.options) do
    option.text:setVisible(false)
  end

  self.arrow_up:setVisible(false)
  self.arrow_down:setVisible(false)
  self.page_text:setVisible(false)
end

function MainMenu:setOptions(options)
  for _, option in ipairs(self.options) do
    Scene.removeDrawable(option.text)
  end

  Scene.removeDrawable(self.arrow_up)
  Scene.removeDrawable(self.arrow_down)
  Scene.removeDrawable(self.page_text)

  self.options = options
  self:init()
end

--- Initializes the menu options
function MainMenu:init()
  for i, menu_item in ipairs(self.options) do
    if menu_item.text ~= nil then
      local is_selected = i == self.selected_index and (menu_item.action ~= nil or menu_item.menu ~= nil)
      menu_item.text:setColor(1, 1, is_selected and 0 or 1)
      menu_item.text:setPosition(320, 260 + ((i - 1) % MAX_DISPLAYED_OPTIONS * 40))
      menu_item.text:setVisible(false)
    end
  end

  -- pagination
  local has_pagination = #self.options > MAX_DISPLAYED_OPTIONS
  self.arrow_up = Text:new("<")
  self.arrow_up:setPosition(320, 220)
  self.arrow_up:setVisible(false)
  self.arrow_up:setAngle(90)
  self.arrow_down = Text:new(">")
  self.arrow_down:setPosition(320, 260 + MAX_DISPLAYED_OPTIONS * 40)
  self.arrow_down:setAngle(90)
  self.arrow_down:setVisible(has_pagination)
  self.page_text = Text:new({ "MAIN_MENU_PAGE", 1 })
  self.page_text:setPosition(520, 420)
  self.page_text:setVisible(has_pagination)
end

--- Updates the menu
function MainMenu:update()
  if Input.isPressed(Input.Up) then
    if self.selected_index <= 1 then
      self:select(#self.options)
    else
      self:select(self.selected_index - 1)
    end
  elseif Input.isPressed(Input.Down) then
    if self.selected_index >= #self.options then
      self:select(1)
    else
      self:select(self.selected_index + 1)
    end
  elseif Input.isPressed(Input.Confirm) then
    local selected_menu = self.options[self.selected_index]
    if type(selected_menu.action) == "function" then
      Audio.playSound("menu_select")
      selected_menu.action(selected_menu)
    end
  elseif Input.isPressed(Input.Cancel) then
    if type(self.onBack) == "function" then
      self.onBack()
    end
  end
end

--- Creates a menu
---@param options Dummy.Menu.Options
---@param onBack? fun()
function MainMenu:new(options, onBack)
  local main_menu = Class:new(MainMenu, {
    options = Utils.getOrDefault(options, {}),
    selected_index = 1,
    onBack = onBack,
  })

  main_menu:init()

  return main_menu
end

return MainMenu
