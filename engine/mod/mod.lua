--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title string|nil
--- @field version string|nil
--- @field standalone boolean|nil


--- @class Dummy.Mod : Dummy.Class
---
--- @field protected id string
--- @field protected name string
--- @field protected version string
--- @field protected title string|nil
--- @field protected standalone boolean
local Mod = Class()

--- Gets the class name
--- @return string
function Mod:getClass()
  return "Dummy.Mod"
end

--- Gets the mod's id
--- @return string
function Mod:getId()
  return self.id
end

--- Gets the mod's name
--- @return string
function Mod:getName()
  return self.name
end

--- Gets the mod's version
--- @return string
function Mod:getVersion()
  return self.version
end

--- Gets the mod's title
--- @return string|nil
function Mod:getTitle()
  return self.title
end

--- Gets the mod's title
--- @param title string
function Mod:setTitle(title)
  self.title = title
end

--- Called when the mod is loading
function Mod:load() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

--- Called when on every update
--- @param dt number
function Mod:update(dt) end

--- Called when the encounter state changes
--- @param current_state string
--- @param previous_state string
function Mod:onStateChange(current_state, previous_state) end

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data)
  assert(data.name ~= nil, "Mod has no name")

  local mod = Class:new(Mod)

  mod.name = data.name
  mod.title = Utils.getOrDefault(data.title, data.name)
  mod.version = Utils.getOrDefault(data.version, "???")
  mod.standalone = Utils.getOrDefault(data.standalone, false)

  return mod
end

return Mod
