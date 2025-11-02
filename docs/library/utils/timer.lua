--[[
  Generated from ..\engine\utils\timer.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/timer.lua
]]

---@meta

--- @class Dummy.Timer : Dummy.Class
---
--- @field protected timer table
--- @field private timers table<table, boolean>
Timer = {}

--- @alias Dummy.Timer.Tween "linear" | "quad" | "cubic" | "quart" | "quint" | "sine" | "expo" | "circ" | "back" | "bounce" | "elastic" | string

--- Updates the timers
--- @param dt number
function Timer.update(dt) end

--- Schedules a function to be called the next update.
--- @param func fun()
--- @return table
function Timer.next(func) end

--- Schedules a function. The function will be executed after `delay` seconds have elapsed.
---
--- `func` will receive itself as only parameter. This is useful to implement periodic behavior.
--- @param delay number
--- @param func fun(func?: fun())
--- @return table
function Timer.after(delay, func) end

--- Executes a function that can be paused without causing the rest of the program to be suspended.
--- @param func fun(wait: fun(delay: number)) script to execute
--- @return table
function Timer.script(func) end

--- Adds a function that will be called `count` times every `delay` seconds.
---
--- If count is omitted, the function will be called until it returns `false` or `timer:cancel()` or `timer:clear()` is called.
--- @param delay number number of seconds between two consecutive function calls
--- @param func fun() the function to be called periodically
--- @param count? number number of times the function is to be called
--- @return table
function Timer.every(delay, func, count) end

--- Runs `func(dt)` for the next delay seconds.
---
--- Optionally runs `after()` once `delay` seconds have passed.
--- @param delay number number of seconds the func will be called
--- @param func fun(dt: number) the function to be called
--- @param after? fun() a function to be called after `delay` seconds
--- @return table
function Timer.during(delay, func, after) end

--- [Tweening](http://en.wikipedia.org/wiki/Inbetweening) (short for in-betweening) is the process that happens between two defined states.
--- For example, a tween can be used to gradually fade out a graphic or move a text message to the center of the screen.
--- For more information why tweening should be important to you, check out this great talk on [juicy games](http://www.youtube.com/watch?v=Fy0aCDmgnxg).
--- @param duration number duration of the tween
--- @param subject table object to be tweened
--- @param target table target values
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param after? fun() function to execute after the tween has finished
--- @param ... any additional arguments to the tweening function
--- @return table
function Timer.tween(duration, subject, target, method, after, ...) end

--- Creates a custom interpolation method
--- @param name string name of the method
--- @param func fun(...: any) function to interpolate
function Timer.addTween(name, func) end

--- Prevent a timer from being executed in the future.
--- @param handle table|nil the function to be canceled
function Timer.cancel(handle) end

--- Remove all timed and periodic functions. Functions that have not yet been executed will discarded.
function Timer.clear() end

