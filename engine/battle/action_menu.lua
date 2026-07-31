--- @class Dummy.Battle.ActionMenu : Dummy.Class
---
--- @field protected options Dummy.Menu.Option[]
--- @field protected indexes_x number[][]
--- @field protected indexes_y number[][]
--- @field protected index_x number
--- @field protected index_y number
--- @field protected direction "horizontal" | "vertical"
--- @field protected pagination boolean
--- @field protected onBack fun(i: number)|nil
--- @field protected page_text Dummy.Text
--- @field protected active boolean
local ActionMenu = Class("Dummy.ActionMenu")

--- Selects an option
--- @param index_x number horizontal index
--- @param index_y number vertical index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function ActionMenu:select(index_x, index_y, silent)
  if not silent and (self.pagination or index_x ~= self.index_x or index_y ~= self.index_y) then
    Assets.playSound("menu_move")
  end

  local option = self:getOption(index_x, index_y)
  if option == nil then return end

  self.index_x = index_x
  self.index_y = index_y

  if self.pagination then
    local max_by_page = self:getMaxX() * self:getMaxY()
    local page = math.ceil(self:getSelectedOptionIndex() / max_by_page)
    self.page_text:setText({ "BATTLE_MENU_ITEM_PAGE", page })

    for i, opt in ipairs(self.options) do
      local visible = not opt.disabled
      if visible then
        visible = (i - 1) >= (page - 1) * max_by_page and i <= page * max_by_page
      end
      opt.text:setVisible(visible)
    end
  end

  local x, y = option.text:getPosition()
  Soul.setPosition(x - 26, y - 1, true)
end

--- Moves cursor option
--- @param delta_x number
--- @param delta_y number
function ActionMenu:move(delta_x, delta_y)
  local index_x = (self.index_x + delta_x + #self.indexes_x[self.index_y + 1]) % #self.indexes_x[self.index_y + 1]
  local index_y = (self.index_y + delta_y + #self.indexes_y[self.index_x + 1]) % #self.indexes_y[self.index_x + 1]
  self:select(index_x, index_y)
end

--- Selects an option by index
--- @param index number options index
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function ActionMenu:selectByIndex(index, silent)
  local index_x, index_y = self:getIndexesByOptionIndex(index)
  self:select(index_x, index_y, silent)
end

function ActionMenu:fillIndexes()
  self.indexes_x = {}
  self.indexes_y = {}

  local i = 1
  for option_index, option in ipairs(self.options) do
    option.disabled = Utils.getOrDefault(option.disabled, false)

    if not option.disabled then
      local max_x = self:getMaxX()
      local max_y = self:getMaxY()
      local max_by_page = max_x * max_y
      if self.pagination or (not self.pagination and i <= max_by_page) then
        local index_x = (math.floor((i - 1) / max_x) % max_y) + 1
        local index_y = ((i - 1) % max_x) + 1 + math.floor((i - 1) / max_by_page) * max_y

        -- fill horizontal indexes
        local idx_x = index_x
        if self.indexes_x[idx_x] == nil then self.indexes_x[idx_x] = {} end
        table.insert(self.indexes_x[idx_x], option_index)
        -- fill vertical indexes
        local idx_y = index_y
        if self.pagination and self.direction == "vertical" then idx_y = index_y % (max_y + 1) + 1 end
        if self.indexes_y[idx_y] == nil then self.indexes_y[idx_y] = {} end
        table.insert(self.indexes_y[idx_y], option_index)
      end

      i = i + 1
    end
  end

  self.index_x = math.min(#self.indexes_x - 1, self.index_x)
  self.index_y = math.min(#self.indexes_y - 1, self.index_y)
end

--- Shows the menu
function ActionMenu:show()
  self:fillIndexes()

  local max_by_page = self:getMaxX() * self:getMaxY()
  for i, option in ipairs(self.options) do
    local page = math.ceil(self:getSelectedOptionIndex() / max_by_page)
    option.text:setVisible(not option.disabled and i <= page * max_by_page)

    if type(option.draw) == "function" then
      option.drawable = Drawable:new()
      option.drawable:setLayer(Constants.LAYERS.UI)
      function option.drawable.draw(_self)
        if not option.text:isVisible() or not _self:isVisible() then return end

        page = math.ceil(self:getSelectedOptionIndex() / max_by_page)
        if i > page * max_by_page then return end

        option.draw(option)
      end
    end
  end

  if self.page_text ~= nil then
    self.page_text:setVisible(self.pagination)
  end

  self:select(self.index_x, self.index_y, true)
end

--- Hides the menu
function ActionMenu:hide()
  for _, option in ipairs(self.options) do
    option.text:setVisible(false)
    if option.drawable ~= nil then
      option.drawable:remove()
    end
  end

  if self.page_text ~= nil then
    self.page_text:setVisible(false)
  end
end

--- Gets the number of options
--- @return number
function ActionMenu:getSize()
  return #self.options
end

--- Wether all the options are disabled
--- @return boolean
function ActionMenu:allDisabled()
  for _, option in ipairs(self.options) do
    if not option.disabled then
      return false
    end
  end
  return true
end

--- Gets the menu options
--- @return Dummy.Menu.Option[]
function ActionMenu:getOptions()
  return table.copy(self.options)
end

--- Sets the menu options
--- @param options Dummy.Menu.Option[]
function ActionMenu:setOptions(options)
  for _, option in ipairs(self.options) do
    option.text:remove()

    if option.drawable ~= nil then
      option.drawable:remove()
    end
  end

  self.options = options
  self:init()
end

--- Gets an option
--- @param index_x number
--- @param index_y number
--- @return Dummy.Menu.Option
function ActionMenu:getOption(index_x, index_y)
  return self.options[self:getOptionIndex(index_x, index_y)]
end

--- Gets the selected option
--- @return Dummy.Menu.Option
function ActionMenu:getSelectedOption()
  return self:getOption(self.index_x, self.index_y)
end

--- Gets the option index
--- @param index_x number
--- @param index_y number
--- @return number
function ActionMenu:getOptionIndex(index_x, index_y)
  return (self.indexes_x[index_y + 1] or {})[index_x + 1] or 0
end

--- Gets the selected option index
--- @return number
function ActionMenu:getSelectedOptionIndex()
  return self:getOptionIndex(self.index_x, self.index_y)
end

--- Gets the grid indexes by option index
--- @param index number
function ActionMenu:getIndexesByOptionIndex(index)
  local index_x = 0
  for _, indexes in ipairs(self.indexes_x) do
    for x, option_index in ipairs(indexes) do
      if option_index == index then
        index_x = x - 1
        break
      end
    end
  end

  local index_y = 0
  for _, indexes in ipairs(self.indexes_y) do
    for y, option_index in ipairs(indexes) do
      if option_index == index then
        index_y = y - 1
        break
      end
    end
  end

  return index_x, index_y
end

--- Gets an option by its index
--- @param index number
--- @return Dummy.Menu.Option
function ActionMenu:getOptionByIndex(index)
  return self:getOption(self:getIndexesByOptionIndex(index))
end

--- Gets the max x option index
--- @return number
--- @protected
function ActionMenu:getMaxX()
  if self.direction == "vertical" then
    return 1
  end

  return math.min(#self.options, 2)
end

--- Gets the max y option index
--- @return number
--- @protected
function ActionMenu:getMaxY()
  if self.direction == "vertical" then
    return math.min(#self.options, self.pagination and 2 or 3)
  end

  return math.min(math.ceil(#self.options / 2), self.pagination and 2 or 3)
end

--- Wether the menu is active
--- @return boolean
function ActionMenu:isActive()
  return self.active
end

--- Sets wether the menu is active
--- @param active boolean
function ActionMenu:setActive(active)
  self.active = active
end

--- Removes the menu
function ActionMenu:remove()
  for _, option in ipairs(self.options) do
    option.text:remove()

    if option.drawable ~= nil then
      option.drawable:remove()
    end
  end

  if self.page_text ~= nil then
    self.page_text:remove()
  end
end

--- Initializes the menu options
function ActionMenu:init()
  for i, option in ipairs(self.options) do
    local max_x = self:getMaxX()
    local max_y = self:getMaxY()
    local x = 100 + 256 * ((i - 1) % max_x)
    local y = 286 + 32 * ((math.ceil(i / max_x) - 1) % max_y)

    if self.direction == "vertical" then
      x = 100 + 256 * ((math.ceil(i / max_y) - 1) % max_x)
      y = 286 + 32 * ((i - 1) % max_y)
    end

    option.text:setPosition(x, y)
    option.text:setOrigin(0, 0.5)
    option.text:setFont("main_text")
    option.text:setCharacterWidth(8)
    option.text:setScale(2)
    option.text:setVisible(false)
    option.text:setLayer(Constants.LAYERS.UI)
  end

  if self.page_text ~= nil then
    self.page_text:remove()
  end

  if self.pagination then
    self.page_text = Text:new({ "BATTLE_MENU_ITEM_PAGE", 1 })
    self.page_text:setPosition(388, 351)
    self.page_text:setOrigin(0, 0.5)
    self.page_text:setFont("main_text")
    self.page_text:setScale(2)
    self.page_text:setVisible(false)
    self.page_text:setLayer(Constants.LAYERS.UI)
  end

  self:fillIndexes()
end

--- Updates the menu, called on every game update
function ActionMenu:update()
  if not self.active then return end

  if Input.isPressed(Input.Up) then
    self:move(0, -1)
  elseif Input.isPressed(Input.Down) then
    self:move(0, 1)
  elseif Input.isPressed(Input.Left) then
    self:move(-1, 0)
  elseif Input.isPressed(Input.Right) then
    self:move(1, 0)
  elseif Input.isPressed(Input.Confirm) then
    local option = self:getSelectedOption()
    if type(option.action) == "function" then
      if option.silent ~= true then
        Assets.playSound("menu_select")
      end
      option.action(option)
    end
  elseif Input.isPressed(Input.Cancel) then
    if type(self.onBack) == "function" then
      self.onBack(self:getSelectedOptionIndex())
    end
  end
end

--- Creates an action menu
--- @param options Dummy.Menu.Option[]
--- @param direction? "horizontal" | "vertical"
--- @param pagination? boolean
--- @param onBack? fun(i: number)
--- @return Dummy.Battle.ActionMenu
function ActionMenu:new(options, direction, pagination, onBack)
  self = Class:new(ActionMenu)
  self.options = Utils.getOrDefault(options, {})
  self.indexes_x = {}
  self.indexes_y = {}
  self.index_x = 0
  self.index_y = 0
  self.direction = Utils.getOrDefault(direction, "horizontal")
  self.pagination = Utils.getOrDefault(pagination, false)
  self.onBack = onBack
  self.active = true

  self:init()

  return self
end

return ActionMenu
