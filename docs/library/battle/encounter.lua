--[[
  Generated from ..\engine\battle\encounter.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/encounter.lua
]]

---@meta

--- @class Dummy.Battle.Encounter : Dummy.Class
---
--- @field protected can_flee boolean
--- @field protected exp_reward number
--- @field protected gold_reward number
--- @field protected enemies Dummy.Battle.Enemy[]
--- @field protected waves Dummy.Battle.Wave[]
Encounter = {}

--- Creates an encounter
--- @return Dummy.Battle.Encounter
function Encounter:new() end

--- Wether the player can flee the encounter
--- @return boolean
function Encounter:canFlee() end

--- Sets wether the player can flee the encounter
--- @param can_flee boolean
function Encounter:setCanFlee(can_flee) end

--- Gets the encounter's reward : exp and gold
--- @return number, number
function Encounter:getReward() end

--- Sets the encounter's reward : exp and gold
--- @param exp number
--- @param gold number
function Encounter:setReward(exp, gold) end

--- Gets the encounter's enemies
--- @return Dummy.Battle.Enemy[]
function Encounter:getEnemies() end

--- Adds one or more enemies to the encounter
--- @param enemy Dummy.Battle.Enemy|Dummy.Battle.Enemy[]
--- @param index? integer
function Encounter:addEnemy(enemy, index) end

--- Removes an enemy from the encounter
--- @param enemy Dummy.Battle.Enemy|integer
function Encounter:removeEnemy(enemy) end

--- Gets the encounter's waves
--- @return Dummy.Battle.Wave[]
function Encounter:getWaves() end

--- Sets one or more waves to the encounter
--- @param wave Dummy.Battle.Wave|nil
--- @param ... Dummy.Battle.Wave
function Encounter:setWave(wave, ...) end

--- Called when an encounter starts
function Encounter:onStart() end

--- Called when an enemy is selected for attack
--- @param enemy Dummy.Battle.Enemy
function Encounter:onEnemyAttackSelected(enemy) end

--- Called when an enemy is selected for ACT
--- @param enemy Dummy.Battle.Enemy
function Encounter:onEnemyActSelected(enemy) end

--- Called when the encounter text is done
function Encounter:onTextEnd() end

--- Called when all enemy dialogues are done
function Encounter:onEnemyDialoguesEnd() end

--- Called when the defending phase is done
function Encounter:onDefendingEnd() end

--- Called when the player tries to flee
--- @return boolean|nil
function Encounter:onFlee() end

--- Called when the encounter state changes
--- @param current_state string
--- @param previous_state string
function Encounter:onStateChange(current_state, previous_state) end

--- Called when an encounter ends
function Encounter:onEnd() end

--- Updates the encounter, called on every game update
--- @param dt number
function Encounter:update(dt) end

