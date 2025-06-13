--[[
  Generated from ..\engine\encounter\encounter.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/encounter.lua
]]

---@meta

--- @class Dummy.Encounter
---
--- @field protected encounter Dummy.Encounter
--- @field protected text Dummy.Text.Text
--- @field protected can_flee boolean
--- @field protected music love.Source
--- @field protected enemies Dummy.Enemy[]
--- @field protected current_state string
--- @field protected previous_state string
--- @field protected current_menu Dummy.Encounter.ActionMenu|nil
--- @field protected bg_sprite Dummy.Sprite
--- @field protected black_sprite Dummy.Sprite
--- @field protected dialogue_text Dummy.DialogueText
--- @field protected target_sprite Dummy.Sprite
--- @field protected target_bar_sprite Dummy.Sprite
--- @field protected miss_text Dummy.Text
--- @field protected strike_sprite Dummy.Sprite
--- @field protected enemy_hp_draw Dummy.Drawable
--- @field protected enemy_hp_text Dummy.Text
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
Encounter = {}

--- Gets the class name
--- @return string
function Encounter.getClass() end

--- Gets the encounter's text
--- @return Dummy.Text.Text
function Encounter.getText() end

--- Sets the encounter's text
--- @param text Dummy.Text.Text
function Encounter.setText(text) end

--- Adds one or more enemies to the encounter
---@param enemy Dummy.Enemy|Dummy.Enemy[]
---@param ... Dummy.Enemy
function Encounter.addEnemy(enemy, ...) end

--- Wether the player can flee the encounter
--- @return boolean
function Encounter.canFlee() end

--- Sets wether the player can flee the encounter
---@param can_flee boolean
function Encounter.setCanFlee(can_flee) end

--- Gets the encounter's text
--- @return love.Source
function Encounter.getMusic() end

--- Sets the encounter music
---@param music string
function Encounter.setMusic(music) end

--- Plays a text dialogue
---@param text Dummy.Text.Text
---@param can_skip? boolean
function Encounter.playDialogue(text, can_skip) end

function Encounter.load() end

--- Loads fight enemy menu
function Encounter.loadFightEnemyMenu() end

--- Loads act enemy menu
function Encounter.loadActEnemyMenu() end

--- Loads act menus
function Encounter.loadActMenus() end

--- Loads item menu
function Encounter.loadItemMenu() end

--- Loads mercy menu
function Encounter.loadMercyMenu() end

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
function Encounter.updateEnemyDialogue(dt) end

--- Starts attacking
function Encounter.startAttacking() end

--- Starts defending
function Encounter.startDefending() end

--- Updates defending
function Encounter.updateDefending(dt) end

function Encounter.update(dt) end

--- Called when the encounter state changes
--- @param current_state string
--- @param previous_state string
function Encounter.onStateChange(current_state, previous_state) end

