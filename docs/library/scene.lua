--[[
  Generated from ..\engine\scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene.lua
]]

---@meta

--- @class Dummy.Scene
---
--- @field private scene Dummy.Scene.Scene|nil
--- @field private scene_name string
--- @field private scene_data table
--- @field private quitting_delay number
--- @field private quitting_timer number
--- @field private quitting_sprite Dummy.Sprite
--- @field private drawables Dummy.Drawable[]
--- @field private dialogues Dummy.DialogueText[]
Scene = {}

--- @class Dummy.Scene.Scene
---
--- @field load fun(...)
--- @field update fun(dt: number)

--- Loads the scene manager
function Scene.load() end

--- Changes scene
--- @param scene_name string
--- @param ... any data to pass to the scene
function Scene.change(scene_name, ...) end

--- Resets the quitting timer
function Scene.resetQuitting() end

--- Updates the quitting timer
function Scene.updateQuitting(dt) end

--- Reloads the current scene
function Scene.reload() end

--- Fully reloads the engine
function Scene.fullReload() end

--- Updates the current scene
---@param dt number
function Scene.update(dt) end

--- Draws the current scene
function Scene.draw() end

--- Gets the current scene name
--- @return string
function Scene.getSceneName() end

--- Gets the current scene
--- @return Dummy.Scene.Scene
function Scene.getCurrentScene() end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable|fun()
function Scene.addDrawable(drawable) end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable|fun()
function Scene.removeDrawable(drawable) end

--- Sorts drawables by layer in the current scene
function Scene.sortDrawables() end

--- Adds a dialogue text in the current scene
--- @param dialogue_text Dummy.DialogueText
function Scene.addDialogue(dialogue_text) end

--- Cleans the current scene
function Scene.clean() end

