--[[
  Generated from ..\engine\world\object\object.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/object.lua
]]

---@meta

--- @class Dummy.Object : Dummy.Sprite
---
--- @field protected collision_enabled boolean
--- @field protected collision_solid boolean
--- @field protected hitbox Dummy.Hitbox
--- @field protected can_interact boolean
--- @field protected depth number
--- @field protected static boolean
--- @field EDITOR_SPRITE string|nil
--- @field ALLOW_EDITOR boolean|nil
Object = {}

--- @alias Dummy.Hitbox [ number, number, number, number ]
--- @alias Dummy.Object.Facing "down" | "right" | "up" | "left"

--- @class Dummy.Object.Data
---
--- @field id integer
--- @field type string
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field mod_id? string

--- @class Dummy.Object.ExtraData
---
--- @field class Dummy.Object
--- @field [string] unknown

--- @class Dummy.Object.CollisionData
---
--- @field collider Dummy.Object
--- @field direction_x number
--- @field direction_y number
--- @field moved_x number
--- @field moved_y number
--- @field amount_x number
--- @field amount_y number

--- Creates an object
function Object:new() end

--- Initializes the object's arguments before creating it
---
--- Note: This function is called for objects provided by the editor
--- @param data Dummy.Object.Data
function Object.initArgs(data) end

--- Gets the object's metadata
--- @return Dummy.Editor.Metadata[]
function Object.getMetadata() end

--- Called when the object form is confirmed in the editor
---
--- Note: Useful for modifying the object's data before it is added to the room
--- @param data Dummy.Object.Data
function Object.onFormConfirm(data) end

--- Updates the object's transform
function Object:updateTransform() end

--- Updates the object's absolute transform
function Object:updateAbsoluteTransform() end

--- Wether the object is static
--- @return boolean
function Object:isStatic() end

--- Sets wether the object is static
--- @param static boolean
function Object:setStatic(static) end

--- Wether the object is collision enabled
--- @return boolean
function Object:isCollisionEnabled() end

--- Sets wether the object is collision enabled
--- @param enabled boolean
function Object:setCollisionEnabled(enabled) end

--- Wether the object's collisions are solid
--- @return boolean
function Object:isCollisionSolid() end

--- Sets wether the object's collisions are solid
--- @param solid boolean
function Object:setCollisionSolid(solid) end

--- Gets the object's hitbox
--- @return number, number, number, number
function Object:getHitbox() end

--- Sets the object's hitbox
--- @param left number
--- @param top number
--- @param width number
--- @param height number
function Object:setHitbox(left, top, width, height) end

--- Gets the object's left position
--- @return number
function Object:getLeft() end

--- Gets the object's right position
--- @return number
function Object:getRight() end

--- Gets the object's left position
--- @return number
function Object:getTop() end

--- Gets the object's right position
--- @return number
function Object:getBottom() end

--- Wether the object can be interacted by the player
--- @return boolean
function Object:canInteract() end

--- Sets wether the object can be interacted by the player
--- @param can_interact boolean
function Object:setCanInteract(can_interact) end

--- Gets the object's depth
--- @return number
function Object:getDepth() end

--- Moves the object
--- @param dx number
--- @param dy number
--- @return number, number
function Object:move(dx, dy) end

--- Moves the object along an axis
--- @param axis "x" | "y"
--- @param amount number
--- @return number
function Object:moveExact(axis, amount) end

--- Called when the object collides with a solid object
--- @param data Dummy.Object.CollisionData
function Object:onCollisionSolid(data) end

--- Called when the object collides with another object
--- @param other Dummy.Object
function Object:onCollision(other) end

--- Called when the object is interacted by the player
function Object:onInteract() end

--- Removes the object from the current scene
function Object:remove() end

--- Updates the object's depth
function Object:updateDepth() end

--- Draws the object's hitbox for debugging
--- @param camera Dummy.Camera
function Object:drawDebug(camera) end

--- Draws the solid object for the editor
--- @param data Dummy.Object.Data
function Object.drawEditor(data) end

--- Updates the object, called on every game update
--- @param dt number
function Object:update(dt) end

