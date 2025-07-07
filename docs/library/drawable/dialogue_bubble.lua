--[[
  Generated from ..\engine\drawable\dialogue_bubble.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/dialogue_bubble.lua
]]

---@meta

--- @class Dummy.DialogueBubble : Dummy.Sprite
---
--- @field protected type Dummy.DialogueBubble.Type
--- @field protected dialogue Dummy.DialogueText
DialogueBubble = {}

--- @alias Dummy.DialogueBubble.Type "left" | "left_short" | "left_wide_short" | "right" | "right_large" | "right_short" | "right_thin" | "right_wide" | "right_wide_short" | "top" | "bottom" | "tiny" | "tiny_top" | "shock"

--- Gets the class name
--- @return string
function DialogueBubble.getClassName() end

--- Gets the dialogue bubble's dialogue text
--- @return Dummy.DialogueText
function DialogueBubble:getDialogue() end

--- Sets the dialogue bubble's alpha
--- @param alpha number
function DialogueBubble:setAlpha(alpha) end

--- Initializes the dialogue bubble
function DialogueBubble:init() end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param type? Dummy.DialogueBubble.Type bubble type
--- @param done_callback? fun() called when the dialogue is done
--- @return Dummy.DialogueBubble
function DialogueBubble:new(value, type, done_callback) end

