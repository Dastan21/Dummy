--[[
  Generated from ..\engine\drawable\shader.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/drawable/shader.lua
]]

---@meta

--- @class Dummy.Shader : Dummy.Drawable
---
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
--- @param data table<string, any>
function Shader:setData(data) end

--- Sets the shader's parent
--- @param parent Dummy.Drawable|nil
function Shader:setParent(parent) end

--- Adds a child to the shader
--- @param child Dummy.Drawable
function Shader:addChild(child) end

--- Removes a child from the shader
--- @param child Dummy.Drawable
function Shader:removeChild(child) end

--- Draws the shader
function Shader:draw() end

--- Updates the shader, called on every game update
--- @param dt number
function Shader:update(dt) end

--- Creates a shader
--- @param shader string|love.Shader
--- @return Dummy.Shader
function Shader:new(shader) end

