--- @class Dummy.Encounter
---
--- @field protected text Dummy.Text.Text
--- @field protected can_flee boolean
--- @field protected music love.Source
--- @field protected enemies Dummy.Enemy[]
--- @field protected waves Dummy.Wave[]
--- @field protected current_state string
--- @field protected previous_state string
--- @field protected current_menu Dummy.Encounter.ActionMenu|nil
--- @field protected bg_sprite Dummy.Sprite
--- @field protected dialogue_text Dummy.DialogueText
--- @field protected bubble_dialogues Dummy.DialogueBubble[]
--- @field protected target_sprite Dummy.Sprite
--- @field protected target_bar_sprite Dummy.Sprite
--- @field protected miss_text Dummy.Text
--- @field protected strike_sprite Dummy.Sprite
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_text Dummy.Text
--- @field protected player_hp_sprite Dummy.Sprite
--- @field protected player_hp_value_text Dummy.Text
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
--- @field protected action table
--- @field protected action.index number
--- @field protected action.fight_sprite Dummy.Sprite
--- @field protected action.fight_hover_sprite Dummy.Sprite
--- @field protected action.act_sprite Dummy.Sprite
--- @field protected action.act_hover_sprite Dummy.Sprite
--- @field protected action.item_sprite Dummy.Sprite
--- @field protected action.item_hover_sprite Dummy.Sprite
--- @field protected action.mercy_sprite Dummy.Sprite
--- @field protected action.mercy_hover_sprite Dummy.Sprite
--- @field protected exp_reward number
--- @field protected gold_reward number
--- @field protected defend_timer table|nil
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
function Encounter.getClassName()
  return "Dummy.Encounter"
end

--- Gets the encounter's text
--- @return Dummy.Text.Text
function Encounter.getText()
  return Encounter.text or ""
end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
function Encounter.setText(text)
  Encounter.text = text
  Encounter.dialogue_text:setText(text)
end

--- Gets the encounter's enemies
--- @return Dummy.Enemy[]
function Encounter.getEnemies()
  return Encounter.enemies
end

--- Adds one or more enemies to the encounter
--- @param enemy Dummy.Enemy|Dummy.Enemy[]
--- @param ... Dummy.Enemy
function Encounter.addEnemy(enemy, ...)
  local enemies = { enemy, ... }
  if #enemy >= 1 then enemies = enemy end
  for _, enemy in ipairs(enemies) do
    table.insert(Encounter.enemies, enemy)
  end

  Encounter.loadFightEnemyMenu()
  Encounter.loadActEnemyMenu()
end

--- Sets one or more waves to the encounter
--- @param wave Dummy.Wave
function Encounter.setWave(wave, ...)
  Encounter.waves = {}

  local waves = { wave, ... }
  if #wave >= 1 then waves = wave end
  for _, wave in ipairs(waves) do
    table.insert(Encounter.waves, wave)
  end
end

--- Wether the player can flee the encounter
--- @return boolean
function Encounter.canFlee()
  return Encounter.can_flee
end

--- Sets wether the player can flee the encounter
--- @param can_flee boolean
function Encounter.setCanFlee(can_flee)
  Encounter.can_flee = can_flee
end

--- Gets the encounter's text
--- @return love.Source
function Encounter.getMusic()
  return Encounter.music
end

--- Sets the encounter music
--- @param music string
function Encounter.setMusic(music)
  Encounter.music = Assets.playMusic(music)
  Encounter.music:setVolume(0.5)
end

--- Gets the encounter dialogue text
--- @return Dummy.DialogueText
function Encounter.getDialogueText()
  return Encounter.dialogue_text
end

--- Plays a dialogue text
--- @param text Dummy.Text.Text|Dummy.Text.Text[]
--- @return Dummy.DialogueText
function Encounter.playDialogueText(text)
  Encounter.dialogue_text:setText(text)
  Encounter.dialogue_text:setVisible(true)
  Encounter.dialogue_text:setCanSkip(false)
  Encounter.setState(Constants.ENCOUNTER_STATES.TEXT_DIALOGUE)
  return Encounter.dialogue_text
end

--- Plays a dialogue bubble
--- @param text Dummy.Text.Text|Dummy.Text.Text[]
--- @param bubble_type? Dummy.DialogueBubble.Type
--- @return Dummy.DialogueBubble
function Encounter.playDialogueBubble(text, bubble_type)
  local dialogue = DialogueBubble:new(text, bubble_type)
  table.insert(Encounter.bubble_dialogues, dialogue)
  return dialogue
end

--- Wether all the enemies are spared
--- @return boolean
function Encounter.allSpared()
  for _, enemy in ipairs(Encounter.enemies) do
    if not enemy:isSpared() then
      return false
    end
  end

  return true
end

--- Wether all the enemies are dead
--- @return boolean
function Encounter.allDead()
  for _, enemy in ipairs(Encounter.enemies) do
    if not enemy:isKilled() then
      return false
    end
  end

  return true
end

--- Wether all the enemies are spared or killed
--- @return boolean
function Encounter.allSparedOrKilled()
  if Encounter.has_won then return true end

  for _, enemy in ipairs(Encounter.enemies) do
    if not enemy:isSpared() and not enemy:isKilled() then
      return false
    end
  end

  return true
end

--- Checks if the encounter is done
function Encounter.checkEncounterEnd()
  if Encounter.has_won then
    Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
  elseif Encounter.allSparedOrKilled() then
    Encounter.win()
  else
    Encounter.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
  end
end

--- Wins the encounter
--- @param exp? number EXP reward
--- @param gold? number GOLD reward
function Encounter.win(exp, gold)
  Encounter.exp_reward = Utils.getOrDefault(exp, Encounter.exp_reward)
  Encounter.gold_reward = Utils.getOrDefault(gold, Encounter.gold_reward)

  local current_music = Assets.getCurrentMusic()
  if current_music ~= nil then
    current_music:stop()
  end

  local win_text = Lang.translate("ENCOUNTER_WIN_REWARD", Encounter.exp_reward, Encounter.gold_reward)
  local level_old = Player.getLV()
  Player.setEXP(Player.getEXP() + Encounter.exp_reward)
  Player.setGold(Player.getGold() + Encounter.gold_reward)
  local level = Player.getLV()
  if level ~= level_old then
    win_text = win_text .. "\n" .. Lang.translate("ENCOUNTER_WIN_LEVEL_UP", level)
  end
  Encounter.has_won = true
  Encounter.playDialogueText(win_text)
  Encounter.dialogue_text:setCanSkip(false)
end

--- Gets the selected enemy
--- @return Dummy.Enemy|nil
function Encounter.getSelectedEnemy()
  return Encounter.enemies[Encounter.enemy_selected_index]
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
  Encounter.dialogue_text = DialogueText:new(Encounter.getText())
  Encounter.dialogue_text:setPosition(52, 270)
  Encounter.dialogue_text:setOrigin(0, 0)
  Encounter.dialogue_text:setFont(Assets.getFont("main_text"))
  Encounter.dialogue_text:setScale(2)
  Encounter.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  Encounter.dialogue_text:setMaxWidth(Constants.ARENA.TEXTBOX_WIDTH - Constants.ARENA.BORDER_WIDTH * 2)
  Encounter.dialogue_text:setCanSkip(true)

  Encounter.bubble_dialogues = {}

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
  Encounter.miss_text:setLayer(Constants.LAYERS.ABOVE_UI)

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

  -- player name
  Encounter.player_name_text = Text:new(Player.getName())
  Encounter.player_name_text:setPosition(30, 400)
  Encounter.player_name_text:setOrigin(0)
  Encounter.player_name_text:setFont(Assets.getFont("curs"))

  -- player level
  Encounter.player_lv_text = Text:new("")
  Encounter.player_lv_text:setPosition(174, 400)
  Encounter.player_lv_text:setOrigin(0)
  Encounter.player_lv_text:setFont(Assets.getFont("curs"))

  -- player hp text
  Encounter.player_hp_sprite = Sprite:new("hp")
  Encounter.player_hp_sprite:setPosition(240, 400)
  Encounter.player_hp_sprite:setOrigin(0)
  Encounter.player_hp_value_text = Text:new("")
  Encounter.player_hp_value_text:setPosition(314, 400)
  Encounter.player_hp_value_text:setOrigin(0)
  Encounter.player_hp_value_text:setFont(Assets.getFont("curs"))

  -- player hp bar
  local player_hp_bar_drawable = Drawable:new()
  player_hp_bar_drawable:setLayer(Constants.LAYERS.UI)
  function player_hp_bar_drawable:draw()
    local max_hp_bar_width = math.clamp(5 * Player.getLV() + 20, 25, 120)
    local hp_bar_width = max_hp_bar_width * Player.getHP() / Player.getMaxHP()

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 275, 400, max_hp_bar_width, 21)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", 275, 400, hp_bar_width, 21)
  end

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
  Encounter.enemy_selected_index = 1

  Encounter.waves = {}

  Encounter.exp_reward = 0
  Encounter.gold_reward = 0
  Encounter.has_won = false
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
    local text = Text:new("* " .. enemy:getName())
    if enemy:getCanBeSpared() then
      text:setColor(1, 1, 0)
    else
      text:setColor(1, 1, 1)
    end

    options[i] = {
      text = text,
      action = function()
        Encounter.enemy_selected_index = i
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
      end,
      disabled = enemy:isKilled() or enemy:isSpared()
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
    local text = Text:new("* " .. enemy:getName())
    if enemy:getCanBeSpared() then
      text:setColor(1, 1, 0)
    else
      text:setColor(1, 1, 1)
    end

    options[i] = {
      text = text,
      action = function()
        Encounter.enemy_selected_index = i
        Encounter.setState(Constants.ENCOUNTER_STATES.ACT_MENU)
      end,
      disabled = enemy:isKilled() or enemy:isSpared()
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
  local spare_text = Text:new("ENCOUNTER_MENU_MERCY_SPARE")
  spare_text:setColor(1, 1, 1)
  for _, enemy in ipairs(Encounter.enemies) do
    if enemy:getCanBeSpared() and not enemy:isSpared() then
      spare_text:setColor(1, 1, 0)
      break
    end
  end

  --- @type Dummy.Menu.Options
  local options = {
    {
      text = spare_text,
      action = function()
        local has_spared = false
        for _, enemy in ipairs(Encounter.enemies) do
          if enemy:getCanBeSpared() then
            enemy:spare()
            enemy:onSpared(true)
            has_spared = true
          end

          if enemy:isSpared() then
            local gold_ratio = (enemy:getMaxHP() - enemy:getHP()) / enemy:getMaxHP()
            if gold_ratio == 0 then Encounter.gold_reward = Encounter.gold_reward + enemy:getGold() end
            Encounter.gold_reward = Encounter.gold_reward + math.floor(enemy:getGold() * gold_ratio)
          end
        end

        if not Encounter.allSparedOrKilled() then
          if not has_spared then
            for _, enemy in ipairs(Encounter.enemies) do
              if not enemy:isKilled() then
                if type(enemy.onSpared) == "function" then
                  enemy:onSpared(false)
                end
              end
            end
          end
        end

        Encounter.checkEncounterEnd()
      end
    }
  }

  if Encounter.canFlee() ~= false then
    table.insert(options, {
      text = Text:new("ENCOUNTER_MENU_MERCY_FLEE"),
      action = function()
        Player.flee()

        Timer.after(1, function()
          Fader.fadeIn(1 / 2.4, function()
            Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
          end)
        end)

        Encounter.mercy_menu:setActive(false)
        Encounter.unselectAction()
        Encounter.leaveMenu()

        --- @type Dummy.Text.Text
        local flee_text = ""
        if Encounter.exp_reward > 0 or Encounter.gold_reward > 0 then
          flee_text = { "ENCOUNTER_FLEE_REWARD", Encounter.exp_reward, Encounter.gold_reward }
        else
          local flee_value = love.math.random(20)
          if flee_value <= 1 then
            flee_text = "ENCOUNTER_FLEE_1"
          elseif flee_value == 2 then
            flee_text = "ENCOUNTER_FLEE_2"
          elseif flee_value == 3 then
            flee_text = "ENCOUNTER_FLEE_3"
          else
            flee_text = "ENCOUNTER_FLEE_4"
          end
        end

        Encounter.dialogue_text:setText(flee_text)
        Encounter.dialogue_text:setCanSkip(true)
        Encounter.dialogue_text:setVisible(true)
        Encounter.dialogue_text:skip()
      end,
      silent = true
    })
  end

  Encounter.mercy_menu = ActionMenu:new(options, "vertical", false, function()
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Gets the current encounter state
--- @return string
function Encounter.getCurrentState()
  return Encounter.current_state
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

  Arena.reset()

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
    Encounter.checkEncounterEnd()
  end
end

--- Starts enemy dialogue
function Encounter.startEnemyDialogue()
  Encounter.dialogue_text:setVisible(false)

  Encounter.unselectAction()
  Encounter.leaveMenu()
  Player.hide()

  for _, enemy in ipairs(Encounter.enemies) do
    if not enemy:isKilled() and not enemy:isSpared() then
      if type(enemy.onDialogue) == "function" then
        enemy:onDialogue()
      end
    end
  end

  if #Encounter.waves > 0 then
    Arena.resize(Constants.ARENA.DEFAULT_WIDTH, Constants.ARENA.DEFAULT_HEIGHT, false, function()
      if #Encounter.bubble_dialogues <= 0 then
        Encounter.setState(Constants.ENCOUNTER_STATES.DEFENDING)
      end
    end)

    local x, y = Arena:getPosition()
    Player.setPosition(x, y - 65)
    Player.show()
  else
    if #Encounter.bubble_dialogues <= 0 then
      Encounter.setState(Constants.ENCOUNTER_STATES.DEFENDING)
    end
  end
end

--- Updates enemy dialogue
function Encounter.updateEnemyDialogue()
  if #Encounter.bubble_dialogues <= 0 then return end

  local all_done = true
  for _, dialogue in ipairs(Encounter.bubble_dialogues) do
    if not dialogue:getDialogue():isDone() then
      all_done = false
      break
    end
  end

  if all_done then
    local function defend()
      for _, dialogue in ipairs(Encounter.bubble_dialogues) do
        dialogue:remove()
      end
      Encounter.bubble_dialogues = {}
      Encounter.defend_timer = nil
      Encounter.setState(Constants.ENCOUNTER_STATES.DEFENDING)
    end

    if Encounter.defend_timer == nil then
      Encounter.defend_timer = Timer.after(1, defend)
    end

    if Input.isPressed(Input.Confirm) then
      Timer.cancel(Encounter.defend_timer)
      Encounter.defend_timer = nil
      defend()
    end
  end
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
    attack_window_timer = nil

    local enemy = Encounter.enemies[Encounter.enemy_selected_index]
    local enemy_x, enemy_y = enemy:getPosition()
    Encounter.strike_sprite:setPosition(enemy_x, enemy_y - enemy:getHeight() / 2)

    local damage = 0
    local enemy_hp_text_vel_y = -4

    local do_attack = function()
      if type(enemy.onBeforeDamage) == "function" then
        damage = Utils.getOrDefault(enemy:onBeforeDamage(damage), damage)
      end

      local enemy_width, enemy_height = enemy:getWidth(), enemy:getHeight()
      local enemy_top_y = enemy_y - enemy_height - 16

      local function end_attack()
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

        if not Encounter.allSparedOrKilled() then
          Timer.after(0.05, function()
            Encounter.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
          end)
        end
      end

      if miss == true or damage == 0 then
        Encounter.miss_text:setPosition(enemy_x, enemy_top_y)
        Encounter.miss_text:setVisible(true)

        Timer.after(1, function()
          Encounter.miss_text:setVisible(false)
        end)

        end_attack()
      else
        Assets.playSound("damage")

        enemy_width = math.max(100, enemy_width)
        local stretchfactor = enemy_width / enemy:getMaxHP()
        local width = math.round(enemy:getMaxHP() * stretchfactor)
        local enemy_apparent_hp = enemy:getHP()
        local enemy_hp_draw_width = math.round(enemy_apparent_hp * stretchfactor)
        local enemy_hp_draw_x = enemy_x - enemy_width / 2

        local fps = Config["fps"]
        if fps > 30 then
          Timer.during(1, function(dt)
            enemy_apparent_hp = math.max(enemy:getHP(), enemy_apparent_hp - damage * dt)
            enemy_hp_draw_width = math.round(enemy_apparent_hp * stretchfactor)
          end)
        else
          Timer.every(2 / 30, function()
            enemy_apparent_hp = math.max(enemy:getHP(), enemy_apparent_hp - (damage / 15))
            enemy_hp_draw_width = math.round(enemy_apparent_hp * stretchfactor)
          end, 15)
        end

        Encounter.enemy_hp_draw:setVisible(true)
        function Encounter.enemy_hp_draw:draw()
          love.graphics.setColor(0, 0, 0, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x - 1, enemy_top_y - 1, width + 2, 15)
          love.graphics.setColor(0.25, 0.25, 0.25, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, width, 13)
          love.graphics.setColor(0, 1, 0, 1)
          love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, enemy_hp_draw_width, 13)
        end

        local enemy_hp_text_x = enemy_x
        local enemy_hp_text_y_start = enemy_y - enemy_height - 31
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
            Encounter.enemy_hp_text_timer = nil
            Encounter.enemy_hp_text:setPosition(enemy_hp_text_x, enemy_hp_text_y_start)
          end
        end)

        Timer.after(1.5, function()
          Encounter.enemy_hp_draw:setVisible(false)
          Encounter.enemy_hp_text:setVisible(false)
        end)

        if type(enemy.onDamage) == "function" then
          enemy:onDamage(damage)
        end

        enemy:setHP(math.clamp(enemy:getHP() - damage, 0, enemy:getMaxHP()))

        if enemy:getHurtSound() ~= nil then
          Timer.after(0.37, function()
            if enemy:getHurtSound() ~= nil then
              enemy:getHurtSound():play()
            end
          end)
        end

        local shudder = 16
        Timer.every(2 / 30, function()
          if shudder == 0 then return end

          local x, y = enemy:getPosition()
          enemy:setPosition(x + shudder, y)
          if shudder < 0 then
            shudder = -(shudder + 2)
          else
            shudder = -shudder
          end

          if shudder == 0 then
            if enemy:isKilled() then
              Encounter.exp_reward = Encounter.exp_reward + enemy:getEXP()
              Encounter.gold_reward = Encounter.gold_reward + enemy:getGold()

              if type(enemy.onKilled) == "function" then
                enemy:onKilled()
              end

              enemy:vaporize()
            else
              if type(enemy.onAfterDamage) == "function" then
                enemy:onAfterDamage()
              end
            end

            Encounter.checkEncounterEnd()
          end
        end, 16)

        Timer.after(1, function()
          end_attack()
        end)
      end
    end

    if miss == true then
      do_attack()
    else
      local target_x = Encounter.target_sprite:getPosition()
      local target_width = Encounter.target_sprite:getWidth()
      local target_bar_x = Encounter.target_bar_sprite:getPosition()
      local bonus_factor = math.abs(target_x - target_bar_x)
      local stretch = (target_width - bonus_factor) / target_width
      damage = math.max(0, Player:getAT() - enemy:getDF() + (love.math.random() * 2))
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
      Timer.after(damage_delay, do_attack)
    end
  end

  Encounter.target_bar_sprite:setPosition(22, 320)
  Encounter.target_bar_sprite:setVisible(true)
  Encounter.target_bar_sprite:setFrame(1)

  local bar_speed = attack_speed + (love.math.random() * 2)
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

  if #Encounter.waves > 0 then
    -- default wave arena size
    Arena.resize(Constants.ARENA.DEFAULT_WIDTH, Constants.ARENA.DEFAULT_HEIGHT)

    for _, wave in ipairs(Encounter.waves) do
      --- @diagnostic disable-next-line: invisible
      wave:__start()
    end
  end
end

--- Updates defending
function Encounter.updateDefending(dt)
  Player.update(dt)

  local all_done = true
  for _, wave in ipairs(Encounter.waves) do
    --- @diagnostic disable-next-line: invisible
    wave:__update(dt)

    if not wave:isDone() then
      all_done = false
    end
  end

  if all_done then
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end
end

--- Updates the encounter
function Encounter.update(dt)
  -- start
  if Encounter.current_state ~= Encounter.previous_state then
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
    Encounter.updateEnemyDialogue()
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DEFENDING then
    Encounter.updateDefending(dt)
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DONE then
    Scene.change("MAIN_MENU")
  end

  if Player.getHP() <= 0 then
    local x, y = Player.getPosition()
    Scene.change("GAME_OVER", x, y)
  end

  -- player UI
  Encounter.updatePlayerUI()

  for _, enemy in ipairs(Encounter.enemies) do
    if type(enemy.update) == "function" then
      enemy:update(dt)
    end
  end
end

--- Updates the player UI
function Encounter.updatePlayerUI()
  Encounter.player_name_text:setText(Player.getName())
  Encounter.player_lv_text:setPosition(Encounter.player_name_text:getWidth() + 57, 400)
  Encounter.player_lv_text:setText(Lang.translate("ENCOUNTER_STAT_LV") .. " " .. tostring(Player.getLV()))
  Encounter.player_hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 400)
  Encounter.player_hp_value_text:setText(string.format("%02d", Player.getHP()) .. " / " .. tostring(Player.getMaxHP()))
end

return Encounter
