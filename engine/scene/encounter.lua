--- @class Dummy.Scene.Encounter
---
--- @field private mod Dummy.Mod
--- @field private current_state string
--- @field private previous_state string
--- @field private current_menu Dummy.Encounter.ActionMenu|nil
--- @field private bg_sprite Dummy.Sprite
--- @field private black_sprite Dummy.Sprite
--- @field private dialogue_text Dummy.DialogueText
--- @field private target_sprite Dummy.Sprite
--- @field private target_bar_sprite Dummy.Sprite
--- @field private miss_text Dummy.Text
--- @field private strike_sprite Dummy.Sprite
--- @field private enemy_hp_draw Dummy.Drawable
--- @field private enemy_hp_text Dummy.Text
--- @field private battle_music love.Source
--- @field private fight_enemy_menu Dummy.Encounter.ActionMenu
--- @field private act_enemy_menu Dummy.Encounter.ActionMenu
--- @field private act_menus table<number, Dummy.Encounter.ActionMenu>
--- @field private item_menu Dummy.Encounter.ActionMenu
--- @field private mercy_menu Dummy.Encounter.ActionMenu
--- @field private enemies table<number, Dummy.Enemy>
--- @field private enemy_selected_index number
--- @field private action.index number
--- @field private action.fight_sprite Dummy.Sprite
--- @field private action.fight_hover_sprite Dummy.Sprite
--- @field private action.act_sprite Dummy.Sprite
--- @field private action.act_hover_sprite Dummy.Sprite
--- @field private action.item_sprite Dummy.Sprite
--- @field private action.item_hover_sprite Dummy.Sprite
--- @field private action.mercy_sprite Dummy.Sprite
--- @field private action.mercy_hover_sprite Dummy.Sprite
local Encounter = {
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
function Encounter.load(mod)
  Encounter.mod = Utils.getOrDefault(mod, {})
  Encounter.mod.player = Utils.getOrDefault(Encounter.mod.player, {})
  Encounter.mod.encounter = Utils.getOrDefault(Encounter.mod.encounter, {})

  if Encounter.mod.title ~= nil then
    love.window.setTitle(Encounter.mod.title)
  end
  love.window.setIcon(love.image.newImageData("assets/icon.png"))

  -- background
  Encounter.bg_sprite = Sprite:new("battle_bg")
  Encounter.bg_sprite:setPosition(319.5, 127)
  Encounter.bg_sprite:setLayer(Constants.LAYERS.BOTTOM)
  Encounter.black_sprite = Sprite:new("black")
  Encounter.black_sprite:setOrigin(0, 0)
  Encounter.black_sprite:setVisible(false)
  Encounter.black_sprite:setAlpha(0)
  Encounter.black_sprite:setLayer(Constants.LAYERS.TOP)

  -- arena
  Arena.load()

  -- player
  Player.load()
  Player.setName(Utils.getOrDefault(Encounter.mod.player.name, "Frisk"))
  Player.setLV(Utils.getOrDefault(Encounter.mod.player.level, 1), true)
  if Encounter.mod.player.max_hp ~= nil then
    Player.setMaxHP(Encounter.mod.player.max_hp)
  end
  if Encounter.mod.player.hp ~= nil then
    Player.setHP(Encounter.mod.player.hp)
  end

  -- enemies
  Encounter.loadEnemies()

  -- state
  Encounter.previous_state = Constants.ENCOUNTER_STATES.ACTION_SELECT
  Encounter.current_state = Constants.ENCOUNTER_STATES.ACTION_SELECT

  -- actions
  Encounter.loadActions()

  -- menus
  Encounter.loadMenus()

  -- textbox dialogue
  Encounter.dialogue_text = DialogueText:new("")
  Encounter.dialogue_text:setPosition(52, 270)
  Encounter.dialogue_text:setOrigin(0, 0)
  Encounter.dialogue_text:setFont(Font.FONTS.MAIN_TEXT)
  Encounter.dialogue_text:setScale(2)
  Encounter.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  Encounter.dialogue_text:setMaxWidth(Constants.ARENA.DEFAULT_WIDTH - Constants.ARENA.BORDER_WIDTH * 2)
  Encounter.dialogue_text:setText(Utils.getOrDefault(Encounter.mod.encounter.text, ""))

  -- attack target
  Encounter.target_sprite = Sprite:new("target")
  Encounter.target_sprite:setPosition(320, 320)
  Encounter.target_sprite:setLayer(Constants.LAYERS.UI)
  Encounter.target_sprite:setVisible(false)
  Encounter.target_bar_sprite = Sprite:new({ "target_bar1", "target_bar2" }, 0.1)
  Encounter.target_bar_sprite:stop()
  Encounter.target_bar_sprite:setVisible(false)
  Encounter.target_bar_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  -- miss
  Encounter.miss_text = Text:new("ENCOUNTER_ATTACK_MISS")
  Encounter.miss_text:setVisible(false)
  Encounter.miss_text:setFont(Font.FONTS.DAMAGE)
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
  }, 4 / 30, false, false)
  Encounter.strike_sprite:stop()
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
  Encounter.enemy_hp_draw:setLayer(Constants.LAYERS.ABOVE_BULLETS)
  Encounter.enemy_hp_draw:setVisible(false)

  Encounter.enemy_hp_text = Text:new("")
  Encounter.enemy_hp_text:setColor(1, 0, 0)
  Encounter.enemy_hp_text:setLayer(Constants.LAYERS.ABOVE_BULLETS)
  Encounter.enemy_hp_text:setFont(Font.FONTS.DAMAGE)
  Encounter.enemy_hp_text:setScale(1)
  Encounter.enemy_hp_text:setVisible(false)

  -- music
  if Encounter.mod.encounter.music ~= nil then
    Encounter.battle_music = Audio.playMusic(Encounter.mod.encounter.music, nil, nil, nil)
  else
    Encounter.battle_music = Audio.playMusic("battle")
  end

  Encounter.battle_music:setVolume(0.5)
end

function Encounter.loadEnemies()
  --- @type table<number, Dummy.Enemy>
  Encounter.enemies = {}

  local enemies_files = love.filesystem.getDirectoryItems("mods/" .. Encounter.mod.id .. "/scripts/enemies")
  for _, filename in ipairs(enemies_files) do
    local enemy_path = "mods." .. Encounter.mod.id .. ".scripts.enemies." .. Utils.getFilenameWithoutExt(filename)
    --- @type boolean, Dummy.Enemy
    local success, enemy = pcall(require, enemy_path)
    if success and type(enemy) == "table" then
      table.insert(Encounter.enemies, enemy)

      -- DEBUG
      Drawable:new(function()
        local x, y = enemy:getPosition()
        local w, h = enemy:getSize()
        love.graphics.setColor(1, 1, 1, 0.2)
        love.graphics.rectangle("fill", x - w / 2, y - h / 2, w, h)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", x - 1, y - 1, 2, 2)
      end):setLayer(Constants.LAYERS.BELOW_ARENA)
    end
  end
end

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

--- Loads actions menus
function Encounter.loadMenus()
  Encounter.loadFightEnemyMenu()
  Encounter.loadActEnemyMenu()
  Encounter.loadActMenus()
  Encounter.loadItemMenu()
  Encounter.loadMercyMenu()
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
        Audio.playSound("menu_select")
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

--- Loads act enemy menu
function Encounter.loadActEnemyMenu()
  --- @type Dummy.Menu.Options
  local options = {}
  for i, enemy in ipairs(Encounter.enemies) do
    options[i] = {
      text = Text:new("* " .. enemy:getName()),
      action = function()
        Encounter.enemy_selected_index = i
        Audio.playSound("menu_select")
        Encounter.setState(Constants.ENCOUNTER_STATES.ACT_MENU)
      end
    }
  end

  Encounter.act_enemy_menu = ActionMenu:new(options, "vertical", false, function(i)
    Encounter.enemy_selected_index = i
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

--- Loads act menus
function Encounter.loadActMenus()
  Encounter.act_menus = {}
  for i, enemy in ipairs(Encounter.enemies) do
    --- @type Dummy.Menu.Options
    local options = {}

    if enemy:hasCheck() then
      table.insert(options, {
        text = Text:new("* " .. Lang.translate("ENCOUNTER_MENU_ACT_CHECK")),
        action = function()
          Audio.playSound("menu_select")
          Encounter.dialogue_text:setText(enemy:getCheckText())
          Encounter.dialogue_text:setCanSkip(false)
          Encounter.setState(Constants.ENCOUNTER_STATES.TEXT_DIALOGUE)
        end
      })
    end

    Encounter.act_menus[i] = ActionMenu:new(options, "horizontal", false, function()
      Encounter.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    end)
  end
end

--- Loads item menu
function Encounter.loadItemMenu()
  --- @type Dummy.Menu.Options
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

  Encounter.item_menu = ActionMenu:new(options, "horizontal", true, function()
    Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
  end)
end

function Encounter.loadMercyMenu()
  --- @type Dummy.Menu.Options
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

  if Encounter.mod.encounter.flee ~= false then
    table.insert(options, {
      text = Text:new("* " .. Lang.translate("ENCOUNTER_MENU_MERCY_FLEE")),
      action = function()
        if Player.isFleeing() then return end

        Encounter.mercy_menu:setActive(false)

        Timer.after(1.5, function()
          Encounter.setState(Constants.ENCOUNTER_STATES.DONE)
        end)

        Timer.during(2, function(dt)
          Player.flee(dt)
        end)

        Timer.after(1, function()
          local time = 0
          Encounter.black_sprite:setVisible(true)

          Timer.during(0.4, function(dt)
            time = time + dt
            Encounter.black_sprite:setAlpha(time / 0.4)
          end)
        end)

        Audio.playSound("escaped")

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
        Encounter.dialogue_text:setText("   * " .. Lang.translate(flee_text_key))
        Encounter.dialogue_text:setVisible(true)
        Encounter.dialogue_text:skip()
        Encounter.leaveMenu()
        Encounter.unselectAction()
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

function Encounter.startActionSelect()
  Player.hide()

  Arena.reset(function()
    Encounter.action.index = math.abs(Encounter.action.index)
    Encounter.updateActions()

    Player.show()

    Encounter.leaveMenu()

    Encounter.dialogue_text:setText(Encounter.mod.encounter.text)
    Encounter.dialogue_text:setCanSkip(true)
    Encounter.dialogue_text:setVisible(true)
  end)
end

function Encounter.updateActionSelect()
  if Input.isPressed(Input.Left) then
    if Encounter.action.index <= Encounter.ACTIONS.FIGHT then
      Encounter.action.index = Encounter.ACTIONS.MERCY
    else
      Encounter.action.index = Encounter.action.index - 1
    end
    Encounter.updateActions()
    Audio.playSound("menu_move")
  elseif Input.isPressed(Input.Right) then
    if Encounter.action.index >= Encounter.ACTIONS.MERCY then
      Encounter.action.index = Encounter.ACTIONS.FIGHT
    else
      Encounter.action.index = Encounter.action.index + 1
    end
    Encounter.updateActions()
    Audio.playSound("menu_move")
  elseif Input.isPressed(Input.Confirm) then
    if Encounter.action.index == Encounter.ACTIONS.FIGHT and Encounter.fight_enemy_menu:getSize() > 0 and not Encounter.fight_enemy_menu:allDisabled() then
      Encounter.setState(Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU)
    elseif Encounter.action.index == Encounter.ACTIONS.ACT and Encounter.fight_enemy_menu:getSize() > 0 and not Encounter.item_menu:allDisabled() then
      Encounter.setState(Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU)
    elseif Encounter.action.index == Encounter.ACTIONS.ITEM and Encounter.item_menu:getSize() > 0 then
      Encounter.setState(Constants.ENCOUNTER_STATES.ITEM_MENU)
    elseif Encounter.action.index == Encounter.ACTIONS.MERCY then
      Encounter.setState(Constants.ENCOUNTER_STATES.MERCY_MENU)
    end

    if Encounter.action.index > 0 then
      Audio.playSound("menu_select")
    end
  end
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

function Encounter.unselectAction()
  Encounter.action.index = -math.abs(Encounter.action.index)
  Encounter.updateActions()
end

function Encounter.startTextDialogue()
  Encounter.dialogue_text:reset()
  Encounter.dialogue_text:setVisible(true)

  Encounter.unselectAction()

  Player.hide()

  Encounter.leaveMenu()
end

function Encounter.updateTextDialogue()
  if Input.isPressed(Input.Confirm) and Encounter.dialogue_text:isDone() then
    Encounter.setState(Constants.ENCOUNTER_STATES.ENEMY_DIALOGUE)
  end
end

function Encounter.startEnemyDialogue()
  Encounter.dialogue_text:setVisible(false)

  Encounter.unselectAction()

  -- TODO: get arena width/height in wave
  local wave_arena_width = 175
  Arena.resize(wave_arena_width, 130, false, function()
    Encounter.enemy_hp_draw:setVisible(false)
    Encounter.enemy_hp_text:setVisible(false)
    Encounter.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  end)

  local x, y = Arena:getPosition()
  Player.setPosition(x, y - 65)
  Player.show()
end

function Encounter.updateEnemyDialogue(dt)
  -- if Input.isPressed(Input.Confirm) then
  --   self.setState(Constants.ENCOUNTER_STATES.DEFENDING)
  -- end
end

function Encounter.startAttacking()
  Encounter.target_sprite:setVisible(true)
  Encounter.target_sprite:setAlpha(1)
  Encounter.target_sprite:setScale(1)

  Player.hide()

  Encounter.leaveMenu()

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

      if miss == true then
        Encounter.miss_text:setPosition(enemy_x, enemy_top_y)
        Encounter.miss_text:setVisible(true)

        Timer.after(1, function()
          Encounter.miss_text:setVisible(false)
        end)
      else
        Audio.playSound("damage")

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
      damage = Player:getAT() - enemy:getDF() + (math.random() * 2)
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
      Audio.playSound("strike")
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

function Encounter.startDefending()
  Encounter.unselectAction()

  -- TODO: get arena width/height in wave
  local wave_arena_width = 175
  local wave_arena_height = 175
  local wave_arena_x = 0
  local wave_arena_y = -45
  Arena.resize(wave_arena_width, wave_arena_height)
  Arena.move(wave_arena_x, wave_arena_y)
end

function Encounter.updateDefending(dt)
  Player.update(dt)
end

function Encounter.update(dt)
  -- start
  if Encounter.current_state ~= Encounter.previous_state then
    Encounter.previous_state = Encounter.current_state

    if Encounter.current_state == Constants.ENCOUNTER_STATES.ACTION_SELECT then
      Encounter.startActionSelect()
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.FIGHT_ENEMY_MENU then
      Encounter.enterMenu(Encounter.fight_enemy_menu)
      if Encounter.current_menu == Encounter.fight_enemy_menu then
        Encounter.fight_enemy_menu:selectByIndex(Encounter.enemy_selected_index, true)
      end
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_ENEMY_MENU then
      Encounter.enterMenu(Encounter.act_enemy_menu)
      if Encounter.current_menu == Encounter.act_enemy_menu then
        Encounter.act_enemy_menu:selectByIndex(Encounter.enemy_selected_index, true)
      end
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ACT_MENU then
      Encounter.enterMenu(Encounter.act_menus[Encounter.enemy_selected_index])
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.ITEM_MENU then
      Encounter.enterMenu(Encounter.item_menu)
      Encounter.item_menu:select(0, 0, true)
    elseif Encounter.current_state == Constants.ENCOUNTER_STATES.MERCY_MENU then
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
    if Input.isPressed(Input.Cancel) then
      Encounter.setState(Constants.ENCOUNTER_STATES.ACTION_SELECT)
    end
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.DONE then
    Scene.change("MAIN_MENU")
  elseif Encounter.current_state == Constants.ENCOUNTER_STATES.NONE then
  end

  if Player.getHP() <= 0 then
    local x, y = Player.getPosition()
    Scene.change("GAME_OVER", x, y)
  end

  Arena.update(dt)
end

return Encounter
