--- @class Dummy.Encounter
---
--- @field current_menu Dummy.Encounter.ActionMenu|nil
local self = {
  ACTIONS = {
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

--- Loads the encounter scene
--- @param mod Dummy.Mod
function self.load(mod)
  Arena = require "engine.encounter.arena"
  Player = require "engine.encounter.player"
  ActionMenu = require "engine.encounter.action_menu"
  Enemy = require "engine.encounter.enemy"

  self.mod = mod or {}
  self.mod.player = Utils.getOrDefault(self.mod.player, {})
  self.mod.encounter = Utils.getOrDefault(self.mod.encounter, {})
  self.mod.enemies = Utils.getOrDefault(self.mod.enemies, {})

  if self.mod.title ~= nil then
    love.window.setTitle(self.mod.title)
  end
  love.window.setIcon(love.image.newImageData("assets/icon.png"))

  -- background
  self.bg_sprite = Sprite:new("battle_bg")
  self.bg_sprite:setPosition(319.5, 127)
  self.bg_sprite:setLayer(Constants.LAYERS.BOTTOM)
  self.black_sprite = Sprite:new("black")
  self.black_sprite:setOrigin(0, 0)
  self.black_sprite:setVisible(false)
  self.black_sprite:setAlpha(0)
  self.black_sprite:setLayer(Constants.LAYERS.TOP)

  -- arena
  Arena.load()

  -- player
  Player.load()
  Player.setName(Utils.getOrDefault(self.mod.player.name, "Frisk"))
  Player.setLV(Utils.getOrDefault(self.mod.player.level, 1), true)
  if self.mod.player.max_hp ~= nil then
    Player.setMaxHP(self.mod.player.max_hp)
  end
  if self.mod.player.hp ~= nil then
    Player.setHP(self.mod.player.hp)
  end

  -- enemies
  self.loadEnemies()

  -- state
  self.previous_state = Constants.ENCOUNTER_STATES.ACTION_SELECT
  self.current_state = Constants.ENCOUNTER_STATES.ACTION_SELECT

  -- actions
  self.loadActions()

  -- menus
  self.loadMenus()

  -- textbox dialogue
  self.dialogue_text = DialogueText:new("")
  self.dialogue_text:setPosition(52, 270)
  self.dialogue_text:setOrigin(0, 0)
  self.dialogue_text:setFont(Font.FONTS.MAIN_TEXT)
  self.dialogue_text:setScale(2)
  self.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  self.dialogue_text:setMaxWidth(Constants.ARENA.DEFAULT_WIDTH - Constants.ARENA.BORDER_WIDTH * 2)
  self.dialogue_text:setText(Utils.getOrDefault(self.mod.encounter.text, ""))

  -- attack target
  self.target_sprite = Sprite:new("target")
  self.target_sprite:setPosition(320, 320)
  self.target_sprite:setVisible(false)
  self.target_sprite:setLayer(Constants.LAYERS.UI)
  self.target_bar_sprite = Sprite:new({ "target_bar1", "target_bar2" }, 0.1)
  self.target_bar_sprite:stop()
  self.target_bar_sprite:setPosition(38, 320)
  self.target_bar_sprite:setVisible(false)
  self.target_bar_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  -- miss
  self.miss_sprite = Sprite:new("miss")
  self.miss_sprite:setVisible(false)
  self.miss_sprite:setPosition(320, 140) -- TODO: use enemy sprite position
  self.miss_sprite:setLayer(Constants.LAYERS.UI)

  -- strike
  self.strike_sprite = Sprite:new({
    "strike1",
    "strike2",
    "strike3",
    "strike4",
    "strike5",
    "strike6"
  }, 1 / 8, false, false)
  self.strike_sprite:stop()
  self.strike_sprite:setPosition(320, 240) -- TODO: use enemy sprite position
  self.strike_sprite:setOrigin(0.5, 1)
  self.strike_sprite:setScale(1.5)
  self.strike_sprite:setVisible(false)

  local player_hp_bar_draw = Drawable:new(function()
    local max_hp_bar_width = math.clamp(5 * Player.getLV() + 20, 25, 120)
    local hp_bar_width = max_hp_bar_width * Player.getHP() / Player.getMaxHP()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 275, 400, max_hp_bar_width, 21)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", 275, 400, hp_bar_width, 21)
  end)
  player_hp_bar_draw:setLayer(Constants.LAYERS.UI)

  -- music
  if self.mod.encounter.music ~= nil then
    self.battle_music = Audio.playMusic(self.mod.encounter.music, nil, nil, nil)
  else
    self.battle_music = Audio.playMusic("battle")
  end

  self.battle_music:setVolume(0.5)
end

function self.loadEnemies()
  --- @type table<number, Dummy.Enemy>
  self.enemies = {}
  for _, enemy in ipairs(self.mod.enemies) do
    if #self.enemies >= 3 then break end

    table.insert(self.enemies, Enemy:new(enemy))
  end
end

function self.loadActions()
  self.action = {}
  self.action.index = self.ACTIONS.FIGHT

  -- FIGHT
  self.action.fight_sprite = Sprite:new("fight")
  self.action.fight_sprite:setPosition(32, 432)
  self.action.fight_sprite:setOrigin(0)
  self.action.fight_hover_sprite = Sprite:new("fight_hover")
  self.action.fight_hover_sprite:setPosition(32, 432)
  self.action.fight_hover_sprite:setOrigin(0)
  self.action.fight_hover_sprite:setVisible(false)

  -- ACT
  self.action.act_sprite = Sprite:new("act")
  self.action.act_sprite:setPosition(185, 432)
  self.action.act_sprite:setOrigin(0)
  self.action.act_hover_sprite = Sprite:new("act_hover")
  self.action.act_hover_sprite:setPosition(185, 432)
  self.action.act_hover_sprite:setOrigin(0)
  self.action.act_hover_sprite:setVisible(false)

  -- ITEM
  self.action.item_sprite = Sprite:new("item")
  self.action.item_sprite:setPosition(345, 432)
  self.action.item_sprite:setOrigin(0)
  self.action.item_hover_sprite = Sprite:new("item_hover")
  self.action.item_hover_sprite:setPosition(345, 432)
  self.action.item_hover_sprite:setOrigin(0)
  self.action.item_hover_sprite:setVisible(false)

  -- MERCY
  self.action.mercy_sprite = Sprite:new("mercy")
  self.action.mercy_sprite:setPosition(500, 432)
  self.action.mercy_sprite:setOrigin(0)
  self.action.mercy_hover_sprite = Sprite:new("mercy_hover")
  self.action.mercy_hover_sprite:setPosition(500, 432)
  self.action.mercy_hover_sprite:setOrigin(0)
  self.action.mercy_hover_sprite:setVisible(false)

  self.updateActions()
end

function self.loadMenus()
  self.loadFightEnemyMenu()
  self.loadActEnemyMenu()
  self.loadActMenus()
  self.loadItemMenu()
  self.loadMercyMenu()
end

function self.loadFightEnemyMenu()
  local options = {}
  for i, enemy in ipairs(self.enemies) do
    options[i] = {
      text = Text:new("* " .. enemy:getName()),
      action = function()
        self.enemy_selected_index = i
        Audio.playSound("menu_select")
        self.setState(Constants.ENCOUNTER_STATES.ATTACKING)
      end,
      draw = function(txt)
        local x, y = txt:getPosition()
        local hp_x, hp_y = x + 220, y - 7
        local hp_width, hp_height = 101, 17
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", hp_x, hp_y, hp_width, hp_height)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle("fill", hp_x, hp_y, hp_width * enemy:getHP() / enemy:getMaxHP(), hp_height)
      end
    }
  end

  self.fight_enemy_menu = ActionMenu:new(options, "vertical", false, function(i)
    self.enemy_selected_index = i
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadActEnemyMenu()
  local options = {}
  for i, enemy in ipairs(self.enemies) do
    options[i] = {
      text = Text:new("* " .. enemy:getName()),
      action = function()
        self.enemy_selected_index = i
        Audio.playSound("menu_select")
        self.setState(Constants.ENCOUNTER_STATES.ACT_MENU)
      end
    }
  end

  self.act_enemy_menu = ActionMenu:new(options, "vertical", false, function(i)
    self.enemy_selected_index = i
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadActMenus()
  self.act_menus = {}
  for i, enemy in ipairs(self.enemies) do
    local options = {}

    if enemy:hasCheck() then
      table.insert(options, {
        text = Text:new("* " .. Lang.translate("ENCOUNTER_MENU_ACT_CHECK")),
        action = function()
          Audio.playSound("menu_select")
          self.dialogue_text:setText(enemy:getCheckText())
          self.setState(Constants.ENCOUNTER_STATES.TEXT_DIALOGUE)
        end
      })
    end

    self.act_menus[i] = ActionMenu:new(options, "horizontal", false, function()
      self.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    end)
  end
end

function self.loadItemMenu()
  local options = {}

  -- DEBUG
  for i = 1, 7 do
    table.insert(options, {
      text = Text:new("* ITEM_" .. i),
      action = function()
        Audio.playSound("menu_select")
        print("> USE ITEM_" .. i)
      end
    })
  end

  self.item_menu = ActionMenu:new(options, "horizontal", true, function()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function self.loadMercyMenu()
  local options = {
    {
      text = Text:new("* " .. Lang.translate("ENCOUNTER_MENU_MERCY_SPARE")),
      action = function()
        Audio.playSound("menu_select")
        -- self.setState(Constants.ENCOUNTER_STATES.NONE)
        Player.setHP(0)
      end
    }
  }

  if self.mod.encounter.flee ~= false then
    table.insert(options, {
      text = Text:new("* " .. Lang.translate("ENCOUNTER_MENU_MERCY_FLEE")),
      action = function()
        if Player.isFleeing() then return end

        self.mercy_menu:setActive(false)

        Timer.after(1.5, function()
          self.setState(Constants.ENCOUNTER_STATES.DONE)
        end)

        Timer.during(2, function(dt)
          Player.flee(dt)
        end)

        Timer.after(1, function()
          local time = 0
          self.black_sprite:setVisible(true)

          Timer.during(0.4, function(dt)
            time = time + dt
            self.black_sprite:setAlpha(time / 0.4)
          end)
        end)

        Audio.playSound("escaped")
      end,
      silent = true
    })
  end

  self.mercy_menu = ActionMenu:new(options, "vertical", false, function()
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Sets current encounter state
--- @param state string
function self.setState(state)
  assert(Constants.ENCOUNTER_STATES[state:upper()] ~= nil, "Unknown encounter state \"" .. tostring(state) .. "\"")

  self.current_state = state
end

function self.startActionSelect()
  Player.hide()

  Arena.reset(function()
    self.action.index = math.abs(self.action.index)
    self.updateActions()

    Player.show()

    self.leaveMenu()

    self.dialogue_text:setText(self.mod.encounter.text)
    self.dialogue_text:setVisible(true)
  end)
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
    if self.action.index == self.ACTIONS.FIGHT and self.fight_enemy_menu:getSize() > 0 and not self.fight_enemy_menu:allDisabled() then
      self.setState(Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU)
    elseif self.action.index == self.ACTIONS.ACT and self.fight_enemy_menu:getSize() > 0 and not self.item_menu:allDisabled() then
      self.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    elseif self.action.index == self.ACTIONS.ITEM and self.item_menu:getSize() > 0 then
      self.setState(Constants.ENCOUNTER_STATES.ITEM_MENU)
    elseif self.action.index == self.ACTIONS.MERCY then
      self.setState(Constants.ENCOUNTER_STATES.MERCY_MENU)
    end

    if self.action.index > 0 then
      Audio.playSound("menu_select")
    end
  elseif Input.isPressed(Input.Cancel) then
    self.dialogue_text:skip()
  end
end

--- Opens an action's menu
--- @param menu Dummy.Encounter.ActionMenu|nil
function self.enterMenu(menu)
  if menu == nil or menu:getSize() <= 0 or menu:allDisabled() then
    self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    return
  end

  self.leaveMenu()
  self.current_menu = menu
  self.current_menu:show()

  self.dialogue_text:setVisible(false)
end

--- Leaves the current menu
function self.leaveMenu()
  if self.current_menu ~= nil then
    self.current_menu:hide()
    self.current_menu = nil
  end
end

--- Updates actions sprites and soul position
function self.updateActions()
  self.action.fight_sprite:setVisible(true)
  self.action.act_sprite:setVisible(true)
  self.action.item_sprite:setVisible(true)
  self.action.mercy_sprite:setVisible(true)
  self.action.fight_hover_sprite:setVisible(false)
  self.action.act_hover_sprite:setVisible(false)
  self.action.item_hover_sprite:setVisible(false)
  self.action.mercy_hover_sprite:setVisible(false)

  local selected_sprite, selected_sprite_hover
  if self.action.index == self.ACTIONS.FIGHT then
    selected_sprite = self.action.fight_sprite
    selected_sprite_hover = self.action.fight_hover_sprite
  elseif self.action.index == self.ACTIONS.ACT then
    selected_sprite = self.action.act_sprite
    selected_sprite_hover = self.action.act_hover_sprite
  elseif self.action.index == self.ACTIONS.ITEM then
    selected_sprite = self.action.item_sprite
    selected_sprite_hover = self.action.item_hover_sprite
  elseif self.action.index == self.ACTIONS.MERCY then
    selected_sprite = self.action.mercy_sprite
    selected_sprite_hover = self.action.mercy_hover_sprite
  end

  if selected_sprite ~= nil then
    selected_sprite:setVisible(false)
    selected_sprite_hover:setVisible(true)

    local x, y = selected_sprite:getPosition()
    Player.setPosition(x + 16, y + 22, true)
  end
end

function self.startTextDialogue()
  self.dialogue_text:reset()
  self.dialogue_text:setVisible(true)

  self.action.index = -math.abs(self.action.index)
  self.updateActions()

  Player.hide()

  self.leaveMenu()
end

function self.updateTextDialogue()
  if Input.isPressed(Input.Cancel) then
    self.dialogue_text:skip()
  elseif Input.isPressed(Input.Confirm) and self.dialogue_text:isDone() then
    self.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
  end
end

function self.startEnemyDialogue()
  self.dialogue_text:setVisible(false)

  self.action.index = -math.abs(self.action.index)
  self.updateActions()

  -- TODO: get arena width/height in wave
  local wave_arena_width = 175
  Arena.resize(wave_arena_width, 130, function()
    self.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  end)

  local x, y = Arena:getPosition()
  Player.setPosition(x, y - 65)
  Player.show()
end

function self.updateEnemyDialogue(dt)
  if Input.isPressed(Input.Confirm) then
    self.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  end
end

function self.startAttacking()
  self.target_sprite:setVisible(true)
  self.target_sprite:setAlpha(1)
  self.target_sprite:setScale(1)

  Player.hide()

  self.leaveMenu()

  local attack_window = 1.55
  local attack_window_timer = nil
  local attack_window_miss_timer = nil

  local alpha = 1
  local scale_x = 1
  local bar_speed = 400

  local function attack(miss)
    Timer.cancel(attack_window_timer)
    Timer.cancel(attack_window_miss_timer)

    local proceed_attack = function()
      Timer.during(1, function(dt)
        alpha = math.clamp(alpha - dt * 2.5, 0, 1)
        self.target_sprite:setAlpha(alpha)

        scale_x = math.max(0.25, scale_x - dt * 2.5)
        self.target_sprite:setScale(scale_x, 1)
      end)

      local enemy = self.enemies[self.enemy_selected_index]

      if miss == true then
        self.miss_sprite:setVisible(true)

        Timer.after(1, function()
          self.miss_sprite:setVisible(false)
        end)
      else
        Audio.playSound("damage")

        enemy:setHP(math.clamp(enemy:getHP() - 12, 0, enemy:getMaxHP())) -- DEBUG
        if enemy:getHP() <= 0 then
          local fight_option = self.fight_enemy_menu:getOptionByIndex(self.enemy_selected_index)
          fight_option.disabled = true
          local act_option = self.act_enemy_menu:getOptionByIndex(self.enemy_selected_index)
          act_option.disabled = true
        end
      end


      self.target_bar_sprite:setVisible(false)
      self.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
    end

    if miss == true then
      proceed_attack()
    else
      self.strike_sprite:setVisible(true)
      self.strike_sprite:play()
      self.target_bar_sprite:play()
      Audio.playSound("strike")
      Timer.after(1, proceed_attack)
    end
  end

  attack_window_timer = Timer.during(attack_window, function(dt)
    local x, y = self.target_bar_sprite:getPosition()
    self.target_bar_sprite:setPosition(x + bar_speed * dt, y)

    if Input.isPressed(Input.Confirm) then
      attack()
    end
  end)

  attack_window_miss_timer = Timer.after(attack_window, function()
    attack(true)
  end)

  Timer.after(0.1, function()
    self.target_bar_sprite:setPosition(38, 320)
    self.target_bar_sprite:setVisible(true)
    self.target_bar_sprite:setFrame(1)
  end)
end

function self.updateAttacking(dt)
end

function self.startDefending()
  self.action.index = -math.abs(self.action.index)
  self.updateActions()

  -- TODO: get arena width/height in wave
  local wave_arena_width = 175
  local wave_arena_height = 175
  Arena.resize(wave_arena_width, wave_arena_height)
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
      if self.current_menu == self.fight_enemy_menu then
        self.fight_enemy_menu:selectByIndex(self.enemy_selected_index, true)
      end
    elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
      self.enterMenu(self.act_enemy_menu)
      if self.current_menu == self.act_enemy_menu then
        self.act_enemy_menu:selectByIndex(self.enemy_selected_index, true)
      end
    elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
      self.enterMenu(self.act_menus[self.enemy_selected_index])
    elseif self.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
      self.enterMenu(self.item_menu)
      self.item_menu:select(0, 0, true)
    elseif self.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
      self.enterMenu(self.mercy_menu)
    elseif self.current_state == Constants.ENCOUNTER_STATES.TEXT_DIALOGUE then
      self.startTextDialogue()
    elseif self.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
      self.startEnemyDialogue()
    elseif self.current_state == Constants.ENCOUNTER_STATES.ATTACKING then
      self.startAttacking()
    elseif self.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
      self.startDefending()
    end
  end

  -- update
  if self.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
    self.updateActionSelect()
  elseif self.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
    if self.current_menu ~= nil then self.current_menu:update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
    if self.current_menu ~= nil then self.current_menu:update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
    if self.current_menu ~= nil then self.current_menu:update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
    if self.current_menu ~= nil then self.current_menu:update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
    if self.current_menu ~= nil then self.current_menu:update() end
  elseif self.current_state == Constants.ENCOUNTER_STATES.TEXT_DIALOGUE then
    self.updateTextDialogue()
  elseif self.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
    self.updateEnemyDialogue(dt)
  elseif self.current_state == Constants.ENCOUNTER_STATES.ATTACKING then
    self.updateAttacking(dt)
  elseif self.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
    self.updateDefending(dt)
    if Input.isPressed(Input.Cancel) then
      self.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    end
  elseif self.current_state == Constants.ENCOUNTER_STATES.DONE then
    Scene.change("MAIN_MENU")
  elseif self.current_state == Constants.ENCOUNTER_STATES.NONE then
  end

  if Player.getHP() <= 0 then
    local x, y = Player.getPosition()
    Scene.change("GAME_OVER", x, y)
  end

  Arena.update(dt)
end

return self
