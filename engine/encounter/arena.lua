--- @class Dummy.Arena
---
--- @field private x number
--- @field private y number
--- @field private width number
--- @field private height number
--- @field private resize_callback fun()|nil
local self = {}

--- @class Dummy.Arena
local current = {}

function self.load()
  current.width = Constants.ARENA.DEFAULT_WIDTH
  current.height = Constants.ARENA.DEFAULT_HEIGHT
  current.x = Constants.ARENA.DEFAULT_X
  current.y = Constants.ARENA.DEFAULT_Y

  self.width = Constants.ARENA.DEFAULT_WIDTH
  self.height = Constants.ARENA.DEFAULT_HEIGHT
  self.x = Constants.ARENA.DEFAULT_X
  self.y = Constants.ARENA.DEFAULT_Y

  self.layer = Constants.LAYERS.ARENA

  Drawable:new(function()
    local arena_x = self.x - (current.width / 2)
    local arena_y = self.y - current.height

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", arena_x, arena_y, current.width, current.height)
  end):setLayer(Constants.LAYERS.ARENA)

  Drawable:new(function()
    local b = Constants.ARENA.BORDER_WIDTH
    local x = self.x - (current.width / 2)
    local y = self.y - current.height

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", x - b, y - b, current.width + b * 2, b)
    love.graphics.rectangle("fill", x - b, y + current.height, current.width + b * 2, b)
    love.graphics.rectangle("fill", x - b, y - b, b, current.height + b * 2)
    love.graphics.rectangle("fill", x + current.width, y - b, b, current.height + b * 2)
  end):setLayer(Constants.LAYERS.ABOVE_BULLETS)
end

function self.update(dt)
  -- if current.x ~= self.x then
  --   local sign = math.sign(self.x - current.x)
  --   current.x = current.x + sign * Constants.ARENA.RESIZE_SPEED * dt
  --   if (math.sign(self.x - current.x) ~= sign) then
  --     current.x = self.x
  --   end
  -- end
  -- if current.y ~= self.y then
  --   local sign = math.sign(self.y - current.y)
  --   current.y = current.y + sign * Constants.ARENA.RESIZE_SPEED * dt
  --   if (math.sign(self.y - current.y) ~= sign) then
  --     current.y = self.y
  --   end
  -- end

  if current.height > self.height then
    current.height = current.height - Constants.ARENA.RESIZE_SPEED * dt * 30
    if current.height < self.height then
      current.height = self.height
    end
  end
  if current.width ~= self.width then
    local sign = math.sign(self.width - current.width)
    current.width = current.width + sign * Constants.ARENA.RESIZE_SPEED * dt * 30
    if (math.sign(self.width - current.width) ~= sign) then
      current.width = self.width
    end
  else
    if current.height < self.height then
      current.height = current.height + Constants.ARENA.RESIZE_SPEED * dt * 30
      if current.height > self.height then
        current.height = self.height
      end
    end
  end

  if current.width == self.width and current.height == self.height and type(self.resize_callback) == "function" then
    self.resize_callback()
    self.resize_callback = nil
  end
end

--- Resizes the arena
--- @param width number target width of the arena
--- @param height number target height of the arena
--- @param resize_callback? fun() called after finished resizing
function self.resize(width, height, resize_callback)
  self.width = width
  self.height = height
  self.resize_callback = resize_callback
end

--- Resets the arena bounds
--- @param resize_callback? fun() called after finished resizing
function self.reset(resize_callback)
  self.resize(Constants.ARENA.DEFAULT_WIDTH, Constants.ARENA.DEFAULT_HEIGHT, resize_callback)
end

--- Gets the arena position
--- @return number, number
function self.getPosition()
  return self.x, self.y
end

--- Gets the arena width
--- @return number
function self.getWidth()
  return self.width
end

--- Gets the arena height
--- @return number
function self.getHeight()
  return self.height
end

return self
