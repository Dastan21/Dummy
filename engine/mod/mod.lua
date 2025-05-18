---@class Dummy.Mod.Data
---
---@field name string
---@field title string|nil
---@field player Dummy.Mod.Data.Player|nil
---@field encounter Dummy.Mod.Data.Encounter|nil
---@field enemies table<number, Dummy.Mod.Data.Enemy>|nil


---@class Dummy.Mod.Data.Player
---
---@field name string|nil
---@field level number|nil
---@field hp number|nil
---@field max_hp number|nil
---@field at number|nil
---@field df number|nil


---@class Dummy.Mod.Data.Encounter
---
---@field text string|nil
---@field flee boolean|nil


---@class Dummy.Mod.Data.Enemy
---
---@field name string
---@field hp number|nil
---@field at number|nil
---@field df number|nil
---@field xp number|nil
---@field gold number|nil
---@field check string|nil
