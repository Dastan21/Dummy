--- @class Dummy.PlayerCellMenu : Dummy.Drawable
---
--- @field protected heart_sprite Dummy.Sprite
--- @field protected opening boolean
--- @field protected closing boolean
--- @field protected number_index integer
--- @field protected phone_name_texts Dummy.Text[]
local PlayerCellMenu = Class(Drawable, "Dummy.PlayerCellMenu")

--- Creates a player cell menu
--- @return Dummy.PlayerCellMenu
function PlayerCellMenu:new()
  self = Class:new(PlayerCellMenu)

  self.width = 167
  self.height = 129
  self:setPosition(97, 29)
  self:setVisible(false)

  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setParent(self)

  self.opening = false
  self.closing = false
  self.number_index = 0
  self.phone_name_texts = {}

  return self
end

--- Opens the player cell menu
function PlayerCellMenu:open()
  self.opening = true
  self.number_index = 0

  self:clean()

  local max_height = 129
  for i, phonecall in pairs(Player.getPhoneCalls()) do
    local phone_name_text = Text:new(phonecall.name)
    phone_name_text:setOrigin(0, 0.5)
    local y = 19 + 16 * (i - 1)
    phone_name_text:setPosition(19, y)
    phone_name_text:setFont("main_text")
    phone_name_text:setParent(self)

    max_height = math.max(max_height, y + phone_name_text:getHeight() + 4)

    table.insert(self.phone_name_texts, phone_name_text)
  end

  self.height = max_height
  self:setVisible(true)
  self:updateHeartPosition()
end

--- Closes the player cell menu
function PlayerCellMenu:close()
  self.closing = true
end

--- Cleans the player cell menu
function PlayerCellMenu:clean()
  for _, text in ipairs(self.phone_name_texts) do
    text:remove()
  end
  self.phone_name_texts = {}
end

--- Changes the selected number
--- @param delta integer
function PlayerCellMenu:changeNumber(delta)
  local new_index = math.clamp(self.number_index + delta, 0, #Player.getPhoneCalls() - 1)

  if self.number_index == new_index then return end
  self.number_index = new_index

  Assets.playSound("menu_move")
  self:updateHeartPosition()
end

--- Updates the player cell menu's heart position
function PlayerCellMenu:updateHeartPosition()
  local x, y = self.phone_name_texts[self.number_index + 1]:getPosition()
  self.heart_sprite:setPosition(x - 7.5, y + 0.5)
  self.heart_sprite:setVisible(true)
end

--- Calls the selected number
function PlayerCellMenu:callSelectedNumber()
  self:close()
  Player.call(self.number_index + 1)
end

--- Draws the player cell menu
--- @param camera Dummy.Camera
function PlayerCellMenu:draw(camera)
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

--- Updates the player cell menu, called on every game update
--- @param dt number
function PlayerCellMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.closing then
    self.closing = false
    self:clean()
    self:setVisible(false)
    return
  end

  if self.opening then
    self.opening = false
    return
  end

  if Input.isPressed(Input.Up) then
    self:changeNumber(-1)
  elseif Input.isPressed(Input.Down) then
    self:changeNumber(1)
  elseif Input.isPressed(Input.Confirm) then
    self:callSelectedNumber()
  elseif Input.isPressed(Input.Cancel) then
    self:close()
  end
end

return PlayerCellMenu
