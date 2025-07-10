--[[
  Generated from ..\engine\drawable\dialogue_text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/dialogue_text.lua
]]

---@meta

--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected text_values Dummy.Text.Text[]
--- @field protected text_value Dummy.Text.Text
--- @field protected font love.Font
--- @field protected nodes Dummy.Text.Node[]
--- @field protected dialogue_timer number
--- @field protected state table<string, any>
--- @field protected total_nodes Dummy.Text.Node[]
--- @field protected speed number
--- @field protected text_value_index number
--- @field protected text_index number
--- @field protected voice string|nil
--- @field protected wait number
--- @field protected skipping boolean
--- @field protected force_skip boolean
--- @field protected no_skip boolean
--- @field protected auto_next boolean
DialogueText = {}

--- Gets the class name
--- @return string
function DialogueText.getClassName() end

--- Sets the dialogue's text value
--- @param value Dummy.Text.Text
--- @param ... Dummy.Text.Text
function DialogueText:setText(value, ...) end

--- Updates the dialogue's text value
--- @protected
function DialogueText:updateDialogue() end

--- Resets the dialogue's current text
function DialogueText:reset() end

--- Skips the dialogue's
function DialogueText:skip() end

--- Wether the dialogue is done
--- @return boolean
function DialogueText:isDone() end

--- Wether the dialogue's current text is done
--- @return boolean
--- @private
function DialogueText:isCurrentDone() end

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

--- Sets the dialogue text's font
--- @param font love.Font
function DialogueText:setFont(font) end

--- Applies the node state
--- @param node Dummy.Text.Node
function DialogueText:processNode(node) end

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

--- Called when the dialogue is done
function DialogueText:onDone() end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
--- @return Dummy.DialogueText
function DialogueText:new(value, ...) end

