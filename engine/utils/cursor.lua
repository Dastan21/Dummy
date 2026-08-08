--- @alias Dummy.Cursor.Icon "default" | "pointer" | "text" | "crosshair" | "grab"

--- @class Dummy.Cursor
---
--- @field protected prev_x number
--- @field protected prev_y number
--- @field protected visible boolean
--- @field protected hidden boolean
--- @field protected icon Dummy.Cursor.Icon|string
--- @field protected sprite Dummy.Sprite
local Cursor = Class(Sprite, "Dummy.Editor.Cursor")

--- Loads the cursor
--- @return Dummy.Cursor
function Cursor.load()
  love.mouse.setVisible(false)
  love.mouse.setGrabbed(false)
  love.mouse.setRelativeMode(false)
  if love.mouse.isCursorSupported() then
    love.mouse.setCursor()
  end

  Cursor.prev_x = 0
  Cursor.prev_y = 0
  Cursor.visible = false
  Cursor.hidden = false
  Cursor.icon = "default"

  Cursor.sprite = Sprite:new("cursor/default")
  Cursor.sprite:setLayer(Constants.LAYERS.CURSOR)
  Cursor.sprite:setPersistent(true)
  Cursor.sprite:setVisible(false)
  Cursor.sprite:setTag("UI")

  function Cursor.sprite.update(self, dt)
    if not self:isVisible() then return end

    Sprite.update(self, dt)

    local camera = Scene.getCameraByTag("UI")
    if camera == nil then return end

    local width, height = camera:getDimensions()
    local cursor_x, cursor_y = Input.getPointerPosition()
    cursor_x = math.floor(cursor_x * width / Constants.WINDOW_WIDTH) + 0.5
    cursor_y = math.floor(cursor_y * height / Constants.WINDOW_HEIGHT) + 0.5
    Cursor.prev_x, Cursor.prev_y = self:getPosition()

    if cursor_x == Cursor.prev_x and cursor_y == Cursor.prev_y then return end

    self:setPosition(cursor_x, cursor_y)
  end

  function Cursor.sprite.draw(self, camera)
    if self:isVisible() and not Input.isPointerInWindow() or Cursor.isHidden() then return end

    Sprite.draw(self, camera)
  end

  return Cursor
end

--- Gets the cursor's previous position
--- @return number, number
function Cursor.getPreviousPosition()
  return Cursor.prev_x, Cursor.prev_y
end

--- Gets the cursor's position
--- @return number, number
function Cursor.getPosition()
  return Cursor.sprite:getPosition()
end

--- Sets the cursor's position
--- @param x number
--- @param y number
function Cursor.setPosition(x, y)
  local camera = Scene.getCameraByTag("UI")
  if camera == nil then return end

  local width, height = camera:getDimensions()
  local pointer_x = (x - 0.5) * Constants.WINDOW_WIDTH / width
  local pointer_y = (y - 0.5) * Constants.WINDOW_HEIGHT / height
  Input.setPointerPosition(pointer_x, pointer_y)

  Cursor.sprite:setPosition(x - 0.5, y - 0.5)
end

--- Gets the cursor's visibility
--- @return boolean
function Cursor.isVisible()
  return Cursor.sprite:isVisible()
end

--- Sets the cursor's visibility
--- @param visible boolean
function Cursor.setVisible(visible)
  Cursor.sprite:setVisible(visible)
end

--- Shows the cursor
function Cursor.show()
  Cursor.hidden = false
end

--- Hides the cursor
function Cursor.hide()
  Cursor.hidden = true
end

--- Wether the cursor is hidden
--- @return boolean
function Cursor.isHidden()
  return Cursor.hidden
end

--- Sets the cursor's icon
--- @param icon Dummy.Cursor.Icon|string
function Cursor.setIcon(icon)
  if Cursor.icon == icon then return end

  Cursor.sprite:setSprite("cursor/" .. icon)
  Cursor.icon = icon
end

return Cursor
