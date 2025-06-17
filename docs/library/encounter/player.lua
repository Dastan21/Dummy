--[[
  Generated from ..\engine\encounter\player.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/encounter/player.lua
]]

---@meta

--- @class Dummy.Player
---
--- @field protected lv number
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected speed number
--- @field protected speed_factor number
--- @field protected is_invincible boolean
--- @field protected invincible boolean
--- @field protected invincible_duration number
--- @field protected hitbox { [1]: number, [2]: number, [3]: number, [4]: number }
--- @field protected soul_sprite Dummy.Sprite
--- @field protected name string
--- @field protected name_text Dummy.Text
--- @field protected lv_text Dummy.Text
--- @field protected hp_sprite Dummy.Sprite
--- @field protected hp_value_text Dummy.Text
--- @field protected is_fleeing boolean
--- @field protected flee_speed number
--- @field protected weapon Dummy.Item.Equipment
--- @field protected armor Dummy.Item.Equipment
--- @field protected items Dummy.Item[]
Player = {}

--- Initializes the player
function Player.load() end

--- Gets the player's soul position
--- @return number x horizontal position
--- @return number y vertical position
function Player.getPosition() end

--- Sets the player's soul position
--- @param x number horizontal position
--- @param y number vertical position
--- @param ignore_arena_bounds? boolean ignore arena bounds collisions
function Player.setPosition(x, y, ignore_arena_bounds) end

--- Shows the player's soul
function Player.show() end

--- Hides the player's soul
function Player.hide() end

--- Wether the player's soul is hidden
--- @return boolean
function Player.isHidden() end

--- Gets the player's name
--- @return string
function Player.getName() end

--- Sets the player's name
--- @param name string name displayed
function Player.setName(name) end

--- Gets the player's LV
--- @return number
function Player.getLV() end

--- Sets the player's LV
--- @param lv number level
function Player.setLV(lv) end

--- Gets the player's HP
--- @return number
function Player.getHP() end

--- Sets the player's HP
--- @param hp number health points
function Player.setHP(hp) end

--- Heals the player
--- @param amount number
--- @param silent? boolean wether to play a sound (Defaults to `false`)
function Player.heal(amount, silent) end

--- Hurts the player
--- @param amount number
--- @param silent? boolean wether to play then sound and animation (Defaults to `false`)
function Player.hurt(amount, silent) end

--- Gets the player's max HP
--- @return number
function Player.getMaxHP() end

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

--- Gets the player's scale
--- @return number, number
function Player.getScale() end

--- Sets the player's scales
--- @overload fun(scale: number)
--- @param scale_x number
--- @param scale_y number
function Player.setScale(scale_x, scale_y) end

--- Wether the player is invincible
--- @return boolean
function Player.isInvincible() end

--- Sets wether the player is invincible
---@param invincible boolean
function Player.setInvincible(invincible) end

--- Gets the player's invincibility duration, in seconds
--- @return number
function Player.getInvincibility() end

--- Sets the player's invincibility duration, in seconds
--- @param invincibility number
function Player.setInvincibility(invincibility) end

--- Gets the player's weapon
--- @return Dummy.Item.Equipment
function Player.getWeapon() end

--- Sets the player's weapon
--- @param weapon Dummy.Item.Equipment
function Player.setWeapon(weapon) end

--- Gets the player's armor
--- @return Dummy.Item.Equipment
function Player.getArmor() end

--- Sets the player's armor
--- @param armor Dummy.Item.Equipment
function Player.setArmor(armor) end

--- Wether the player's hitbox collides bullet's hitbox
--- @param bullet Dummy.Bullet
function Player.isColliding(bullet) end

--- Animates the soul escaping
function Player.flee() end

--- Wether the playing is playing the escape animation
---@return boolean
function Player.isFleeing() end

--- Gets the player's items
--- @return Dummy.Item[]
function Player.getItems() end

--- Adds one or more items to the player
---@param item Dummy.Item|Dummy.Item[]
---@param ... Dummy.Item
function Player.addItem(item, ...) end

--- Removes an item from the player
--- @param item Dummy.Item
function Player.removeItem(item) end

--- Updates the player
--- @param dt number
function Player.update(dt) end

