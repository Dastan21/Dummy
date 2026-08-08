--- @class Dummy.ChestboxMenu : Dummy.Drawable
---
--- @field protected inventory_text Dummy.Text
--- @field protected box_text Dummy.Text
--- @field protected hint_close_text Dummy.Text
--- @field protected heart_sprite Dummy.Sprite
--- @field protected twin_bars_drawable Dummy.Drawable
--- @field protected player_items_texts Dummy.Text[]
--- @field protected box_items_texts Dummy.Text[]
--- @field protected list Dummy.Item[]
--- @field protected on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @field protected on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
--- @field protected opening boolean
--- @field protected cursor_i integer
--- @field protected cursor_j integer
local ChestboxMenu = Class(Drawable, "Dummy.ChestboxMenu")

ChestboxMenu.MENU_X = 11
ChestboxMenu.MENU_Y = 11

ChestboxMenu.STORAGE_MAX = 10

-- TODO: fix overflow items

--- Creates a chestbox menu
--- @return Dummy.ChestboxMenu
function ChestboxMenu:new()
  self = Class:new(ChestboxMenu)

  self.width = 299
  self.height = 219
  self:setLayer(Constants.LAYERS.WORLD_MENU)
  self:setVisible(false)

  self.inventory_text = Text:new("WORLD_CHESTBOX_MENU_INVENTORY")
  self.inventory_text:setOrigin(0, 0.5)
  self.inventory_text:setPosition(41, 12)
  self.inventory_text:setFont("main_text")
  self.inventory_text:setParent(self)

  self.box_text = Text:new("WORLD_CHESTBOX_MENU_BOX")
  self.box_text:setOrigin(0, 0.5)
  self.box_text:setPosition(213, 12)
  self.box_text:setFont("main_text")
  self.box_text:setParent(self)

  self.hint_close_text = Text:new("WORLD_CHESTBOX_MENU_HINT_CLOSE")
  self.hint_close_text:setOrigin(0, 0.5)
  self.hint_close_text:setPosition(89, 200)
  self.hint_close_text:setFont("main_text")
  self.hint_close_text:setParent(self)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setPosition(18.5, 65.5)
  self.heart_sprite:setParent(self)

  self.twin_bars_drawable = Drawable:new()
  self.twin_bars_drawable:setTag("UI")
  self.twin_bars_drawable:setVisible(false)

  function self.twin_bars_drawable.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)
    love.graphics.line(322, 94, 322, 394)
    love.graphics.line(324, 94, 324, 394)

    love.graphics.setColor(1, 0, 0)
    if #Player.getItems() < Player.getMaxItems() then
      for i = Player.getMaxItems(), #Player.getItems() + 1, -1 do
        local y = 94 + 32 * (i - 1)
        love.graphics.line(80, y, 260, y)
      end
    end
    if #self.list < ChestboxMenu.STORAGE_MAX then
      for i = ChestboxMenu.STORAGE_MAX, #self.list + 1, -1 do
        local y = 94 + 32 * (i - 1)
        love.graphics.line(382, y, 562, y)
      end
    end
  end

  self.player_items_texts = {}
  for i = 1, Player.getMaxItems() do
    local text = Text:new()
    text:setOrigin(0, 0.5)
    local y = 33 + 16 * (i - 1)
    text:setPosition(23, y)
    text:setFont("main_text")
    text:setParent(self)
    text:setVisible(false)

    table.insert(self.player_items_texts, text)
  end

  self.box_items_texts = {}
  for i = 1, ChestboxMenu.STORAGE_MAX do
    local text = Text:new()
    text:setOrigin(0, 0.5)
    local y = 33 + 16 * (i - 1)
    text:setPosition(174, y)
    text:setFont("main_text")
    text:setParent(self)
    text:setVisible(false)

    table.insert(self.box_items_texts, text)
  end

  self.list = {}
  self.opening = false
  self.cursor_i = 0
  self.cursor_j = 0

  return self
end

--- Updates the chestbox menu's position
function ChestboxMenu:updatePosition()
  local camera = Scene.getCameraByTag("GAME")
  if camera == nil then return end

  local width, height = camera:getDimensions()
  local viewport_x, viewport_y = camera:getViewportPosition()
  viewport_x = viewport_x - width / 2
  viewport_y = viewport_y - height / 2
  self:setPosition(viewport_x + ChestboxMenu.MENU_X, viewport_y + ChestboxMenu.MENU_Y)
end

--- Updates the chestbox menu's texts
function ChestboxMenu:updateTexts()
  local player_items = Player.getItems()
  for i = 1, Player.getMaxItems() do
    local item = player_items[i]
    if item ~= nil then
      self.player_items_texts[i]:setText(item:getName())
      self.player_items_texts[i]:setVisible(true)
    else
      self.player_items_texts[i]:setVisible(false)
    end
  end

  local box_items = self.list
  for i = 1, ChestboxMenu.STORAGE_MAX do
    local item = box_items[i]
    if item ~= nil then
      self.box_items_texts[i]:setText(item:getName())
      self.box_items_texts[i]:setVisible(true)
    else
      self.box_items_texts[i]:setVisible(false)
    end
  end
end

--- Changes the selected action
--- @param delta_x integer
--- @param delta_y integer
function ChestboxMenu:changeCursor(delta_x, delta_y)
  self.cursor_j = math.clamp(self.cursor_j + delta_y, 0, 1)
  local max_i = Player.getMaxItems() - 1
  if self.cursor_j == 1 then max_i = ChestboxMenu.STORAGE_MAX - 1 end
  self.cursor_i = math.clamp(self.cursor_i + delta_x, 0, max_i)

  self:updateHeartPosition()
end

--- Swaps the item in the chestbox
function ChestboxMenu:swapItem()
  if self.cursor_j == 0 then
    if #self.list >= ChestboxMenu.STORAGE_MAX then return end

    self:onAdd(Player.getItems()[self.cursor_i + 1])
    Player.removeItem(self.cursor_i + 1)
  elseif self.cursor_j == 1 then
    if #Player.getItems() >= Player.getMaxItems() then return end

    Player.addItem(self.list[self.cursor_i + 1])
    self:onRemove(self.cursor_i + 1)
  end

  self:updateTexts()
end

--- Called when an item is added to the chestbox
--- @param item Dummy.Item
function ChestboxMenu:onAdd(item)
  if type(self.on_add) == "function" then
    self:on_add(item)
  else
    World.addItemIntoChestbox(item)
  end
end

--- Called when an item is added to the chestbox
--- @param index integer
function ChestboxMenu:onRemove(index)
  if type(self.on_remove) == "function" then
    self:on_remove(index)
  else
    World.removeItemFromChestbox(index)
  end
end

--- Updates the heart position to the current action
function ChestboxMenu:updateHeartPosition()
  local x = 13.5 + 151 * self.cursor_j
  local y = 34.5 + 16 * self.cursor_i
  self.heart_sprite:setPosition(x, y)
end

--- Opens the chestbox menu
--- @param list Dummy.Item[]
--- @param on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @param on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
function ChestboxMenu:open(list, on_add, on_remove)
  self.opening = true
  self.cursor_i = 0
  self.cursor_j = 0

  self.list = list
  self.on_add = on_add
  self.on_remove = on_remove

  self:setVisible(true)
  self:updatePosition()
  self:updateTexts()
  self:updateHeartPosition()
  self.heart_sprite:setVisible(true)
  self.twin_bars_drawable:setVisible(true)

  local obj_player = Player.getObject()
  obj_player:setInteraction("menu")
end

--- Closes the chestbox menu
function ChestboxMenu:close()
  self:setVisible(false)
  self.twin_bars_drawable:setVisible(false)

  local obj_player = Player.getObject()
  obj_player:setInteraction("none")
end

--- Draws the chestbox menu
--- @param camera Dummy.Camera
function ChestboxMenu:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getWidth(), self:getHeight()

  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", -3, -3, width + 6, height + 6)
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, width, height)

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Updates the chestbox menu, called on every game update
--- @param dt number
function ChestboxMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.opening then
    self.opening = false
    return
  end

  if Input.isPressed(Input.Left) then
    self:changeCursor(0, -1)
  elseif Input.isPressed(Input.Right) then
    self:changeCursor(0, 1)
  elseif Input.isPressed(Input.Up) then
    self:changeCursor(-1, 0)
  elseif Input.isPressed(Input.Down) then
    self:changeCursor(1, 0)
  elseif Input.isPressed(Input.Confirm) then
    self:swapItem()
  elseif Input.isPressed(Input.Cancel) then
    self:close()
  end
end

return ChestboxMenu
