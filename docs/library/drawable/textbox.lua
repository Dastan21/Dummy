--[[
  Generated from ..\engine\drawable\textbox.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/textbox.lua
]]

---@meta

--- @class Dummy.Textbox : Dummy.Drawable
---
--- @field protected dialogue Dummy.DialogueText
--- @field protected choice boolean
--- @field protected choice_index integer
--- @field protected heart_sprite Dummy.Sprite
--- @field protected portraits table<string, Dummy.Textbox.Portrait.Callback>
--- @field protected active_portrait string|nil
--- @field protected portrait_sprite Dummy.Sprite
Textbox = {}

--- @alias Dummy.Textbox.Portrait.Callback fun(textbox: Dummy.Textbox, face: string, emotion: string)

--- Creates a textbox
--- @param value Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
--- @return Dummy.Textbox
function Textbox:new(value, ...) end

--- Sets wether the textbox is visible
---
--- @param visible boolean
function Textbox:setVisible(visible) end

--- Gets the textbox's dialogue text
--- @return Dummy.DialogueText
function Textbox:getDialogue() end

--- Gets the textbox's portraits
--- @return table<string, Dummy.Textbox.Portrait.Callback>
function Textbox:getPortraits() end

--- Gets the textbox's portrait sprite
--- @return Dummy.Sprite
function Textbox:getPortrait() end

--- Gets the textbox's active portrait
--- @return string|nil
function Textbox:getActivePortrait() end

--- Adds a portrait to the world textbox
---
--- Note: Use the command `[portrait:ID]` in dialogues to use a portrait
--- @param character_id string
--- @param callback Dummy.Textbox.Portrait.Callback
function Textbox:addPortrait(character_id, callback) end

--- Removes a portrait from the world textbox
--- @param character_id string
function Textbox:removePortrait(character_id) end

--- Plays a dialogue in the world
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText, choice?: integer)
function Textbox:playDialogue(texts, on_done) end

--- Updates the textbox's position
function Textbox:updatePosition() end

--- Changes the selected choice
--- @param delta integer
function Textbox:changeChoice(delta) end

--- Updates the heart position to the current choice
function Textbox:updateHeartPosition() end

--- Resets the portrait
function Textbox:resetPortrait() end

--- Draws the textbox
--- @param camera Dummy.Camera
function Textbox:draw(camera) end

--- Updates the textbox, called on every game update
--- @param dt number
function Textbox:update(dt) end

