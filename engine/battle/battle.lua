--- @class Dummy.Battle.Data
---
--- @field text? string first displayed text of the encounter
--- @field music? string music to play when the encounter starts
--- @field enemies Dummy.Battle.Enemy[] list of enemies in the encounter
--- @field x? number target position x of the heart
--- @field y? number target position y of the heart

--- @class Dummy.Battle
---
--- @field protected music love.Source
--- @field protected bg_sprite Dummy.Sprite
--- @field protected text Dummy.Text.Text[]
--- @field protected current_state string
--- @field protected previous_state string
--- @field protected current_menu Dummy.Battle.ActionMenu|nil
--- @field protected dialogue_text Dummy.DialogueText
--- @field protected bubble_dialogues Dummy.DialogueBubble[]
--- @field protected can_skip_bubble_dialogues boolean
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
--- @field protected enemy_hp_text_timer Dummy.Timer.Handle|nil
--- @field protected battle_music love.Source
--- @field protected fight_enemy_menu Dummy.Battle.ActionMenu
--- @field protected act_enemy_menu Dummy.Battle.ActionMenu
--- @field protected act_menus Dummy.Battle.ActionMenu[]
--- @field protected item_menu Dummy.Battle.ActionMenu
--- @field protected mercy_menu Dummy.Battle.ActionMenu
--- @field protected enemy_selected_index number
--- @field protected action_index number
--- @field protected action_fight_sprite Dummy.Sprite
--- @field protected action_fight_hover_sprite Dummy.Sprite
--- @field protected action_act_sprite Dummy.Sprite
--- @field protected action_act_hover_sprite Dummy.Sprite
--- @field protected action_item_sprite Dummy.Sprite
--- @field protected action_item_hover_sprite Dummy.Sprite
--- @field protected action_mercy_sprite Dummy.Sprite
--- @field protected action_mercy_hover_sprite Dummy.Sprite
--- @field protected is_attacking boolean
--- @field protected attack_window_timer Dummy.Timer.Handle|nil
local Battle = {}

--- Loads the encounter
function Battle.load()
  -- background
  Battle.bg_sprite = Sprite:new("battle_bg")
  Battle.bg_sprite:setOrigin(0, 0)
  Battle.bg_sprite:setLayer(Constants.LAYERS.BOTTOM)

  -- state
  Battle.previous_state = Constants.BATTLE_STATES.ACTION_SELECT
  Battle.current_state = Constants.BATTLE_STATES.ACTION_SELECT

  -- actions
  Battle.loadActions()

  -- textbox dialogue
  Battle.dialogue_text = DialogueText:new(table.unpack(Battle.getText() or {}))
  Battle.dialogue_text:setPosition(52, 270)
  Battle.dialogue_text:setOrigin(0, 0)
  Battle.dialogue_text:setFont("main_text")
  Battle.dialogue_text:setCharacterWidth(8)
  Battle.dialogue_text:setCharacterHeight(16)
  Battle.dialogue_text:setScale(2)
  Battle.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)

  Battle.bubble_dialogues = {}
  Battle.can_skip_bubble_dialogues = false

  -- attack target
  Battle.target_sprite = Sprite:new("target")
  Battle.target_sprite:setPosition(319, 320)
  Battle.target_sprite:setLayer(Constants.LAYERS.UI)
  Battle.target_sprite:setVisible(false)
  Battle.target_bar_sprite = Sprite:new({ "target_bar1", "target_bar2" }, 0.1, nil, false)
  Battle.target_bar_sprite:setVisible(false)
  Battle.target_bar_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  -- miss
  Battle.miss_text = Text:new("BATTLE_ATTACK_MISS")
  Battle.miss_text:setVisible(false)
  Battle.miss_text:setFont("damage")
  Battle.miss_text:setColor(0.87, 0.87, 0.87)
  Battle.miss_text:setLayer(Constants.LAYERS.ABOVE_UI)

  -- strike
  Battle.strike_sprite = Sprite:new({
    "strike1",
    "strike2",
    "strike3",
    "strike4",
    "strike5",
    "strike6"
  }, 4 / 30, false, false, false)
  Battle.strike_sprite:setOrigin(0.5, 0.5)
  Battle.strike_sprite:setScale(1.5)
  Battle.strike_sprite:setVisible(false)
  Battle.strike_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  -- player name
  Battle.player_name_text = Text:new(Player.getName())
  Battle.player_name_text:setPosition(30, 400)
  Battle.player_name_text:setOrigin(0)
  Battle.player_name_text:setFont("curs")

  -- player level
  Battle.player_lv_text = Text:new("")
  Battle.player_lv_text:setPosition(174, 400)
  Battle.player_lv_text:setOrigin(0)
  Battle.player_lv_text:setFont("curs")

  -- player hp text
  Battle.player_hp_sprite = Sprite:new("hp")
  Battle.player_hp_sprite:setPosition(240, 400)
  Battle.player_hp_sprite:setOrigin(0)
  Battle.player_hp_value_text = Text:new("")
  Battle.player_hp_value_text:setPosition(314, 400)
  Battle.player_hp_value_text:setOrigin(0)
  Battle.player_hp_value_text:setFont("curs")

  -- player hp bar
  local player_hp_bar_drawable = Drawable:new()
  player_hp_bar_drawable:setLayer(Constants.LAYERS.UI)
  function player_hp_bar_drawable.draw(_self)
    if not _self:isVisible() then return end

    local max_hp_bar_width = math.clamp(5 * Player.getLV() + 20, 25, 120)
    local hp_bar_width = max_hp_bar_width * Player.getHP() / Player.getMaxHP()

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", 275, 400, max_hp_bar_width, 21)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.rectangle("fill", 275, 400, hp_bar_width, 21)
  end

  -- enemy hp bar & damage text
  Battle.enemy_hp_draw = Drawable:new()
  Battle.enemy_hp_draw:setLayer(Constants.LAYERS.ABOVE_UI)
  Battle.enemy_hp_draw:setVisible(false)

  Battle.enemy_hp_text = Text:new("")
  Battle.enemy_hp_text:setColor(1, 0, 0)
  Battle.enemy_hp_text:setLayer(Constants.LAYERS.ABOVE_UI)
  Battle.enemy_hp_text:setFont("damage")
  Battle.enemy_hp_text:setScale(1)
  Battle.enemy_hp_text:setVisible(false)

  -- menus
  Battle.fight_enemy_menu = nil
  Battle.act_enemy_menu = nil
  Battle.act_menus = {}
  Battle.item_menu = nil
  Battle.mercy_menu = nil

  Battle.enemy_selected_index = 1

  Battle.has_won = false

  Battle.is_attacking = false

  local music = Assets.getCurrentMusic()
  if music ~= nil then
    music:stop()
  end
end

--- Starts the encounter
--- @param encounter Dummy.Battle.Encounter
function Battle.start(encounter)
  Battle.encounter = encounter

  if type(encounter.onStart) == "function" then
    encounter:onStart()
  end
end

--- Gets the current battle encounter
--- @return Dummy.Battle.Encounter
function Battle.getEncounter()
  return Battle.encounter
end

--- Gets the encounter's text
--- @return love.Source
function Battle.getMusic()
  return Battle.music
end

--- Sets the encounter music
--- @param music string
function Battle.setMusic(music)
  Battle.music = Assets.playMusic(music)
  Battle.music:setVolume(0.5)
end

--- Gets the encounter background sprite
--- @return Dummy.Sprite
function Battle.getBackgroundSprite()
  return Battle.bg_sprite
end

--- Sets the encounter background sprite
--- @param sprite Dummy.Sprite
function Battle.setBackgroundSprite(sprite)
  Battle.bg_sprite = sprite
end

--- Gets the encounter's text
--- @return Dummy.Text.Text[]
function Battle.getText()
  return Battle.text or {}
end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Battle.setText(text, ...)
  Battle.text = { text, ... }
  Battle.dialogue_text:setText(text, ...)
end

--- Gets the encounter dialogue text
--- @return Dummy.DialogueText
function Battle.getDialogueText()
  return Battle.dialogue_text
end

--- Plays a dialogue text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Battle.playDialogueText(text, ...)
  Battle.dialogue_text:setText(text, ...)
  Battle.dialogue_text:setVisible(true)
  Battle.setState(Constants.BATTLE_STATES.TEXT_DIALOGUE)
  return Battle.dialogue_text
end

--- Plays a dialogue bubble
--- @param bubble_type Dummy.DialogueBubble.Type
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueBubble
function Battle.playDialogueBubble(bubble_type, text, ...)
  local dialogue = DialogueBubble:new(bubble_type, text, ...)
  table.insert(Battle.bubble_dialogues, dialogue)
  return dialogue
end

--- Sets the selected action
--- @param action number
function Battle.setAction(action)
  Soul.getSprite():setVisible(true)
  Battle.action_index = math.clamp(action, 1, 4)
  Battle.updateActions()
end

--- Disables the selected action
function Battle.disableAction()
  Soul.getSprite():setVisible(false)
  Battle.action_index = -math.abs(Battle.action_index)
  Battle.updateActions()
end

--- Wether all the enemies are spared
--- @return boolean
function Battle.allSpared()
  for _, enemy in ipairs(Battle.encounter:getEnemies()) do
    if not enemy:isSpared() then
      return false
    end
  end

  return true
end

--- Wether all the enemies are dead
--- @return boolean
function Battle.allDead()
  for _, enemy in ipairs(Battle.encounter:getEnemies()) do
    if not enemy:isKilled() then
      return false
    end
  end

  return true
end

--- Wether all the enemies are spared or killed
--- @return boolean
function Battle.allSparedOrKilled()
  if Battle.has_won then return true end

  for _, enemy in ipairs(Battle.encounter:getEnemies()) do
    if not enemy:isSpared() and not enemy:isKilled() then
      return false
    end
  end

  return true
end

--- Checks if the encounter is done
function Battle.checkEncounterEnd()
  if Battle.has_won then
    Battle.setState(Constants.BATTLE_STATES.DONE)
  elseif Battle.allSparedOrKilled() then
    for _, enemy in ipairs(Battle.encounter:getEnemies()) do
      if enemy:isKilled() then
        local exp_reward, gold_reward = Battle.encounter:getReward()
        Battle.encounter:setReward(exp_reward + enemy:getEXP(), gold_reward + enemy:getGold())
      end
    end

    Battle.win(Battle.encounter:getReward())
  else
    Battle.setState(Constants.BATTLE_STATES.ENEMY_DIALOGUE)
  end
end

--- Wins the encounter
--- @param exp? number EXP reward
--- @param gold? number GOLD reward
function Battle.win(exp, gold)
  exp = Utils.getOrDefault(exp, 0)
  gold = Utils.getOrDefault(gold, 0)

  local current_music = Assets.getCurrentMusic()
  if current_music ~= nil then
    current_music:stop()
  end

  local win_text = Lang.translate("BATTLE_WIN_REWARD", exp, gold)
  local level_old = Player.getLV()
  Player.setEXP(Player.getEXP() + exp)
  Player.setGold(Player.getGold() + gold)
  local level = Player.getLV()
  if level ~= level_old then
    win_text = win_text .. "\n" .. Lang.translate("BATTLE_WIN_LEVEL_UP", level)
  end
  Battle.has_won = true
  Battle.playDialogueText(win_text)
end

--- Gets the selected enemy
--- @return Dummy.Battle.Enemy|nil
function Battle.getSelectedEnemy()
  return Battle.encounter:getEnemies()[Battle.enemy_selected_index]
end

--- Gets the encounter's fight enemy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getFightEnemyMenu()
  return Battle.fight_enemy_menu
end

--- Loads fight enemy menu
function Battle.loadFightEnemyMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  for i, enemy in ipairs(Battle.encounter:getEnemies()) do
    local text = Text:new("* " .. Lang.translate(enemy:getName()))
    text:setCharacterWidth(8)
    if enemy:getCanBeSpared() then
      text:setColor(1, 1, 0)
    else
      text:setColor(1, 1, 1)
    end

    options[i] = {
      text = text,
      action = function()
        Battle.enemy_selected_index = i
        Battle.setState(Constants.BATTLE_STATES.ATTACKING)
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

  if Battle.fight_enemy_menu ~= nil then
    Battle.fight_enemy_menu:setOptions(options)
  else
    Battle.fight_enemy_menu = ActionMenu:new(options, "vertical", #options > 3, function(i)
      Battle.enemy_selected_index = i
      Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
    end)
  end
end

--- Gets the encounter's act enemy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getActEnemyMenu()
  return Battle.act_enemy_menu
end

--- Loads act enemy menu
function Battle.loadActEnemyMenu()
  --- @type Dummy.Menu.Options
  local options = {}

  for i, enemy in ipairs(Battle.encounter:getEnemies()) do
    local text = Text:new("* " .. Lang.translate(enemy:getName()))
    text:setCharacterWidth(8)
    if enemy:getCanBeSpared() then
      text:setColor(1, 1, 0)
    else
      text:setColor(1, 1, 1)
    end

    options[i] = {
      text = text,
      action = function()
        Battle.enemy_selected_index = i
        Battle.setState(Constants.BATTLE_STATES.ACT_MENU)
      end,
      disabled = enemy:isKilled() or enemy:isSpared()
    }
  end

  if Battle.act_enemy_menu ~= nil then
    Battle.act_enemy_menu:setOptions(options)
  else
    Battle.act_enemy_menu = ActionMenu:new(options, "vertical", #options > 3, function(i)
      Battle.enemy_selected_index = i
      Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
    end)
  end
end

--- Gets the encounter's act menus
--- @return Dummy.Battle.ActionMenu[]
function Battle.getActMenus()
  return Battle.act_menus
end

--- Loads act menus
function Battle.loadActMenus()
  if Battle.act_menus ~= nil and #Battle.act_menus > 0 then
    for _, menu in ipairs(Battle.act_menus) do
      menu:remove()
    end
  end
  Battle.act_menus = {}

  for i, enemy in ipairs(Battle.encounter:getEnemies()) do
    --- @type Dummy.Menu.Options
    local options = {}

    if enemy:hasCheck() then
      table.insert(options, {
        text = Text:new("BATTLE_MENU_ACT_CHECK"),
        action = function()
          Battle.dialogue_text:setText(enemy:getCheckText())
          Battle.setState(Constants.BATTLE_STATES.TEXT_DIALOGUE)
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

    Battle.act_menus[i] = ActionMenu:new(options, "horizontal", false, function()
      Battle.setState(Constants.BATTLE_STATES.ACT_ENEMY_MENU)
    end)
  end
end

--- Gets the encounter's item menu
--- @return Dummy.Battle.ActionMenu
function Battle.getItemMenu()
  return Battle.item_menu
end

--- Loads item menu
function Battle.loadItemMenu()
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

  if Battle.item_menu ~= nil then
    Battle.item_menu:setOptions(options)
  else
    Battle.item_menu = ActionMenu:new(options, "horizontal", true, function()
      Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
    end)
  end
end

--- Gets the encounter's mercy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getMercyMenu()
  return Battle.mercy_menu
end

--- Loads mercy menu
function Battle.loadMercyMenu()
  local spare_text = Text:new("BATTLE_MENU_MERCY_SPARE")
  spare_text:setCharacterWidth(8)
  spare_text:setColor(1, 1, 1)
  for _, enemy in ipairs(Battle.encounter:getEnemies()) do
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
        for _, enemy in ipairs(Battle.encounter:getEnemies()) do
          if enemy:getCanBeSpared() then
            enemy:spare()
            enemy:onSpared(true)
            has_spared = true
          end

          if enemy:isSpared() then
            local gold_ratio = (enemy:getMaxHP() - enemy:getHP()) / enemy:getMaxHP()
            local exp_reward, gold_reward = Battle.encounter:getReward()
            if gold_ratio == 0 then gold_reward = gold_reward + enemy:getGold() end
            gold_reward = gold_reward + math.floor(enemy:getGold() * gold_ratio)
            Battle.encounter:setReward(exp_reward, gold_reward)
          end
        end

        if not Battle.allSparedOrKilled() then
          if not has_spared then
            for _, enemy in ipairs(Battle.encounter:getEnemies()) do
              if not enemy:isKilled() then
                if type(enemy.onSpared) == "function" then
                  enemy:onSpared(false)
                end
              end
            end
          end
        end

        Battle.checkEncounterEnd()
      end
    }
  }

  if Battle.encounter:canFlee() ~= false then
    table.insert(options, {
      text = Text:new("BATTLE_MENU_MERCY_FLEE"),
      action = function()
        Battle.flee()
      end,
      silent = true
    })
  end

  if Battle.mercy_menu ~= nil then
    Battle.mercy_menu:setOptions(options)
  else
    Battle.mercy_menu = ActionMenu:new(options, "vertical", false, function()
      Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
    end)
  end
end

--- Flees the encounter
function Battle.flee()
  if Battle.encounter:canFlee() == false then return end

  if Scene.getCurrentSceneId() == "BATTLE" then
    if type(Battle.encounter.onFlee) == "function" then
      if Battle.encounter:onFlee() == false then return end
    end
  end

  Soul.flee()

  Timer.after(1, function()
    Fader.fadeIn(1 / 2.4, "linear", function()
      Battle.setState(Constants.BATTLE_STATES.DONE)
    end)
  end)

  Battle.mercy_menu:setActive(false)
  Battle.unselectAction()
  Battle.leaveMenu()

  --- @type Dummy.Text.Text
  local flee_text = ""
  local exp_reward, gold_reward = Battle.encounter:getReward()
  if exp_reward > 0 or gold_reward > 0 then
    flee_text = { "BATTLE_FLEE_REWARD", exp_reward, gold_reward }
  else
    local flee_value = love.math.random(20)
    if flee_value <= 1 then
      flee_text = "BATTLE_FLEE_1"
    elseif flee_value == 2 then
      flee_text = "BATTLE_FLEE_2"
    elseif flee_value == 3 then
      flee_text = "BATTLE_FLEE_3"
    else
      flee_text = "BATTLE_FLEE_4"
    end
  end

  Battle.dialogue_text:setText(flee_text)
  Battle.dialogue_text:setVisible(true)
  Battle.dialogue_text:skip()
end

--- Gets the current encounter state
--- @return string
function Battle.getCurrentState()
  return Battle.current_state
end

--- Sets current encounter state
--- @param state string
function Battle.setState(state)
  Battle.current_state = state
end

--- Gets the action fight sprite
--- @return Dummy.Sprite
function Battle.getActionFightSprite()
  return Battle.action_fight_sprite
end

--- Gets the action act sprite
--- @return Dummy.Sprite
function Battle.getActionActSprite()
  return Battle.action_act_sprite
end

--- Gets the action item sprite
--- @return Dummy.Sprite
function Battle.getActionItemSprite()
  return Battle.action_item_sprite
end

--- Gets the action mercy sprite
--- @return Dummy.Sprite
function Battle.getActionMercySprite()
  return Battle.action_mercy_sprite
end

--- Starts action select
function Battle.startActionSelect()
  Soul.getSprite():setVisible(false)

  Arena.reset(function()
    Battle.action_index = math.abs(Battle.action_index)
    Battle.updateActions()

    Soul.getSprite():setVisible(true)

    Battle.leaveMenu()

    Battle.dialogue_text:setText(table.unpack(Battle.getText()))
    Battle.dialogue_text:setVisible(true)
  end)
end

--- Updates action select
function Battle.updateActionSelect()
  if not Soul.getSprite():isVisible() then return end

  if Input.isPressed(Input.Left) then
    if Battle.action_index <= Constants.BATTLE_ACTIONS.FIGHT then
      Battle.action_index = Constants.BATTLE_ACTIONS.MERCY
    else
      Battle.action_index = Battle.action_index - 1
    end
    Battle.updateActions()
    Assets.playSound("menu_move")
  elseif Input.isPressed(Input.Right) then
    if Battle.action_index >= Constants.BATTLE_ACTIONS.MERCY then
      Battle.action_index = Constants.BATTLE_ACTIONS.FIGHT
    else
      Battle.action_index = Battle.action_index + 1
    end
    Battle.updateActions()
    Assets.playSound("menu_move")
  elseif Input.isPressed(Input.Confirm) then
    if Battle.action_index == Constants.BATTLE_ACTIONS.FIGHT then
      Battle.loadFightEnemyMenu()
      if Battle.canEnterMenu(Battle.fight_enemy_menu) then
        Battle.setState(Constants.BATTLE_STATES.FIGHT_ENEMY_MENU)
      end
    elseif Battle.action_index == Constants.BATTLE_ACTIONS.ACT then
      Battle.loadActEnemyMenu()
      if Battle.canEnterMenu(Battle.act_enemy_menu) then
        Battle.setState(Constants.BATTLE_STATES.ACT_ENEMY_MENU)
      end
    elseif Battle.action_index == Constants.BATTLE_ACTIONS.ITEM then
      Battle.loadItemMenu()
      if Battle.canEnterMenu(Battle.item_menu) then
        Battle.setState(Constants.BATTLE_STATES.ITEM_MENU)
      end
    elseif Battle.action_index == Constants.BATTLE_ACTIONS.MERCY then
      Battle.setState(Constants.BATTLE_STATES.MERCY_MENU)
    end

    if Battle.action_index > 0 then
      Assets.playSound("menu_select")
    end
  end
end

--- Loads encounter actions
function Battle.loadActions()
  Battle.action = {}
  Battle.action_index = Constants.BATTLE_ACTIONS.FIGHT

  -- FIGHT
  Battle.action_fight_sprite = Sprite:new("fight")
  Battle.action_fight_sprite:setPosition(32, 432)
  Battle.action_fight_sprite:setOrigin(0)
  Battle.action_fight_hover_sprite = Sprite:new("fight_hover")
  Battle.action_fight_hover_sprite:setPosition(32, 432)
  Battle.action_fight_hover_sprite:setOrigin(0)
  Battle.action_fight_hover_sprite:setVisible(false)

  -- ACT
  Battle.action_act_sprite = Sprite:new("act")
  Battle.action_act_sprite:setPosition(185, 432)
  Battle.action_act_sprite:setOrigin(0)
  Battle.action_act_hover_sprite = Sprite:new("act_hover")
  Battle.action_act_hover_sprite:setPosition(185, 432)
  Battle.action_act_hover_sprite:setOrigin(0)
  Battle.action_act_hover_sprite:setVisible(false)

  -- ITEM
  Battle.action_item_sprite = Sprite:new("item")
  Battle.action_item_sprite:setPosition(345, 432)
  Battle.action_item_sprite:setOrigin(0)
  Battle.action_item_hover_sprite = Sprite:new("item_hover")
  Battle.action_item_hover_sprite:setPosition(345, 432)
  Battle.action_item_hover_sprite:setOrigin(0)
  Battle.action_item_hover_sprite:setVisible(false)

  -- MERCY
  Battle.action_mercy_sprite = Sprite:new("mercy")
  Battle.action_mercy_sprite:setPosition(500, 432)
  Battle.action_mercy_sprite:setOrigin(0)
  Battle.action_mercy_hover_sprite = Sprite:new("mercy_hover")
  Battle.action_mercy_hover_sprite:setPosition(500, 432)
  Battle.action_mercy_hover_sprite:setOrigin(0)
  Battle.action_mercy_hover_sprite:setVisible(false)

  Battle.updateActions()
end

--- Wether an action menu can be entered
--- @param menu Dummy.Battle.ActionMenu | nil
--- @return boolean
function Battle.canEnterMenu(menu)
  return menu ~= nil and menu:getSize() > 0 and not menu:allDisabled()
end

--- Opens an action's menu
--- @param menu Dummy.Battle.ActionMenu|nil
function Battle.enterMenu(menu)
  if menu == nil or menu:getSize() <= 0 or menu:allDisabled() then
    Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
    return
  end

  Arena.reset()
  Soul.getSprite():setVisible(true)

  Battle.leaveMenu()
  Battle.current_menu = menu
  Battle.current_menu:show()

  Battle.dialogue_text:setVisible(false)
end

--- Leaves the current menu
function Battle.leaveMenu()
  if Battle.current_menu ~= nil then
    Battle.current_menu:hide()
    Battle.current_menu = nil
  end
end

--- Updates actions sprites and soul position
function Battle.updateActions()
  Battle.action_fight_sprite:setVisible(true)
  Battle.action_act_sprite:setVisible(true)
  Battle.action_item_sprite:setVisible(true)
  Battle.action_mercy_sprite:setVisible(true)
  Battle.action_fight_hover_sprite:setVisible(false)
  Battle.action_act_hover_sprite:setVisible(false)
  Battle.action_item_hover_sprite:setVisible(false)
  Battle.action_mercy_hover_sprite:setVisible(false)

  local selected_sprite, selected_sprite_hover
  if Battle.action_index == Constants.BATTLE_ACTIONS.FIGHT then
    selected_sprite = Battle.action_fight_sprite
    selected_sprite_hover = Battle.action_fight_hover_sprite
  elseif Battle.action_index == Constants.BATTLE_ACTIONS.ACT then
    selected_sprite = Battle.action_act_sprite
    selected_sprite_hover = Battle.action_act_hover_sprite
  elseif Battle.action_index == Constants.BATTLE_ACTIONS.ITEM then
    selected_sprite = Battle.action_item_sprite
    selected_sprite_hover = Battle.action_item_hover_sprite
  elseif Battle.action_index == Constants.BATTLE_ACTIONS.MERCY then
    selected_sprite = Battle.action_mercy_sprite
    selected_sprite_hover = Battle.action_mercy_hover_sprite
  end

  if selected_sprite ~= nil then
    selected_sprite:setVisible(false)
    selected_sprite_hover:setVisible(true)

    local x, y = selected_sprite:getPosition()
    Soul.setPosition(x + 16, y + 22, true)
  end
end

--- Unselects the current action
function Battle.unselectAction()
  Battle.action_index = -math.abs(Battle.action_index)
  Battle.updateActions()
end

--- Starts text dialogue
function Battle.startTextDialogue()
  Battle.dialogue_text:reset()
  Battle.dialogue_text:setVisible(true)

  Battle.unselectAction()
  Soul.getSprite():setVisible(false)
  Battle.leaveMenu()
end

--- Updates text dialogue
function Battle.updateTextDialogue()
  if Battle.dialogue_text:isDone() then
    Battle.checkEncounterEnd()
  end
end

--- Starts enemy dialogue
function Battle.startEnemyDialogue()
  Battle.can_skip_bubble_dialogues = false
  Battle.dialogue_text:setVisible(false)

  Battle.unselectAction()
  Battle.leaveMenu()
  Soul.getSprite():setVisible(false)

  for _, enemy in ipairs(Battle.encounter:getEnemies()) do
    if not enemy:isKilled() and not enemy:isSpared() then
      if type(enemy.onDialogue) == "function" then
        enemy:onDialogue()
      end
    end
  end

  local waves = Battle.encounter:getWaves()
  if #waves > 0 then
    local arena_width, arena_height = Constants.ARENA.DEFAULT_WIDTH, Constants.ARENA.DEFAULT_HEIGHT
    for _, wave in ipairs(waves) do
      arena_width, arena_height = wave:getArenaSize()
    end

    Arena.resize(arena_width, arena_height, false, function()
      Battle.can_skip_bubble_dialogues = true
      if #Battle.bubble_dialogues <= 0 then
        Battle.setState(Constants.BATTLE_STATES.DEFENDING)
      end
    end)

    local x, y = Arena:getPosition()
    Soul.setPosition(x, y - 65)
    Soul.getSprite():setVisible(true)
  else
    Battle.can_skip_bubble_dialogues = true
    if #Battle.bubble_dialogues <= 0 then
      Battle.setState(Constants.BATTLE_STATES.DEFENDING)
    end
  end
end

--- Updates enemy dialogue
function Battle.updateEnemyDialogue()
  Soul.setPosition(Soul.getPosition())

  if #Battle.bubble_dialogues <= 0 or not Battle.can_skip_bubble_dialogues then return end

  local all_done = true
  for _, dialogue in ipairs(Battle.bubble_dialogues) do
    if not dialogue:getDialogue():isDone() then
      all_done = false
      break
    end
  end

  if all_done then
    for _, dialogue in ipairs(Battle.bubble_dialogues) do
      dialogue:remove()
    end
    Battle.bubble_dialogues = {}
    Battle.setState(Constants.BATTLE_STATES.DEFENDING)
  end
end

--- Starts attacking
function Battle.startAttacking()
  Battle.leaveMenu()
  Battle.unselectAction()
  Soul.getSprite():setVisible(false)

  Battle.target_sprite:setVisible(true)
  Battle.target_sprite:setAlpha(1)
  Battle.target_sprite:setScale(1)

  Battle.is_attacking = false
  -- Determine if the standard attack function can continue, otherwise run a weapon's custom attack
  local override = false
  if type(Player.getWeapon().GetAttackEffect) == "function" then
    override = Player.getWeapon():GetAttackEffect()
  end

  if override then return end
  local attack_speed = 11

  Battle.target_bar_sprite:setPosition(22, 320)
  Battle.target_bar_sprite:setVisible(true)
  Battle.target_bar_sprite:stop()
  Battle.target_bar_sprite:setFrame(1)

  local bar_speed = attack_speed + (love.math.random() * 2)
  Battle.attack_window_timer = Timer.during(2, function(dt)
    local x, y = Battle.target_bar_sprite:getPosition()
    local target_bar_x = x + bar_speed * dt * 30
    Battle.target_bar_sprite:setPosition(target_bar_x, y)

    local target_x = Battle.target_sprite:getPosition()
    local width = Battle.target_sprite:getWidth()
    if target_bar_x > target_x + width / 2 then
      Battle.attack(true)
    end

    if Input.isPressed(Input.Confirm) then
      Battle.attack()
    end
  end)
end

--- Attacks the enemy
--- @param miss? boolean wether the attack missed
function Battle.attack(miss)
  if Battle.is_attacking then return end

  Battle.is_attacking = true
  if Battle.attack_window_timer ~= nil then
    Timer.cancel(Battle.attack_window_timer)
  end

  local enemy = Battle.encounter:getEnemies()[Battle.enemy_selected_index]
  local enemy_x, enemy_y = enemy:getPosition()
  local enemy_width, enemy_height = enemy:getWidth(), enemy:getHeight()
  local enemy_origin_x, enemy_origin_y = enemy:getOrigin()
  local enemy_scale_x, enemy_scale_y = enemy:getScale()
  local enemy_center_x = enemy_x + (0.5 - enemy_origin_x) * enemy_width * enemy_scale_x
  local enemy_center_y = enemy_y + (0.5 - enemy_origin_y) * enemy_height * enemy_scale_y
  Battle.strike_sprite:setPosition(enemy_center_x, enemy_center_y)

  if miss == true then
    Battle.proceedAttack(enemy, 0, true)
  else
    if type(enemy.onBeforeAttack) == "function" then
      enemy:onBeforeAttack()
    end

    local target_x = Battle.target_sprite:getPosition()
    local target_width = Battle.target_sprite:getWidth()
    local target_bar_x = Battle.target_bar_sprite:getPosition()
    local bonus_factor = math.abs(target_x - target_bar_x)
    local stretch = (target_width - bonus_factor) / target_width
    local damage = math.max(0, Player.getAT() - enemy:getDF() + (love.math.random() * 2))
    if bonus_factor <= 12 then
      damage = math.round(damage * 2.2)
    else
      damage = math.round(damage * 2 * stretch)
    end

    Battle.strike_sprite:setVisible(true)
    Battle.strike_sprite:setScale(stretch * 2 - 0.5)
    local strike_speed_base = 0.5 - stretch / 4
    local strike_speed = 1 / (strike_speed_base * 30)
    Battle.strike_sprite:setSpeed(strike_speed)
    Battle.strike_sprite:play()
    Battle.target_bar_sprite:play()
    Assets.playSound("strike")
    local damage_delay = (1 / strike_speed_base * 6 + 3) / 30
    Timer.after(damage_delay, function()
      Battle.proceedAttack(enemy, damage, miss)
    end)
  end
end

--- Proceeds attack on an enemy
--- @param enemy Dummy.Battle.Enemy the attacked enemy
--- @param damage number damage amount
--- @param miss? boolean wether the attack missed
--- @protected
function Battle.proceedAttack(enemy, damage, miss)
  if type(enemy.onBeforeDamage) == "function" then
    local d, m = enemy:onBeforeDamage(damage, miss or false)
    damage = Utils.getOrDefault(d, damage)
    miss = Utils.getOrDefault(m, miss)
  end

  local enemy_x, enemy_y = enemy:getPosition()
  local enemy_width, enemy_height = enemy:getWidth(), enemy:getHeight()
  local enemy_origin_x, enemy_origin_y = enemy:getOrigin()
  local enemy_scale_x, enemy_scale_y = enemy:getScale()
  local enemy_center_x = enemy_x + (0.5 - enemy_origin_x) * enemy_width * enemy_scale_x
  local enemy_center_y = enemy_y + (0.5 - enemy_origin_y) * enemy_height * enemy_scale_y
  local enemy_top_y = enemy_center_y - enemy_height * enemy_scale_y / 2 - 16
  if enemy:getWidth() > 120 then
    enemy_top_y = enemy_center_y
  end
  if miss == true then
    Battle.miss_text:setPosition(enemy_center_x, enemy_top_y)
    Battle.miss_text:setVisible(true)

    Timer.after(1, function()
      Battle.miss_text:setVisible(false)
    end)

    Battle.endAttack(enemy)
  else
    Assets.playSound("damage")

    local stretch_factor = math.max(100, enemy_width) / enemy:getMaxHP()
    local hp_bar_width = math.round(enemy:getMaxHP() * stretch_factor)
    local enemy_apparent_hp = enemy:getHP()
    local enemy_hp_draw_width = math.round(enemy_apparent_hp * stretch_factor)
    local enemy_hp_draw_x = enemy_center_x - hp_bar_width / 2

    local fps = love.timer.getFPS()
    Timer.every(2 / fps, function()
      enemy_apparent_hp = math.max(enemy:getHP(), enemy_apparent_hp - (damage / (fps / 2)))
      enemy_hp_draw_width = math.round(enemy_apparent_hp * stretch_factor)
    end, fps / 2)

    Battle.enemy_hp_draw:setVisible(true)
    function Battle.enemy_hp_draw.draw(_self)
      if not _self:isVisible() then return end

      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("fill", enemy_hp_draw_x - 1, enemy_top_y - 1, hp_bar_width + 2, 15)
      love.graphics.setColor(0.25, 0.25, 0.25, 1)
      love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, hp_bar_width, 13)
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("fill", enemy_hp_draw_x, enemy_top_y, enemy_hp_draw_width, 13)
    end

    local enemy_hp_text_vel_y = -4
    local enemy_hp_text_y_start = enemy_top_y - 15
    local enemy_hp_text_y = enemy_hp_text_y_start
    Battle.enemy_hp_text:setPosition(enemy_center_x, enemy_hp_text_y_start)
    Battle.enemy_hp_text:setVisible(true)
    Battle.enemy_hp_text:setText(tostring(damage))
    Battle.enemy_hp_text_timer = Timer.during(1, function(dt)
      enemy_hp_text_vel_y = enemy_hp_text_vel_y + 0.5 * dt * 30
      enemy_hp_text_y = enemy_hp_text_y + enemy_hp_text_vel_y * dt * 30
      Battle.enemy_hp_text:setPosition(enemy_center_x, enemy_hp_text_y)

      if enemy_hp_text_y >= enemy_hp_text_y_start + 8 then
        if Battle.enemy_hp_text_timer ~= nil then
          Timer.cancel(Battle.enemy_hp_text_timer)
        end
        Battle.enemy_hp_text:setPosition(enemy_center_x, enemy_hp_text_y_start)
      end
    end)

    Timer.after(1.5, function()
      Battle.enemy_hp_draw:setVisible(false)
      Battle.enemy_hp_text:setVisible(false)
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
          local exp_reward, gold_reward = Battle.encounter:getReward()
          Battle.encounter:setReward(exp_reward + enemy:getEXP(), gold_reward + enemy:getGold())

          if type(enemy.onKilled) == "function" then
            enemy:onKilled()
          end

          enemy:vaporize()
        else
          if type(enemy.onAfterDamage) == "function" then
            enemy:onAfterDamage()
          end
        end
      end
    end, 16)

    Timer.after(1, function()
      Battle.endAttack(enemy)
    end)
  end
end

--- Ends attack on an enemy
--- @param enemy Dummy.Battle.Enemy the attacked enemy
function Battle.endAttack(enemy)
  local alpha = 1
  local scale_x = 1

  if type(enemy.onAfterAttack) == "function" then
    enemy:onAfterAttack()
  end

  Timer.during(0.5, function(dt)
    alpha = math.clamp(alpha - 2.4 * dt, 0, 1)
    Battle.target_sprite:setAlpha(alpha)

    scale_x = math.max(0.25, scale_x - 1.8 * dt)
    Battle.target_sprite:setScale(scale_x, 1)

    if alpha <= 0 then
      Battle.target_sprite:setVisible(false)
    end
  end)

  Battle.target_bar_sprite:setVisible(false)

  Battle.checkEncounterEnd()
end

--- Starts defending
function Battle.startDefending()
  Battle.unselectAction()
  local waves = Battle.encounter:getWaves()
  if #waves <= 0 then return end

  for _, wave in ipairs(waves) do
    if type(wave.onStart) == "function" then
      ---@diagnostic disable-next-line: invisible
      wave:__start()
    end
  end
end

--- Updates defending
function Battle.updateDefending(dt)
  Soul.update(dt)

  local all_done = true
  for _, wave in ipairs(Battle.encounter:getWaves()) do
    ---@diagnostic disable-next-line: invisible
    wave:__update(dt)

    if not wave:isDone() then
      all_done = false
    end
  end

  if all_done then
    Battle.setState(Constants.BATTLE_STATES.ACTION_SELECT)
  end
end

--- Updates the player UI
function Battle.updatePlayerUI()
  Battle.player_name_text:setText(Player.getName())
  Battle.player_lv_text:setPosition(Battle.player_name_text:getWidth() + 57, 400)
  Battle.player_lv_text:setText(Lang.translate("BATTLE_STAT_LV") .. " " .. tostring(Player.getLV()))
  Battle.player_hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 400)
  Battle.player_hp_value_text:setText(string.format("%02d", Player.getHP()) .. " / " .. tostring(Player.getMaxHP()))
end

--- Updates the encounter
--- @param dt number
function Battle.update(dt)
  -- start
  if Battle.current_state ~= Battle.previous_state then
    Battle.previous_state = Battle.current_state

    if Battle.current_state == Constants.BATTLE_STATES.ACTION_SELECT then
      Battle.startActionSelect()
    elseif Battle.current_state == Constants.BATTLE_STATES.FIGHT_ENEMY_MENU then
      Battle.loadFightEnemyMenu()
      Battle.enterMenu(Battle.fight_enemy_menu)
      if Battle.current_menu == Battle.fight_enemy_menu then
        Battle.fight_enemy_menu:selectByIndex(Battle.enemy_selected_index, true)
      end
    elseif Battle.current_state == Constants.BATTLE_STATES.ACT_ENEMY_MENU then
      Battle.loadActEnemyMenu()
      Battle.enterMenu(Battle.act_enemy_menu)
      if Battle.current_menu == Battle.act_enemy_menu then
        Battle.act_enemy_menu:selectByIndex(Battle.enemy_selected_index, true)
      end
    elseif Battle.current_state == Constants.BATTLE_STATES.ACT_MENU then
      Battle.loadActMenus()
      Battle.enterMenu(Battle.act_menus[Battle.enemy_selected_index])
    elseif Battle.current_state == Constants.BATTLE_STATES.ITEM_MENU then
      Battle.loadItemMenu()
      Battle.enterMenu(Battle.item_menu)
      Battle.item_menu:select(0, 0, true)
    elseif Battle.current_state == Constants.BATTLE_STATES.MERCY_MENU then
      Battle.loadMercyMenu()
      Battle.enterMenu(Battle.mercy_menu)
    elseif Battle.current_state == Constants.BATTLE_STATES.TEXT_DIALOGUE then
      Battle.startTextDialogue()
    elseif Battle.current_state == Constants.BATTLE_STATES.ENEMY_DIALOGUE then
      Battle.startEnemyDialogue()
    elseif Battle.current_state == Constants.BATTLE_STATES.ATTACKING then
      Battle.startAttacking()
    elseif Battle.current_state == Constants.BATTLE_STATES.DEFENDING then
      Battle.startDefending()
    end
  end

  -- update
  if Battle.current_state == Constants.BATTLE_STATES.ACTION_SELECT then
    Battle.updateActionSelect()
  elseif Battle.current_state == Constants.BATTLE_STATES.FIGHT_ENEMY_MENU then
    if Battle.current_menu ~= nil then Battle.current_menu:update() end
  elseif Battle.current_state == Constants.BATTLE_STATES.ACT_MENU then
    if Battle.current_menu ~= nil then Battle.current_menu:update() end
  elseif Battle.current_state == Constants.BATTLE_STATES.ACT_ENEMY_MENU then
    if Battle.current_menu ~= nil then Battle.current_menu:update() end
  elseif Battle.current_state == Constants.BATTLE_STATES.ITEM_MENU then
    if Battle.current_menu ~= nil then Battle.current_menu:update() end
  elseif Battle.current_state == Constants.BATTLE_STATES.MERCY_MENU then
    if Battle.current_menu ~= nil then Battle.current_menu:update() end
  elseif Battle.current_state == Constants.BATTLE_STATES.TEXT_DIALOGUE then
    Battle.updateTextDialogue()
  elseif Battle.current_state == Constants.BATTLE_STATES.ENEMY_DIALOGUE then
    Battle.updateEnemyDialogue()
  elseif Battle.current_state == Constants.BATTLE_STATES.DEFENDING then
    Battle.updateDefending(dt)
  end

  if Player.getHP() <= 0 then
    Battle.setState(Constants.BATTLE_STATES.NONE)
    local x, y = Soul.getPosition()
    Timer.after(4 / 30, function()
      Scene.change("GAME_OVER", x, y)
    end)
  end

  -- player UI
  Battle.updatePlayerUI()

  Arena.update(dt)
end

return Battle
