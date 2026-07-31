--[[
  Generated from ..\engine\utils\timer.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/timer.lua
]]

---@meta

--- @class Dummy.Timer : Dummy.Class
Timer = {}

--- @alias Dummy.Timer.Tween
--- | "linear"
--- | "in-linear"
--- | "out-linear"
--- | "in-out-linear"
---
--- | "quad"
--- | "in-quad"
--- | "out-quad"
--- | "in-out-quad"
---
--- | "cubic"
--- | "in-cubic"
--- | "out-cubic"
--- | "in-out-cubic"
---
--- | "quart"
--- | "in-quart"
--- | "out-quart"
--- | "in-out-quart"
---
--- | "quint"
--- | "in-quint"
--- | "out-quint"
--- | "in-out-quint"
---
--- | "sine"
--- | "in-sine"
--- | "out-sine"
--- | "in-out-sine"
---
--- | "expo"
--- | "in-expo"
--- | "out-expo"
--- | "in-out-expo"
---
--- | "circ"
--- | "in-circ"
--- | "out-circ"
--- | "in-out-circ"
---
--- | "back"
--- | "in-back"
--- | "out-back"
--- | "in-out-back"
---
--- | "bounce"
--- | "in-bounce"
--- | "out-bounce"
--- | "in-out-bounce"
---
--- | "elastic"
--- | "in-elastic"
--- | "out-elastic"
--- | "in-out-elastic"
---
--- | string

--- @class Dummy.Timer.Handle
---
--- @field time number
--- @field after fun(fun: fun())
--- @field during fun(dt: number, left: number)
--- @field limit number
--- @field count number
--- @field persistent boolean

--- Updates the timers, called on every game update
--- @param dt number
function Timer.update(dt) end

--- Updates the timer, called on every game update
--- @overload fun(delay: number, fn: fun())
--- @param dt number
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:update(dt) end

--- Schedules a function to be called the next update.
--- @param func fun()
--- @return Dummy.Timer.Handle
function Timer.next(func) end

--- Schedules a function to be called the next update.
--- @param func fun()
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:next(func) end

--- Schedules a function. The function will be executed after `delay` seconds have elapsed.
---
--- `func` will receive itself as only parameter. This is useful to implement periodic behavior.
--- @param delay number
--- @param func fun(func?: fun())
--- @return Dummy.Timer.Handle
function Timer.after(delay, func) end

--- Schedules a function. The function will be executed after `delay` seconds have elapsed.
---
--- `func` will receive itself as only parameter. This is useful to implement periodic behavior.
--- @param delay number
--- @param func fun(func?: fun())
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:after(delay, func) end

--- Executes a function that can be paused without causing the rest of the program to be suspended.
--- @param func fun(wait: fun(delay: number)) script to execute
--- @return Dummy.Timer.Handle
function Timer.script(func) end

--- Executes a function that can be paused without causing the rest of the program to be suspended.
--- @param func fun(wait: fun(delay: number)) script to execute
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:script(func) end

--- Adds a function that will be called `count` times every `delay` seconds.
---
--- If count is omitted, the function will be called until it returns `false` or `timer:cancel()` or `timer:clear()` is called.
--- @param delay number number of seconds between two consecutive function calls
--- @param func fun() the function to be called periodically
--- @param count? number number of times the function is to be called
--- @return Dummy.Timer.Handle
function Timer.every(delay, func, count) end

--- Adds a function that will be called `count` times every `delay` seconds.
---
--- If count is omitted, the function will be called until it returns `false` or `timer:cancel()` or `timer:clear()` is called.
--- @param delay number number of seconds between two consecutive function calls
--- @param func fun() the function to be called periodically
--- @param count? number number of times the function is to be called
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:every(delay, func, count) end

--- Runs `func(dt)` for the next delay seconds.
---
--- Optionally runs `after()` once `delay` seconds have passed.
--- @param delay number number of seconds the func will be called
--- @param func fun(dt: number, left: number) the function to be called
--- @param after? fun() a function to be called after `delay` seconds
--- @return Dummy.Timer.Handle
function Timer.during(delay, func, after) end

--- Runs `func(dt)` for the next delay seconds.
---
--- Optionally runs `after()` once `delay` seconds have passed.
--- @param delay number number of seconds the func will be called
--- @param func fun(dt: number, left: number) the function to be called
--- @param after? fun() a function to be called after `delay` seconds
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:during(delay, func, after) end

--- [Tweening](http://en.wikipedia.org/wiki/Inbetweening) (short for in-betweening) is the process that happens between two defined states.
--- For example, a tween can be used to gradually fade out a graphic or move a text message to the center of the screen.
--- For more information why tweening should be important to you, check out this great talk on [juicy games](http://www.youtube.com/watch?v=Fy0aCDmgnxg).
--- @param duration number duration of the tween
--- @param subject table object to be tweened
--- @param target table target values
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param after? fun() function to execute after the tween has finished
--- @param ... any additional arguments to the tweening function
--- @return Dummy.Timer.Handle
function Timer.tween(duration, subject, target, method, after, ...) end

--- [Tweening](http://en.wikipedia.org/wiki/Inbetweening) (short for in-betweening) is the process that happens between two defined states.
--- For example, a tween can be used to gradually fade out a graphic or move a text message to the center of the screen.
--- For more information why tweening should be important to you, check out this great talk on [juicy games](http://www.youtube.com/watch?v=Fy0aCDmgnxg).
--- @param duration number duration of the tween
--- @param subject table object to be tweened
--- @param target table target values
--- @param method? Dummy.Timer.Tween tweening method (Defaults to `"linear"`)
--- @param after? fun() function to execute after the tween has finished
--- @param ... any additional arguments to the tweening function
--- @return Dummy.Timer.Handle
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:tween(duration, subject, target, method, after, ...) end

--- Creates a custom interpolation method
--- @param name string name of the method
--- @param func fun(...: any) function to interpolate
function Timer.addTween(name, func) end

--- Prevent a timer from being executed in the future.
--- @param handle Dummy.Timer.Handle|nil the function to be canceled
function Timer.cancel(handle) end

--- Prevent a timer from being executed in the future.
--- @param handle Dummy.Timer.Handle|nil the function to be canceled
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:cancel(handle) end

--- Remove all timed and periodic functions. Functions that have not yet been executed will discarded.
function Timer.clear() end

--- Remove all timed and periodic functions. Functions that have not yet been executed will discarded.
--- @diagnostic disable-next-line: duplicate-set-field
function Timer:clear() end

--- Creates a new timer
--- @return Dummy.Timer
function Timer:new() end

