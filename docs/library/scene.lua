--[[
  Generated from ..\engine\scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene.lua
]]

---@meta

--- @class Dummy.Scene
---
--- @field protected scenes table<string, Dummy.Scene.Scene>
--- @field protected scene Dummy.Scene.Scene|nil
--- @field protected scene_name string|nil
--- @field protected previous_scene_name string|nil
--- @field protected scene_data table
--- @field protected quitting_delay number
--- @field protected quitting_timer number
--- @field protected quitting_sprite Dummy.Sprite
--- @field protected layer_canvas [ love.Canvas, love.Canvas ]
--- @field protected drawables Dummy.Drawable[]
--- @field protected shaders Dummy.Shader[]
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
--- @param dt number
function Scene.update(dt) end

--- Draws the current scene
function Scene.draw() end

--- Gets the current scene name
--- @return string
function Scene.getCurrentSceneName() end

--- Gets the previous scene name
--- @return string
function Scene.getPreviousSceneName() end

--- Gets the current scene
--- @return Dummy.Scene.Scene
function Scene.getCurrentScene() end

--- Adds a scene
--- @param scene_name string
--- @param scene Dummy.Scene.Scene
function Scene.addScene(scene_name, scene) end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable
--- @return Dummy.Drawable|nil
function Scene.addDrawable(drawable) end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function Scene.removeDrawable(drawable) end

--- Sorts current scene drawables
function Scene.sortDrawables() end

--- Gets the current scene layers
--- @return number[]
function Scene.getLayers() end

--- Adds a shader in the current scene
--- @param shader Dummy.Shader
--- @return Dummy.Shader|nil
function Scene.addShader(shader) end

--- Removes a shader in the current scene
--- @param shader Dummy.Shader
function Scene.removeShader(shader) end

--- Sorts shaders in the current scene by priority
function Scene.sortShaders() end

--- Cleans the current scene
function Scene.clean() end

