--- @class Dummy.Shader : Dummy.Class
---
--- @field protected active boolean
--- @field protected priority number
--- @field protected layer_min number
--- @field protected layer_max number
--- @field protected data table<string, any>
local Shader = Class()

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

--- Wether the shader is active
--- @return boolean
function Shader:isActive()
  return self.active
end

--- Sets wether the shader is active
--- @param active boolean
function Shader:setActive(active)
  self.active = active
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
--- @overload fun(self: Dummy.Shader, data: table<string, any>)
--- @param key string
--- @param value any
function Shader:setData(key, value)
  if type(key) == "table" then
    self.data = key
  else
    self.data[tostring(key)] = value
  end
end

--- Updates the shader, called on every game update
--- @param dt number
function Shader:update(dt)
  if not self:isActive() then return end

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
