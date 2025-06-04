--- @class Dummy.Mod.Player
---
--- @field name string|nil
--- @field level number|nil
--- @field hp number|nil
--- @field max_hp number|nil
--- @field at number|nil
--- @field df number|nil


--- @class Dummy.Mod.Encounter
---
--- @field text string|nil
--- @field flee boolean|nil
--- @field music string|nil


--- @class Dummy.Mod.Enemy
---
--- @field name string
--- @field hp number|nil
--- @field at number|nil
--- @field df number|nil
--- @field xp number|nil
--- @field gold number|nil
--- @field check string|table<number, string>|nil
--- @field position { [1]: number, [2]: number }|nil
--- @field size { [1]: number, [2]: number }|nil

--- @class Dummy.Mod.Data
---
--- @field name string
--- @field title string|nil
--- @field standalone boolean|nil

--- @class Dummy.Mod : Dummy.Class
---
--- @field id string
--- @field name string
--- @field title string|nil
--- @field player Dummy.Mod.Player|nil
--- @field encounter Dummy.Mod.Encounter|nil
--- @field enemies table<number, Dummy.Mod.Enemy>|nil
local Mod = Class()

--- Gets the class name
--- @return string
function Mod:getClass()
  return "Dummy.Mod"
end

--- Called when the mod is loaded
function Mod:load() end

--- Creates a mod
--- @param data Dummy.Mod.Data
--- @return Dummy.Mod
function Mod:new(data)
  return Class:new(Mod, data)
end

return Mod
