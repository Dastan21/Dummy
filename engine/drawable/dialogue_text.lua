--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected text_values Dummy.Text.Text[]
--- @field protected text_value Dummy.Text.Text
--- @field protected font love.Font
--- @field protected nodes Dummy.Text.Node[]
--- @field protected dialogue_timer number
--- @field protected state table<string, any>
--- @field protected total_nodes Dummy.Text.Node[]
--- @field protected done boolean
--- @field protected speed number
--- @field protected text_value_index number
--- @field protected text_index number
--- @field protected voice string|nil
--- @field protected wait number
--- @field protected skipping boolean
--- @field protected force_skip boolean
--- @field protected no_skip boolean
--- @field protected auto_next boolean
local DialogueText = Class:extend(Text)

--- Dialogue text commands
DialogueText.COMMANDS = { "wait", "speed", "voice", "noskip", "instant", "stopinstant", "next" }

--- Silent characters
DialogueText.SILENT_CHARACTERS = { " ", "\n" }

--- Gets the class name
--- @return string
function DialogueText.getClassName()
  return "Dummy.DialogueText"
end

--- Sets the dialogue's text value
--- @param value Dummy.Text.Text
--- @param ... Dummy.Text.Text
function DialogueText:setText(value, ...)
  self.text_values = { value, ... }
  self.text_value_index = 1
  self.text_value = self.text_values[1] or ""

  self:reset()
end

--- Updates the dialogue's text value
--- @protected
function DialogueText:updateDialogue()
  self.nodes = table.slice(self.total_nodes, 1, self.text_index)
end

--- Resets the dialogue's current text
function DialogueText:reset()
  self.done = false
  self.dialogue_timer = 0
  self.text_index = 0
  self.skipping = false
  self.force_skip = false
  self.no_skip = false
  self.auto_next = false
  self.wait = 0

  self:parseNodes(self.text_value)
  self:updateDialogue()
end

--- Skips the dialogue's
function DialogueText:skip()
  if self:isCurrentDone() or self.no_skip == true then return end

  self.force_skip = true
  self.skipping = true
  self.wait = 0
  self.text_index = #self.total_nodes
  self:updateDialogue()
  self:update(0)
end

--- Wether the dialogue is done
--- @return boolean
function DialogueText:isDone()
  return self.done
end

--- Wether the dialogue's current text is done
--- @return boolean
--- @private
function DialogueText:isCurrentDone()
  return not self:isVisible() or self.text_index >= #self.total_nodes and self.wait <= 0
end

--- Gets the dialogue's speed
--- @return number
function DialogueText:getSpeed()
  return self.speed
end

--- Sets the dialogue's speed
--- @param speed number
function DialogueText:setSpeed(speed)
  self.speed = speed
end

--- Gets the dialogue's voice
--- @return string|nil
function DialogueText:getVoice()
  return self.voice
end

--- Sets the dialogue's voice
--- @param voice string|nil
function DialogueText:setVoice(voice)
  self.voice = voice
end

--- Sets the dialogue text's font
--- @param font love.Font
function DialogueText:setFont(font)
  self.font = font
  self:parseNodes(self.text_value)
end

--- Applies the node state
--- @param node Dummy.Text.Node
function DialogueText:processNode(node)
  if node.type ~= "command" then return end

  Text.processNode(self, node)

  self.state.wait = nil
  if node.command == "wait" then
    local delay = node.arguments[1] or "1s"
    if delay ~= nil then
      if delay:sub(-1) == "s" then
        self.state.wait = tonumber(delay:sub(1, -2))
      else
        self.state.wait = tonumber(delay) / 30
      end
    end
  elseif node.command == "speed" then
    if node.arguments[1] == "reset" then
      self.state.speed = nil
    else
      self.state.speed = tonumber(node.arguments[1])
    end
  elseif node.command == "voice" then
    local voice = node.arguments[1]
    if voice == "none" then
      self.state.voice = "none"
    elseif voice == "reset" then
      self.state.voice = nil
    else
      local success = pcall(Assets.playSound, node.arguments[1], false, false, false)
      if success then
        self.state.voice = node.arguments[1]
      end
    end
  elseif node.command == "noskip" then
    self.no_skip = true
  elseif node.command == "next" then
    self.auto_next = true
  end

  node.state = table.merge(table.clone(self.state), node.state or {})
end

--- Parses the dialogue text command
--- @param text string
--- @return Dummy.Text.Node|nil
function DialogueText:parseCommand(text)
  local node = Text.parseCommand(self, text)
  if node ~= nil then return node end

  local split = text:split(":")
  local command = split[1]
  local arguments = (split[2] or ""):split(",")
  if not table.contains(DialogueText.COMMANDS, command) then return end

  return {
    type = "command",
    command = command,
    arguments = arguments
  }
end

--- Parses the dialogue text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function DialogueText:parseNodes(value)
  self.text = nil
  self.state = {}
  self.total_nodes = Text.parseNodes(self, value)
  return {}
end

--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt)
  Text.update(self, dt)

  if not self:isVisible() or self:isDone() then return end

  if not self.skipping then
    if self.wait > 0 then
      self.wait = math.max(0, self.wait - dt)
    else
      local speed = self.state.speed or self.speed
      self.dialogue_timer = math.min(#self.total_nodes, self.dialogue_timer + dt * speed * 30)
    end
  else
    self.dialogue_timer = #self.total_nodes
  end

  if self:isCurrentDone() then
    if Input.isPressed(Input.Confirm) or (self.auto_next and not self.skipping) then
      self.text_value_index = self.text_value_index + 1
      self.text_value = self.text_values[self.text_value_index] or ""

      if self.text_value_index >= #self.text_values and self.text_index >= #self.total_nodes then
        self.done = true
        self.skipping = false
        if type(self.onDone) == "function" then
          self:onDone()
        end
      else
        self:reset()
      end
    end
    return
  end

  while math.floor(self.dialogue_timer) > self.text_index do
    self.text_index = self.text_index + 1

    local node = self.total_nodes[math.min(self.text_index, #self.total_nodes)]
    while node.type == "command" and self.text_index <= #self.total_nodes do
      if node.command == "instant" then
        self.skipping = true
      elseif node.command == "stopinstant" and not self.force_skip then
        self.skipping = false
        self.dialogue_timer = self.text_index
      end

      if not self.skipping then
        self.wait = node.state.wait or self.wait
        self.state.speed = node.state.speed
      end

      if (node.command == "wait" or node.command == "speed") and not self.skipping then
        self.dialogue_timer = self.text_index
        break
      else
        self.dialogue_timer = self.dialogue_timer + 1
        self.text_index = self.text_index + 1
      end

      node = self.total_nodes[math.min(self.text_index, #self.total_nodes)]
    end

    local voice = node.state.voice or self.voice
    if voice ~= nil and node.state.voice ~= "none" and node.character ~= nil and not table.contains(DialogueText.SILENT_CHARACTERS, node.character) and not self.skipping then
      Assets.playSound(voice)
    end
  end

  self.text_index = math.max(1, math.floor(self.dialogue_timer))

  if Input.isPressed(Input.Cancel) then
    self:skip()
  end

  self:updateDialogue()
end

--- Called when the dialogue is done
function DialogueText:onDone() end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
--- @return Dummy.DialogueText
function DialogueText:new(value, ...)
  self = Class:new(DialogueText, { value })
  self.speed = 1
  self.voice = "voice_text"

  self:setText(value, ...)

  return self
end

return DialogueText
