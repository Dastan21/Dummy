--[[
  Generated from ..\engine\drawable\text.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/text.lua
]]

---@meta

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text love.Text
--- @field protected value Dummy.Text.Text
--- @field protected no_translation boolean
--- @field protected font love.Font
--- @field protected align Dummy.Text.Align
--- @field protected width number
--- @field protected height number
--- @field protected wrap_limit number|nil
--- @field protected max_width number
--- @field protected overflow Dummy.Text.Overflow
--- @field protected is_clipping boolean
--- @field protected char_width number
--- @field protected char_height number
--- @field protected nodes Dummy.Text.Node[]
--- @field protected time number
--- @field protected state table<string, any>
--- @field protected custom_commands table<string, fun(node: Dummy.Text.Node)>
--- @field protected custom_commands_called table<Dummy.Text.Node, boolean>
Text = {}

--- @alias Dummy.Text.Text string|table
--- @alias Dummy.Text.Align "left" | "center" | "right"
--- @alias Dummy.Text.Overflow "clip" | "ellipsis"

--- @class Dummy.Text.Node
---
--- @field type "character" | "command"
--- @field character string|nil
--- @field command string|nil
--- @field arguments string[]|nil
--- @field state table<string, any>|nil

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText() end

--- Sets the text's value
--- @param value Dummy.Text.Text text value
--- @param force? boolean wether to force the text to be updated
--- @param no_command? boolean wether to force plain text
function Text:setText(value, force, no_command) end

--- Updates the render text or its nodes
function Text:updateText() end

--- Gets the text's width
--- @return number
function Text:getWidth() end

--- Gets the text's height
--- @return number
function Text:getHeight() end

--- Sets the text's color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a) end

--- Gets the text's font
--- @return love.Font
function Text:getFont() end

--- Sets the text's font
--- @param font love.Font|Dummy.Assets.Font|string
function Text:setFont(font) end

--- Gets the text's align
--- @return Dummy.Text.Align
function Text:getAlign() end

--- Sets the text's align
--- @param align Dummy.Text.Align
function Text:setAlign(align) end

--- Gets the text's wrap limit
--- @return number|nil
function Text:getWrapLimit() end

--- Sets the text's wrap limit
--- @param wrap_limit number|nil
function Text:setWrapLimit(wrap_limit) end

--- Gets the text's max width
--- @return number
function Text:getMaxWidth() end

--- Sets the text's max width
--- @param max_width number
function Text:setMaxWidth(max_width) end

--- Gets the text's overflow
--- @return Dummy.Text.Overflow
function Text:getOverflow() end

--- Sets the text's overflow
--- @param overflow Dummy.Text.Overflow
function Text:setOverflow(overflow) end

--- Wether the text is clipping
--- @return boolean
function Text:isClipping() end

--- Gets the text's characters width
--- @return number
function Text:getCharacterWidth() end

--- Sets the text's characters width
--- @param char_width number
function Text:setCharacterWidth(char_width) end

--- Gets the text's characters height
--- @return number
function Text:getCharacterHeight() end

--- Sets the text's characters height
--- @param char_height number
function Text:setCharacterHeight(char_height) end

--- Sets the text's scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Text:setScale(scale_x, scale_y) end

--- Ellipsizes a text
--- @param text string
--- @param max_width number
--- @param font love.Font
function Text.ellipse(text, max_width, font) end

--- Clips a text
--- @param text string
--- @param max_width number
--- @param font love.Font
function Text.clip(text, max_width, font) end

--- Gets the formatted text's value
--- @param value Dummy.Text.Text
--- @param color love.Color
--- @param alpha? number
--- @return [ love.Color, string ]
function Text.getFormattedValue(value, color, alpha) end

--- Gets the text's nodes
--- @return Dummy.Text.Node[]
function Text:getNodes() end

--- Gets the text's line width
--- @param line number
--- @return number
function Text:getLineWidth(line) end

--- Gets the text's char offset
--- @param line number
--- @return number
function Text:getCharOffset(line) end

--- Registers a custom text command
--- @param command string
--- @param func fun(node: Dummy.Text.Node)
function Text:registerCommand(command, func) end

--- Unregisters a custom text command
--- @param command string
function Text:unregisterCommand(command) end

--- Updates the text, called on every game update
--- @param dt number
function Text:update(dt) end

--- Draws the text
--- @param camera Dummy.Camera
function Text:draw(camera) end

--- Draws the text's bounding box for debugging
--- @param camera Dummy.Camera
function Text:drawDebug(camera) end

--- Updates text nodes
--- @param dt number
function Text:updateNodes(dt) end

--- Parses a text command
--- @param text string
--- @return Dummy.Text.Node|nil
function Text:parseCommand(text) end

--- Applies the node state
--- @param node Dummy.Text.Node
function Text:processNode(node) end

--- Parses the text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function Text:parseNodes(value) end

--- Reloads the text
function Text:reload() end

--- Creates a text
--- @param value? Dummy.Text.Text
--- @param no_translation? boolean wether the value should not be translated (Defaults to `false`)
--- @return Dummy.Text
function Text:new(value, no_translation) end

