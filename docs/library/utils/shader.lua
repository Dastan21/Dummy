--[[
  Generated from ..\engine\utils\shader.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/utils/shader.lua
]]

---@meta

--- @class Dummy.Shader : Dummy.Class
---
--- @field protected active boolean
--- @field protected priority number
--- @field protected layer_min number
--- @field protected layer_max number
--- @field protected data table<string, any>
Shader = {}

--- Gets the class's name
--- @return string
function Shader.getClassName() end

--- Gets the shader's shader
--- @return love.Shader
function Shader:getShader() end

--- Wether the shader is active
--- @return boolean
function Shader:isActive() end

--- Sets wether the shader is active
--- @param active boolean
function Shader:setActive(active) end

--- Gets the shader's priority
--- @return number
function Shader:getPriority() end

--- Sets the shader's priority
--- @param priority number
function Shader:setPriority(priority) end

--- Gets the shader's layer
--- @return number, number
function Shader:getLayers() end

--- Sets the shader's layer
--- @param min number
--- @param max number
function Shader:setLayers(min, max) end

--- Gets the shader's data
--- @return table<string, any>
function Shader:getData() end

--- Sets the shader's data
--- @overload fun(self: Dummy.Shader, data: table<string, any>)
--- @param key string
--- @param value any
function Shader:setData(key, value) end

--- Updates the shader, called on every game update
--- @param dt number
function Shader:update(dt) end

--- Creates a shader
--- @param shader string|love.Shader
--- @return Dummy.Shader
function Shader:new(shader) end

