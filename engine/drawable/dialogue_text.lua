--- @class Dummy.DialogueText : Dummy.Text
---
--- @field protected text_value Dummy.Text.Text
--- @field protected nodes Dummy.Text.Node[]
--- @field protected state table<string, any>
--- @field protected total_nodes Dummy.Text.Node[]
--- @field protected speed number
--- @field protected text_index number
--- @field protected voice string|nil
--- @field protected done_callback fun()|nil
--- @field protected can_skip boolean
--- @field protected can_confirm boolean
--- @field protected wait number
local DialogueText = Class:extend(Text)

--- Dialogue text commands
DialogueText.COMMANDS = { "wait", "speed", "voice" }

--- Silent characters
DialogueText.SILENT_CHARACTERS = { " ", "\n" }

--- Gets the class name
--- @return string
function DialogueText:getClass()
  return "Dummy.DialogueText"
end

--- Sets the dialogue's text value
--- @param value Dummy.Text.Text
function DialogueText:setText(value)
  self.text_value = value
  self:reset()
end

--- Updates the dialogue's text value
--- @protected
function DialogueText:updateDialogue()
  self.nodes = table.slice(self.total_nodes, 1, self.text_index)
end

--- Resets the dialogue's current text
function DialogueText:reset()
  self.dialogue_timer = 0
  self.text_index = 1
  self.is_skipping = false
  self.wait = 0
  self:parseNodes(self.text_value)
  self:updateDialogue()
end

--- Wether the dialogue's can be skipped
--- @return boolean
function DialogueText:canSkip()
  return self.can_skip
end

--- Sets wether the dialogue's can be skipped
--- @param can_skip boolean
function DialogueText:setCanSkip(can_skip)
  self.can_skip = can_skip
end

--- Skips the dialogue's
function DialogueText:skip()
  if self:isDone() or not self.can_skip then return end

  self.is_skipping = true
end

--- Wether the dialogue's can be confirmed
--- @return boolean
function DialogueText:canConfirm()
  return self.can_confirm
end

--- Sets wether the dialogue's can be confirmed
--- @param can_confirm boolean
function DialogueText:setCanConfirm(can_confirm)
  self.can_confirm = can_confirm
end

--- Wether the dialogue's is done
--- @return boolean
function DialogueText:isDone()
  return not self:isVisible() or self.text_index >= #self.total_nodes
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

local process_node = Text.processNode
--- Applies the node state
--- @param node Dummy.Text.Node
function DialogueText:processNode(node)
  if node.type ~= "command" then return end

  process_node(self, node)

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
  end

  node.state = table.merge(table.clone(self.state), node.state or {})
end

local parse_command = Text.parseCommand
--- Parses the dialogue text command
--- @param text string
--- @return Dummy.Text.Node|nil
function DialogueText:parseCommand(text)
  local node = parse_command(self, text)
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

local parse_nodes = Text.parseNodes
--- Parses the dialogue text nodes
--- @param value Dummy.Text.Text
--- @return Dummy.Text.Node[]
function DialogueText:parseNodes(value)
  self.state = {}
  self.total_nodes = parse_nodes(self, value)
  return {}
end

local text_update = Text.update
--- Updates the dialogue
--- @param dt number
function DialogueText:update(dt)
  text_update(self, dt)

  if self:isDone() or not self:isVisible() then return end

  if not self.is_skipping then
    if self.wait > 0 then
      self.wait = math.max(0, self.wait - dt)
    else
      local speed = self.state.speed or self.speed
      self.dialogue_timer = self.dialogue_timer + dt * speed * 30
    end
  else
    self.dialogue_timer = #self.total_nodes
  end

  while math.floor(self.dialogue_timer) > self.text_index do
    self.text_index = self.text_index + 1

    local node = self.total_nodes[math.min(self.text_index, #self.total_nodes)]
    while node.type == "command" and self.text_index < #self.total_nodes do
      self.state.speed = node.state.speed
      self.wait = node.state.wait or self.wait

      if node.command == "wait" or node.command == "speed" then
        self.dialogue_timer = self.text_index
        break
      else
        self.dialogue_timer = self.dialogue_timer + 1
        self.text_index = self.text_index + 1
      end

      node = self.total_nodes[self.text_index]
    end

    local voice = node.state.voice ~= "none" and nil or (node.state.voice or self.voice)
    if voice ~= nil and node.character ~= nil and not table.contains(DialogueText.SILENT_CHARACTERS, node.character) and not self.is_skipping then
      Assets.playSound(voice)
    end
  end

  self.text_index = math.max(1, math.floor(self.dialogue_timer))

  if Input.isPressed(Input.Cancel) then
    self:skip()
  end

  if self:isDone() then
    self.is_skipping = false
    if type(self.done_callback) == "function" then
      self.done_callback()
    end
  end

  self:updateDialogue()
end

--- Creates a dialogue text
--- @param value Dummy.Text.Text text value
--- @param done_callback? fun() called when the dialogue is done
--- @return Dummy.DialogueText
function DialogueText:new(value, done_callback)
  local dialogue_text = Class:new(DialogueText, { value })

  dialogue_text.speed = 1
  dialogue_text.dialogue_timer = 0
  dialogue_text.text_index = 1
  dialogue_text.voice = "voice_text"
  dialogue_text.done_callback = done_callback
  dialogue_text.can_skip = true
  dialogue_text.can_confirm = true
  dialogue_text.wait = 0

  dialogue_text:setText(value)

  return dialogue_text
end

return DialogueText
