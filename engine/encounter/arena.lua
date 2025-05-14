---@class Dummy.Arena : Dummy.Drawable
---
---@field private x number
---@field private y number
---@field private width number
---@field private height number
local self = Drawable.new()

local RESIZE_SPEED = 400
local DEFAULT_WIDTH = 565
local DEFAULT_HEIGHT = 130
local BORDER_WIDTH = 5
local DEFAULT_X = 320
local DEFAULT_Y = 385

---@class Dummy.Arena
local current = {}

function self.load()
  current.width = DEFAULT_WIDTH
  current.height = DEFAULT_HEIGHT
  current.x = DEFAULT_X
  current.y = DEFAULT_Y

  self.width = DEFAULT_WIDTH
  self.height = DEFAULT_HEIGHT
  self.x = DEFAULT_X
  self.y = DEFAULT_Y

  self.layer = Constants.LAYERS.ARENA

  Scene.addDrawable(self)
end

function self.update(dt)
  -- if current.x ~= self.x then
  --   local sign = math.sign(self.x - current.x)
  --   current.x = current.x + sign * SPEED * dt
  --   if (math.sign(self.x - current.x) ~= sign) then
  --     current.x = self.x
  --   end
  -- end
  -- if current.y ~= self.y then
  --   local sign = math.sign(self.y - current.y)
  --   current.y = current.y + sign * SPEED * dt
  --   if (math.sign(self.y - current.y) ~= sign) then
  --     current.y = self.y
  --   end
  -- end

  if current.height > self.height then
    current.height = current.height - RESIZE_SPEED * dt * 3
    if current.height < self.height then
      current.height = self.height
    end
  end
  if current.width ~= self.width then
    local sign = math.sign(self.width - current.width)
    current.width = current.width + sign * RESIZE_SPEED * dt * 4
    if (math.sign(self.width - current.width) ~= sign) then
      current.width = self.width
    end
  else
    if current.height < self.height then
      current.height = current.height + RESIZE_SPEED * dt * 3
      if current.height > self.height then
        current.height = self.height
      end
    end
  end
end

function self.draw()
  local arena_x = self.x - (current.width / 2)
  local arena_y = self.y - current.height

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", arena_x - BORDER_WIDTH, arena_y - BORDER_WIDTH, current.width + 2 * BORDER_WIDTH,
    current.height + 2 * BORDER_WIDTH)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", arena_x, arena_y, current.width, current.height)
  love.graphics.setColor(1, 1, 1, 1)
end

--- Resizes the arena
---@param width number
---@param height number
function self.resize(width, height)
  self.width = width
  self.height = height
end

--- Resets the arena bounds
function self.reset()
  self.resize(DEFAULT_WIDTH, DEFAULT_HEIGHT)
end

--- Gets the arena position
---@return number, number
function self.getPosition()
  return self.x, self.y
end

--- Gets the arena width
---@return number
function self.getWidth()
  return self.width
end

--- Gets the arena height
---@return number
function self.getHeight()
  return self.height
end

return self
