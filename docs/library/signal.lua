--[[
  Generated from ..\engine\signal.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/signal.lua
]]

---@meta

--- @class Dummy.Signal
---
--- @field protected listeners table<string, fun(...)[]>
Signal = {}

--- Adds a listener to an event
--- @param event string
--- @param callback fun(...) the callback to add
function Signal.on(event, callback) end

--- Removes a listener from an event
--- @param event string
--- @param callback fun(...) the callback to remove
function Signal.off(event, callback) end

--- Emits an event
--- @param event string
--- @param ... any
function Signal.emit(event, ...) end

