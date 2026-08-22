--[[
  Generated from ..\engine\world\world.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/world.lua
]]

---@meta

--- @class Dummy.World
---
--- @field protected from_editor boolean
--- @field protected current_room Dummy.Room|nil
--- @field protected rooms table<number, Dummy.Room>
--- @field protected shops table<number, Dummy.Shop>
--- @field protected chestbox_items Dummy.Item[]
--- @field protected cutscene Dummy.Cutscene|nil
--- @field protected starting_encounter boolean
--- @field protected player_sprite Dummy.Sprite
--- @field protected heart_sprite Dummy.Sprite
--- @field protected overlay Dummy.Drawable
--- @field protected textbox Dummy.Textbox
--- @field protected player_menu Dummy.PlayerMenu
--- @field protected save_menu Dummy.SaveMenu
--- @field protected chestbox_menu Dummy.ChestboxMenu
--- @field protected playtime number
World = {}

--- Loads the world
--- @param from_editor? boolean
function World.load(from_editor) end

--- Wether the player is in a battle
--- @return boolean
function World.isInBattle() end

--- Gets the current room
--- @return Dummy.Room|nil
function World.getCurrentRoom() end

--- Gets a room by id
--- @generic T : Dummy.Room
--- @param room_id string
--- @return T
function World.getRoom(room_id) end

--- Transitions to a room
--- @param room_id string
--- @param spawn_x number
--- @param spawn_y number
--- @param instant? boolean wether the transition is instant (Defaults to `false`)
function World.transitionRoom(room_id, spawn_x, spawn_y, instant) end

--- Enters a room
--- @param room Dummy.Room
--- @param spawn_x number
--- @param spawn_y number
--- @param instant? boolean
--- @private
function World.enterRoom(room, spawn_x, spawn_y, instant) end

--- Handles the music transition out
--- @param next_music_name string|nil
--- @param instant? boolean
--- @private
function World.handleMusicTransitionOut(next_music_name, instant) end

--- Handles the music transition in
--- @param next_music_name string|nil
--- @param instant? boolean
--- @private
function World.handleMusicTransitionIn(next_music_name, instant) end

--- Handles the music transition pause
--- @param room Dummy.Room
--- @private
function World.handleMusicTransitionPause(room) end

--- Handles the music transition resume
--- @param room Dummy.Room
--- @private
function World.handleMusicTransitionResume(room) end

--- Starts an encounter
--- @param encounter Dummy.Battle.Data
--- @param ambush? boolean wether to play the ambush animation (Defaults to `false`)
--- @param ambush_sprite? string custom ambush sprite
function World.startEncounter(encounter, ambush, ambush_sprite) end

--- Does the transition animation
--- @param target_x number
--- @param target_y number
--- @private
function World.doEncounterTransitionAnimation(target_x, target_y) end

--- Gets a shop by id
--- @param shop_id string
--- @return Dummy.Shop
function World.getShop(shop_id) end

--- Transitions to a shop
--- @param shop_id string
function World.transitionShop(shop_id) end

--- Gets the chestbox's items
--- @return Dummy.Item[]
function World.getItemsInChestbox() end

--- Adds an item to the chestbox
--- @param item Dummy.Item
--- @param index? integer
function World.addItemIntoChestbox(item, index) end

--- Removes an item from the chestbox
--- @param index integer
function World.removeItemFromChestbox(index) end

--- Wether an object collide another in the world
--- @param object Dummy.Object
--- @param x? number
--- @param y? number
--- @return boolean, Dummy.Object|nil
function World.checkCollision(object, x, y) end

--- Called when the world is paused
function World.onPause() end

--- Called when the world is resumed
function World.onResume() end

--- Gets the textbox
--- @return Dummy.Textbox
function World.getTextbox() end

--- Plays a dialogue in the textbox
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText, choice?: integer)
--- @return Dummy.Textbox
function World.playDialogue(texts, on_done) end

--- Plays a cutscene in the world
--- @param cutscene fun(cutscene: Dummy.Cutscene)
function World.playCutscene(cutscene) end

--- Stops the current cutscene
function World.stopCutscene() end

--- Shows the save menu
function World.openSaveMenu() end

--- Closes the save menu
function World.closeSaveMenu() end

--- Opens the player menu
function World.openPlayerMenu() end

--- Closes the player menu
function World.closePlayerMenu() end

--- Opens the chestbox menu
--- @param chestbox_list? Dummy.Item[]
--- @param on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @param on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
function World.openChestboxMenu(chestbox_list, on_add, on_remove) end

--- Closes the chestbox menu
function World.closeChestboxMenu() end

--- Updates the world, called on every game update
--- @param dt number
function World.update(dt) end

