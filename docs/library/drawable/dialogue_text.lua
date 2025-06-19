--[[
  Generated from ..\engine\drawable\dialogue_text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/dialogue_text.lua
]]

---@meta

--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected full_text string
--- @field protected speed number
--- @field protected time number
--- @field protected text_index number
--- @field protected voice string|nil
DialogueText = {}

--- Gets the class name
--- @return string
function DialogueText:getClass() end

--- Sets the dialogue text value
--- @param value Dummy.Text.Text
function DialogueText:setText(value) end

--- Updates the dialogue text sprite value
--- @protected
function DialogueText:updateDialogue() end

--- Resets the dialogue current text
function DialogueText:reset() end

--- Wether the dialogue can be skipped
---@return boolean
function DialogueText:canSkip() end

--- Sets wether the dialogue can be skipped
--- @param can_skip boolean
function DialogueText:setCanSkip(can_skip) end

--- Skips the dialogue
function DialogueText:skip() end

--- Wether the dialogue is done
---@return boolean
function DialogueText:isDone() end

function DialogueText:getMaxWidth() end

function DialogueText:setMaxWidth(max_width) end

--- Gets the dialogue speed
--- @return number
function DialogueText:getSpeed() end

--- Sets the dialogue speed
--- @param speed number
function DialogueText:setSpeed(speed) end

--- Gets the dialogue voice
--- @return string|nil
function DialogueText:getVoice() end

--- Sets the dialogue voice
--- @param voice string|nil
function DialogueText:setVoice(voice) end

--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt) end

--- Creates a dialogue text
--- @param value Dummy.Text.Text
--- @return Dummy.DialogueText
function DialogueText:new(value) end

