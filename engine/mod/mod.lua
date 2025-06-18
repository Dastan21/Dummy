--- @class Dummy.Mod.Encounter
---
--- @field text Dummy.Text.Text|nil the encounter text
--- @field can_flee boolean|nil wether the action is displayed (Defaults to `true`)
--- @field music string|nil the encounter music (Defaults to `"battle"`)


--- @class Dummy.Mod.Enemy
---
--- @field name string
--- @field hp number|nil
--- @field at number|nil
--- @field df number|nil
--- @field xp number|nil
--- @field gold number|nil
--- @field check Dummy.Text.Text|nil
--- @field position { [1]: number, [2]: number }|nil
--- @field size { [1]: number, [2]: number }|nil


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

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data)
  return Class:new(Mod, {
    name = data.name,
    title = data.title,
    version = Utils.getOrDefault(data.version, "???"),
    standalone = Utils.getOrDefault(data.standalone, false),
  })
end

return Mod
