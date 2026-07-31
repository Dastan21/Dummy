--- @class Dummy.Cutscene : Dummy.Class
---
--- @field protected coroutine thread
--- @field protected wait_time number
--- @field protected wait_function fun(self: Dummy.Cutscene): boolean
--- @field protected paused boolean
--- @field protected ended boolean
--- @field protected timers table<Dummy.Timer.Handle, boolean>
local Cutscene = Class("Dummy.Cutscene")

--- Creates a cutscene
--- @param func fun()
--- @param ... unknown
--- @return Dummy.Cutscene
function Cutscene:new(func, ...)
  self = Class:new(Cutscene)

  self.coroutine = coroutine.create(func)
  self.wait_time = 0
  self.paused = false
  self.ended = false
  self.timers = {}

  self:resume(self, ...)

  return self
end

--- Wether the cutscene is playing
--- @return boolean
function Cutscene:isPlaying()
  return not self.ended
end

--- Plays a textbox dialogue in the cutscene
--- @param texts Dummy.Text.Text[]
function Cutscene:text(texts)
  local done = false
  local args = {}
  World.playDialogue(texts, function(_, ...)
    done = true
    args = { ... }
  end)
  return self:wait(function() return done, table.unpack(args) end)
end

--- Walks an NPC to a target position in the cutscene
--- @param obj Dummy.Object.NPC
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
function Cutscene:walkTo(obj, target_x, target_y, speed, keep_facing)
  local walked = false
  obj:walkTo(target_x, target_y, speed, keep_facing, function() walked = true end)
  return function() return walked end
end

--- Moves an NPC to a target position in the cutscene
--- @param obj Dummy.Object.NPC
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
function Cutscene:slideTo(obj, target_x, target_y, speed, keep_facing)
  local walked = false
  obj:slideTo(target_x, target_y, speed, keep_facing, function() walked = true end)
  return function() return walked end
end

--- Waits a certain amount of time in the cutscene
--- @param time number|function
function Cutscene:wait(time)
  if type(time) == "function" then
    self.wait_function = time
  else
    self.wait_time = Utils.getOrDefault(time, 0)
  end
  return coroutine.yield()
end

--- Waits for the player to press a button
--- @param input string|string[]
--- @param ... string|string[]
function Cutscene:waitForInput(input, ...)
  local inputs = { input, ... }
  local done = false
  return self:wait(function()
    for _, keys in ipairs(inputs) do
      if Input.isDown(keys) then
        done = true
        break
      end
    end
    return done
  end)
end

--- Gets the camera in the cutscene
--- @return Dummy.WorldCamera
function Cutscene:getCamera()
  assert(Scene.getCurrentSceneId() == "WORLD", "The cutscene can only be used in the world scene")

  local world_scene = Scene.getCurrentScene() --[[@as Dummy.Scene.World]]
  return world_scene:getCamera()
end

--- Attaches the camera to the player object in the cutscene
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:attachCamera(duration, method)
  local camera = self:getCamera()
  self:targetObject(camera:getTarget(), duration, method)
  camera:setAttached(true)
end

--- Detaches the camera from the player object in the cutscene
function Cutscene:detachCamera()
  local camera = self:getCamera()
  camera:setAttached(false)
end

--- Sets the camera target to an object in the cutscene
--- @param obj Dummy.Object|nil
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:targetObject(obj, duration, method)
  local room = World.getCurrentRoom()
  if room == nil then return end

  duration = Utils.getOrDefault(duration, 0)

  local camera = self:getCamera()
  if duration <= 0 or obj == nil then
    camera:setTarget(obj)
    return
  end

  local x, y = obj:getPosition()
  local width, height = camera:getDimensions()
  local room_width, room_height = room:getWidth(), room:getHeight()
  x = math.clamp(x, width / 2, room_width - width / 2)
  y = math.clamp(y, height / 2, room_height - height / 2)

  local start_x, start_y = camera:getViewportPosition()
  local data = {
    x = start_x,
    y = start_y
  }
  local done = false
  local during_timer = Timer.during(duration, function()
    camera:setViewportPosition(data.x, data.y)
  end)
  self.timers[during_timer] = true

  local tween_timer = Timer.tween(duration, data, {
    x = x,
    y = y
  }, Utils.getOrDefault(method, "linear"), function()
    camera:setTarget(obj)
    done = true
  end)
  self.timers[tween_timer] = true

  return self:wait(function() return done end)
end

--- Moves the camera to a position in the cutscene
--- @param x number
--- @param y number
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:moveCamera(x, y, duration, method)
  duration = Utils.getOrDefault(duration, 0)

  local camera = self:getCamera()
  if duration <= 0 then
    camera:setViewportPosition(x, y)
    return
  end

  local start_x, start_y = camera:getViewportPosition()
  local data = {
    x = start_x,
    y = start_y
  }
  local done = false
  local during_timer = Timer.during(duration, function()
    camera:setViewportPosition(data.x, data.y)
  end)
  self.timers[during_timer] = true

  local tween_timer = Timer.tween(duration, data, {
    x = x,
    y = y
  }, Utils.getOrDefault(method, "linear"), function()
    camera:setViewportPosition(x, y)
    done = true
  end)
  self.timers[tween_timer] = true

  return self:wait(function() return done end)
end

--- Zooms the camera in the cutscene
--- @param zoom number
--- @param duration? number
--- @param method? Dummy.Timer.Tween
function Cutscene:zoomCamera(zoom, duration, method)
  duration = Utils.getOrDefault(duration, 0)

  local camera = self:getCamera()
  if duration <= 0 then
    camera:setZoom(zoom)
    return
  end

  local data = {
    zoom = camera:getZoom(),
  }
  local done = false
  local during_timer = Timer.during(duration, function()
    camera:setZoom(data.zoom)
  end)
  self.timers[during_timer] = true

  local tween_timer = Timer.tween(duration, data, {
    zoom = zoom
  }, Utils.getOrDefault(method, "linear"), function()
    camera:setZoom(zoom)
    done = true
  end)
  self.timers[tween_timer] = true

  return self:wait(function() return done end)
end

--- Wether the cutscene can be resumed
--- @return boolean
function Cutscene:canResume()
  if self.wait_time > 0 or self.paused then return false end

  if self.wait_function then
    return self:wait_function()
  end

  return true
end

--- Tries to resume the cutscene
--- @return boolean
function Cutscene:tryResume()
  local result, a, b, c, d, e, f = self:canResume()
  if result then
    self:resume(a, b, c, d, e, f)
    return true
  end

  return false
end

--- Resumes the cutscene
--- @param ... unknown
function Cutscene:resume(...)
  self.paused = false
  self.wait_function = nil
  local ok, msg = coroutine.resume(self.coroutine, ...)
  if not ok then
    error(msg)
  end
end

--- Pauses the cutscene
function Cutscene:pause()
  self.paused = true
  return coroutine.yield()
end

--- Stops the cutscene
function Cutscene:stop()
  self.ended = true

  for timer in pairs(self.timers) do
    Timer.cancel(timer)
  end
  self.timers = {}
end

--- Updates the cutscene, called on every game update
--- @param dt number
function Cutscene:update(dt)
  if self.ended then return end

  self.wait_time = math.max(self.wait_time - dt, 0)

  if self.ended then return end

  if coroutine.status(self.coroutine) == "suspended" then
    self:tryResume()
  end

  if coroutine.status(self.coroutine) == "dead" then
    self:stop()
  end
end

return Cutscene
