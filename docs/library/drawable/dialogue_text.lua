--[[
  Generated from ..\engine\drawable\dialogue_text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/dialogue_text.lua
]]

---@meta

--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected text_value Dummy.Text.Text
--- @field protected nodes Dummy.Text.Node[]
--- @field protected total_nodes Dummy.Text.Node[]
--- @field protected speed number
--- @field protected time number
--- @field protected wait_time number
--- @field protected text_index number
--- @field protected voice string|nil
--- @field protected done_callback fun()|nil
--- @field protected can_skip boolean
--- @field protected can_confirm boolean
DialogueText = {}

--- Gets the class name
--- @return string
function DialogueText:getClass() end

--- Sets the dialogue's text value
--- @param value Dummy.Text.Text
function DialogueText:setText(value) end

--- Updates the dialogue's text value
--- @protected
function DialogueText:updateDialogue() end

--- Resets the dialogue's current text
function DialogueText:reset() end

--- Wether the dialogue's can be skipped
--- @return boolean
function DialogueText:canSkip() end

--- Sets wether the dialogue's can be skipped
--- @param can_skip boolean
function DialogueText:setCanSkip(can_skip) end

--- Skips the dialogue's
function DialogueText:skip() end

--- Wether the dialogue's can be confirmed
--- @return boolean
function DialogueText:canConfirm() end

--- Sets wether the dialogue's can be confirmed
--- @param can_confirm boolean
function DialogueText:setCanConfirm(can_confirm) end

--- Wether the dialogue's is done
--- @return boolean
function DialogueText:isDone() end

--- Gets the dialogue's speed
--- @return number
function DialogueText:getSpeed() end

--- Sets the dialogue's speed
--- @param speed number
function DialogueText:setSpeed(speed) end

--- Gets the dialogue's voice
--- @return string|nil
function DialogueText:getVoice() end

--- Sets the dialogue's voice
--- @param voice string|nil
function DialogueText:setVoice(voice) end

--- Applies the node state
--- @param node Dummy.Text.Node
--- @param state table<string, any>
--- @return table<string, any>
function DialogueText:applyNodeState(node, state) end

--- Parses the dialogue text command
--- @param text string
--- @return Dummy.Text.Node|nil
function DialogueText:parseCommand(text) end

--- Parses the dialogue text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function DialogueText:parseNodes(value) end

--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt) end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param done_callback? fun() called when the dialogue is done
--- @return Dummy.DialogueText
function DialogueText:new(value, done_callback) end

