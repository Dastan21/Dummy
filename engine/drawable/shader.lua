--- @class Dummy.Shader : Dummy.Drawable
---
--- @field protected priority number
--- @field protected layer_min number
--- @field protected layer_max number
--- @field protected data table<string, any>
local Shader = Class:extend(Drawable)

--- Gets the class's name
--- @return string
function Shader.getClassName()
  return "Dummy.Shader"
end

--- Gets the shader's shader
--- @return love.Shader
function Shader:getShader()
  return self.shader
end

--- Gets the shader's priority
--- @return number
function Shader:getPriority()
  return self.priority
end

--- Sets the shader's priority
--- @param priority number
function Shader:setPriority(priority)
  self.priority = priority

  Scene.addShader(self)
end

--- Gets the shader's layer
--- @return number, number
function Shader:getLayers()
  return self.layer_min, self.layer_max
end

--- Sets the shader's layer
--- @param min number
--- @param max number
function Shader:setLayers(min, max)
  self.layer_min = min
  self.layer_max = math.max(min, max)

  Scene.addShader(self)
end

--- Gets the shader's data
--- @return table<string, any>
function Shader:getData()
  return self.data
end

--- Sets the shader's data
--- @param data table<string, any>
function Shader:setData(data)
  self.data = data
end

--- Sets the shader's parent
--- @param parent Dummy.Drawable|nil
function Shader:setParent(parent)
  Drawable.setParent(self, parent)

  if parent ~= nil then
    Scene.removeShader(self)
  else
    Scene.addShader(self)
  end
end

--- Adds a child to the shader
--- @param child Dummy.Drawable
function Shader:addChild(child)
  Drawable.addChild(self, child)

  Scene.removeShader(self)
end

--- Removes a child from the shader
--- @param child Dummy.Drawable
function Shader:removeChild(child)
  Drawable.removeChild(self, child)

  if not self:hasChildren() then
    Scene.addShader(self)
  end
end

--- Draws the shader
function Shader:draw()
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  love.graphics.setShader(self.shader)
  self:drawChildren()
  love.graphics.setShader()
end

--- Updates the shader, called on every game update
--- @param dt number
function Shader:update(dt)
  self:updateChildren(dt)

  for key, value in pairs(self.data) do
    if self.shader:hasUniform(key) then
      self.shader:send(key, value)
    end
  end
end

--- Creates a shader
--- @param shader string|love.Shader
--- @return Dummy.Shader
function Shader:new(shader)
  self = Class:new(Shader)

  if type(shader) == "string" then
    self.shader = love.graphics.newShader("assets/shaders/" .. shader .. ".glsl")
  else
    self.shader = shader
  end

  self.priority = 0
  self.layer_min = Constants.LAYERS.BOTTOM
  self.layer_max = Constants.LAYERS.TOP
  self.data = {}

  Scene.addShader(self)

  return self
end

return Shader
