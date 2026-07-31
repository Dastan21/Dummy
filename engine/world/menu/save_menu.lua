--- @class Dummy.SaveMenu : Dummy.Drawable
---
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_text Dummy.Text
--- @field protected playtime_text Dummy.Text
--- @field protected room_name_text Dummy.Text
--- @field protected save_action_text Dummy.Text
--- @field protected return_action_text Dummy.Text
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected saved boolean
--- @field protected action_index integer
--- @field protected total_actions integer
local SaveMenu = Class(Drawable, "Dummy.SaveMenu")

SaveMenu.MENU_X = 57
SaveMenu.MENU_Y = 62

--- Creates a save menu
--- @return Dummy.SaveMenu
function SaveMenu:new()
  self = Class:new(SaveMenu)

  self.width = 206
  self.height = 81
  self:setLayer(Constants.LAYERS.WORLD_MENU)
  self:setVisible(false)

  self.player_name_text = Text:new("", true)
  self.player_name_text:setOrigin(0, 0.5)
  self.player_name_text:setPosition(13, 16)
  self.player_name_text:setFont("main_text")
  self.player_name_text:setParent(self)

  self.player_lv_text = Text:new()
  self.player_lv_text:setOrigin(0, 0.5)
  self.player_lv_text:setPosition(93, 16)
  self.player_lv_text:setFont("main_text")
  self.player_lv_text:setParent(self)

  self.playtime_text = Text:new()
  self.playtime_text:setOrigin(1, 0.5)
  self.playtime_text:setPosition(193, 16)
  self.playtime_text:setFont("main_text")
  self.playtime_text:setParent(self)

  self.room_name_text = Text:new()
  self.room_name_text:setOrigin(0, 0.5)
  self.room_name_text:setPosition(13, 36)
  self.room_name_text:setFont("main_text")
  self.room_name_text:setParent(self)

  -- actions
  self.save_action_text = Text:new("WORLD_SAVE_MENU_ACTION_SAVE")
  self.save_action_text:setOrigin(0, 0.5)
  self.save_action_text:setPosition(28, 66)
  self.save_action_text:setFont("main_text")
  self.save_action_text:setParent(self)

  self.return_action_text = Text:new("WORLD_SAVE_MENU_ACTION_RETURN")
  self.return_action_text:setOrigin(0, 0.5)
  self.return_action_text:setPosition(118, 66)
  self.return_action_text:setFont("main_text")
  self.return_action_text:setParent(self)

  self.file_saved_text = Text:new("WORLD_SAVE_MENU_SAVED")
  self.file_saved_text:setOrigin(0, 0.5)
  self.file_saved_text:setPosition(28, 66)
  self.file_saved_text:setFont("main_text")
  self.file_saved_text:setColor(1, 1, 0)
  self.file_saved_text:setParent(self)
  self.file_saved_text:setVisible(false)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setPosition(18.5, 65.5)
  self.heart_sprite:setParent(self)

  self.opening = false
  self.saved = false
  self.action_index = 0
  self.total_actions = 2

  return self
end

--- Updates the save menu's position
function SaveMenu:updatePosition()
  local camera = Scene.getCameraByTag("GAME")
  if camera == nil then return end

  local width, height = camera:getDimensions()
  local viewport_x, viewport_y = camera:getViewportPosition()
  viewport_x = viewport_x - width / 2
  viewport_y = viewport_y - height / 2
  self:setPosition(viewport_x + SaveMenu.MENU_X, viewport_y + SaveMenu.MENU_Y)
end

--- Updates the save menu's texts
function SaveMenu:updateTexts()
  local mod = ModList.getCurrentMod()
  if mod == nil then return end

  local save_data = self:loadSavepointData()

  self.player_name_text:setText(save_data.name)
  self.player_name_text:setColor(1, 1, 1)

  self.player_lv_text:setText({ "WORLD_SAVE_MENU_LV", save_data.lv })
  self.player_lv_text:setColor(1, 1, 1)

  local time = save_data.time
  local minutes = math.floor(time / 60)
  local seconds = math.round(((time / 60) - minutes) * 60)
  if seconds >= 60 then
    seconds = 59
  end
  local seconds_str = tostring(seconds)
  if seconds < 10 then
    seconds_str = "0" .. seconds_str
  end
  self.playtime_text:setText({ "WORLD_SAVE_MENU_TIME", minutes, seconds_str })
  self.playtime_text:setColor(1, 1, 1)

  self.room_name_text:setText(save_data.room_name)
  self.room_name_text:setColor(1, 1, 1)

  self.save_action_text:setVisible(true)
  self.return_action_text:setVisible(true)
end

--- Changes the selected action
--- @param delta integer
function SaveMenu:changeAction(delta)
  self.action_index = (self.action_index + delta + self.total_actions) % self.total_actions

  Assets.playSound("menu_move")
  self:updateHeartPosition()
end

--- Updates the heart position to the current action
function SaveMenu:updateHeartPosition()
  local x, y = 0, 0
  if self.action_index == 0 then
    x, y = self.save_action_text:getPosition()
  elseif self.action_index == 1 then
    x, y = self.return_action_text:getPosition()
  end
  self.heart_sprite:setPosition(x - 9.5, y - 0.5)
end

--- Loads the save data
--- @return Dummy.Mod.Config.Savepoint
function SaveMenu:loadSavepointData()
  local config = ModList.getCurrentMod():getConfig()
  if config.savepoint ~= nil then return config.savepoint end

  return {
    name = "WORLD_SAVE_MENU_EMPTY",
    lv = 0,
    time = 0,
    room_id = "default",
    room_name = "--"
  }
end

--- Saves the current progress
function SaveMenu:save()
  local sound = Assets.playSound("save")
  sound:setVolume(0.87)

  local save_data = self:loadSavepointData()
  save_data.name = Player.getName()
  save_data.lv = Player.getLV()
  ---@diagnostic disable-next-line: invisible
  save_data.time = World.playtime
  save_data.room_id = World.getCurrentRoom():getId()
  save_data.room_name = World.getCurrentRoom():getName()

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    mod:getConfig().savepoint = save_data
    if type(mod.onGameSave) == "function" then
      mod:onGameSave()
    end
  end

  Config.save()

  self.saved = true

  self:updateTexts()
  self.player_name_text:setColor(1, 1, 0)
  self.player_lv_text:setColor(1, 1, 0)
  self.playtime_text:setColor(1, 1, 0)
  self.room_name_text:setColor(1, 1, 0)
  self.save_action_text:setVisible(false)
  self.return_action_text:setVisible(false)
  self.heart_sprite:setVisible(false)
  self.file_saved_text:setVisible(true)
end

--- Opens the save menu
function SaveMenu:open()
  self.opening = true
  self.saved = false
  self.action_index = 0

  self:setVisible(true)
  self:updatePosition()
  self:updateTexts()
  self:updateHeartPosition()
  self.heart_sprite:setVisible(true)
  self.file_saved_text:setVisible(false)

  local obj_player = Player.getObject()
  obj_player:setInteraction("menu")
end

--- Closes the save menu
function SaveMenu:close()
  self:setVisible(false)

  local obj_player = Player.getObject()
  obj_player:setInteraction("none")
end

--- Draws the save menu
--- @param camera Dummy.Camera
function SaveMenu:draw(camera)
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

--- Updates the save menu, called on every game update
--- @param dt number
function SaveMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.opening then
    self.opening = false
    return
  end

  if Input.isPressed(Input.Left) then
    self:changeAction(-1)
  elseif Input.isPressed(Input.Right) then
    self:changeAction(1)
  elseif Input.isPressed(Input.Confirm) then
    if self.action_index == 1 or self.saved then
      self:close()
    elseif self.action_index == 0 then
      self:save()
    end
  elseif Input.isPressed(Input.Cancel) then
    self:close()
  end
end

return SaveMenu
