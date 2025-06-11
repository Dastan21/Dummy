--[[
  Generated from ..\engine\encounter\enemy.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/enemy.lua
]]

---@meta

--- @class Dummy.Enemy : Dummy.Class
---
--- @field protected name string
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected xp number
--- @field protected gold number
--- @field protected check Dummy.Text.Text|table<number, string>|nil
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
Enemy = {}

--- Gets the class name
--- @return string
function Enemy:getClass() end

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

--- Wether the enemy has a check dialogue
--- @return boolean
function Enemy:hasCheck() end

--- Gets the enemy's check
--- @return string
function Enemy:getCheck() end

--- Sets the enemy's check
--- @param check Dummy.Text.Text|table<number, Dummy.Text.Text>
function Enemy:setCheck(check) end

--- Gets the computed enemy's check text
--- @return string
function Enemy:getCheckText() end

--- Gets the enemy's center position
---@return number, number
function Enemy:getPosition() end

--- Sets the enemy's center position
---@param x number
---@param y number
function Enemy:setPosition(x, y) end

--- Gets the enemy's size
---@return number, number
function Enemy:getSize() end

--- Sets the enemy's size
---@param width number
---@param height number
function Enemy:setSize(width, height) end

--- Creates an enemy
--- @param data Dummy.Mod.Enemy
--- @return Dummy.Enemy
function Enemy:new(data) end

function Enemy:init() end

