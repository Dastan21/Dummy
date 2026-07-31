--[[
  Generated from ..\engine\battle\enemy.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/battle/enemy.lua
]]

---@meta

--- @class Dummy.Battle.Enemy : Dummy.Sprite
---
--- @field protected name Dummy.Text.Text
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected exp number
--- @field protected gold number
--- @field protected check Dummy.Text.Text|nil
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
--- @field protected acts Dummy.Battle.ACT[]
--- @field protected can_be_spared boolean
--- @field protected is_spared boolean
--- @field protected spare_dust_timer Dummy.Timer.Handle|nil
--- @field protected encounter Dummy.Battle.Encounter
Enemy = {}

--- Gets the enemy's name
--- @return Dummy.Text.Text
function Enemy:getName() end

--- Sets the enemy's name
--- @param name string
function Enemy:setName(name) end

--- Gets the enemy's HP
--- @return number
function Enemy:getHP() end

--- Sets the enemy's HP
--- @param hp number health points
function Enemy:setHP(hp) end

--- Gets the enemy's max HP
--- @return number
function Enemy:getMaxHP() end

--- Sets the enemy's max HP
--- @param max_hp number maximum health points
function Enemy:setMaxHP(max_hp) end

--- Gets the enemy's AT
--- @return number
function Enemy:getAT() end

--- Sets the enemy's AT
--- @param at number attack point
function Enemy:setAT(at) end

--- Gets the enemy's DE
--- @return number
function Enemy:getDF() end

--- Sets the enemy's DE
--- @param df number defense point
function Enemy:setDF(df) end

--- Gets the enemy's EXP
--- @return number
function Enemy:getEXP() end

--- Sets the enemy's EXP
--- @param exp number experience points
function Enemy:setEXP(exp) end

--- Gets the enemy's gold
--- @return number
function Enemy:getGold() end

--- Sets the enemy's gold
--- @param gold number gold
function Enemy:setGold(gold) end

--- Wether the enemy has a check text
--- @return boolean
function Enemy:hasCheck() end

--- Gets the enemy's check
--- @return Dummy.Text.Text
function Enemy:getCheck() end

--- Sets the enemy's check
--- @param check Dummy.Text.Text
function Enemy:setCheck(check) end

--- Gets the computed enemy's check text
--- @return string
function Enemy:getCheckText() end

--- Gets the enemy's ACTs
--- @return Dummy.Battle.ACT[]
function Enemy:getACTs() end

--- Adds one or more ACTs to the enemy
--- @param act Dummy.Battle.ACT|Dummy.Battle.ACT[]
--- @param ... Dummy.Battle.ACT
function Enemy:addACT(act, ...) end

--- Removes an ACT from the enemy
--- @param act Dummy.Battle.ACT
function Enemy:removeACT(act) end

--- Wether the enemy can be spared
--- @return boolean
function Enemy:getCanBeSpared() end

--- Sets wether the enemy can be spared
--- @param can_be_spared boolean
function Enemy:setCanBeSpared(can_be_spared) end

--- Wether the enemy has been spared
--- @return boolean
function Enemy:isSpared() end

--- Sets wether the enemy has been spared
--- @param spared boolean
function Enemy:setSpared(spared) end

--- Spares the enemy
function Enemy:spare() end

--- Wether the enemy has been killed
--- @return boolean
function Enemy:isKilled() end

--- Gets the enemy's hurt sound
--- @return love.Source|nil
function Enemy:getHurtSound() end

--- Sets the enemy's hurt sound
--- @param hurt_sound string|nil
function Enemy:setHurtSound(hurt_sound) end

--- Removes the drawable from the current scene
function Enemy:remove() end

--- Called when the enemy should dialogue
function Enemy:onDialogue() end

--- Called when trying to spare an enemy
--- @param spared boolean wether the enemy has been spared
function Enemy:onSpared(spared) end

--- Called before the strike animation is played on the enemy
function Enemy:onBeforeAttack() end

--- Called before the enemy is damaged
--- @param damage number calculated damage
--- @param miss boolean wether the attack missed
--- @return number|nil damage, boolean|nil miss override damage & wether the attack missed
function Enemy:onBeforeDamage(damage, miss) end

--- Called when the enemy is damaged
--- @param damage number damage taken
function Enemy:onDamage(damage) end

--- Called after when the enemy is damaged
function Enemy:onAfterDamage() end

--- Called after attacking the enemy
function Enemy:onAfterAttack() end

--- Called when the enemy is killed
function Enemy:onKilled() end

--- Creates an enemy
--- @param name Dummy.Text.Text
--- @param sprite string
--- @return Dummy.Battle.Enemy
function Enemy:new(name, sprite) end

