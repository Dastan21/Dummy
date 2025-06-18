--- @class Dummy.Encounter
---
--- @field protected text Dummy.Text.Text
--- @field protected can_flee boolean
--- @field protected music love.Source
--- @field protected enemies Dummy.Enemy[]
--- @field protected wave Dummy.Wave
--- @field protected current_state string
--- @field protected previous_state string
--- @field protected current_menu Dummy.Encounter.ActionMenu|nil
--- @field protected bg_sprite Dummy.Sprite
--- @field protected dialogue_text Dummy.DialogueText
--- @field protected target_sprite Dummy.Sprite
--- @field protected target_bar_sprite Dummy.Sprite
--- @field protected miss_text Dummy.Text
--- @field protected strike_sprite Dummy.Sprite
--- @field protected enemy_hp_draw Dummy.Drawable
--- @field protected enemy_hp_text Dummy.Text
--- @field protected enemy_hp_text_timer table|nil
--- @field protected battle_music love.Source
--- @field protected fight_enemy_menu Dummy.Encounter.ActionMenu
--- @field protected act_enemy_menu Dummy.Encounter.ActionMenu
--- @field protected act_menus Dummy.Encounter.ActionMenu[]
--- @field protected item_menu Dummy.Encounter.ActionMenu
--- @field protected mercy_menu Dummy.Encounter.ActionMenu
--- @field protected enemy_selected_index number
--- @field protected action.index number
--- @field protected action.fight_sprite Dummy.Sprite
--- @field protected action.fight_hover_sprite Dummy.Sprite
--- @field protected action.act_sprite Dummy.Sprite
--- @field protected action.act_hover_sprite Dummy.Sprite
--- @field protected action.item_sprite Dummy.Sprite
--- @field protected action.item_hover_sprite Dummy.Sprite
--- @field protected action.mercy_sprite Dummy.Sprite
--- @field protected action.mercy_hover_sprite Dummy.Sprite
local Encounter = {}

--- Encounter actions
Encounter.ACTIONS = {
  --- FIGHT action
  FIGHT = 1,
  --- ACT action
  ACT = 2,
  --- ITEM action
  ITEM = 3,
  --- MERCY action
  MERCY = 4,
}

--- Gets the class name
--- @return string
function Encounter.getClass()
  return "Dummy.Encounter"
end

--- Gets the encounter's text
--- @return Dummy.Text.Text
function Encounter.getText()
  return Encounter.text
end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
function Encounter.setText(text)
  Encounter.text = text
  Encounter.dialogue_text:setText(Encounter.getText())
end

--- Adds one or more enemies to the encounter
---@param enemy Dummy.Enemy|Dummy.Enemy[]
---@param ... Dummy.Enemy
function Encounter.addEnemy(enemy, ...)
  local enemies = { enemy, ... }
  if #enemy >= 1 then enemies = enemy end
  for _, enemy in ipairs(enemies) do
    table.insert(Encounter.enemies, enemy)
  end

  Encounter.loadFightEnemyMenu()
  Encounter.loadActEnemyMenu()
end

--- Sets the encounter's next wave
--- @param wave Dummy.Wave
function Encounter.setWave(wave)
  Encounter.wave = wave
end

--- Wether the player can flee the encounter
--- @return boolean
function Encounter.canFlee()
  return Encounter.can_flee
end

--- Sets wether the player can flee the encounter
---@param can_flee boolean
function Encounter.setCanFlee(can_flee)
  Encounter.can_flee = can_flee
end

--- Gets the encounter's text
--- @return love.Source
function Encounter.getMusic()
  return Encounter.music
end

--- Sets the encounter music
---@param music string
function Encounter.setMusic(music)
  Encounter.music = Assets.playMusic(music)
  Encounter.music:setVolume(0.5)
end

--- Plays a text dialogue
---@param text Dummy.Text.Text
---@param can_skip? boolean
function Encounter.playDialogue(text, can_skip)
  Encounter.dialogue_text:setText(text)
  Encounter.dialogue_text:setCanSkip(Utils.getOrDefault(can_skip, true))
  Encounter.setState(Constants.ENCOUNTER_STATES.TEXT_DIALOGUE)
end

--- Flees the encounter
function Encounter.flee()
  Encounter.mercy_menu:setActive(false)

  Player.flee()

  Timer.after(1, function()
    Fader.fadeIn(1 / 2.4, function()
      Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
    end)
  end)

  Assets.playSound("escaped")

  local flee_value = math.random(20)
  local flee_text_key
  if flee_value <= 1 then
    flee_text_key = "ENCOUNTER_FLEE_TEXT_1"
  elseif flee_value == 2 then
    flee_text_key = "ENCOUNTER_FLEE_TEXT_2"
  elseif flee_value == 3 then
    flee_text_key = "ENCOUNTER_FLEE_TEXT_3"
  else
    flee_text_key = "ENCOUNTER_FLEE_TEXT_4"
  end
  Encounter.dialogue_text:setText(flee_text_key)
  Encounter.dialogue_text:setCanSkip(true)
  Encounter.dialogue_text:setVisible(true)
  Encounter.dialogue_text:skip()
end

--- Loads the encounter
function Encounter.load()
  -- background
  Encounter.bg_sprite = Sprite:new("battle_bg")
  Encounter.bg_sprite:setPosition(319.5, 127)
  Encounter.bg_sprite:setLayer(Constants.LAYERS.BOTTOM)

  -- state
  Encounter.previous_state = Constants.ENCOUNTER_STATES.ACTION_SELECT
  Encounter.current_state = Constants.ENCOUNTER_STATES.ACTION_SELECT

  -- actions
  Encounter.loadActions()

  -- textbox dialogue
  Encounter.dialogue_text = DialogueText:new("")
  Encounter.dialogue_text:setPosition(52, 270)
  Encounter.dialogue_text:setOrigin(0, 0)
  Encounter.dialogue_text:setFont(Assets.getFont("main_text"))
  Encounter.dialogue_text:setScale(2)
  Encounter.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  Encounter.dialogue_text:setMaxWidth(Constants.ARENA.DEFAULT_WIDTH - Constants.ARENA.BORDER_WIDTH * 2)
  Encounter.dialogue_text:setCanSkip(true)
  Encounter.dialogue_text:setText(Encounter.getText())

  -- attack target
  Encounter.target_sprite = Sprite:new("target")
  Encounter.target_sprite:setPosition(320, 320)
  Encounter.target_sprite:setLayer(Constants.LAYERS.UI)
  Encounter.target_sprite:setVisible(false)
  Encounter.target_bar_sprite = Sprite:new({ "target_bar1", "target_bar2" }, 0.1, nil, false)
  Encounter.target_bar_sprite:setVisible(false)
  Encounter.target_bar_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  -- miss
  Encounter.miss_text = Text:new("ENCOUNTER_ATTACK_MISS")
  Encounter.miss_text:setVisible(false)
  Encounter.miss_text:setFont(Assets.getFont("damage"))
  Encounter.miss_text:setColor(0.75, 0.75, 0.75)
  Encounter.miss_text:setLayer(Constants.LAYERS.UI)

  -- strike
  Encounter.strike_sprite = Sprite:new({
    "strike1",
    "strike2",
    "strike3",
    "strike4",
    "strike5",
    "strike6"
  }, 4 / 30, false, false, false)
  Encounter.strike_sprite:setOrigin(0.5, 0.5)
  Encounter.strike_sprite:setScale(1.5)
  Encounter.strike_sprite:setVisible(false)

  -- player hp bar
  Drawable:new(function()
    local max_hp_bar_width = math.clamp(5 * Player.getLV() + 20, 25, 120)
    local hp_bar_width = max_hp_bar_width * Player.getHP() / Player.getMaxHP()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 275, 400, max_hp_bar_width, 21)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", 275, 400, hp_bar_width, 21)
  end):setLayer(Constants.LAYERS.UI)

  -- enemy hp bar & damage text
  Encounter.enemy_hp_draw = Drawable:new()
  Encounter.enemy_hp_draw:setLayer(Constants.LAYERS.ABOVE_BULLET)
  Encounter.enemy_hp_draw:setVisible(false)

  Encounter.enemy_hp_text = Text:new("")
  Encounter.enemy_hp_text:setColor(1, 0, 0)
  Encounter.enemy_hp_text:setLayer(Constants.LAYERS.ABOVE_BULLET)
  Encounter.enemy_hp_text:setFont(Assets.getFont("damage"))
  Encounter.enemy_hp_text:setScale(1)
  Encounter.enemy_hp_text:setVisible(false)

  Encounter.can_flee = true
  Encounter.setMusic("battle")

  Encounter.enemies = {}
end

--- Gets the encounter's fight enemy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getFightEnemyMenu()
  return Encounter.fight_enemy_menu
end

--- Loads fight enemy menu
function Encounter.loadFightEnemyMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  for i, enemy in ipairs(Encounter.enemies) do
    options[i] = {
      text = Text:new("* " .. enemy:getName()),
      action = function()
        Encounter.enemy_selected_index = i
        Assets.playSound("menu_select")
        Encounter.setState(Constants.ENCOUNTER_STATES.ATTACKING)
      end,
      draw = function(option)
        local x, y = option.text:getPosition()
        local hp_x, hp_y = x + 220, y - 7
        local hp_width, hp_height = 101, 17
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", hp_x, hp_y, hp_width, hp_height)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle("fill", hp_x, hp_y, hp_width * enemy:getHP() / enemy:getMaxHP(), hp_height)
      end
    }
  end

  Encounter.fight_enemy_menu = ActionMenu:new(options, "vertical", false, function(i)
    Encounter.enemy_selected_index = i
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Gets the encounter's act enemy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getActEnemyMenu()
  return Encounter.act_enemy_menu
end

--- Loads act enemy menu
function Encounter.loadActEnemyMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  for i, enemy in ipairs(Encounter.enemies) do
    options[i] = {
      text = Text:new("* " .. enemy:getName()),
      action = function()
        Encounter.enemy_selected_index = i
        Assets.playSound("menu_select")
        Encounter.setState(Constants.ENCOUNTER_STATES.ACT_MENU)
      end
    }
  end

  Encounter.act_enemy_menu = ActionMenu:new(options, "vertical", false, function(i)
    Encounter.enemy_selected_index = i
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Gets the encounter's act menus
--- @return Dummy.Encounter.ActionMenu[]
function Encounter.getActMenus()
  return Encounter.act_menus
end

--- Loads act menus
function Encounter.loadActMenus()
  Encounter.act_menus = {}
  for i, enemy in ipairs(Encounter.enemies) do
    --- @type Dummy.Menu.Options
    local options = {}

    if enemy:hasCheck() then
      table.insert(options, {
        text = Text:new("ENCOUNTER_MENU_ACT_CHECK"),
        action = function()
          Assets.playSound("menu_select")
          Encounter.dialogue_text:setText(enemy:getCheckText())
          Encounter.dialogue_text:setCanSkip(true)
          Encounter.setState(Constants.ENCOUNTER_STATES.TEXT_DIALOGUE)
        end
      })
    end

    for _, act in ipairs(enemy:getACTs()) do
      table.insert(options, {
        text = Text:new(act:getName()),
        action = function()
          Assets.playSound("menu_select")
          if type(act.use) == "function" then
            act:use()
          end
        end
      })
    end

    Encounter.act_menus[i] = ActionMenu:new(options, "horizontal", false, function()
      Encounter.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    end)
  end
end

--- Gets the encounter's item menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getItemMenu()
  return Encounter.item_menu
end

--- Loads item menu
function Encounter.loadItemMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  for _, item in ipairs(Player.getItems()) do
    table.insert(options, {
      text = Text:new(item:getShortName()),
      action = function()
        Assets.playSound("menu_select")
        if type(item.use) == "function" then
          item:use()
        end
      end
    })
  end

  Encounter.item_menu = ActionMenu:new(options, "horizontal", true, function()
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Gets the encounter's mercy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getMercyMenu()
  return Encounter.mercy_menu
end

--- Loads mercy menu
function Encounter.loadMercyMenu()
  --- @type Dummy.Menu.Options
  local options = {
    {
      text = Text:new("ENCOUNTER_MENU_MERCY_SPARE"),
      action = function()
        Assets.playSound("menu_select")
        -- self:setState(Constants.ENCOUNTER_STATES.NONE)
        Player.setHP(0)
      end
    }
  }

  if Encounter.canFlee() ~= false then
    table.insert(options, {
      text = Text:new("ENCOUNTER_MENU_MERCY_FLEE"),
      action = function()
        if Player.isFleeing() then return end

        Encounter.flee()
        Encounter.unselectAction()
        Encounter.leaveMenu()
      end,
      silent = true
    })
  end

  Encounter.mercy_menu = ActionMenu:new(options, "vertical", false, function()
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Sets current encounter state
--- @param state string
function Encounter.setState(state)
  assert(Constants.ENCOUNTER_STATES[state:upper()] ~= nil, "Unknown encounter state \"" .. tostring(state) .. "\"")

  Encounter.current_state = state
end

--- Starts action select
function Encounter.startActionSelect()
  Player.hide()

  Arena.reset(function()
    Encounter.action.index = math.abs(Encounter.action.index)
    Encounter.updateActions()

    Player.show()

    Encounter.leaveMenu()

    Encounter.dialogue_text:setText(Encounter.getText())
    Encounter.dialogue_text:setCanSkip(true)
    Encounter.dialogue_text:setVisible(true)
  end)
end

--- Updates action select
function Encounter.updateActionSelect()
  if Player.isHidden() then return end

  if Input.isPressed(Input.Left) then
    if Encounter.action.index <= Encounter.ACTIONS.FIGHT then
      Encounter.action.index = Encounter.ACTIONS.MERCY
    else
      Encounter.action.index = Encounter.action.index - 1
    end
    Encounter.updateActions()
    Assets.playSound("menu_move")
  elseif Input.isPressed(Input.Right) then
    if Encounter.action.index >= Encounter.ACTIONS.MERCY then
      Encounter.action.index = Encounter.ACTIONS.FIGHT
    else
      Encounter.action.index = Encounter.action.index + 1
    end
    Encounter.updateActions()
    Assets.playSound("menu_move")
  elseif Input.isPressed(Input.Confirm) then
    if Encounter.action.index == Encounter.ACTIONS.FIGHT and Encounter.fight_enemy_menu:getSize() > 0 and not Encounter.fight_enemy_menu:allDisabled() then
      Encounter.setState(Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU)
    elseif Encounter.action.index == Encounter.ACTIONS.ACT and Encounter.act_enemy_menu:getSize() > 0 and not Encounter.act_enemy_menu:allDisabled() then
      Encounter.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    elseif Encounter.action.index == Encounter.ACTIONS.ITEM then
      Encounter.loadItemMenu()
      if Encounter.item_menu:getSize() > 0 then
        Encounter.setState(Constants.ENCOUNTER_STATES.ITEM_MENU)
      end
    elseif Encounter.action.index == Encounter.ACTIONS.MERCY then
      Encounter.setState(Constants.ENCOUNTER_STATES.MERCY_MENU)
    end

    if Encounter.action.index > 0 then
      Assets.playSound("menu_select")
    end
  end
end

--- Loads encounter actions
function Encounter.loadActions()
  Encounter.action = {}
  Encounter.action.index = Encounter.ACTIONS.FIGHT

  -- FIGHT
  Encounter.action.fight_sprite = Sprite:new("fight")
  Encounter.action.fight_sprite:setPosition(32, 432)
  Encounter.action.fight_sprite:setOrigin(0)
  Encounter.action.fight_hover_sprite = Sprite:new("fight_hover")
  Encounter.action.fight_hover_sprite:setPosition(32, 432)
  Encounter.action.fight_hover_sprite:setOrigin(0)
  Encounter.action.fight_hover_sprite:setVisible(false)

  -- ACT
  Encounter.action.act_sprite = Sprite:new("act")
  Encounter.action.act_sprite:setPosition(185, 432)
  Encounter.action.act_sprite:setOrigin(0)
  Encounter.action.act_hover_sprite = Sprite:new("act_hover")
  Encounter.action.act_hover_sprite:setPosition(185, 432)
  Encounter.action.act_hover_sprite:setOrigin(0)
  Encounter.action.act_hover_sprite:setVisible(false)

  -- ITEM
  Encounter.action.item_sprite = Sprite:new("item")
  Encounter.action.item_sprite:setPosition(345, 432)
  Encounter.action.item_sprite:setOrigin(0)
  Encounter.action.item_hover_sprite = Sprite:new("item_hover")
  Encounter.action.item_hover_sprite:setPosition(345, 432)
  Encounter.action.item_hover_sprite:setOrigin(0)
  Encounter.action.item_hover_sprite:setVisible(false)

  -- MERCY
  Encounter.action.mercy_sprite = Sprite:new("mercy")
  Encounter.action.mercy_sprite:setPosition(500, 432)
  Encounter.action.mercy_sprite:setOrigin(0)
  Encounter.action.mercy_hover_sprite = Sprite:new("mercy_hover")
  Encounter.action.mercy_hover_sprite:setPosition(500, 432)
  Encounter.action.mercy_hover_sprite:setOrigin(0)
  Encounter.action.mercy_hover_sprite:setVisible(false)

  Encounter.updateActions()
end

--- Opens an action's menu
--- @param menu Dummy.Encounter.ActionMenu|nil
function Encounter.enterMenu(menu)
  if menu == nil or menu:getSize() <= 0 or menu:allDisabled() then
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    return
  end

  Encounter.leaveMenu()
  Encounter.current_menu = menu
  Encounter.current_menu:show()

  Encounter.dialogue_text:setVisible(false)
end

--- Leaves the current menu
function Encounter.leaveMenu()
  if Encounter.current_menu ~= nil then
    Encounter.current_menu:hide()
    Encounter.current_menu = nil
  end
end

--- Updates actions sprites and soul position
function Encounter.updateActions()
  Encounter.action.fight_sprite:setVisible(true)
  Encounter.action.act_sprite:setVisible(true)
  Encounter.action.item_sprite:setVisible(true)
  Encounter.action.mercy_sprite:setVisible(true)
  Encounter.action.fight_hover_sprite:setVisible(false)
  Encounter.action.act_hover_sprite:setVisible(false)
  Encounter.action.item_hover_sprite:setVisible(false)
  Encounter.action.mercy_hover_sprite:setVisible(false)

  local selected_sprite, selected_sprite_hover
  if Encounter.action.index == Encounter.ACTIONS.FIGHT then
    selected_sprite = Encounter.action.fight_sprite
    selected_sprite_hover = Encounter.action.fight_hover_sprite
  elseif Encounter.action.index == Encounter.ACTIONS.ACT then
    selected_sprite = Encounter.action.act_sprite
    selected_sprite_hover = Encounter.action.act_hover_sprite
  elseif Encounter.action.index == Encounter.ACTIONS.ITEM then
    selected_sprite = Encounter.action.item_sprite
    selected_sprite_hover = Encounter.action.item_hover_sprite
  elseif Encounter.action.index == Encounter.ACTIONS.MERCY then
    selected_sprite = Encounter.action.mercy_sprite
    selected_sprite_hover = Encounter.action.mercy_hover_sprite
  end

  if selected_sprite ~= nil then
    selected_sprite:setVisible(false)
    selected_sprite_hover:setVisible(true)

    local x, y = selected_sprite:getPosition()
    Player.setPosition(x + 16, y + 22, true)
  end
end

--- Unselects the current action
function Encounter.unselectAction()
  Encounter.action.index = -math.abs(Encounter.action.index)
  Encounter.updateActions()
end

--- Starts text dialogue
function Encounter.startTextDialogue()
  Encounter.dialogue_text:reset()
  Encounter.dialogue_text:setVisible(true)

  Encounter.unselectAction()
  Player.hide()
  Encounter.leaveMenu()
end

--- Updates text dialogue
function Encounter.updateTextDialogue()
  if Input.isPressed(Input.Confirm) and Encounter.dialogue_text:isDone() then
    Encounter.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
  end
end

--- Starts enemy dialogue
function Encounter.startEnemyDialogue()
  Encounter.dialogue_text:setVisible(false)

  Encounter.unselectAction()

  Arena.resize(130, 130, false, function()
    Encounter.enemy_hp_draw:setVisible(false)
    Encounter.enemy_hp_text:setVisible(false)
    Encounter.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  end)

  local x, y = Arena:getPosition()
  Player.setPosition(x, y - 65)
  Player.show()
end

--- Updates enemy dialogue
function Encounter.updateEnemyDialogue(dt)
  -- if Input.isPressed(Input.Confirm) then
  --   self.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  -- end
end

--- Starts attacking
function Encounter.startAttacking()
  Encounter.leaveMenu()
  Encounter.unselectAction()
  Player.hide()

  Encounter.target_sprite:setVisible(true)
  Encounter.target_sprite:setAlpha(1)
  Encounter.target_sprite:setScale(1)


  local attacking = false
  local attack_window_timer = nil
  local alpha = 1
  local scale_x = 1
  local attack_speed = 11

  local function attack(miss)
    if attacking then return end

    attacking = true
    Timer.cancel(attack_window_timer)

    local enemy = Encounter.enemies[Encounter.enemy_selected_index]
    local enemy_x, enemy_y = enemy:getPosition()
    Encounter.strike_sprite:setPosition(enemy_x, enemy_y)

    local damage = 0
    local enemy_hp_text_vel_y = -4

    local proceed_attack = function()
      local enemy_width, enemy_height = enemy:getSize()
      local enemy_top_y = enemy_y - enemy_height / 2 - 16

      if miss == true or damage == 0 then
        Encounter.miss_text:setPosition(enemy_x, enemy_top_y)
        Encounter.miss_text:setVisible(true)

        Timer.after(1, function()
          Encounter.miss_text:setVisible(false)
        end)
      else
        Assets.playSound("damage")

        enemy_width = math.max(100, enemy_width)
        local stretchfactor = enemy_width / enemy:getMaxHP()
        local width = math.round(enemy:getMaxHP() * stretchfactor)
        local enemy_current_hp = enemy:getHP()
        local enemy_hp_draw_width = math.round(enemy_current_hp * stretchfactor)
        local enemy_hp_draw_x = enemy_x - enemy_width / 2

        Timer.during(1, function(dt)
          enemy_current_hp = math.max(enemy:getHP(), enemy_current_hp - damage * dt)
          enemy_hp_draw_width = math.round(enemy_current_hp * stretchfactor)
        end)

        Encounter.enemy_hp_draw:setVisible(true)
        Encounter.enemy_hp_draw:setDraw(function()
          love.graphics.setColor(0, 0, 0, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x - 1, enemy_top_y - 1, width + 2, 15)
          love.graphics.setColor(0.25, 0.25, 0.25, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, width, 13)
          love.graphics.setColor(0, 1, 0, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, enemy_hp_draw_width, 13)
        end)

        local enemy_hp_text_x = enemy_x
        local enemy_hp_text_y_start = enemy_y - enemy_height / 2 - 31
        local enemy_hp_text_y = enemy_hp_text_y_start
        Encounter.enemy_hp_text:setPosition(enemy_hp_text_x, enemy_hp_text_y_start)
        Encounter.enemy_hp_text:setVisible(true)
        Encounter.enemy_hp_text:setText(tostring(damage))
        Encounter.enemy_hp_text_timer = Timer.during(1, function(dt)
          enemy_hp_text_vel_y = enemy_hp_text_vel_y + 0.5 * dt * 30
          enemy_hp_text_y = enemy_hp_text_y + enemy_hp_text_vel_y * dt * 30
          Encounter.enemy_hp_text:setPosition(enemy_hp_text_x, enemy_hp_text_y)

          if enemy_hp_text_y >= enemy_hp_text_y_start + 8 then
            Timer.cancel(Encounter.enemy_hp_text_timer)
            Encounter.enemy_hp_text:setPosition(enemy_hp_text_x, enemy_hp_text_y_start)
          end
        end)

        enemy:setHP(math.clamp(enemy:getHP() - damage, 0, enemy:getMaxHP()))
        if enemy:getHP() <= 0 then
          local fight_option = Encounter.fight_enemy_menu:getOptionByIndex(Encounter.enemy_selected_index)
          fight_option.disabled = true
          local act_option = Encounter.act_enemy_menu:getOptionByIndex(Encounter.enemy_selected_index)
          act_option.disabled = true
          if type(enemy.onKilled) == "function" then
            enemy:onKilled()
          end
        end
      end

      Timer.after(1, function()
        Timer.during(0.5, function(dt)
          alpha = math.clamp(alpha - 2.4 * dt, 0, 1)
          Encounter.target_sprite:setAlpha(alpha)

          scale_x = math.max(0.25, scale_x - 1.8 * dt)
          Encounter.target_sprite:setScale(scale_x, 1)

          if alpha <= 0 then
            Encounter.target_sprite:setVisible(false)
          end
        end)

        Encounter.target_bar_sprite:setVisible(false)

        Timer.after(0.05, function()
          Encounter.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
        end)
      end)
    end

    if miss == true then
      proceed_attack()
    else
      local target_x = Encounter.target_sprite:getPosition()
      local target_width = Encounter.target_sprite:getWidth()
      local target_bar_x = Encounter.target_bar_sprite:getPosition()
      local bonus_factor = math.abs(target_x - target_bar_x)
      local stretch = (target_width - bonus_factor) / target_width
      damage = math.max(0, Player:getAT() - enemy:getDF() + (math.random() * 2))
      if bonus_factor <= 12 then
        damage = math.round(damage * 2.2)
      else
        damage = math.round(damage * 2 * stretch)
      end

      Encounter.strike_sprite:setVisible(true)
      Encounter.strike_sprite:setScale(stretch * 2 - 0.5)
      local strike_speed_base = 0.5 - stretch / 4
      local strike_speed = 1 / (strike_speed_base * 30)
      Encounter.strike_sprite:setSpeed(strike_speed)
      Encounter.strike_sprite:play()
      Encounter.target_bar_sprite:play()
      Assets.playSound("strike")
      local damage_delay = (1 / strike_speed_base * 6 + 3) / 30
      Timer.after(damage_delay, proceed_attack)
    end
  end

  Encounter.target_bar_sprite:setPosition(22, 320)
  Encounter.target_bar_sprite:setVisible(true)
  Encounter.target_bar_sprite:setFrame(1)

  local bar_speed = attack_speed + (math.random() * 2)
  attack_window_timer = Timer.during(2, function(dt)
    local x, y = Encounter.target_bar_sprite:getPosition()
    local target_bar_x = x + bar_speed * dt * 30
    Encounter.target_bar_sprite:setPosition(target_bar_x, y)

    local target_x = Encounter.target_sprite:getPosition()
    local width = Encounter.target_sprite:getWidth()
    if target_bar_x > target_x + width / 2 then
      attack(true)
    end

    if Input.isPressed(Input.Confirm) then
      attack()
    end
  end)
end

--- Starts defending
function Encounter.startDefending()
  Encounter.unselectAction()

  -- default wave arena size
  Arena.resize(130, 130)

  ---@diagnostic disable-next-line: invisible
  Encounter.wave:__start()
end

--- Updates defending
function Encounter.updateDefending(dt)
  Player.update(dt)

  ---@diagnostic disable-next-line: invisible
  Encounter.wave:__update(dt)
end

--- Updates the encounter
function Encounter.update(dt)
  -- start
  if Encounter.current_state ~= Encounter.previous_state then
    Encounter.onStateChange(Encounter.current_state, Encounter.previous_state)
    Encounter.previous_state = Encounter.current_state

    if Encounter.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
      Encounter.startActionSelect()
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
      Encounter.loadFightEnemyMenu()
      Encounter.enterMenu(Encounter.fight_enemy_menu)
      if Encounter.current_menu == Encounter.fight_enemy_menu then
        Encounter.fight_enemy_menu:selectByIndex(Encounter.enemy_selected_index, true)
      end
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
      Encounter.loadActEnemyMenu()
      Encounter.enterMenu(Encounter.act_enemy_menu)
      if Encounter.current_menu == Encounter.act_enemy_menu then
        Encounter.act_enemy_menu:selectByIndex(Encounter.enemy_selected_index, true)
      end
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
      Encounter.loadActMenus()
      Encounter.enterMenu(Encounter.act_menus[Encounter.enemy_selected_index])
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
      Encounter.loadItemMenu()
      Encounter.enterMenu(Encounter.item_menu)
      Encounter.item_menu:select(0, 0, true)
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
      Encounter.loadMercyMenu()
      Encounter.enterMenu(Encounter.mercy_menu)
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.TEXT_DIALOGUE then
      Encounter.startTextDialogue()
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
      Encounter.startEnemyDialogue()
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ATTACKING then
      Encounter.startAttacking()
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
      Encounter.startDefending()
    end
  end

  -- update
  if Encounter.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
    Encounter.updateActionSelect()
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
    if Encounter.current_menu ~= nil then Encounter.current_menu:update() end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
    if Encounter.current_menu ~= nil then Encounter.current_menu:update() end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
    if Encounter.current_menu ~= nil then Encounter.current_menu:update() end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
    if Encounter.current_menu ~= nil then Encounter.current_menu:update() end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
    if Encounter.current_menu ~= nil then Encounter.current_menu:update() end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.TEXT_DIALOGUE then
    Encounter.updateTextDialogue()
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE then
    Encounter.updateEnemyDialogue(dt)
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
    Encounter.updateDefending(dt)
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DONE then
    Scene.change("MAIN_MENU")
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.NONE then
  end

  if Player.getHP() <= 0 then
    local x, y = Player.getPosition()
    Scene.change("GAME_OVER", x, y)
  end
end

--- Called when the encounter state changes
--- @param current_state string
--- @param previous_state string
function Encounter.onStateChange(current_state, previous_state) end

return Encounter
