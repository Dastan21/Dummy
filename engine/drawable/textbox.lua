--- @alias Dummy.Textbox.Portrait.Callback fun(textbox: Dummy.Textbox, face: string, emotion: string)

--- @class Dummy.Textbox : Dummy.Drawable
---
--- @field protected dialogue Dummy.DialogueText
--- @field protected choice boolean
--- @field protected choice_index integer
--- @field protected heart_sprite Dummy.Sprite
--- @field protected portraits table<string, Dummy.Textbox.Portrait.Callback>
--- @field protected active_portrait string|nil
--- @field protected portrait_sprite Dummy.Sprite
local Textbox = Class(Drawable, "Dummy.Textbox")

--- Creates a textbox
--- @param value Dummy.Text.Text text value
--- @param ... Dummy.Text.Text more text value
--- @return Dummy.Textbox
function Textbox:new(value, ...)
  self = Class:new(Textbox)

  self.width = 283
  self.height = 70
  self:setLayer(Constants.LAYERS.WORLD_DIALOGUE)

  self.dialogue = DialogueText:new(value, ...)
  self.dialogue:setOrigin(0, 0)
  self.dialogue:setVoice("voice_dialogue")
  self.dialogue:setFont("plain")
  self.dialogue:setParent(self)
  self.dialogue:setPosition(11, 7)

  self.choice = false
  self.choice_index = 0
  self.dialogue:registerCommand("choice", function()
    self.choice = true
    self.choice_index = 0
  end)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setParent(self)
  self.heart_sprite:setVisible(false)

  self.dialogue:registerCommand("portrait", function(node)
    local portrait_id = tostring(node.arguments[1])
    if portrait_id == "none" or portrait_id == "reset" then
      self:resetPortrait()
    elseif portrait_id ~= nil then
      local portraits = self:getPortraits()
      local callback = portraits[portrait_id]
      if type(callback) == "function" then
        self:resetPortrait()
        self.active_portrait = portrait_id
        callback(self, node.arguments[2], node.arguments[3])
      end
    end
  end)

  self.portraits = {}

  self.portrait_sprite = Sprite:new()
  self.portrait_sprite:setVisible(false)
  self.portrait_sprite:setParent(self)

  self:setVisible(false)

  return self
end

--- Sets wether the textbox is visible
---
--- @param visible boolean
function Textbox:setVisible(visible)
  if self.visible == visible then return end

  Drawable.setVisible(self, visible)

  self.dialogue:setVisible(visible)
  self.heart_sprite:setVisible(false)
  self.active_portrait = nil
end

--- Gets the textbox's dialogue text
--- @return Dummy.DialogueText
function Textbox:getDialogue()
  return self.dialogue
end

--- Gets the textbox's portraits
--- @return table<string, Dummy.Textbox.Portrait.Callback>
function Textbox:getPortraits()
  return self.portraits
end

--- Gets the textbox's portrait sprite
--- @return Dummy.Sprite
function Textbox:getPortrait()
  return self.portrait_sprite
end

--- Gets the textbox's active portrait
--- @return string|nil
function Textbox:getActivePortrait()
  return self.active_portrait
end

--- Adds a portrait to the world textbox
---
--- Note: Use the command `[portrait:ID]` in dialogues to use a portrait
--- @param character_id string
--- @param callback Dummy.Textbox.Portrait.Callback
function Textbox:addPortrait(character_id, callback)
  self.portraits[character_id] = callback
end

--- Removes a portrait from the world textbox
--- @param character_id string
function Textbox:removePortrait(character_id)
  self.portraits[character_id] = nil
end

--- Plays a dialogue in the world
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText, choice?: integer)
function Textbox:playDialogue(texts, on_done)
  local current_room = World.getCurrentRoom()
  if current_room == nil then return end

  self.dialogue:setText(table.unpack(texts))
  self.dialogue:setVoice("voice_dialogue")
  self.dialogue:setFont("main_text")
  self.dialogue:setCharacterWidth(8)
  self.dialogue:setCharacterHeight(18)
  self.dialogue:setPosition(11, 7)
  self.dialogue:reset()

  function self.dialogue.onDone(_self)
    self:setVisible(false)
    _self:setVoice("voice_dialogue")
    _self:reset()
    Player.getObject():setInteraction("none")

    if type(on_done) == "function" then
      local choice = nil
      if self.choice then
        choice = self.choice_index
      end
      on_done(_self, choice)
    end
  end

  Player.getObject():setInteraction("interact")
  self.choice = false
  self.portrait_sprite:setVisible(false)
  self:setVisible(true)

  self:updatePosition()
end

--- Updates the textbox's position
function Textbox:updatePosition()
  local obj_player = Player.getObject()
  if obj_player == nil or not self.dialogue:isVisible() then return end

  local camera = Scene.getCameraByTag("GAME")
  if camera == nil then return end

  local width, height = camera:getDimensions()
  local viewport_x, viewport_y = camera:getViewportPosition()
  viewport_x = viewport_x - width / 2
  viewport_y = viewport_y - height / 2
  local _, y = obj_player:getPosition()
  if y > 146 then
    self:setPosition(viewport_x + 19, viewport_y + 8)
  else
    self:setPosition(viewport_x + 19, viewport_y + 163)
  end
end

--- Changes the selected choice
--- @param delta integer
function Textbox:changeChoice(delta)
  local new_index = (self.choice_index + delta + 2) % 2
  if self.choice_index == new_index then return end

  self.choice_index = new_index
  self:updateHeartPosition()
end

--- Updates the heart position to the current choice
function Textbox:updateHeartPosition()
  local x = 74.5 + 96 * self.choice_index
  self.heart_sprite:setPosition(x, 51.5)
  self.heart_sprite:setVisible(true)
end

--- Resets the portrait
function Textbox:resetPortrait()
  self.active_portrait = nil
  self.portrait_sprite:setVisible(false)
  self.dialogue:setVoice("voice_dialogue")
  self.dialogue:setPosition(11, 7)
end

--- Draws the textbox
--- @param camera Dummy.Camera
function Textbox:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getWidth(), self:getHeight()

  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", -3, -3, width + 6, height + 6)
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, width, height)

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Updates the textbox, called on every game update
--- @param dt number
function Textbox:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.dialogue:isCurrentDone() then
    self.active_portrait = nil

    if self.choice then
      if not self.heart_sprite:isVisible() then
        self:updateHeartPosition()
      end

      if Input.isPressed(Input.Left) then
        self:changeChoice(-1)
      elseif Input.isPressed(Input.Right) then
        self:changeChoice(1)
      elseif Input.isPressed(Input.Confirm) then
        self.choice = false
        self.dialogue:setVisible(false)
        self:setVisible(false)
      end
    end
  elseif self.choice then
    self.heart_sprite:setVisible(false)
  end
end

return Textbox
