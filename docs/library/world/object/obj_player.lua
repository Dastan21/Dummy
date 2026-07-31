--[[
  Generated from ..\engine\world\object\obj_player.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_player.lua
]]

---@meta

--- @class Dummy.Object.Player : Dummy.Object.NPC
---
--- @field protected prev_facing Dummy.Object.Facing
--- @field protected can_move boolean
--- @field protected moving boolean
--- @field protected facing Dummy.Object.Facing
--- @field protected interaction Dummy.Object.Player.Interaction
--- @field protected phasing boolean
--- @field protected debug_text Dummy.Text|nil
PlayerObject = {}

--- @alias Dummy.Object.Player.Interaction "none" | "interact" | "menu" | "room_transition" | "shop_transition" | "cutscene"

--- Creates a player
--- @return Dummy.Object.Player
function PlayerObject:new() end

--- Gets the player's facing direction
--- @return Dummy.Object.Facing
function PlayerObject:getFacing() end

--- Sets the player's facing direction
--- @param facing Dummy.Object.Facing
function PlayerObject:setFacing(facing) end

--- Wether the player is interacting
--- @return boolean
function PlayerObject:isInteracting() end

--- Gets the player's interaction
--- @return Dummy.Object.Player.Interaction
function PlayerObject:getInteraction() end

--- Sets the player's interaction
--- @param interaction Dummy.Object.Player.Interaction
function PlayerObject:setInteraction(interaction) end

--- Wether the player is phasing
--- @return boolean
function PlayerObject:isPhasing() end

--- Sets wether the player is phasing
--- @param phasing boolean
function PlayerObject:setPhasing(phasing) end

--- Updates the player's sprite
function PlayerObject:updateSprite() end

--- Moves the player
--- @param dx number
--- @param dy number
--- @param keep_facing? boolean
--- @return number, number
function PlayerObject:move(dx, dy, keep_facing) end

--- Handles the player's movement
--- @param dt number
function PlayerObject:handleMovement(dt) end

--- Gets the player's interact box
--- @return number, number, number, number
function PlayerObject:getInteractBox() end

--- Handles the player's interaction
function PlayerObject:handleInteration() end

--- Handles the player's collisions
function PlayerObject:handleCollisions() end

--- Wether the player collides with an object
---@param x number
---@param y number
---@param width number
---@param height number
---@param objects? Dummy.Object[]
---@return boolean, Dummy.Object|nil
function PlayerObject:collides(x, y, width, height, objects) end

--- Called when the player collides with a solid object
--- @param data Dummy.Object.CollisionData
function PlayerObject:onCollisionSolid(data) end

--- Removes the player from the current scene
function PlayerObject:remove() end

--- Draws the player's hitbox for debugging
--- @param camera Dummy.Camera
function PlayerObject:drawDebug(camera) end

--- Updates the player, called on every game update
--- @param dt number
function PlayerObject:update(dt) end

