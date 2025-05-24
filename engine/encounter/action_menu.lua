local self = {}

--- Creates an action menu
--- @param options table<number, Dummy.Menu.Option>
--- @param direction? "horizontal"|"vertical"
--- @param pagination? boolean
--- @param onBack? fun(i: number)
--- @return Dummy.Encounter.ActionMenu
function self.new(options, direction, pagination, onBack)
  --- @class Dummy.Encounter.ActionMenu
  ---
  --- @field private options table<number, Dummy.Menu.Option>
  --- @field private indexes_x table<number, table<number, number>>
  --- @field private indexes_y table<number, table<number, number>>
  --- @field private index_x number
  --- @field private index_y number
  --- @field private direction "horizontal"|"vertical"
  --- @field private pagination boolean
  --- @field private onBack fun(i: number)|nil
  --- @field private page_text Dummy.Text
  local menu = {}

  menu.options = options or {}
  menu.indexes_x = {}
  menu.indexes_y = {}
  menu.index_x = 0
  menu.index_y = 0
  menu.direction = Utils.getOrDefault(direction, "horizontal")
  menu.pagination = Utils.getOrDefault(pagination, false)
  menu.onBack = onBack

  --- Selects an option
  --- @param index_x number horizontal index
  --- @param index_y number vertical index
  --- @param silent? boolean wether to play a sound (Defaults to `false`)
  function menu.select(index_x, index_y, silent)
    if not silent and (menu.pagination or index_x ~= menu.index_x or index_y ~= menu.index_y) then
      Audio.playSound("menu_move")
    end

    local option = menu.getOption(index_x, index_y)
    if option == nil then return end

    menu.index_x = index_x
    menu.index_y = index_y

    if menu.pagination then
      local max_by_page = menu.getMaxX() * menu.getMaxY()
      local page = math.ceil(menu.getSelectedOptionIndex() / max_by_page)
      menu.page_text:setText({ "ENCOUNTER_MENU_ITEM_PAGE", page })

      for i, opt in ipairs(menu.options) do
        local visible = not opt.disabled
        if visible then
          visible = (i - 1) >= (page - 1) * max_by_page and i <= page * max_by_page
        end
        opt.text:setVisible(visible)
      end
    end

    local x, y = option.text:getPosition()
    Player.setPosition(x - 26, y - 1, true)
  end

  --- Moves cursor option
  --- @param delta_x number
  --- @param delta_y number
  function menu.move(delta_x, delta_y)
    local index_x = (menu.index_x + delta_x + #menu.indexes_x[menu.index_y + 1]) % #menu.indexes_x[menu.index_y + 1]
    local index_y = (menu.index_y + delta_y + #menu.indexes_y[menu.index_x + 1]) % #menu.indexes_y[menu.index_x + 1]
    menu.select(index_x, index_y)
    -- menu.select(menu.index_x + delta_x, menu.index_y + delta_y)
  end

  --- Selects an option by index
  --- @param index number options index
  --- @param silent? boolean wether to play a sound (Defaults to `false`)
  function menu.selectByIndex(index, silent)
    local index_x, index_y = menu.getIndexesByOptionIndex(index)
    menu.select(index_x, index_y, silent)
  end

  function menu.fillIndexes()
    menu.indexes_x = {}
    menu.indexes_y = {}

    local i = 1
    for option_index, option in ipairs(menu.options) do
      option.disabled = Utils.getOrDefault(option.disabled, false)

      if not option.disabled then
        local max_by_page = menu.getMaxX() * menu.getMaxY()
        if menu.pagination or (not menu.pagination and i <= max_by_page) then
          local index_x = (math.floor((i - 1) / menu.getMaxX()) % menu.getMaxY()) + 1
          local index_y = ((i - 1) % menu.getMaxX()) + 1 + math.floor((i - 1) / max_by_page) * menu.getMaxY()

          -- fill horizontal indexes
          local idx_x = index_x
          if menu.pagination and menu.direction == "vertical" then idx_x = index_y end
          if menu.indexes_x[idx_x] == nil then menu.indexes_x[idx_x] = {} end
          table.insert(menu.indexes_x[idx_x], option_index)
          -- fill vertical indexes
          local idx_y = index_y
          if menu.pagination and menu.direction == "vertical" then idx_y = index_x end
          if menu.indexes_y[idx_y] == nil then menu.indexes_y[idx_y] = {} end
          table.insert(menu.indexes_y[idx_y], option_index)
        end

        i = i + 1
      end
    end
  end

  --- Shows the menu
  function menu.show()
    menu.fillIndexes()

    for i, option in ipairs(menu.options) do
      -- show corresponding options
      local visible = not option.disabled
      if menu.pagination and i > menu.getMaxX() * menu.getMaxY() then
        visible = false
      end
      option.text:setVisible(visible)

      if visible and type(option.draw) == "function" then
        option.drawable = Drawable.new()
        option.drawable:setLayer(Constants.LAYERS.UI)
        option.drawable.draw = function()
          if option.text:isVisible() then
            option.draw(option.text)
          end
        end
        Scene.addDrawable(option.drawable)
      end
    end

    if menu.page_text ~= nil then
      menu.page_text:setVisible(menu.pagination)
    end

    menu.select(menu.index_x, menu.index_y, true)
  end

  --- Hides the menu
  function menu.hide()
    for _, option in ipairs(menu.options) do
      option.text:setVisible(false)
      Scene.removeDrawable(option.drawable)
    end

    if menu.page_text ~= nil then
      menu.page_text:setVisible(false)
    end
  end

  --- Gets the number of options
  --- @return number
  function menu.getSize()
    return #menu.options
  end

  --- Wether all the options are disabled
  --- @return boolean
  function menu.allDisabled()
    for _, option in ipairs(menu.options) do
      if not option.disabled then
        return false
      end
    end
    return true
  end

  --- Gets an option
  --- @param index_x number
  --- @param index_y number
  --- @return Dummy.Menu.Option
  function menu.getOption(index_x, index_y)
    return menu.options[menu.getOptionIndex(index_x, index_y)]
  end

  --- Gets the selected option
  --- @return Dummy.Menu.Option
  function menu.getSelectedOption()
    return menu.getOption(menu.index_x, menu.index_y)
  end

  --- Gets the option index
  --- @param index_x number
  --- @param index_y number
  --- @return number
  function menu.getOptionIndex(index_x, index_y)
    return (menu.indexes_x[index_y + 1] or {})[index_x + 1]
  end

  --- Gets the selected option index
  --- @return number
  function menu.getSelectedOptionIndex()
    return menu.getOptionIndex(menu.index_x, menu.index_y)
  end

  --- Gets the grid indexes by option index
  --- @param index number
  function menu.getIndexesByOptionIndex(index)
    local index_x = 0
    for _, indexes in ipairs(menu.indexes_x) do
      for x, option_index in ipairs(indexes) do
        if option_index == index then
          index_x = x - 1
          break
        end
      end
    end

    local index_y = 0
    for _, indexes in ipairs(menu.indexes_y) do
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
  function menu.getOptionByIndex(index)
    local index_x, index_y = menu.getIndexesByOptionIndex(index)
    return menu.getOption(index_x, index_y)
  end

  --- Gets the max x option index
  --- @return number
  --- @private
  function menu.getMaxX()
    if menu.direction == "vertical" then
      return math.min(math.ceil(#menu.options / (menu.pagination and 2 or 3)), 2)
    end

    return math.min(#menu.options, 2)
  end

  --- Gets the max y option index
  --- @return number
  --- @private
  function menu.getMaxY()
    if menu.direction == "vertical" then
      return math.min(#menu.options, menu.pagination and 2 or 3)
    end

    return math.min(math.ceil(#menu.options / 2), menu.pagination and 2 or 3)
  end

  --- Updates the menu
  function menu.update()
    if Input.isPressed(Input.Up) then
      menu.move(0, -1)
    elseif Input.isPressed(Input.Down) then
      menu.move(0, 1)
    elseif Input.isPressed(Input.Left) then
      menu.move(-1, 0)
    elseif Input.isPressed(Input.Right) then
      menu.move(1, 0)
    elseif Input.isPressed(Input.Confirm) then
      local option = menu.getSelectedOption()
      if type(option.action) == "function" then
        option.action(option.text)
      end
    elseif Input.isPressed(Input.Cancel) then
      if type(menu.onBack) == "function" then
        menu.onBack(menu.getSelectedOptionIndex())
      end
    end
  end

  -- init options
  for i, option in ipairs(menu.options) do
    local max_x = menu.getMaxX()
    local max_y = menu.getMaxY()
    local x = 98 + 256 * ((i - 1) % max_x)
    local y = 287 + 32 * ((math.ceil(i / max_x) - 1) % max_y)

    if menu.direction == "vertical" then
      x = 98 + 256 * ((math.ceil(i / max_y) - 1) % max_x)
      y = 287 + 32 * ((i - 1) % max_y)
    end

    option.text:setPosition(x, y)
    option.text:setOrigin(0, 0.5)
    option.text:setFont(Font.FONTS.MAIN_TEXT)
    option.text:setScale(2)
    option.text:setVisible(false)
    option.text:setLayer(Constants.LAYERS.UI)
  end

  if menu.pagination then
    menu.page_text = Text.new({ "ENCOUNTER_MENU_ITEM_PAGE", 1 })
    menu.page_text:setPosition(388, 351)
    menu.page_text:setOrigin(0, 0.5)
    menu.page_text:setFont(Font.FONTS.MAIN_TEXT)
    menu.page_text:setScale(2)
    menu.page_text:setVisible(false)
    menu.page_text:setLayer(Constants.LAYERS.UI)
  end

  menu.fillIndexes()

  return menu
end

return self
