--- @class Dummy.Mod
---
--- @field id string
--- @field name string
--- @field title string|nil
--- @field player Dummy.Mod.Player|nil
--- @field encounter Dummy.Mod.Encounter|nil
--- @field enemies table<number, Dummy.Mod.Enemy>|nil
--- @field load fun()|nil
--- @field preview fun()|nil


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
--- @field check string|nil
--- @field position Dummy.Mod.Enemy.Position|nil

--- @class Dummy.Mod.Enemy.Position
---
--- @field center { [1]: number, [2]: number }|nil
--- @field size { [1]: number, [2]: number }|nil
