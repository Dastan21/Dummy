--[[
  Generated from ..\engine\encounter\enemy.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/enemy.lua
]]

---@meta

--- @class Dummy.Enemy : Dummy.Sprite
---
--- @field protected name string
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
--- @field protected acts Dummy.ACT[]
--- @field protected can_be_spared boolean
--- @field protected is_spared boolean
Enemy = {}

--- Gets the class name
--- @return string
function Enemy.getClassName() end

--- Gets the enemy's name
--- @return string
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
--- @return Dummy.ACT[]
function Enemy:getACTs() end

--- Adds one or more ACTs to the enemy
--- @param act Dummy.ACT|Dummy.ACT[]
--- @param ... Dummy.ACT
function Enemy:addACT(act, ...) end

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

--- Called when trying to spare an enemy
--- @param spared boolean wether the enemy has been spared
function Enemy:onSpared(spared) end

--- Called before the enemy is damaged
--- @param damage number calculated damage
--- @return number|nil damage override damage
function Enemy:onBeforeDamage(damage) end

--- Called when the enemy is damaged
--- @param damage number damage taken
function Enemy:onDamage(damage) end

--- Called after when the enemy is damaged
function Enemy:onAfterDamage() end

--- Called when the enemy should dialogue
function Enemy:onDialogue() end

--- Called when the enemy is killed
function Enemy:onKilled() end

--- Updates the enemy
--- @param dt number
function Enemy:update(dt) end

--- Creates an enemy
--- @param name string
--- @param sprite string
--- @return Dummy.Enemy
function Enemy:new(name, sprite) end

