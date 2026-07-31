--- @class Dummy.Mod.Config.Savepoint
---
--- @field name string
--- @field lv number
--- @field time number
--- @field room_id string
--- @field room_name string
--- @field [string] unknown

--- @class Dummy.Mod.Config
---
--- @field savepoint Dummy.Mod.Config.Savepoint
--- @field [string] unknown

--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title Dummy.Text.Text|nil
--- @field version string|nil
--- @field standalone boolean|nil

--- @class Dummy.Mod : Dummy.Class
---
--- @field protected id string
--- @field protected name string
--- @field protected version string
--- @field protected title Dummy.Text.Text|nil
--- @field protected standalone boolean
--- @field protected config Dummy.Mod.Config
local Mod = Class("Dummy.Mod")

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data)
  assert(data.name ~= nil, "Mod requires at least a name")

  self = Class:new(Mod)
  self.name = data.name
  self.title = Utils.getOrDefault(data.title, data.name)
  self.version = data.version
  self.standalone = Utils.getOrDefault(data.standalone, false)
  self.config = nil

  return self
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
--- @return Dummy.Text.Text|nil
function Mod:getTitle()
  return self.title
end

--- Gets the mod's title
--- @param title Dummy.Text.Text|nil
function Mod:setTitle(title)
  if self.title == title then return end

  self.title = title
  ModList.setWindowTitleAndIcon()
end

--- Gets the mod's config
--- @return Dummy.Mod.Config
function Mod:getConfig()
  return self.config
end

--- Loads the mod
function Mod:load() end

--- Called when the main menu is loaded, for standalone mods only
function Mod:preview() end

--- Called before the game is saved
function Mod:onGameSave() end

--- Called when a room is entered
--- @param room Dummy.Room
function Mod:onRoomEnter(room) end

--- Called when a room is left
--- @param room Dummy.Room
function Mod:onRoomLeave(room) end

--- Called when an encounter starts
--- @param encounter Dummy.Battle.Encounter
function Mod:onEncounterStart(encounter) end

--- Called when an encounter ends
--- @param encounter Dummy.Battle.Encounter
function Mod:onEncounterEnd(encounter) end

--- Updates the mod, called on every game update
--- @param dt number
function Mod:update(dt) end

return Mod
