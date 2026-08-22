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
local Text = Class(Drawable, "Dummy.Text")

--- Text commands
Text.COMMANDS = { "color", "scale", "font", "shake", "twitch", "wave", "spacing" }

--- Gets the text's value
--- @return Dummy.Text.Text
function Text:getText()
  return self.value
end

--- Sets the text's value
--- @param value Dummy.Text.Text text value
--- @param force? boolean wether to force the text to be updated
--- @param no_command? boolean wether to force plain text
function Text:setText(value, force, no_command)
  if self.value == value and not force then return end

  local translated_value = self.no_translation and tostring(value) or Lang.translate(value)

  -- text has no command
  local char_width = self:getCharacterWidth()
  local char_height = self:getCharacterHeight()
  if (no_command == true or translated_value:find("%b[]") == nil and char_width == 0 and char_height == 0) then
    self.value = value
    self.nodes = {}

    if self.text == nil then
      self.text = love.graphics.newText(self.font, "")
    end
    self:updateText()
  else
    self.value = value
    self.text = nil
    self.nodes = self:parseNodes(value)

    local has_command = false
    for _, node in ipairs(self.nodes) do
      if node.command ~= nil then
        has_command = true
        break
      end
    end

    if has_command or char_width ~= 0 or char_height ~= 0 then
      self:updateNodes(0)
    else
      self:setText(value, true, true)
    end
  end
end

--- Updates the render text or its nodes
function Text:updateText()
  if self.text ~= nil then
    self.text:setFont(self.font)

    local max_width = self:getMaxWidth()
    local wrap_limit = self:getWrapLimit()
    local value = self.no_translation and tostring(self.value) or Lang.translate(self.value)
    if value:find("%b[]") ~= nil then
      value = value:gsub("\\%[", "[")
    end
    local pre_overflow_value = value
    local trimmed = value:match("^(.-)%s*$")
    if max_width > 0 then
      if self:getOverflow() == "ellipsis" then
        value = Text.ellipse(trimmed, max_width, self.font)
      else
        value = Text.clip(trimmed, max_width, self.font)
      end
    end
    self.is_clipping = value ~= pre_overflow_value
    local width = self.font:getWidth(value)
    if wrap_limit ~= nil then
      local align = "left"
      if width > wrap_limit then
        align = self:getAlign()
      end
      self.text:setf(Text.getFormattedValue(value, self:getColor()), wrap_limit, align)
      width = math.min(wrap_limit, width)
    else
      self.text:set(Text.getFormattedValue(value, self:getColor()))
    end
    self.width = width
    self.height = self.text:getHeight()
  else
    self.nodes = self:parseNodes(self.value)
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
--- @param font love.Font|Dummy.Assets.Font|string
function Text:setFont(font)
  if type(font) == "string" then
    font = Assets.getFont(font)
  end
  self.font = font

  self:updateText()
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

  self:updateText()
end

--- Gets the text's wrap limit
--- @return number|nil
function Text:getWrapLimit()
  return self.wrap_limit
end

--- Sets the text's wrap limit
--- @param wrap_limit number|nil
function Text:setWrapLimit(wrap_limit)
  self.wrap_limit = wrap_limit

  self:updateText()
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

  self:updateText()
end

--- Gets the text's overflow
--- @return Dummy.Text.Overflow
function Text:getOverflow()
  return self.overflow
end

--- Sets the text's overflow
--- @param overflow Dummy.Text.Overflow
function Text:setOverflow(overflow)
  self.overflow = overflow

  self:updateText()
end

--- Wether the text is clipping
--- @return boolean
function Text:isClipping()
  return self.is_clipping
end

--- Gets the text's characters width
--- @return number
function Text:getCharacterWidth()
  return self.char_width
end

--- Sets the text's characters width
--- @param char_width number
function Text:setCharacterWidth(char_width)
  char_width = math.max(math.round(char_width), 0)
  if self.char_width == char_width then return end

  self.char_width = char_width

  self:setText(self:getText(), true)
end

--- Gets the text's characters height
--- @return number
function Text:getCharacterHeight()
  return self.char_height
end

--- Sets the text's characters height
--- @param char_height number
function Text:setCharacterHeight(char_height)
  char_height = math.max(math.round(char_height), 0)
  if self.char_height == char_height then return end

  self.char_height = char_height

  self:setText(self:getText(), true)
end

--- Sets the text's scale
--- @overload fun(self: Dummy.Drawable, scale: number)
--- @param scale_x number
--- @param scale_y number
function Text:setScale(scale_x, scale_y)
  Drawable.setScale(self, scale_x, scale_y)

  self:updateText()
end

--- Ellipsizes a text
--- @param text string
--- @param max_width number
--- @param font love.Font
function Text.ellipse(text, max_width, font)
  if font:getWidth(text) <= max_width then return text end

  local ellipsis = "..."
  local ellipsis_width = font:getWidth(ellipsis)
  if ellipsis_width > max_width then return "" end

  return Text.clip(text, max_width - ellipsis_width, font) .. ellipsis
end

--- Clips a text
--- @param text string
--- @param max_width number
--- @param font love.Font
function Text.clip(text, max_width, font)
  if font:getWidth(text) <= max_width then return text end

  local length = UTF8.len(text)
  if length == nil or length == 0 then return "" end

  local left, right = 0, length
  local result = ""

  while left <= right do
    local mid = math.floor((left + right) / 2)
    local candidate = UTF8.sub(text, 1, mid)
    if font:getWidth(candidate) <= max_width then
      result = candidate
      left = mid + 1
    else
      right = mid - 1
    end
  end

  return result
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
        local char_width = self:getCharacterWidth()
        if char_width <= 0 then
          char_width = font:getWidth(node.character)
        end
        width = width + char_width * scale_x + (self.state.spacing or 0)
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

--- Unregisters a custom text command
--- @param command string
function Text:unregisterCommand(command)
  self.custom_commands[command] = nil
end

--- Updates the text, called on every game update
--- @param dt number
function Text:update(dt)
  if not self:isVisible() or self.text ~= nil then return end

  self.time = self.time + dt * 30

  for _, node in ipairs(self.nodes) do
    if node.state ~= nil and (node.state.wave_speed or 0) > 0 then
      node.state.wave_direction = (node.state.wave_direction or 0) + (node.state.wave_speed * dt * 30)
    end
  end

  self:updateNodes(dt)
end

--- Draws the text
--- @param camera Dummy.Camera
function Text:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local alpha = self:getAlpha()
  love.graphics.setColor(1, 1, 1, alpha)
  if self.text ~= nil then
    self.text:setFont(self.font)
    local origin_x, origin_y = self:getOrigin()
    local width, height = self:getWidth(), self:getHeight()
    local text_x, text_y = math.ceil(-width * origin_x), math.ceil(-height * origin_y)
    love.graphics.draw(self.text, text_x, text_y)
  else
    for _, node in ipairs(self.nodes) do
      if node.type == "character" and node.state.text ~= nil then
        local scale_x, scale_y = node.state.scale_x or 1, node.state.scale_y or 1
        local font = node.state.font or self.font
        love.graphics.print(node.state.text or node.character, font, node.state.x, node.state.y, 0, scale_x, scale_y)
      end
    end
  end

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Draws the text's bounding box for debugging
--- @param camera Dummy.Camera
function Text:drawDebug(camera)
  if not Debug.shouldShowDebug() or not self:isVisibleOnScreen() then return end

  local width, height = self:getWidth(), self:getHeight()
  if width == 0 and height == 0 then return end

  love.graphics.push()
  love.graphics.origin()

  camera:apply()

  love.graphics.setColor(0, 0, 1, 1)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle("rough")
  local bb = self:getBoundingBox()
  love.graphics.polygon("line",
    bb[1] + 0.5, bb[2] + 0.5,
    bb[3] - 0.5, bb[4] + 0.5,
    bb[5] - 0.5, bb[6] - 0.5,
    bb[7] + 0.5, bb[8] - 0.5
  )

  love.graphics.pop()
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
      local alpha = (color[4] or 1) * self:getAlpha()
      node.state.text = Text.getFormattedValue(node.character, color, alpha)

      local spacing = node.state.spacing or 0
      local scale_x = node.state.scale_x or 1
      local scale_y = node.state.scale_y or 1
      local font = node.state.font or self.font
      local char_height = self:getCharacterHeight()
      if char_height <= 0 then
        char_height = math.round(font:getHeight() * font:getLineHeight())
      end
      line_height = math.max(line_height, char_height * scale_y)
      local line_diff = (line_height - char_height * scale_y) / 2

      if node.state.shake ~= nil and node.state.shake > 0 and dt > 0 then
        if node.state == nil then node.state = {} end
        if self.time - (node.state.last_shake or 0) >= 1 then
          node.state.last_shake = self.time
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

      local char_width = self:getCharacterWidth()
      if char_width <= 0 then
        char_width = font:getWidth(node.character)
      end
      char_x = char_x + char_width * scale_x + spacing
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
      local a = tonumber(node.arguments[4])
      if r ~= nil and g ~= nil and b ~= nil then
        self.state.color = {
          math.clamp(r, 0, 1),
          math.clamp(g, 0, 1),
          math.clamp(b, 0, 1)
        }

        if a ~= nil then
          self.state.color[4] = math.clamp(a, 0, 1)
        end
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
  value = self.no_translation and tostring(value) or Lang.translate(value)

  self.state = {}
  local nodes = {}
  local width = 0
  local line_width, line_height = 0, 0
  local lines_heights = {}
  local line_count = 1
  local length = UTF8.len(value)
  local command = nil
  local escaping = false
  local i = 1
  while i <= length do
    local char = UTF8.sub(value, i, i)
    local next_char = UTF8.sub(value, i + 1, i + 1)
    if char == "\\" and (next_char == "[" or next_char == "]") then
      escaping = true
    elseif char == "[" and not escaping then
      command = ""
    elseif char == "]" and not escaping and command ~= nil then
      local node = self:parseCommand(command)
      if node ~= nil then
        self:processNode(node)
        table.insert(nodes, node)
      else
        i = i - UTF8.len(command) - 2
        escaping = true
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
      local char_width = self:getCharacterWidth()
      if char_width <= 0 then
        char_width = math.round(font:getWidth(char))
      end
      line_width = line_width + char_width * scale_x + spacing
      width = math.max(width, line_width)
      local char_height = self:getCharacterHeight()
      if char_height <= 0 then
        char_height = math.round(font:getHeight() * font:getLineHeight())
      end
      line_height = math.max(line_height, char_height * scale_y)
      lines_heights[line_count] = line_height
      if char == "\n" then
        line_width, line_height = 0, 0
        line_count = line_count + 1
      end

      table.insert(nodes, {
        type = "character",
        character = char,
        state = table.copy(self.state)
      })
    end

    i = i + 1
  end

  self.width = width
  self.height = table.sum(lines_heights)
  self.custom_commands_called = {}
  self.state = {}

  return nodes
end

--- Reloads the text
function Text:reload()
  self:setText(self:getText(), true)
end

--- Creates a text
--- @param value? Dummy.Text.Text
--- @param no_translation? boolean wether the value should not be translated (Defaults to `false`)
--- @return Dummy.Text
function Text:new(value, no_translation)
  self = Class:new(Text)

  self.no_translation = Utils.getOrDefault(no_translation, false)
  self.color = { 1, 1, 1, 1 }
  self.font = love.graphics.getFont()
  self.align = "left"
  self.max_width = 0
  self.overflow = "clip"
  self.is_clipping = false
  self.char_width = 0
  self.char_height = 0
  self.time = 0
  self.custom_commands = {}
  self.custom_commands_called = {}

  Signal.on("hot_reload_language", function()
    self:reload()
  end)

  self:setText(Utils.getOrDefault(value, ""))

  return self
end

return Text
