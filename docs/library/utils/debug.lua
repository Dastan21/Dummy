--[[
  Generated from ..\engine\utils\debug.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/debug.lua
]]

---@meta

--- @class Dummy.Debug
---
--- @field protected debug_camera Dummy.DebugCamera
--- @field protected logs string[]
--- @field protected margin number
--- @field protected scale number
--- @field protected display_hitbox boolean
--- @field protected paused boolean
--- @field protected log_bg_sprite Dummy.Sprite
--- @field protected log_text Dummy.Text
--- @field protected fps_text Dummy.Text
--- @field protected screenshot_text Dummy.Text
--- @field protected screenshot_fade_delay number
--- @field protected screenshot_fade_time number
--- @field protected screenshot_fade_timer Dummy.Timer.Handle|nil
Debug = {}

--- Wether the hitboxes should be displayed
--- @return boolean
function Debug.shouldDisplayHitbox() end

--- Wether the debugger is paused
--- @return boolean
function Debug.isPaused() end

--- Pauses the game
function Debug.pause() end

--- Resumes the game
function Debug.resume() end

--- Loads the debugger
function Debug.load() end

--- Saves the logs
function Debug.saveLogs() end

--- Clears the logs
function Debug.clearLogs() end

--- Updates the debugger, called on every game update
--- @param dt number
--- @return number
function Debug.update(dt) end

---
---Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](command:extension.lua.doc?["en-us/54/manual.html/pdf-tostring"]).
---The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"]) and [io.write](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"]).
---
---
---[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-print"])
---
---@param ... any
function print(...) end

