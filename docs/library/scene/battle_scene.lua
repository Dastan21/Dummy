--[[
  Generated from ..\engine\scene\battle_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/battle_scene.lua
]]

---@meta

--- @class Dummy.Scene.Battle : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected previous_scene string
--- @field protected mod Dummy.Mod
--- @field protected encounter Dummy.Battle.Encounter
--- @field protected previous_state string
--- @field protected fader_alpha number
--- @field protected fader_drawable Dummy.Drawable
BattleScene = {}

--- Loads the battle scene
--- @param EncounterClass Dummy.Battle.Encounter
--- @param previous_scene? string
function BattleScene.load(EncounterClass, previous_scene) end

--- Fades out the battle scene
--- @private
function BattleScene.fadeOut() end

--- Updates the battle scene, called on every game update
--- @param dt number
function BattleScene.update(dt) end

