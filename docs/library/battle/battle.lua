--[[
  Generated from ..\engine\battle\battle.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/battle.lua
]]

---@meta

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
Battle = {}

--- @class Dummy.Battle.Data
---
--- @field text? string first displayed text of the encounter
--- @field music? string music to play when the encounter starts
--- @field enemies Dummy.Battle.Enemy[] list of enemies in the encounter
--- @field x? number target position x of the heart
--- @field y? number target position y of the heart

--- Loads the battle
function Battle.load() end

function Battle.unload() end

--- Starts the encounter
--- @param encounter Dummy.Battle.Encounter
function Battle.start(encounter) end

--- Gets the current battle encounter
--- @return Dummy.Battle.Encounter
function Battle.getEncounter() end

--- Gets the encounter's text
--- @return love.Source
function Battle.getMusic() end

--- Sets the encounter music
--- @param music string
function Battle.setMusic(music) end

--- Gets the encounter background sprite
--- @return Dummy.Sprite
function Battle.getBackgroundSprite() end

--- Sets the encounter background sprite
--- @param sprite Dummy.Sprite
function Battle.setBackgroundSprite(sprite) end

--- Gets the encounter's text
--- @return Dummy.Text.Text[]
function Battle.getText() end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Battle.setText(text, ...) end

--- Gets the encounter dialogue text
--- @return Dummy.DialogueText
function Battle.getDialogueText() end

--- Plays a dialogue text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Battle.playDialogueText(text, ...) end

--- Plays a dialogue bubble
--- @param bubble_type Dummy.DialogueBubble.Type
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueBubble
function Battle.playDialogueBubble(bubble_type, text, ...) end

--- Sets the selected action
--- @param action number
function Battle.setAction(action) end

--- Disables the selected action
function Battle.disableAction() end

--- Wether all the enemies are spared
--- @return boolean
function Battle.allSpared() end

--- Wether all the enemies are dead
--- @return boolean
function Battle.allDead() end

--- Wether all the enemies are spared or killed
--- @return boolean
function Battle.allSparedOrKilled() end

--- Checks if the encounter is done
function Battle.checkEncounterEnd() end

--- Wins the encounter
--- @param exp? number EXP reward
--- @param gold? number GOLD reward
function Battle.win(exp, gold) end

--- Gets the selected enemy
--- @return Dummy.Battle.Enemy|nil
function Battle.getSelectedEnemy() end

--- Gets the battle's fight enemy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getFightEnemyMenu() end

--- Loads fight enemy menu
function Battle.loadFightEnemyMenu() end

--- Gets the battle's act enemy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getActEnemyMenu() end

--- Loads act enemy menu
function Battle.loadActEnemyMenu() end

--- Gets the battle's act menus
--- @return Dummy.Battle.ActionMenu[]
function Battle.getActMenus() end

--- Loads act menus
function Battle.loadActMenus() end

--- Gets the battle's item menu
--- @return Dummy.Battle.ActionMenu
function Battle.getItemMenu() end

--- Loads item menu
function Battle.loadItemMenu() end

--- Gets the battle's mercy menu
--- @return Dummy.Battle.ActionMenu
function Battle.getMercyMenu() end

--- Loads mercy menu
function Battle.loadMercyMenu() end

--- Flees the encounter
function Battle.flee() end

--- Gets the current battle state
--- @return string
function Battle.getCurrentState() end

--- Sets current battle state
--- @param state string
function Battle.setState(state) end

--- Gets the action fight sprite
--- @return Dummy.Sprite
function Battle.getActionFightSprite() end

--- Gets the action act sprite
--- @return Dummy.Sprite
function Battle.getActionActSprite() end

--- Gets the action item sprite
--- @return Dummy.Sprite
function Battle.getActionItemSprite() end

--- Gets the action mercy sprite
--- @return Dummy.Sprite
function Battle.getActionMercySprite() end

--- Starts action select
function Battle.startActionSelect() end

--- Updates action select
function Battle.updateActionSelect() end

--- Loads battle actions
function Battle.loadActions() end

--- Wether an action menu can be entered
--- @param menu Dummy.Battle.ActionMenu | nil
--- @return boolean
function Battle.canEnterMenu(menu) end

--- Opens an action's menu
--- @param menu Dummy.Battle.ActionMenu|nil
function Battle.enterMenu(menu) end

--- Leaves the current menu
function Battle.leaveMenu() end

--- Updates actions sprites and soul position
function Battle.updateActions() end

--- Unselects the current action
function Battle.unselectAction() end

--- Starts text dialogue
function Battle.startTextDialogue() end

--- Updates text dialogue
function Battle.updateTextDialogue() end

--- Starts enemy dialogue
function Battle.startEnemyDialogue() end

--- Updates enemy dialogue
function Battle.updateEnemyDialogue() end

--- Starts attacking
function Battle.startAttacking() end

--- Attacks the enemy
--- @param miss? boolean wether the attack missed
function Battle.attack(miss) end

--- Proceeds attack on an enemy
--- @param enemy Dummy.Battle.Enemy the attacked enemy
--- @param damage number damage amount
--- @param miss? boolean wether the attack missed
--- @protected
function Battle.proceedAttack(enemy, damage, miss) end

--- Ends attack on an enemy
--- @param enemy Dummy.Battle.Enemy the attacked enemy
function Battle.endAttack(enemy) end

--- Starts defending
function Battle.startDefending() end

--- Updates defending
function Battle.updateDefending(dt) end

--- Updates the player UI
function Battle.updatePlayerUI() end

--- Updates the battle
--- @param dt number
function Battle.update(dt) end

