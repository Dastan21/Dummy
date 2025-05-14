Arena = require "engine.encounter.arena"
Player = require "engine.encounter.player"
ActionMenu = require "engine.encounter.action_menu"

---@class Encounter
---
---@field current_menu Dummy.Encounter.ActionMenu|nil
local self = {
  ACTIONS = {
    --- No action
    NONE = 0,
    --- FIGHT action
    FIGHT = 1,
    --- ACT action
    ACT = 2,
    --- ITEM action
    ITEM = 3,
    --- MERCY action
    MERCY = 4,
  },
}

function self.load(encounter)
  self.encounter = encounter or {}
  self.encounter.player = Utils.getOrDefault(self.encounter.player, {})
  self.encounter.encounter = Utils.getOrDefault(self.encounter.encounter, {})
  self.encounter.encounter.arena = Utils.getOrDefault(self.encounter.encounter.arena, {})
  self.encounter.encounter.arena.width = Utils.getOrDefault(self.encounter.encounter.arena.width, 130)
  self.encounter.encounter.arena.height = Utils.getOrDefault(self.encounter.encounter.arena.height, 130)

  -- background
  self.bg = Sprite.new("battle_bg")
  self.bg:setPosition(319.5, 127)
  self.black_bg = Sprite.new("black_bg")
  self.black_bg:setOrigin(0, 0)
  self.black_bg:setActive(false)
  self.black_bg:setAlpha(0)
  self.black_bg:setLayer(Constants.LAYERS.TOP)

  -- arena
  Arena.load()

  -- player
  Player.load()
  Player.setName(Utils.getOrDefault(self.encounter.player.name, "Frisk"))
  Player.setLV(Utils.getOrDefault(self.encounter.player.level, 1), true)
  Player.setHP(Utils.getOrDefault(self.encounter.player.hp, 99))

  -- state
  self.previous_state = Constants.ENCOUNTER_STATES.ACTION_SELECT
  self.current_state = Constants.ENCOUNTER_STATES.ACTION_SELECT

  -- actions
  self.loadActions()

  -- menus
  self.loadMenus()

  Scene.addDrawable(function()
    local max_hp_bar_width = math.clamp(5 * Player.getLV() + 20, 25, 120)
    local hp_bar_width = max_hp_bar_width * Player.getHP() / Player.getMaxHP()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 275, 400, max_hp_bar_width, 21)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", 275, 400, hp_bar_width, 21)
    love.graphics.setColor(1, 1, 1, 1)
  end, Constants.LAYERS.UI)
end

function self.loadActions()
  self.action = {}
  self.action.index = self.ACTIONS.FIGHT

  -- FIGHT
  self.action.fight = Sprite.new("action_fight")
  self.action.fight:setPosition(32, 432)
  self.action.fight:setOrigin(0)
  self.action.fight_hover = Sprite.new("action_fight_hover")
  self.action.fight_hover:setPosition(32, 432)
  self.action.fight_hover:setOrigin(0)
  self.action.fight_hover:setActive(false)

  -- ACT
  self.action.act = Sprite.new("action_act")
  self.action.act:setPosition(185, 432)
  self.action.act:setOrigin(0)
  self.action.act_hover = Sprite.new("action_act_hover")
  self.action.act_hover:setPosition(185, 432)
  self.action.act_hover:setOrigin(0)
  self.action.act_hover:setActive(false)

  -- ITEM
  self.action.item = Sprite.new("action_item")
  self.action.item:setPosition(345, 432)
  self.action.item:setOrigin(0)
  self.action.item_hover = Sprite.new("action_item_hover")
  self.action.item_hover:setPosition(345, 432)
  self.action.item_hover:setOrigin(0)
  self.action.item_hover:setActive(false)

  -- MERCY
  self.action.mercy = Sprite.new("action_mercy")
  self.action.mercy:setPosition(500, 432)
  self.action.mercy:setOrigin(0)
  self.action.mercy_hover = Sprite.new("action_mercy_hover")
  self.action.mercy_hover:setPosition(500, 432)
  self.action.mercy_hover:setOrigin(0)
  self.action.mercy_hover:setActive(false)

  self.updateActions()
end

function self.loadMenus()
  self.loadFightEnemyMenu()
  self.loadActEnemyMenu()
  self.loadActMenu()
  self.loadItemMenu()
  self.loadMercyMenu()
end

function self.loadFightEnemyMenu()
  local options = {
    {
      text = Text.new("* " .. self.encounter.encounter.name),
      action = function()
        Audio.playSound("menu_select")
        -- self.setState(Constants.ENCOUNTER_STATES.ATTACKING)
        self.current_menu.hide()
        self.current_menu = nil
        self.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
      end,
      draw = function(txt)
        local x, y = txt:getPosition()
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", x + 220, y - 7, 101, 17)
      end
    }
  }

  self.fight_enemy_menu = ActionMenu.new(options, "vertical", false, function()
    self.action.index = self.ACTIONS.FIGHT
    self.updateActions()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadActEnemyMenu()
  local options = {
    {
      text = Text.new("* " .. self.encounter.encounter.name),
      action = function()
        Audio.playSound("menu_select")
        self.setState(Constants.ENCOUNTER_STATES.ACT_MENU)
      end
    }
  }

  self.act_enemy_menu = ActionMenu.new(options, "vertical", false, function()
    self.action.index = self.ACTIONS.ACT
    self.updateActions()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadActMenu()
  local options = {}

  if self.encounter.encounter.check ~= nil then
    table.insert(options, {
      text = Text.new("ENCOUNTER_MENU_ACT_CHECK"),
      action = function()
        Audio.playSound("menu_select")
        print("> CHECKING", self.encounter.encounter.check)
      end
    })
  end

  self.act_menu = ActionMenu.new(options, "horizontal", false, function()
    self.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
  end)
end

function self.loadItemMenu()
  local options = {}

  -- DEBUG
  for i = 1, 7 do
    table.insert(options, {
      text = Text.new("* ITEM_" .. i),
      action = function()
        Audio.playSound("menu_select")
        print("> USE ITEM_" .. i)
      end
    })
  end

  self.item_menu = ActionMenu.new(options, "horizontal", true, function()
    self.action.index = self.ACTIONS.ITEM
    self.updateActions()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadMercyMenu()
  local options = {
    {
      text = Text.new("ENCOUNTER_MENU_MERCY_SPARE"),
      action = function()
        self.setState(Constants.ENCOUNTER_STATES.NONE)
        Audio.playSound("menu_select")
      end
    }
  }

  if self.encounter.encounter.flee ~= false then
    table.insert(options, {
      text = Text.new("ENCOUNTER_MENU_MERCY_FLEE"),
      action = function()
        Timer.after(1.5, function()
          self.setState(Constants.ENCOUNTER_STATES.DONE)
        end)

        Timer.during(2, function(dt)
          Player.flee(dt)
        end)

        Timer.after(1, function()
          local time = 0
          self.black_bg:setActive(true)

          Timer.during(0.4, function(dt)
            time = time + dt
            self.black_bg:setAlpha(time / 0.4)
          end)
        end)

        Audio.playSound("escaped")
      end,
      silent = true
    })
  end

  self.mercy_menu = ActionMenu.new(options, "vertical", false, function()
    self.action.index = self.ACTIONS.MERCY
    self.updateActions()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Sets current encounter state
---@param state string
function self.setState(state)
  assert(Constants.ENCOUNTER_STATES[state:upper()] ~= nil, "Unknown encounter state \"" .. tostring(state) .. "\"")

  self.current_state = state
end

function self.startActionSelect()
  if self.action.index == self.ACTIONS.NONE then
    self.action.index = self.ACTIONS.FIGHT
  end
  self.updateActions()

  Arena.reset()
end

function self.updateActionSelect()
  if Input.isPressed(Input.Left) then
    if self.action.index <= self.ACTIONS.FIGHT then
      self.action.index = self.ACTIONS.MERCY
    else
      self.action.index = self.action.index - 1
    end
    self.updateActions()
    Audio.playSound("menu_move")
  elseif Input.isPressed(Input.Right) then
    if self.action.index >= self.ACTIONS.MERCY then
      self.action.index = self.ACTIONS.FIGHT
    else
      self.action.index = self.action.index + 1
    end
    self.updateActions()
    Audio.playSound("menu_move")
  elseif Input.isPressed(Input.Confirm) then
    if self.action.index == self.ACTIONS.FIGHT then
      self.setState(Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU)
    elseif self.action.index == self.ACTIONS.ACT then
      self.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    elseif self.action.index == self.ACTIONS.ITEM then
      self.setState(Constants.ENCOUNTER_STATES.ITEM_MENU)
    elseif self.action.index == self.ACTIONS.MERCY then
      self.setState(Constants.ENCOUNTER_STATES.MERCY_MENU)
    end

    Audio.playSound("menu_select")
  end
end

--- Opens an action's menu
---@param menu Dummy.Encounter.ActionMenu|nil
function self.enterMenu(menu)
  if menu ~= nil and menu:getSize() <= 0 then
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    return
  end

  if self.current_menu ~= nil then
    self.current_menu.hide()
  end
  self.current_menu = menu
  self.current_menu.show()
end

--- Updates actions sprites and soul position
function self.updateActions()
  self.action.fight:setActive(true)
  self.action.act:setActive(true)
  self.action.item:setActive(true)
  self.action.mercy:setActive(true)
  self.action.fight_hover:setActive(false)
  self.action.act_hover:setActive(false)
  self.action.item_hover:setActive(false)
  self.action.mercy_hover:setActive(false)

  local selected_sprite, selected_sprite_hover
  if self.action.index == self.ACTIONS.FIGHT then
    selected_sprite = self.action.fight
    selected_sprite_hover = self.action.fight_hover
  elseif self.action.index == self.ACTIONS.ACT then
    selected_sprite = self.action.act
    selected_sprite_hover = self.action.act_hover
  elseif self.action.index == self.ACTIONS.ITEM then
    selected_sprite = self.action.item
    selected_sprite_hover = self.action.item_hover
  elseif self.action.index == self.ACTIONS.MERCY then
    selected_sprite = self.action.mercy
    selected_sprite_hover = self.action.mercy_hover
  end

  if selected_sprite ~= nil then
    selected_sprite:setActive(false)
    selected_sprite_hover:setActive(true)

    local x, y = selected_sprite:getPosition()
    Player.setPosition(x + 16, y + 22, true)
  end
end

function self.startEnemyDialogue()
  self.action.index = self.ACTIONS.NONE
  self.updateActions()

  Arena.resize(self.encounter.encounter.arena.width, 130)
  local x, y = Arena:getPosition()
  Player.setPosition(x, y - 65)
end

function self.updateEnemyDialogue(dt)
  if Input.isPressed(Input.Confirm) then
    self.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  end
end

function self.startDefending()
  self.action.index = self.ACTIONS.NONE
  self.updateActions()

  Arena.resize(self.encounter.encounter.arena.width, self.encounter.encounter.arena.height)
end

function self.updateDefending(dt)
  Player.update(dt)
end

function self.update(dt)
  -- start
  if self.current_state ~= self.previous_state then
    self.previous_state = self.current_state

    if self.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
      self.startActionSelect()
    elseif self.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
      self.enterMenu(self.fight_enemy_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
      self.enterMenu(self.act_enemy_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
      self.enterMenu(self.act_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
      self.enterMenu(self.item_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
      self.enterMenu(self.mercy_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
      self.startEnemyDialogue()
    elseif self.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
      self.startDefending()
    end
  end

  -- update
  if self.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
    self.updateActionSelect()
  elseif self.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
    if self.current_menu ~= nil then self.current_menu.update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
    if self.current_menu ~= nil then self.current_menu.update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
    if self.current_menu ~= nil then self.current_menu.update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
    if self.current_menu ~= nil then self.current_menu.update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
    if self.current_menu ~= nil then self.current_menu.update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
    self.updateEnemyDialogue(dt)
  elseif self.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
    self.updateDefending(dt)
    if Input.isPressed(Input.Cancel) then
      self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    end
  elseif self.current_state == Constants.ENCOUNTER_STATES.DONE then
    Scene.change("MAIN_MENU")
  elseif self.current_state == Constants.ENCOUNTER_STATES.NONE then
  else
    error("Unknown encounter state: " .. self.current_state)
  end

  Arena.update(dt)
end

return self
