--[[
  Generated from ..\engine\scene\encounter_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/encounter_scene.lua
]]

---@meta

--- @class Dummy.Scene.Encounter : Dummy.Scene.Scene
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
Encounter = {}

--- Loads the encounter scene
--- @param mod Dummy.Mod
function Encounter.load(mod) end

function Encounter.addEnemy(enemy) end

function Encounter.loadActions() end

--- Loads actions menus
function Encounter.loadMenus() end

--- Loads fight enemy menu
function Encounter.loadFightEnemyMenu() end

--- Loads act enemy menu
function Encounter.loadActEnemyMenu() end

--- Loads act menus
function Encounter.loadActMenus() end

--- Loads item menu
function Encounter.loadItemMenu() end

function Encounter.loadMercyMenu() end

--- Sets current encounter state
--- @param state string
function Encounter.setState(state) end

function Encounter.startActionSelect() end

function Encounter.updateActionSelect() end

--- Opens an action's menu
--- @param menu Dummy.Encounter.ActionMenu|nil
function Encounter.enterMenu(menu) end

--- Leaves the current menu
function Encounter.leaveMenu() end

--- Updates actions sprites and soul position
function Encounter.updateActions() end

function Encounter.unselectAction() end

function Encounter.startTextDialogue() end

function Encounter.updateTextDialogue() end

function Encounter.startEnemyDialogue() end

function Encounter.updateEnemyDialogue(dt) end

function Encounter.startAttacking() end

function Encounter.startDefending() end

function Encounter.updateDefending(dt) end

function Encounter.update(dt) end

