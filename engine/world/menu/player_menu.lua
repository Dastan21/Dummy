local PlayerItemMenu = require "world.menu.player_item_menu"
local PlayerStatMenu = require "world.menu.player_stat_menu"
local PlayerCellMenu = require "world.menu.player_cell_menu"

--- @class Dummy.PlayerMenu : Dummy.Drawable
---
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_label_text Dummy.Text
--- @field protected player_lv_value_text Dummy.Text
--- @field protected player_hp_label_text Dummy.Text
--- @field protected player_hp_value_text Dummy.Text
--- @field protected player_gold_label_text Dummy.Text
--- @field protected player_gold_value_text Dummy.Text
--- @field protected opening boolean
--- @field protected saved boolean
--- @field protected action_index integer
--- @field protected total_actions integer
local PlayerMenu = Class(Drawable, "Dummy.PlayerMenu")

--- Creates a player menu
--- @return Dummy.PlayerMenu
function PlayerMenu:new()
  self = Class:new(PlayerMenu)

  self:setLayer(Constants.LAYERS.WORLD_MENU)
  self:setVisible(false)

  -- player recap
  self.player_recap_container = Drawable:new()
  self.player_recap_container.width = 65
  self.player_recap_container.height = 49
  self.player_recap_container:setPosition(19, 29)
  self.player_recap_container:setParent(self)

  function self.player_recap_container.draw(_self, camera)
    if not _self:isVisible() then return end

    love.graphics.applyTransform(_self:getTransform())

    local width, height = _self:getWidth(), _self:getHeight()

    -- Recap window
    -- outline
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", -3, -3, width + 6, height + 6)
    -- background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, height)

    _self:drawChildren(camera)
    _self:drawDebug(camera)
  end

  self.player_name_text = Text:new("", true)
  self.player_name_text:setOrigin(0, 0.5)
  self.player_name_text:setPosition(4, 9)
  self.player_name_text:setFont("main_text")
  self.player_name_text:setParent(self.player_recap_container)

  self.player_lv_label_text = Text:new("WORLD_PLAYER_MENU_LV")
  self.player_lv_label_text:setOrigin(0, 0.5)
  self.player_lv_label_text:setPosition(4, 24)
  self.player_lv_label_text:setFont("small")
  self.player_lv_label_text:setParent(self.player_recap_container)
  self.player_lv_value_text = Text:new()
  self.player_lv_value_text:setOrigin(0, 0.5)
  self.player_lv_value_text:setPosition(22, 24)
  self.player_lv_value_text:setFont("small")
  self.player_lv_value_text:setParent(self.player_recap_container)

  self.player_hp_label_text = Text:new("WORLD_PLAYER_MENU_HP")
  self.player_hp_label_text:setOrigin(0, 0.5)
  self.player_hp_label_text:setPosition(4, 33)
  self.player_hp_label_text:setFont("small")
  self.player_hp_label_text:setParent(self.player_recap_container)
  self.player_hp_value_text = Text:new()
  self.player_hp_value_text:setOrigin(0, 0.5)
  self.player_hp_value_text:setPosition(22, 33)
  self.player_hp_value_text:setFont("small")
  self.player_hp_value_text:setParent(self.player_recap_container)

  self.player_gold_label_text = Text:new("WORLD_PLAYER_MENU_GOLD")
  self.player_gold_label_text:setOrigin(0, 0.5)
  self.player_gold_label_text:setPosition(4, 42)
  self.player_gold_label_text:setFont("small")
  self.player_gold_label_text:setParent(self.player_recap_container)
  self.player_gold_value_text = Text:new()
  self.player_gold_value_text:setOrigin(0, 0.5)
  self.player_gold_value_text:setPosition(22, 42)
  self.player_gold_value_text:setFont("small")
  self.player_gold_value_text:setParent(self.player_recap_container)

  -- actions
  self.item_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_ITEM")
  self.item_action_text:setOrigin(0, 0.5)
  self.item_action_text:setPosition(42, 102)
  self.item_action_text:setFont("main_text")
  self.item_action_text:setParent(self)

  self.stat_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_STAT")
  self.stat_action_text:setOrigin(0, 0.5)
  self.stat_action_text:setPosition(42, 120)
  self.stat_action_text:setFont("main_text")
  self.stat_action_text:setParent(self)

  self.cell_action_text = Text:new("WORLD_PLAYER_MENU_ACTION_CELL")
  self.cell_action_text:setOrigin(0, 0.5)
  self.cell_action_text:setPosition(42, 138)
  self.cell_action_text:setFont("main_text")
  self.cell_action_text:setParent(self)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setParent(self)

  self.item_menu = PlayerItemMenu:new()
  self.item_menu:setParent(self)

  self.stat_menu = PlayerStatMenu:new()
  self.stat_menu:setParent(self)

  self.cell_menu = PlayerCellMenu:new()
  self.cell_menu:setParent(self)

  self.opening = false
  self.saved = false
  self.action_index = 0
  self.total_actions = 3

  return self
end

--- Updates the player menu's position
function PlayerMenu:updatePosition()
  local camera = Scene.getCameraByTag("GAME")
  if camera == nil then return end

  local obj_player = Player.getObject()
  if obj_player == nil then return end

  local width, height = camera:getDimensions()
  local viewport_x, viewport_y = camera:getViewportPosition()
  viewport_x = viewport_x - width / 2
  viewport_y = viewport_y - height / 2
  local _, y = obj_player:getPosition()
  if y > 146 then
    self.player_recap_container:setPosition(19, 164)
  else
    self.player_recap_container:setPosition(19, 29)
  end
  self:setPosition(viewport_x, viewport_y)
end

--- Updates the player menu's texts
function PlayerMenu:updateTexts()
  local mod = ModList.getCurrentMod()
  if mod == nil then return end

  self.player_name_text:setText(Player.getName())
  self.player_lv_value_text:setText(tostring(Player.getLV()))
  self.player_hp_value_text:setText(Player.getHP() .. "/" .. Player.getMaxHP())
  self.player_gold_value_text:setText(tostring(Player.getGold()))

  if #Player.getItems() > 0 then
    self.item_action_text:setColor(1, 1, 1)
  else
    self.item_action_text:setColor(0.5, 0.5, 0.5)
  end
  self.item_action_text:setVisible(true)

  self.stat_action_text:setVisible(true)

  if Player.hasCellphone() then
    if #Player.getPhoneCalls() > 0 then
      self.cell_action_text:setColor(1, 1, 1)
    else
      self.cell_action_text:setColor(0.5, 0.5, 0.5)
    end
    self.cell_action_text:setVisible(true)
  else
    self.cell_action_text:setVisible(false)
  end
end

--- Changes the selected action
--- @param delta integer
function PlayerMenu:changeAction(delta)
  self.action_index = (self.action_index + delta + self.total_actions) % self.total_actions

  Assets.playSound("menu_move")
  self:updateHeartPosition()
end

--- Updates the heart position to the current action
function PlayerMenu:updateHeartPosition()
  local x, y = 0, 0
  if self.action_index == 0 then
    x, y = self.item_action_text:getPosition()
  elseif self.action_index == 1 then
    x, y = self.stat_action_text:getPosition()
  elseif self.action_index == 2 then
    x, y = self.cell_action_text:getPosition()
  end
  self.heart_sprite:setPosition(x - 9.5, y + 0.5)
  self.heart_sprite:setVisible(true)
end

--- Opens the selected action submenu
function PlayerMenu:openSubmenu()
  local opened = false

  if self.action_index == 0 and #Player.getItems() > 0 then
    self.item_menu:open()
    opened = true
  elseif self.action_index == 1 then
    self.stat_menu:open()
    opened = true
  elseif self.action_index == 2 and #Player.getPhoneCalls() > 0 then
    self.cell_menu:open()
    opened = true
  end

  if opened then
    self.submenu_open = true
    self.heart_sprite:setVisible(false)
    Assets.playSound("menu_select")
  end
end

--- Opens the player menu
function PlayerMenu:open()
  Assets.playSound("menu_select")
  self.opening = true
  self.saved = false

  if Player.hasCellphone() then
    self.total_actions = 3
  else
    self.total_actions = 2
  end

  self:setVisible(true)
  self:updatePosition()
  self:updateTexts()
  self:updateHeartPosition()
  self.heart_sprite:setVisible(true)

  local obj_player = Player.getObject()
  obj_player:setInteraction("menu")
end

--- Closes the player menu
function PlayerMenu:close()
  self.submenu_open = false
  self:setVisible(false)

  local obj_player = Player.getObject()
  obj_player:setInteraction("none")
end

--- Wether the player menu has focus
--- @return boolean
function PlayerMenu:hasFocus()
  if Player.getObject():getInteraction() ~= "menu" then return false end

  for _, menu in ipairs({ self.item_menu, self.stat_menu, self.cell_menu }) do
    if menu:isVisible() then
      return false
    end
  end
  return true
end

--- Draws the player menu
--- @param camera Dummy.Camera
function PlayerMenu:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local x, y = 19, 87
  local width, height = 65, 68

  -- Action window
  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", x - 3, y - 3, width + 6, height + 6)
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", x, y, width, height)

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Updates the player menu, called on every game update
--- @param dt number
function PlayerMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.opening then
    self.opening = false
    return
  end

  if Player.getObject():getInteraction() == "none" then
    self:close()
    return
  end

  if self:hasFocus() then
    if self.submenu_open then
      self.submenu_open = false
      self:changeAction(0)
      return
    end

    if Input.isPressed(Input.Up) then
      self:changeAction(-1)
    elseif Input.isPressed(Input.Down) then
      self:changeAction(1)
    elseif Input.isPressed(Input.Confirm) then
      self:openSubmenu()
    elseif Input.isPressed(Input.Cancel) or (Player.getObject():getInteraction() == "menu" and Input.isPressed(Input.Menu)) then
      self:close()
    end
  end
end

return PlayerMenu
