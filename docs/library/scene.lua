--[[
  Generated from ..\engine\scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene.lua
]]

---@meta

--- @class Dummy.Scene
---
--- @field protected available_scenes table<string, Dummy.Scene.Scene>
--- @field protected frozen_scenes table<string, Dummy.Scene.Frozen>
--- @field protected current_scene Dummy.Scene.Scene|nil
--- @field protected current_scene_data table
--- @field protected current_scene_id string|nil
--- @field protected previous_scene_id string|nil
--- @field protected next_scene_id string|nil
--- @field protected quit_was_pressed boolean
--- @field protected quitting_delay number
--- @field protected quitting_time number
--- @field protected quitting_sprite Dummy.Sprite
--- @field protected layers table<string, number[]>
--- @field protected drawables table<string, Dummy.Drawable[]>
--- @field protected drawables_to_add Dummy.Drawable[]
--- @field protected drawables_to_remove Dummy.Drawable[]
--- @field protected next_drawables table<string, table<number, Dummy.Drawable[]>>
--- @field protected shaders Dummy.Shader[]
--- @field protected cameras Dummy.Camera[]
--- @field protected timers table<string, Dummy.Timer>
Scene = {}

--- @class Dummy.Scene.Frozen
---
--- @field scene Dummy.Scene.Scene
--- @field drawables table<string, Dummy.Drawable[]>
--- @field cameras Dummy.Camera[]

--- @class Dummy.Scene.Scene
---
--- @field load? fun(...)
--- @field unload? fun()
--- @field update? fun(dt: number)
--- @field isPersistent? fun(): boolean Wether the world scene is persistent
--- @field onPause? fun() Called when the scene is paused
--- @field onResume? fun() Called when the scene is resumed
--- @field canQuit? fun(): boolean? Wether the game can quit

--- Loads the scene manager
function Scene.load() end

--- Changes scene
--- @param scene_id string
--- @param ... any data to pass to the scene
function Scene.change(scene_id, ...) end

--- Resets the quitting timer
function Scene.resetQuitting() end

--- Updates the quitting timer
function Scene.updateQuitting(dt) end

--- Reloads the current scene
function Scene.reload() end

--- Reloads the current scene with data
--- @param ... any data to pass to the scene
function Scene.reloadWithData(...) end

--- Fully reloads the engine
function Scene.fullReload() end

--- Releases a frozen scene
--- @param scene_id string
function Scene.release(scene_id) end

--- Applies the next scene change
function Scene.applyChange() end

--- Updates the current scene, called on every game update
--- @param dt number
function Scene.update(dt) end

--- Draws the current scene
function Scene.draw() end

--- Draws the given camera
--- @param camera Dummy.Camera
function Scene.drawCamera(camera) end

--- Gets the current scene name
--- @return string
function Scene.getCurrentSceneId() end

--- Gets the previous scene name
--- @return string
function Scene.getPreviousSceneId() end

--- Gets the current scene
--- @return Dummy.Scene.Scene
function Scene.getCurrentScene() end

--- Adds a scene
--- @param scene_id string
--- @param scene Dummy.Scene.Scene
function Scene.addScene(scene_id, scene) end

--- Gets the drawables
--- @return table<string, Dummy.Drawable[]>
function Scene.getDrawables() end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable
--- @return Dummy.Drawable|nil
function Scene.addDrawable(drawable) end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function Scene.removeDrawable(drawable) end

--- Sorts current scene drawables
function Scene.sortDrawables() end

--- Prepares the next scene drawables
function Scene.prepareNextDrawables() end

--- Gets the current scene layers for a tag
--- @param tag string
--- @return number[]
function Scene.getLayers(tag) end

--- Adds a shader in the current scene
--- @param shader Dummy.Shader
--- @return Dummy.Shader|nil
function Scene.addShader(shader) end

--- Removes a shader in the current scene
--- @param shader Dummy.Shader
function Scene.removeShader(shader) end

--- Sorts shaders in the current scene by priority
function Scene.sortShaders() end

--- Gets the current scene cameras
--- @return Dummy.Camera[]
function Scene.getCameras() end

--- Gets a camera by tag
--- @param tag string
--- @return Dummy.Camera|nil
function Scene.getCameraByTag(tag) end

--- Adds a camera to the current scene
--- @param camera Dummy.Camera
--- @return Dummy.Camera|nil
function Scene.addCamera(camera) end

--- Removes a camera from the current scene
--- @param camera Dummy.Camera
function Scene.removeCamera(camera) end

--- Sorts cameras in the current scene by layer
function Scene.sortCameras() end

--- Gets the timer of the current scene
--- @return table
function Scene.getTimer() end

--- Wether the game can quit
--- @return boolean
function Scene.canQuit() end

--- Keeps only drawables that are persistent
--- @generic T : Dummy.Drawable|Dummy.Camera
--- @param drawables T[]
--- @param persistent? boolean
--- @param delete_others? boolean
--- @return T[]
function Scene.keepPersistents(drawables, persistent, delete_others) end

--- Cleans the current scene
function Scene.clean() end

