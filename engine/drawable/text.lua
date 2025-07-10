--- @alias Dummy.Text.Text string|table
--- @alias Dummy.Text.Align "left" | "center" | "right"

--- @class Dummy.Text.Node
---
--- @field type "character" | "command"
--- @field character string|nil
--- @field command string|nil
--- @field arguments string[]|nil
--- @field state table<string, any>|nil

--- @class Dummy.Text : Dummy.Drawable
---
--- @field protected text love.Text
--- @field protected value Dummy.Text.Text
--- @field protected font love.Font
--- @field protected align Dummy.Text.Align
--- @field protected width number
--- @field protected height number
--- @field protected nodes Dummy.Text.Node[]
--- @field protected timer number
--- @field protected state table<string, any>
--- @field protected custom_commands table<string, fun(node: Dummy.Text.Node)>
--- @field protected custom_commands_called table<Dummy.Text.Node, boolean>
local Text = Class:extend(Drawable)

--- Text commands
Text.COMMANDS = { "color", "scale", "font", "shake", "twitch", "wave", "spacing" }

--- Gets the class name
--- @return string
function Text.getClassName()
  return "Dummy.Text"
end

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText()
  return self.value
end

--- Sets the text's value
--- @param value Dummy.Text.Text text value
--- @param force? boolean wether to force the text to be updated
function Text:setText(value, force)
  if self.value == value and not force then return end

  -- text has no command
  if Lang.translate(value):find("%b[]") == nil then
    self.value = value
    self.nodes = {}

    if self.text == nil then
      self.text = love.graphics.newText(self.font, "")
    end
    self:updateText()
    self.width = self.text:getWidth()
    self.height = self.text:getHeight()
  else
    self.value = value
    self.text = nil
    self.nodes = self:parseNodes(value)
    self:updateNodes(0)
  end
end

--- Updates the text
function Text:updateText()
  if self.text ~= nil then
    self.text:setf(Text.getFormattedValue(self.value, self.color, self.alpha), Constants.SCREEN_WIDTH, self.align)
  end
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

--- Sets the text's color
--- @overload fun(self: Dummy.Text, color: love.Color)
--- @param r number red
--- @param g number green
--- @param b number blue
--- @param a number alpha
function Text:setColor(r, g, b, a)
  Drawable.setColor(self, r, g, b, a)

  if self.text ~= nil then
    self:updateText()
  end
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

  if self.text ~= nil then
    self.text:setFont(font)
    self.width = self.text:getWidth()
    self.height = self.text:getHeight()
  else
    self.nodes = self:parseNodes(self.value)
  end
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

  if self.text ~= nil then
    self:updateText()
    self.width = self.text:getWidth()
    self.height = self.text:getHeight()
  end
end

--- Gets the formatted text's value
--- @param value Dummy.Text.Text
--- @param color love.Color
--- @param alpha? number
--- @return [ love.Color, string ]
function Text.getFormattedValue(value, color, alpha)
  return { { color[1], color[2], color[3], color[4] or alpha or 1 }, Lang.translate(value) }
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
  local width = 0
  local current_line = 1
  for _, node in ipairs(self.nodes) do
    if node.type == "character" then
      if current_line == line then
        local font = node.state.font or self.font
        local scale_x = node.state.scale_x or 1
        width = width + font:getWidth(node.character) * scale_x + (self.state.spacing or 0)
      elseif current_line > line then
        return width
      end

      if node.character == "\n" then
        current_line = current_line + 1
      end
    elseif node.type == "command" then
      self:processNode(node)
    end
  end
  return width
end

--- Gets the text's char offset
--- @param line number
--- @return number
function Text:getCharOffset(line)
  local align = self.state.align or self.align
  if align == "right" then
    return self:getWidth() - self:getLineWidth(line)
  elseif align == "center" then
    return self:getWidth() / 2 - self:getLineWidth(line) / 2
  end
  return 0
end

--- Registers a custom text command
--- @param command string
--- @param func fun(node: Dummy.Text.Node)
function Text:registerCommand(command, func)
  self.custom_commands[command] = func
end

--- Updates the text
function Text:update(dt)
  if not self:isVisible() or self.text ~= nil then return end

  self.timer = self.timer + dt * 30

  for _, node in ipairs(self.nodes) do
    if node.state ~= nil and (node.state.wave_speed or 0) > 0 then
      node.state.wave_direction = (node.state.wave_direction or 0) + (node.state.wave_speed * dt * 30)
    end
  end

  self:updateNodes(dt)
end

--- Draws the text
function Text:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local origin_x, origin_y = self:getOrigin()
  local width, height = self:getWidth(), self:getHeight()
  if Debugger.shouldDisplayHitbox() and (width > 0 or height > 0) then
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", -0.5 - width * origin_x, -0.5 - height * origin_y, width + 1, height + 1)
  end

  love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
  if self.text ~= nil then
    local align_offset = 0
    if self.align == "right" then
      align_offset = Constants.SCREEN_WIDTH - self.text:getWidth()
    elseif self.align == "center" then
      align_offset = Constants.SCREEN_WIDTH / 2 - self.text:getWidth() / 2
    end
    love.graphics.draw(self.text, -width * origin_x - align_offset, -height * origin_y)
  else
    for _, node in ipairs(self.nodes) do
      if node.type == "character" and node.state.text ~= nil then
        local scale_x, scale_y = node.state.scale_x or 1, node.state.scale_y or 1
        love.graphics.print(node.state.text or node.character, node.state.font or self.font, node.state.x, node.state.y,
          0,
          scale_x, scale_y)
      end
    end
  end

  self:drawChildren()
end

--- Updates text nodes
--- @param dt number
function Text:updateNodes(dt)
  local line = 1
  local char_x, char_y = self:getCharOffset(line), 0
  local line_height = 0
  local characters = 0
  for _, node in ipairs(self.nodes) do
    if node.type == "character" then
      characters = characters + 1

      local color = node.state.color or self.color
      local alpha = (color[4] or 1) * self.alpha
      node.state.text = Text.getFormattedValue(node.character, color, alpha)

      local spacing = node.state.spacing or 0
      local scale_x = node.state.scale_x or 1
      local scale_y = node.state.scale_y or 1
      local font = node.state.font or self.font
      local char_height = font:getHeight() * scale_y
      line_height = math.max(line_height, char_height)
      local line_diff = (line_height - char_height) / 2

      if node.state.shake ~= nil and node.state.shake > 0 and dt > 0 then
        if node.state == nil then node.state = {} end
        if self.timer - (node.state.last_shake or 0) >= dt * 30 then
          node.state.last_shake = self.timer
          node.state.offset_x = math.round(love.math.random() * (2 * node.state.shake) - node.state.shake)
          node.state.offset_y = math.round(love.math.random() * (2 * node.state.shake) - node.state.shake)
        end
      end

      if node.state.wave_distance ~= nil and node.state.wave_distance > 0 and dt > 0 then
        local direction = (node.state.wave_direction or 0) + (node.state.wave_offset * characters)

        node.state.offset_x = math.cos(math.rad(-direction)) * node.state.wave_distance * 0.7
        node.state.offset_y = math.sin(math.rad(-direction)) * node.state.wave_distance * 0.7
      end

      local origin_x, origin_y = self:getOrigin()
      node.state.x = char_x + (node.state.offset_x or 0) - self:getWidth() * origin_x
      node.state.y = char_y + line_diff + (node.state.offset_y or 0) - self:getHeight() * origin_y

      char_x = char_x + font:getWidth(node.character) * scale_x + spacing
      if node.character == "\n" then
        line = line + 1
        char_x = self:getCharOffset(line)
        char_y = char_y + line_height
        line_height = 0
      end
    elseif node.type == "command" then
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
function Text:processNode(node)
  if node.type ~= "command" then return end

  if node.command == "color" then
    if node.arguments[1] == "reset" then
      self.state.color = nil
    elseif #node.arguments == 3 or #node.arguments == 4 then
      local r = tonumber(node.arguments[1])
      local g = tonumber(node.arguments[2])
      local b = tonumber(node.arguments[3])
      if r ~= nil and g ~= nil and b ~= nil then
        self.state.color = {
          math.clamp(r, 0, 1),
          math.clamp(g, 0, 1),
          math.clamp(b, 0, 1)
        }
      end
    end
  elseif node.command == "alpha" then
    if node.arguments[1] == "reset" then
      self.state.alpha = nil
    else
      local alpha = tonumber(node.arguments[1])
      if alpha ~= nil then
        self.state.alpha = math.clamp(alpha, 0, 1)
      end
    end
  elseif node.command == "scale" then
    if node.arguments[1] == "reset" then
      self.state.scale_x = nil
      self.state.scale_y = nil
    else
      local scale_x = tonumber(node.arguments[1]) or 1
      local scale_y = tonumber(node.arguments[2]) or scale_x
      self.state.scale_x = scale_x
      self.state.scale_y = scale_y
    end
  elseif node.command == "font" then
    if node.arguments[1] == "reset" then
      self.state.font = nil
    else
      self.state.font = Assets.getFont(node.arguments[1])
    end
  elseif node.command == "spacing" then
    if node.arguments[1] == "reset" then
      self.state.spacing = nil
    else
      self.state.spacing = tonumber(node.arguments[1]) or 0
    end
  elseif node.command == "shake" then
    if node.arguments[1] == "reset" then
      self.state.shake = nil
    else
      self.state.shake = tonumber(node.arguments[1]) or 1
    end
  elseif node.command == "twitch" then
    if node.arguments[1] == "reset" then
      self.state.shake = nil
    else
      self.state.shake = 0.501
    end
  elseif node.command == "wave" then
    if node.arguments[1] == "reset" then
      self.state.wave_distance = nil
      self.state.wave_offset = nil
      self.state.wave_speed = nil
    else
      self.state.wave_distance = tonumber(node.arguments[1]) or 2
      self.state.wave_offset = tonumber(node.arguments[2]) or 30
      self.state.wave_speed = tonumber(node.arguments[3]) or 20
    end
  end
end

--- Parses the text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function Text:parseNodes(value)
  value = Lang.translate(value)

  self.state = {}
  local nodes = {}
  local width = 0
  local line_width, line_height = 0, 0
  local lines_heights = {}
  local line_count = 1
  local length = UTF8.len(value)
  local command = nil
  local escaping = false
  for i = 1, length do
    local char = UTF8.sub(value, i, i)
    local next_char = i < #value and UTF8.sub(value, i + 1, i + 1)
    if char == "\\" and (next_char == "[" or next_char == "]") then
      escaping = true
    elseif char == "[" and not escaping then
      command = ""
    elseif char == "]" and not escaping and command ~= nil then
      local node = self:parseCommand(command)
      if node ~= nil then
        self:processNode(node)
        table.insert(nodes, node)
      end
      command = nil
    elseif command ~= nil then
      command = command .. char
    else
      escaping = false

      local font = self.state.font or self.font
      local scale_x = self.state.scale_x or 1
      local scale_y = self.state.scale_y or 1
      local spacing = self.state.spacing or 0
      line_width = line_width + font:getWidth(char) * scale_x + spacing
      width = math.max(width, line_width)
      line_height = math.max(line_height, font:getHeight() * scale_y)
      lines_heights[line_count] = line_height
      if char == "\n" then
        line_width, line_height = 0, 0
        line_count = line_count + 1
      end

      table.insert(nodes, {
        type = "character",
        character = char,
        state = table.clone(self.state)
      })
    end
  end

  self.width = width
  self.height = math.sum(table.unpack(lines_heights))
  self.custom_commands_called = {}
  self.state = {}

  return nodes
end

--- Creates a text
--- @param value Dummy.Text.Text
--- @return Dummy.Text
function Text:new(value)
  local text = Class:new(Text)

  text.color = { 1, 1, 1 }
  text.font = love.graphics.getFont()
  text.align = "left"
  text.timer = 0
  text.custom_commands = {}
  text.custom_commands_called = {}

  text:setText(value)

  return text
end

return Text
