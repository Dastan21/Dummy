--[[
  Generated from ..\engine\scene\error_scene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/scene/error_scene.lua
]]

---@meta

--- @class Dummy.Scene.Error : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected traceback string
--- @field protected error_text Dummy.Text
--- @field protected back_main_menu_text Dummy.Text
--- @field protected copy_traceback_text Dummy.Text
--- @field protected copied_data table<string, number>
--- @field protected escape boolean
ErrorScene = {}

--- Loads the error scene
function ErrorScene.load(err) end

--- Updates the error scene, called on every game update
function ErrorScene.update() end

