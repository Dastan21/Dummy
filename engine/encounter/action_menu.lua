local self = {}

---@class Dummy.Menu.Option

--- Creates an action menu
---@param options table<number, Dummy.Menu.Option>
---@param direction? "horizontal"|"vertical"
---@param pagination? boolean
---@param onBack? fun()
---@return Dummy.Encounter.ActionMenu
function self.new(options, direction, pagination, onBack)
  ---@class Dummy.Encounter.ActionMenu
  ---
  ---@field private options table<number, Dummy.Menu.Option>
  ---@field private indexes_x table<number, table<number, number>>
  ---@field private index_x number
  ---@field private index_y number
  ---@field private direction "horizontal"|"vertical"
  ---@field private pagination boolean
  ---@field private onBack fun()|nil
  ---@field private page_text Dummy.Text
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
  ---@param index_x number horizontal index
  ---@param index_y number vertical index
  ---@param silent? boolean wether to play a sound (Defaults to `false`)
  function menu.select(index_x, index_y, silent)
    if not silent and (menu.pagination or index_x ~= menu.index_x or index_y ~= menu.index_y) then
      Audio.playSound("menu_move")
    end

    local option = menu.getOption(index_x, index_y)
    if option == nil then return end

    menu.index_x = index_x
    menu.index_y = index_y

    if menu.page_text ~= nil then
      local max_by_page = menu.getMaxX() * menu.getMaxY()
      local page = math.ceil(menu.getOptionIndex(menu.index_x, menu.index_y) / max_by_page)
      menu.page_text:setText({ "ENCOUNTER_MENU_ITEM_PAGE", page })

      for i, opt in ipairs(menu.options) do
        local active = (i - 1) >= (page - 1) * max_by_page and i <= page * max_by_page
        opt.text:setActive(active)
      end
    end

    local x, y = option.text:getPosition()
    Player.setPosition(x - 26, y - 1, true)
  end

  --- Moves cursor option
  ---@param delta_x number
  ---@param delta_y number
  function menu.move(delta_x, delta_y)
    local index_x = (menu.index_x + delta_x + #menu.indexes_x[menu.index_y + 1]) % #menu.indexes_x[menu.index_y + 1]
    local index_y = (menu.index_y + delta_y + #menu.indexes_y[menu.index_x + 1]) % #menu.indexes_y[menu.index_x + 1]
    menu.select(index_x, index_y)
  end

  --- Hides the menu
  function menu.hide()
    for _, option in ipairs(menu.options) do
      option.text:setActive(false)
    end

    if menu.page_text ~= nil then
      menu.page_text:setActive(false)
    end
  end

  --- Shows the menu
  function menu.show()
    menu.indexes_x = {}
    menu.indexes_y = {}

    for i, option in ipairs(menu.options) do
      local max_by_page = menu.getMaxX() * menu.getMaxY()
      if menu.pagination or (not menu.pagination and i <= max_by_page) then
        local index_x = (math.floor((i - 1) / menu.getMaxX()) % menu.getMaxY()) + 1
        local index_y = ((i - 1) % menu.getMaxX()) + 1 + math.floor((i - 1) / max_by_page) * menu.getMaxY()

        -- fill horizontal indexes
        local idx_x = index_x
        if menu.pagination and menu.direction == "vertical" then idx_x = index_y end
        if menu.indexes_x[idx_x] == nil then menu.indexes_x[idx_x] = {} end
        table.insert(menu.indexes_x[idx_x], i)
        -- fill vertical indexes
        local idx_y = index_y
        if menu.pagination and menu.direction == "vertical" then idx_y = index_x end
        if menu.indexes_y[idx_y] == nil then menu.indexes_y[idx_y] = {} end
        table.insert(menu.indexes_y[idx_y], i)
      end

      -- show corresponding options
      local active = option.disabled and false or true
      if menu.pagination and i > max_by_page then
        active = false
      end
      option.text:setActive(active)

      if active and type(option.draw) == "function" then
        Scene.addDrawable(function()
          option.draw(option.text)
        end, Constants.LAYERS.ABOVE_ARENA)
      end
    end

    if menu.page_text ~= nil then
      menu.page_text:setActive(menu.pagination)
    end

    menu.select(0, 0, true)
  end

  --- Gets the number of options
  ---@return number
  function menu.getSize()
    return #menu.options
  end

  --- Gets an option
  ---@param index_x number
  ---@param index_y number
  ---@return Dummy.Menu.Option
  function menu.getOption(index_x, index_y)
    return menu.options[menu.getOptionIndex(index_x, index_y)]
  end

  --- Gets the selected option
  ---@return Dummy.Menu.Option
  function menu.getSelectedOption()
    return menu.getOption(menu.index_x, menu.index_y)
  end

  --- Gets the computed index
  ---@param index_x number
  ---@param index_y number
  ---@return number
  function menu.getOptionIndex(index_x, index_y)
    return menu.indexes_x[index_y + 1][index_x + 1]
  end

  --- Gets the max x option index
  ---@return number
  ---@private
  function menu.getMaxX()
    if menu.direction == "vertical" then
      return math.min(math.ceil(#menu.options / (menu.pagination and 2 or 3)), 2)
    end

    return math.min(#menu.options, 2)
  end

  --- Gets the max y option index
  ---@return number
  ---@private
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
        menu.hide()
        menu.onBack()
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
    option.text:setFont(Font.FONT.MAIN_TEXT)
    option.text:setScale(2)
    option.text:setActive(false)
    option.text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  end

  if menu.pagination then
    menu.page_text = Text.new({ "ENCOUNTER_MENU_ITEM_PAGE", 1 })
    menu.page_text:setPosition(388, 351)
    menu.page_text:setOrigin(0, 0.5)
    menu.page_text:setFont(Font.FONT.MAIN_TEXT)
    menu.page_text:setScale(2)
    menu.page_text:setActive(false)
    menu.page_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  end

  return menu
end

return self
