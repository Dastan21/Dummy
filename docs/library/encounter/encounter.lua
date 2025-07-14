--[[
  Generated from ..\engine\encounter\encounter.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/encounter.lua
]]

---@meta

--- @class Dummy.Encounter
---
--- @field protected text Dummy.Text.Text[]
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
Encounter = {}

--- Gets the class name
--- @return string
function Encounter.getClassName() end

--- Gets the encounter's text
--- @return Dummy.Text.Text[]
function Encounter.getText() end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
function Encounter.setText(text, ...) end

--- Gets the encounter's enemies
--- @return Dummy.Enemy[]
function Encounter.getEnemies() end

--- Adds one or more enemies to the encounter
--- @param enemy Dummy.Enemy|Dummy.Enemy[]
--- @param ... Dummy.Enemy
function Encounter.addEnemy(enemy, ...) end

--- Sets one or more waves to the encounter
--- @param wave Dummy.Wave
function Encounter.setWave(wave, ...) end

--- Wether the player can flee the encounter
--- @return boolean
function Encounter.canFlee() end

--- Sets wether the player can flee the encounter
--- @param can_flee boolean
function Encounter.setCanFlee(can_flee) end

--- Gets the encounter's text
--- @return love.Source
function Encounter.getMusic() end

--- Sets the encounter music
--- @param music string
function Encounter.setMusic(music) end

--- Gets the encounter dialogue text
--- @return Dummy.DialogueText
function Encounter.getDialogueText() end

--- Plays a dialogue text
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Encounter.playDialogueText(text, ...) end

--- Plays a dialogue bubble
--- @param bubble_type Dummy.DialogueBubble.Type
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueBubble
function Encounter.playDialogueBubble(bubble_type, text, ...) end

--- Wether all the enemies are spared
--- @return boolean
function Encounter.allSpared() end

--- Wether all the enemies are dead
--- @return boolean
function Encounter.allDead() end

--- Wether all the enemies are spared or killed
--- @return boolean
function Encounter.allSparedOrKilled() end

--- Checks if the encounter is done
function Encounter.checkEncounterEnd() end

--- Wins the encounter
--- @param exp? number EXP reward
--- @param gold? number GOLD reward
function Encounter.win(exp, gold) end

--- Gets the selected enemy
--- @return Dummy.Enemy|nil
function Encounter.getSelectedEnemy() end

--- Loads the encounter
function Encounter.load() end

--- Gets the encounter's fight enemy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getFightEnemyMenu() end

--- Loads fight enemy menu
function Encounter.loadFightEnemyMenu() end

--- Gets the encounter's act enemy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getActEnemyMenu() end

--- Loads act enemy menu
function Encounter.loadActEnemyMenu() end

--- Gets the encounter's act menus
--- @return Dummy.Encounter.ActionMenu[]
function Encounter.getActMenus() end

--- Loads act menus
function Encounter.loadActMenus() end

--- Gets the encounter's item menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getItemMenu() end

--- Loads item menu
function Encounter.loadItemMenu() end

--- Gets the encounter's mercy menu
--- @return Dummy.Encounter.ActionMenu
function Encounter.getMercyMenu() end

--- Loads mercy menu
function Encounter.loadMercyMenu() end

--- Flees the encounter
function Encounter.flee() end

--- Gets the current encounter state
--- @return string
function Encounter.getCurrentState() end

--- Sets current encounter state
--- @param state string
function Encounter.setState(state) end

--- Starts action select
function Encounter.startActionSelect() end

--- Updates action select
function Encounter.updateActionSelect() end

--- Loads encounter actions
function Encounter.loadActions() end

--- Opens an action's menu
--- @param menu Dummy.Encounter.ActionMenu|nil
function Encounter.enterMenu(menu) end

--- Leaves the current menu
function Encounter.leaveMenu() end

--- Updates actions sprites and soul position
function Encounter.updateActions() end

--- Unselects the current action
function Encounter.unselectAction() end

--- Starts text dialogue
function Encounter.startTextDialogue() end

--- Updates text dialogue
function Encounter.updateTextDialogue() end

--- Starts enemy dialogue
function Encounter.startEnemyDialogue() end

--- Updates enemy dialogue
function Encounter.updateEnemyDialogue() end

--- Starts attacking
function Encounter.startAttacking() end

--- Starts defending
function Encounter.startDefending() end

--- Updates defending
function Encounter.updateDefending(dt) end

--- Updates the encounter
function Encounter.update(dt) end

--- Updates the player UI
function Encounter.updatePlayerUI() end

