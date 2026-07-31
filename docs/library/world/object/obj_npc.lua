--[[
  Generated from ..\engine\world\object\obj_npc.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/object/obj_npc.lua
]]

---@meta

--- @class Dummy.Object.NPC : Dummy.Object
---
--- @field protected id string
--- @field protected facing Dummy.Object.Facing
--- @field protected facing_before_talk Dummy.Object.Facing
--- @field protected moving boolean
--- @field protected talking boolean
--- @field protected speaking boolean
--- @field protected voice string
--- @field protected blink_timer Dummy.Timer.Handle|nil
NPCObject = {}

--- Creates an NPC
--- @param id string
function NPCObject:new(id) end

--- Gets the NPC's id
--- @return string
function NPCObject:getId() end

--- Gets the NPC's facing
--- @return Dummy.Object.Facing
function NPCObject:getFacing() end

--- Sets the NPC's facing
--- @param facing Dummy.Object.Facing
function NPCObject:setFacing(facing) end

--- Gets the NPC's voice
--- @return string
function NPCObject:getVoice() end

--- Sets the NPC's voice
--- @param voice string
function NPCObject:setVoice(voice) end

--- Wether the NPC is talking
---
--- Note: `true` until the end of the dialogue interaction
--- @return boolean
function NPCObject:isTalking() end

--- Wether the NPC is speaking
---
--- Note: `true` until the end of the dialogue current text
--- @return boolean
function NPCObject:isSpeaking() end

--- Called when the NPC is interacted by the player
function NPCObject:onInteract() end

--- Talk to the NPC
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText)
function NPCObject:talk(texts, on_done) end

--- Makes the NPC's face the player
function NPCObject:facePlayer() end

--- Moves the NPC
--- @param dx number
--- @param dy number
--- @param keep_facing? boolean
--- @return number, number
function NPCObject:move(dx, dy, keep_facing) end

--- Walks to a position
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
--- @param on_walked? fun()
function NPCObject:walkTo(target_x, target_y, speed, keep_facing, on_walked) end

--- Slides to a position
--- @param target_x number
--- @param target_y number
--- @param speed? number
--- @param keep_facing? boolean
--- @param on_slided? fun()
function NPCObject:slideTo(target_x, target_y, speed, keep_facing, on_slided) end

--- Updates the NPC's sprite
function NPCObject:updateSprite() end

--- Updates the NPC, called on every game update
--- @param dt number
function NPCObject:update(dt) end

