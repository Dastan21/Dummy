--- @class Dummy.PlayerItemMenu : Dummy.Drawable
---
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected closing boolean
--- @field protected item_index integer
--- @field protected item_action_index integer
--- @field protected item_selected_index integer|nil
--- @field protected item_name_texts Dummy.Text[]
local PlayerItemMenu = Class(Drawable, "Dummy.PlayerItemMenu")

--- Creates a player item menu
--- @return Dummy.PlayerItemMenu
function PlayerItemMenu:new()
  self = Class:new(PlayerItemMenu)

  self.width = 167
  self.height = 175
  self:setPosition(97, 29)
  self:setVisible(false)

  self.use_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_USE")
  self.use_action_text:setOrigin(0, 0.5)
  self.use_action_text:setPosition(19, 159)
  self.use_action_text:setFont("main_text")
  self.use_action_text:setParent(self)

  self.info_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_INFO")
  self.info_action_text:setOrigin(0, 0.5)
  self.info_action_text:setPosition(67, 159)
  self.info_action_text:setFont("main_text")
  self.info_action_text:setParent(self)

  self.drop_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_DROP")
  self.drop_action_text:setOrigin(0, 0.5)
  self.drop_action_text:setPosition(124, 159)
  self.drop_action_text:setFont("main_text")
  self.drop_action_text:setParent(self)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setParent(self)

  self.opening = false
  self.closing = false
  self.item_index = 0
  self.item_action_index = 0
  self.item_name_texts = {}

  return self
end

--- Opens the player item menu
function PlayerItemMenu:open()
  self.opening = true
  self.item_index = 0
  self.item_action_index = 0
  self.item_selected_index = nil

  self:clean()

  for i, item in pairs(Player.getItems()) do
    local item_name_text = Text:new(item:getName(), true)
    item_name_text:setOrigin(0, 0.5)
    item_name_text:setPosition(19, 19 + 16 * (i - 1))
    item_name_text:setFont("main_text")
    item_name_text:setParent(self)

    table.insert(self.item_name_texts, item_name_text)
  end

  self:setVisible(true)
  self:updateHeartPosition()
end

--- Closes the player item menu
function PlayerItemMenu:close()
  self.closing = true
end

--- Cleans the player item menu
function PlayerItemMenu:clean()
  for _, text in ipairs(self.item_name_texts) do
    text:remove()
  end
  self.item_name_texts = {}
end

--- Changes the selected item
--- @param delta integer
function PlayerItemMenu:changeItem(delta)
  local new_index = math.clamp(self.item_index + delta, 0, #Player.getItems() - 1)

  if self.item_index == new_index then return end
  self.item_index = new_index

  Assets.playSound("menu_move")
  self:updateHeartPosition()
end

--- Changes the selected action for the selected item
--- @param delta integer
function PlayerItemMenu:changeItemAction(delta)
  local new_index = math.clamp(self.item_action_index + delta, 0, 2)

  if new_index == self.item_action_index then return end
  self.item_action_index = new_index

  Assets.playSound("menu_move")
  self:updateHeartPosition()
end

--- Updates the player item menu's heart position
function PlayerItemMenu:updateHeartPosition()
  if self.item_selected_index == nil then
    local x, y = self.item_name_texts[self.item_index + 1]:getPosition()
    self.heart_sprite:setPosition(x - 7.5, y + 0.5)
    self.heart_sprite:setVisible(true)
  else
    local x, y = 0, 0
    if self.item_action_index == 0 then
      x, y = self.use_action_text:getPosition()
    elseif self.item_action_index == 1 then
      x, y = self.info_action_text:getPosition()
    elseif self.item_action_index == 2 then
      x, y = self.drop_action_text:getPosition()
    end
    self.heart_sprite:setPosition(x - 7.5, y + 0.5)
    self.heart_sprite:setVisible(true)
  end
end

--- Selects the item to which do actions
function PlayerItemMenu:selectItem()
  self.item_selected_index = self.item_index

  Assets.playSound("menu_select")
  self:updateHeartPosition()
end

--- Does an action on the selected item
function PlayerItemMenu:doActionOnSelectItem()
  if self.item_selected_index == nil then return end

  local item = Player.getItems()[self.item_selected_index + 1]
  if item == nil then return end

  if self.item_action_index == 0 then
    self:close()
    item:use()
  elseif self.item_action_index == 1 then
    self:close()
    World.playDialogue({ item:getDescription() })
  elseif self.item_action_index == 2 then
    self:close()
    item:drop()
  end
end

--- Draws the player item menu
--- @param camera Dummy.Camera
function PlayerItemMenu:draw(camera)
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

--- Updates the player item menu, called on every game update
--- @param dt number
function PlayerItemMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.closing then
    self.closing = false
    self:clean()
    self:setVisible(false)
    return
  end

  if self.opening then
    self.opening = false
    return
  end

  if self.item_selected_index == nil then
    if Input.isPressed(Input.Up) then
      self:changeItem(-1)
    elseif Input.isPressed(Input.Down) then
      self:changeItem(1)
    elseif Input.isPressed(Input.Confirm) then
      self:selectItem()
    elseif Input.isPressed(Input.Cancel) then
      self:close()
    end
  else
    if Input.isPressed(Input.Left) then
      self:changeItemAction(-1)
    elseif Input.isPressed(Input.Right) then
      self:changeItemAction(1)
    elseif Input.isPressed(Input.Confirm) then
      self:doActionOnSelectItem()
    elseif Input.isPressed(Input.Cancel) then
      self.item_selected_index = nil
      self:updateHeartPosition()
    end
  end
end

return PlayerItemMenu
