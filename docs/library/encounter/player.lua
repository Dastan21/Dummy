--[[
  Generated from ..\engine\encounter\player.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/player.lua
]]

---@meta

--- @class Dummy.Player
---
--- @field private lv number
--- @field private hp number
--- @field private max_hp number
--- @field private at number
--- @field private df number
--- @field private speed number
--- @field private speed_factor number
--- @field private hitbox {[1]: number, [2]: number, [3]: number, [4]: number}
--- @field private soul_sprite Dummy.Sprite
--- @field private name string
--- @field private name_text Dummy.Text
--- @field private lv_text Dummy.Text
--- @field private hp_sprite Dummy.Sprite
--- @field private hp_value_text Dummy.Text
--- @field private is_fleeing boolean
--- @field private flee_speed number
Player = {}

--- Inits the player
function Player.load() end

--- Sets the player's soul position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function Player.setPosition(x, y, ignore_arena_bounds) end

--- Gets the player's soul position
--- @return number x horizontal position
--- @return number y vertical position
function Player.getPosition() end

--- Shows the player's soul
function Player.show() end

--- Hides the player's soul
function Player.hide() end

--- Wether the player's soul is hidden
--- @return boolean
function Player.isHidden() end

--- Sets the player's name
--- @param name string name displayed
function Player.setName(name) end

--- Gets the player's name
--- @return string
function Player.getName() end

--- Sets the player's LV
--- @param lv number level
--- @param heal? boolean set HP to max HP
function Player.setLV(lv, heal) end

--- Gets the player's LV
--- @return number
function Player.getLV() end

--- Sets the player's HP
--- @param hp number health points
function Player.setHP(hp) end

--- Gets the player's HP
--- @return number
function Player.getHP() end

--- Sets the player's max HP
--- @param max_hp number maximum health points
--- @param heal? boolean set HP to max HP
function Player.setMaxHP(max_hp, heal) end

--- Gets the player's AT
--- @return number
function Player.getAT() end

--- Sets the player's AT
--- @param at number attack point
function Player.setAT(at) end

--- Gets the player's DE
--- @return number
function Player.getDF() end

--- Sets the player's DE
--- @param df number defense point
function Player.setDF(df) end

--- Gets the player's speed
--- @return number
function Player.getSpeed() end

--- Sets the player's speeds
--- @param speed number
function Player.setSpeed(speed) end

--- Wether the player's hitbox collides bullet's hitbox
--- @param bullet Dummy.Bullet
function Player.isColliding(bullet) end

--- Gets the player's max HP
--- @return number
function Player.getMaxHP() end

--- Wether the playing is playing the escape animation
---@return boolean
function Player.isFleeing() end

--- Animates the soul escaping
function Player.escape(dt) end

--- Updates the player
--- @param dt number
function Player.update(dt) end

