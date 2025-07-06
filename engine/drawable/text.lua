--- @alias Dummy.Text.Text string|table|fun(): string|table
--- @alias Dummy.Text.Align "left" | "center" | "right"

--- @class Dummy.Text.Node
---
--- @field type "character" | "command"
--- @field character string|nil
--- @field command string|nil
--- @field arguments string[]|nil

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text Dummy.Text.Text
--- @field protected font love.Font
--- @field protected max_width number
--- @field protected align Dummy.Text.Align
--- @field protected width number
--- @field protected height number
--- @field protected nodes Dummy.Text.Node[]
--- @field protected state table<string, any>
--- @field protected custom_commands table<string, fun(node: Dummy.Text.Node)>
--- @field protected custom_commands_called table<Dummy.Text.Node, boolean>
local Text = Class:extend(Drawable)

--- Text commands
Text.COMMANDS = {
  "reset",
  "color",
  "alpha",
  "angle",
  "scale",
  "font",
}

--- Gets the class name
--- @return string
function Text:getClass()
  return "Dummy.Text"
end

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText()
  return self.text
end

--- Sets the text's value
--- @param value Dummy.Text.Text
function Text:setText(value)
  self.text = value
  self.nodes = self:parseNodes(value)
end

--- Gets the text's width
--- @return number
function Text:getWidth()
  return self.width
end

--- Gets the text's height
--- @return number
function Text:getHeight()
  return self.height
end

local set_color = Text.setColor
--- Sets the text's color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a)
  set_color(self, r, g, b, a)
end

--- Gets the text's font
--- @return love.Font
function Text:getFont()
  return self.font
end

--- Sets the text's font
--- @param font love.Font
function Text:setFont(font)
  self.font = font
  self.nodes = self:parseNodes(self.text)
end

--- Gets the text's max width
--- @return number
function Text:getMaxWidth()
  return self.max_width
end

--- Sets the text's max width
--- @param max_width number
function Text:setMaxWidth(max_width)
  self.max_width = max_width
  self.nodes = self:parseNodes(self.text)
end

--- Gets the text's align
--- @return Dummy.Text.Align
function Text:getAlign()
  return self.align
end

--- Sets the text's align
--- @param align Dummy.Text.Align
function Text:setAlign(align)
  self.align = align
end

--- Gets the text's nodes
--- @return Dummy.Text.Node[]
function Text:getNodes()
  return self.nodes
end

--- Gets the text's line width
--- @param line number
--- @return number
function Text:getLineWidth(line)
  local state = {}
  local width = 0
  local current_line = 1
  for _, node in ipairs(self.nodes) do
    if node.type == "character" then
      if current_line == line then
        local font = state.font or self.font
        width = width + font:getWidth(node.character)
      elseif current_line > line then
        return width
      end

      if node.character == "\n" then
        current_line = current_line + 1
      end
    elseif node.type == "command" then
      state = self:applyNodeState(node, state)
    end
  end
  return width
end

--- Gets the text's char offset
--- @param line number
--- @return number
function Text:getCharOffset(line)
  if self.align == "right" then
    return self:getWidth() - self:getLineWidth(line)
  elseif self.align == "center" then
    return self:getWidth() / 2 - self:getLineWidth(line) / 2
  end
  return 0
end

--- Registers a text command
--- @param command string
--- @param func fun(node: Dummy.Text.Node)
function Text:registerCommand(command, func)
  self.custom_commands[command] = func
end

--- Draws the text
function Text:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  if Debugger.shouldDisplayHitbox() then
    love.graphics.setColor(0, 0, 1, 1)
    local origin_x, origin_y = self:getOrigin()
    love.graphics.rectangle("line", -0.5 - self:getWidth() * origin_x, -0.5 - self:getHeight() * origin_y,
      self:getWidth() + 1, self:getHeight() + 1)
  end

  self:drawNodes()

  self:drawChildren()
end

--- Draws a text node
function Text:drawNodes()
  if #self.nodes <= 0 then return end

  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)

  local state = {}
  local origin_x, origin_y = self:getOrigin()
  local line = 1
  local char_x, char_y = self:getCharOffset(line), 0
  local line_height = 0
  for _, node in ipairs(self.nodes) do
    if node.type == "character" then
      local color = state.color or self.color
      local alpha = state.alpha or self.alpha
      local text = { { color[1], color[2], color[3], alpha }, node.character }
      local angle = state.angle or 0
      local scale_x = state.scale_x or 1
      local scale_y = state.scale_y or 1
      local font = state.font or self.font
      local char_height = font:getHeight() * scale_y
      line_height = math.max(line_height, char_height)
      local line_diff = (line_height - char_height) / 2

      local x = char_x - self:getWidth() * origin_x
      local y = char_y - self:getHeight() * origin_y + line_diff
      love.graphics.print(text, font, x, y, angle, scale_x, scale_y)

      char_x = char_x + font:getWidth(node.character) * scale_x
      if node.character == "\n" then
        line = line + 1
        char_x = self:getCharOffset(line)
        char_y = char_y + char_height
        line_height = 0
      end
    elseif node.type == "command" then
      state = self:applyNodeState(node, state)

      if not self.custom_commands_called[node] then
        local func = self.custom_commands[node.command]
        if type(func) == "function" then
          func(node)
        end
        self.custom_commands_called[node] = true
      end
    end
  end
end

--- Parses a text command
--- @param text string
--- @return Dummy.Text.Node|nil
function Text:parseCommand(text)
  local split = text:split(":")
  local command = split[1]
  local arguments = (split[2] or ""):split(",")
  if not table.contains(Text.COMMANDS, command) and self.custom_commands[command] == nil then return end

  return {
    type = "command",
    command = command,
    arguments = arguments
  }
end

--- Applies the node state
--- @param node Dummy.Text.Node
--- @param state table<string, any>
--- @return table<string, any>
function Text:applyNodeState(node, state)
  if node.type ~= "command" then return state end

  if node.command == "reset" then
    return {}
  elseif node.command == "color" then
    if #node.arguments == 3 then
      local r = tonumber(node.arguments[1])
      local g = tonumber(node.arguments[2])
      local b = tonumber(node.arguments[3])
      if r ~= nil and g ~= nil and b ~= nil then
        state.color = { r, g, b }
      end
    end
  elseif node.command == "alpha" then
    state.alpha = tonumber(node.arguments[1])
  elseif node.command == "angle" then
    state.angle = tonumber(node.arguments[1])
  elseif node.command == "scale" then
    local scale_x = tonumber(node.arguments[1])
    local scale_y = tonumber(node.arguments[2])
    state.scale_x = scale_x
    state.scale_y = Utils.getOrDefault(scale_x, scale_y)
  elseif node.command == "font" then
    state.font = Assets.getFont(node.arguments[1])
  end

  return state
end

--- Parses the text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function Text:parseNodes(value)
  value = Lang.translate(value)

  local state = {}
  local nodes = {}
  local width = 0
  local line_width, line_height = 0, 0
  local lines_heights = {}
  local line_count = 1
  local length = UTF8.len(value)
  local command = nil
  for i = 1, length do
    local char = UTF8.sub(value, i, i)
    if char == "[" then
      command = ""
    elseif char == "]" and command ~= nil then
      local node = self:parseCommand(command)
      if node ~= nil then
        state = self:applyNodeState(node, state)
        table.insert(nodes, node)
      end
      command = nil
    elseif command ~= nil then
      command = command .. char
    else
      local font = state.font or self.font
      local scale_x = state.scale_x or 1
      local scale_y = state.scale_y or 1
      line_width = line_width + font:getWidth(char) * scale_x
      width = math.max(width, line_width)
      line_height = math.max(line_height, font:getHeight() * scale_y)
      lines_heights[line_count] = line_height
      if char == "\n" then
        line_width, line_height = 0, 0
        line_count = line_count + 1
      end

      table.insert(nodes, {
        type = "character",
        character = char
      })
    end
  end

  self.width = width
  self.height = math.sum(table.unpack(lines_heights))
  self.custom_commands_called = {}

  return nodes
end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value)
  local text = Class:new(Text)

  text.color = { 1, 1, 1 }
  text.font = love.graphics.getFont()
  text.max_width = Constants.SCREEN_WIDTH
  text.align = "left"
  text.custom_commands = {}
  text.custom_commands_called = {}

  text:setText(value)

  return text
end

return Text
