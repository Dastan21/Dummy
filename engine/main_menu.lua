--- @alias Dummy.Menu.Options Dummy.Menu.Option[]

--- @class Dummy.MainMenu.Inputs
---
--- @field next string|string[]
--- @field previous string|string[]
--- @field confirm string|string[]
--- @field cancel string|string[]

--- @class Dummy.Menu.Option
---
--- @field id string|nil unique identifier
--- @field text Dummy.Text text to display
--- @field action fun(self: Dummy.Menu.Option)|nil callback when the option is confirmed
--- @field draw fun(self: Dummy.Menu.Option)|nil draw along the option
--- @field drawable Dummy.Drawable|nil option drawable created from `option.draw`
--- @field disabled boolean|nil wether the option is disabled
--- @field silent boolean|nil wether the option is silent
--- @field selected boolean|nil wether the option is selected
--- @field menu Dummy.MainMenu|nil sub menu

--- @class Dummy.MainMenu : Dummy.Class
---
--- @field protected options Dummy.Menu.Options
--- @field protected onBack fun()|nil
--- @field protected max_displayed_options number
--- @field protected title_text Dummy.Text
--- @field protected control_inputs Dummy.MainMenu.Inputs
local MainMenu = Class("Dummy.MainMenu")

--- Select a menu option
--- @param index number options index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function MainMenu:select(index, silent)
  -- previously selected menu item
  local menu_item = self:getSelectedOption()
  if menu_item ~= nil then
    local color = menu_item.disabled == true and 0.5 or 1
    menu_item.text:setColor(color, color, color)
  end

  self.selected_index = index

  -- newly selected menu item
  menu_item = self.options[index]
  if menu_item ~= nil and (menu_item.action ~= nil or menu_item.menu ~= nil) then
    local color = menu_item.disabled == true and 0.5 or 1
    menu_item.text:setColor(color, color, 0)
  end

  local max_options = self:getMaxDisplayedOptions()
  for i, option in ipairs(self.options) do
    local visible = math.floor((self.selected_index - 1) / max_options) == math.floor((i - 1) / max_options)
    option.text:setVisible(visible)
  end

  local page = math.floor((self.selected_index - 1) / max_options) + 1
  self.arrow_up:setVisible(page > 1)
  self.arrow_down:setVisible(page < math.ceil(#self.options / max_options))

  if not silent then
    Assets.playSound("menu_move")
  end
end

--- Shows the menu
function MainMenu:show()
  local max_options = self:getMaxDisplayedOptions()
  for i, option in ipairs(self.options) do
    option.text:setVisible((i - 1) < max_options)
    option.text:setText(option.text:getText(), true)
  end

  self.title_text:setVisible(true)

  self:select(self.selected_index, true)
end

--- Hides the menu
function MainMenu:hide()
  for _, option in ipairs(self.options) do
    option.text:setVisible(false)
  end

  self.title_text:setVisible(false)

  self.arrow_up:setVisible(false)
  self.arrow_down:setVisible(false)
end

--- Gets the menu title
--- @return Dummy.Text.Text
function MainMenu:getTitle()
  return self.title_text:getText()
end

--- Sets the menu title
--- @param title Dummy.Text.Text
function MainMenu:setTitle(title)
  self.title_text:setText(title)
end

--- Sets the menu options
--- @param options Dummy.Menu.Option[]
function MainMenu:setOptions(options)
  for _, option in ipairs(self.options) do
    option.text:remove()
  end

  self.arrow_up:remove()
  self.arrow_down:remove()

  self.options = options
  self:init()
end

--- Gets the menu options
--- @return Dummy.Menu.Option[]
function MainMenu:getOptions()
  return table.copy(self.options)
end

--- Gets the selected option
--- @return Dummy.Menu.Option
function MainMenu:getSelectedOption()
  return self.options[self.selected_index]
end

--- Gets a meny option by id
--- @param id string
--- @return Dummy.Menu.Option|nil
function MainMenu:getOptionById(id)
  for _, opt in ipairs(self.options) do
    if opt.id ~= nil and opt.id == id then
      return opt
    end
  end
end

--- Gets the maximum number of displayed options
--- @return number
function MainMenu:getMaxDisplayedOptions()
  return self.max_displayed_options
end

--- Sets the maximum number of displayed options
--- @param max number
function MainMenu:setMaxDisplayedOptions(max)
  self.max_displayed_options = max

  self:init()
end

--- Gets the control inputs
--- @return Dummy.MainMenu.Inputs
function MainMenu:getControlInputs()
  return self.control_inputs
end

--- Sets the control inputs
--- @param next? string|string[]
--- @param previous? string|string[]
--- @param confirm? string|string[]
--- @param cancel? string|string[]
function MainMenu:setControlInputs(next, previous, confirm, cancel)
  if next ~= nil then
    self.control_inputs.next = next
  end
  if previous ~= nil then
    self.control_inputs.previous = previous
  end
  if confirm ~= nil then
    self.control_inputs.confirm = confirm
  end
  if cancel ~= nil then
    self.control_inputs.cancel = cancel
  end
end

--- Initializes the menu options
function MainMenu:init()
  local max_options = self:getMaxDisplayedOptions()
  for i, menu_item in ipairs(self.options) do
    if menu_item.text ~= nil then
      local is_selected = i == self.selected_index and (menu_item.action ~= nil or menu_item.menu ~= nil)
      local color = menu_item.disabled == true and 0.5 or 1
      menu_item.text:setColor(color, color, is_selected and 0 or color)
      menu_item.text:setPosition(320, 230 + ((i - 1) % max_options * 40))
      menu_item.text:setVisible(false)
    end
  end

  -- pagination
  self.arrow_up = Text:new("<")
  self.arrow_up:setPosition(320, 200)
  self.arrow_up:setVisible(false)
  self.arrow_up:setAngle(90)
  self.arrow_down = Text:new(">")
  self.arrow_down:setPosition(320, 230 + max_options * 40)
  self.arrow_down:setAngle(90)
  self.arrow_down:setVisible(false)
end

--- Updates the menu, called on every game update
function MainMenu:update()
  local inputs = self:getControlInputs()
  if #self.options > 1 then
    if Input.isPressed(inputs.previous) then
      if self.selected_index <= 1 then
        self:select(#self.options)
      else
        self:select(self.selected_index - 1)
      end
    elseif Input.isPressed(inputs.next) then
      if self.selected_index >= #self.options then
        self:select(1)
      else
        self:select(self.selected_index + 1)
      end
    end
  end
  if Input.isPressed(inputs.confirm) then
    local selected_menu_item = self:getSelectedOption()
    if type(selected_menu_item.action) == "function" then
      if selected_menu_item.disabled == true then
        Assets.playSound("hurt")
      else
        if selected_menu_item.silent ~= true then
          Assets.playSound("menu_select")
        end
        selected_menu_item.action(selected_menu_item)
      end
    end
  elseif Input.isPressed(inputs.cancel) then
    if type(self.onBack) == "function" then
      self.onBack()
    end
  end
end

--- Creates a menu
--- @param options Dummy.Menu.Options
--- @param title Dummy.Text.Text
--- @param onBack? fun()
function MainMenu:new(options, title, onBack)
  self = Class:new(MainMenu)

  self.options = Utils.getOrDefault(options, {})
  self.onBack = onBack
  self.max_displayed_options = 5
  self.selected_index = 1

  self.title_text = Text:new(title)
  self.title_text:setPosition(320, 160)
  self.title_text:setWrapLimit(600)
  self.title_text:setAlign("center")
  self.title_text:setScale(1.25)
  self.title_text:setVisible(false)

  self.control_inputs = {
    next = Input.Down,
    previous = Input.Up,
    confirm = Input.Confirm,
    cancel = Input.Cancel
  }

  self:init()

  return self
end

return MainMenu
