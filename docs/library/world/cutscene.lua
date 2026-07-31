--[[
  Generated from ..\engine\world\cutscene.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/cutscene.lua
]]

---@meta

--- @class Dummy.Cutscene : Dummy.Class
---
--- @field protected coroutine thread
--- @field protected wait_time number
--- @field protected wait_function fun(self: Dummy.Cutscene): boolean
--- @field protected paused boolean
--- @field protected ended boolean
--- @field protected timers table<Dummy.Timer.Handle, boolean>
Cutscene = {}

--- Creates a cutscene
--- @param func fun()
--- @param ... unknown
--- @return Dummy.Cutscene
function Cutscene:new(func, ...) end

--- Wether the cutscene is playing
--- @return boolean
function Cutscene:isPlaying() end

--- Plays a textbox dialogue in the cutscene
--- @param texts Dummy.Text.Text[]
function Cutscene:text(texts) end

--- Walks an NPC to a target position in the cutscene
--- @param obj Dummy.Object.NPC
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
function Cutscene:walkTo(obj, target_x, target_y, speed, keep_facing) end

--- Moves an NPC to a target position in the cutscene
--- @param obj Dummy.Object.NPC
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
function Cutscene:slideTo(obj, target_x, target_y, speed, keep_facing) end

--- Waits a certain amount of time in the cutscene
--- @param time number|function
function Cutscene:wait(time) end

--- Waits for the player to press a button
--- @param input string|string[]
--- @param ... string|string[]
function Cutscene:waitForInput(input, ...) end

--- Gets the camera in the cutscene
--- @return Dummy.WorldCamera
function Cutscene:getCamera() end

--- Attaches the camera to the player object in the cutscene
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:attachCamera(duration, method) end

--- Detaches the camera from the player object in the cutscene
function Cutscene:detachCamera() end

--- Sets the camera target to an object in the cutscene
--- @param obj Dummy.Object|nil
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:targetObject(obj, duration, method) end

--- Moves the camera to a position in the cutscene
--- @param x number
--- @param y number
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:moveCamera(x, y, duration, method) end

--- Zooms the camera in the cutscene
--- @param zoom number
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:zoomCamera(zoom, duration, method) end

--- Wether the cutscene can be resumed
--- @return boolean
function Cutscene:canResume() end

--- Tries to resume the cutscene
--- @return boolean
function Cutscene:tryResume() end

--- Resumes the cutscene
--- @param ... unknown
function Cutscene:resume(...) end

--- Pauses the cutscene
function Cutscene:pause() end

--- Stops the cutscene
function Cutscene:stop() end

--- Updates the cutscene, called on every game update
--- @param dt number
function Cutscene:update(dt) end

