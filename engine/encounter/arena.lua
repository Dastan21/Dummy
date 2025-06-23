--- @class Dummy.Arena
---
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
--- @field protected target_x number
--- @field protected target_y number
--- @field protected target_width number
--- @field protected target_height number
--- @field protected resize_callback fun()|nil
--- @field protected move_callback fun()|nil
local Arena = {}

--- Loads the arena
function Arena.load()
  Arena.x = Constants.ARENA.DEFAULT_X
  Arena.y = Constants.ARENA.DEFAULT_Y
  Arena.width = Constants.ARENA.DEFAULT_WIDTH
  Arena.height = Constants.ARENA.DEFAULT_HEIGHT

  Arena.target_x = Constants.ARENA.DEFAULT_X
  Arena.target_y = Constants.ARENA.DEFAULT_Y
  Arena.target_width = Constants.ARENA.DEFAULT_WIDTH
  Arena.target_height = Constants.ARENA.DEFAULT_HEIGHT

  Arena.resize_callback = nil
  Arena.move_callback = nil

  Arena.layer = Constants.LAYERS.ARENA

  --- arena background
  local arena_background_drawable = Drawable:new()
  arena_background_drawable:setLayer(Constants.LAYERS.ARENA)
  function arena_background_drawable:draw()
    local arena_x = Arena.x - (Arena.width / 2)
    local arena_y = Arena.y - Arena.height

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", arena_x, arena_y, Arena.width, Arena.height)
  end

  --- arena border
  local arena_border_drawable = Drawable:new()
  arena_border_drawable:setLayer(Constants.LAYERS.ABOVE_BULLET)
  function arena_border_drawable:draw()
    local b = Constants.ARENA.BORDER_WIDTH
    local x = Arena.x - (Arena.width / 2)
    local y = Arena.y - Arena.height

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", x - b, y - b, Arena.width + b * 2, b)
    love.graphics.rectangle("fill", x - b, y + Arena.height, Arena.width + b * 2, b)
    love.graphics.rectangle("fill", x - b, y - b, b, Arena.height + b * 2)
    love.graphics.rectangle("fill", x + Arena.width, y - b, b, Arena.height + b * 2)
  end
end

--- Updates the arena
function Arena.update(dt)
  -- resize
  if Arena.height > Arena.target_height then
    Arena.height = Arena.height - Constants.ARENA.RESIZE_SPEED * dt * 30
    if Arena.height < Arena.target_height then
      Arena.height = Arena.target_height
    end
  end
  if Arena.width ~= Arena.target_width then
    local sign = math.sign(Arena.target_width - Arena.width)
    Arena.width = Arena.width + sign * Constants.ARENA.RESIZE_SPEED * dt * 30
    if (math.sign(Arena.target_width - Arena.width) ~= sign) then
      Arena.width = Arena.target_width
    end
  else
    if Arena.height < Arena.target_height then
      Arena.height = Arena.height + Constants.ARENA.RESIZE_SPEED * dt * 30
      if Arena.height > Arena.target_height then
        Arena.height = Arena.target_height
      end
    end
  end

  if Arena.width == Arena.target_width and Arena.height == Arena.target_height and type(Arena.resize_callback) == "function" then
    Arena.resize_callback()
    Arena.resize_callback = nil
  end

  -- move
  if Arena.x ~= Arena.target_x then
    local sign = math.sign(Arena.target_x - Arena.x)
    Arena.x = Arena.x + sign * Constants.ARENA.RESIZE_SPEED * dt * 30
    if (math.sign(Arena.target_x - Arena.x) ~= sign) then
      Arena.x = Arena.target_x
    end
  end
  if Arena.y ~= Arena.target_y then
    local sign = math.sign(Arena.target_y - Arena.y)
    Arena.y = Arena.y + sign * Constants.ARENA.RESIZE_SPEED * dt * 30
    if (math.sign(Arena.target_y - Arena.y) ~= sign) then
      Arena.y = Arena.target_y
    end
  end

  if Arena.x == Arena.target_x and Arena.y == Arena.target_y and type(Arena.move_callback) == "function" then
    Arena.move_callback()
    Arena.move_callback = nil
  end
end

--- Resizes the arena
--- @param width number target width of the arena
--- @param height number target height of the arena
--- @param instant? boolean resizes the arena instantly (Defaults to `false`)
--- @param resize_callback? fun() called when the resize is done
function Arena.resize(width, height, instant, resize_callback)
  if Utils.getOrDefault(instant, false) then
    Arena.width = width
    Arena.height = height
    Arena.target_width = width
    Arena.target_height = height

    if type(resize_callback) == "function" then
      resize_callback()
    end
  else
    Arena.target_width = width
    Arena.target_height = height
    Arena.resize_callback = resize_callback
  end
end

--- Moves the arena relative from the center-bottom
---@param x number target x position of the arena
---@param y number target y position of the arena
--- @param instant? boolean moves the arena instantly (Defaults to `false`)
--- @param move_callback? fun() called when the move is done
function Arena.move(x, y, instant, move_callback)
  local abs_x = Arena.x + x
  local abs_y = Arena.y + y
  if Utils.getOrDefault(instant, false) then
    Arena.x = abs_x
    Arena.y = abs_y
    Arena.target_x = abs_x
    Arena.target_y = abs_y

    if type(move_callback) == "function" then
      move_callback()
    end
  else
    Arena.target_x = abs_x
    Arena.target_y = abs_y
    Arena.move_callback = move_callback
  end
end

--- Moves the arena absolute
--- @param x number target x position of the arena
--- @param y number target y position of the arena
--- @param instant? boolean moves the arena instantly (Defaults to `false`)
--- @param move_callback? fun() called when the move is done
function Arena.moveAbsolute(x, y, instant, move_callback)
  Arena.move(x - Arena.x, y - Arena.y, instant, move_callback)
end

--- Resets the arena bounds
--- @param reset_callback? fun() called when the reset is done
function Arena.reset(reset_callback)
  local finished_resizing = false
  local finished_moving = false
  local callback = function(resize, move)
    if type(reset_callback) ~= "function" then return end

    finished_resizing = finished_resizing or resize
    finished_moving = finished_moving or move
    if finished_resizing and finished_moving then
      reset_callback()
    end
  end

  Arena.resize(Constants.ARENA.DEFAULT_WIDTH, Constants.ARENA.DEFAULT_HEIGHT, false, function() callback(true) end)

  local move_x, move_y = Constants.ARENA.DEFAULT_X - Arena.x, Constants.ARENA.DEFAULT_Y - Arena.y
  Arena.move(move_x, move_y, false, function() callback(nil, true) end)
end

--- Gets the arena position
--- @return number, number
function Arena.getPosition()
  return Arena.x, Arena.y
end

--- Gets the arena width
--- @return number
function Arena.getWidth()
  return Arena.width
end

--- Gets the arena height
--- @return number
function Arena.getHeight()
  return Arena.height
end

return Arena
