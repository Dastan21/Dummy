--- @class Dummy.Signal
---
--- @field protected listeners table<string, fun(...)[]>
local Signal = {}

Signal.listeners = {}

--- Adds a listener to an event
--- @param event string
--- @param callback fun(...) the callback to add
function Signal.on(event, callback)
  if type(callback) ~= "function" then return end

  event = tostring(event)
  if Signal.listeners[event] == nil then
    Signal.listeners[event] = {}
  end
  table.insert(Signal.listeners[event], callback)
end

--- Removes a listener from an event
--- @param event string
--- @param callback fun(...) the callback to remove
function Signal.off(event, callback)
  local list = Signal.listeners[tostring(event)]
  if list == nil then return end

  for _ = #list, 1, -1 do
    table.removebyvalue(list, callback)
  end
end

--- Emits an event
--- @param event string
--- @param ... any
function Signal.emit(event, ...)
  local list = Signal.listeners[tostring(event)]
  if list == nil then return end

  for _, callback in ipairs(list) do
    callback(...)
  end
end

return Signal
