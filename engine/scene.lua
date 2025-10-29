--- @class Dummy.Scene
---
--- @field protected scenes table<string, Dummy.Scene.Scene>
--- @field protected scene Dummy.Scene.Scene|nil
--- @field protected scene_name string|nil
--- @field protected previous_scene_name string|nil
--- @field protected scene_data table
--- @field protected quitting_delay number
--- @field protected quitting_timer number
--- @field protected quitting_sprite Dummy.Sprite
--- @field protected layer_canvas [ love.Canvas, love.Canvas ]
--- @field protected drawables Dummy.Drawable[]
--- @field protected shaders Dummy.Shader[]
local Scene = {}

--- @class Dummy.Scene.Scene
---
--- @field load fun(...)
--- @field update fun(dt: number)

local SCENE_QUITTING_DELAY = 0.8

--- Loads the scene manager
function Scene.load()
  Scene.clean()

  Scene.scenes = {}
  Scene.scene = nil
  Scene.scene_data = {}
  Scene.layer_canvas = {
    love.graphics.newCanvas(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT),
    love.graphics.newCanvas(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT)
  }

  Scene.quitting_delay = SCENE_QUITTING_DELAY
  Scene.quitting_timer = 0
end

--- Changes scene
--- @param scene_name string
--- @param ... any data to pass to the scene
function Scene.change(scene_name, ...)
  scene_name = tostring(scene_name):upper()

  assert(Scene.scenes[scene_name] ~= nil, "Cannot change scene: unkwown scene \"" .. scene_name .. "\"")

  if Scene.scene_name == scene_name then return end

  Fader.reset()
  Shaker.reset()
  Scene.clean()
  Scene.scene = Scene.scenes[scene_name]
  Scene.previous_scene_name = Scene.scene_name
  Scene.scene_name = scene_name
  Scene.scene_data = { ... }
  if type(Scene.scene.load) == "function" then
    Scene.scene.load(...)
  end

  Scene.quitting_delay = SCENE_QUITTING_DELAY
  Scene.quitting_timer = 0
  Scene.quitting_sprite = Sprite:new("quitting1")
  Scene.quitting_sprite:setPosition(1, 1)
  Scene.quitting_sprite:setOrigin(0)
  Scene.quitting_sprite:setAlpha(0)
  Scene.quitting_sprite:setVisible(false)
end

--- Resets the quitting timer
function Scene.resetQuitting()
  Scene.quitting_timer = 0
  Scene.quitting_sprite:setSprite("quitting1")
  Scene.quitting_sprite:setAlpha(0)
  Scene.quitting_sprite:setVisible(false)
end

--- Updates the quitting timer
function Scene.updateQuitting(dt)
  if Scene.scene_name == "MAIN_MENU" then
    if Input.isPressed("escape") then
      love.event.quit()
    end
  else
    if Input.isDown("escape") and Scene.quitting_timer < Scene.quitting_delay then
      Scene.quitting_sprite:setVisible(true)
      Scene.quitting_timer = Scene.quitting_timer + dt
      Scene.quitting_sprite:setAlpha(Scene.quitting_timer / Scene.quitting_delay)
    elseif Input.isReleased("escape") then
      Scene.resetQuitting()
    end

    if Scene.quitting_timer >= Scene.quitting_delay then
      Scene.resetQuitting()
      Scene.change("MAIN_MENU")
    elseif Scene.quitting_timer > Scene.quitting_delay * 2 / 3 then
      Scene.quitting_sprite:setSprite("quitting3")
    elseif Scene.quitting_timer > Scene.quitting_delay * 1 / 3 then
      Scene.quitting_sprite:setSprite("quitting2")
    end
  end
end

--- Reloads the current scene
function Scene.reload()
  if Scene.scene_name == nil then return end

  Scene.previous_scene_name = Scene.scene_name
  Scene.scene_name = nil
  Scene.change(Scene.previous_scene_name, table.unpack(Scene.scene_data))
end

--- Fully reloads the engine
function Scene.fullReload()
  Scene.change("MAIN_MENU")
end

--- Updates the current scene
--- @param dt number
function Scene.update(dt)
  if Scene.scene == nil then return end

  local drawables = { table.unpack(Scene.drawables) }
  for _, drawable in ipairs(drawables) do
    if drawable:getParent() == nil then
      if type(drawable.update) == "function" then
        drawable:update(dt)
      end
    end
  end

  local shaders = { table.unpack(Scene.shaders) }
  for _, shader in ipairs(shaders) do
    if type(shader.update) == "function" then
      shader:update(dt)
    end
  end

  if type(Scene.scene.update) == "function" then
    Scene.scene.update(dt)
  end

  Scene.updateQuitting(dt)
end

--- Draws the current scene
function Scene.draw()
  if Scene.scene == nil then return end

  local drawables = { table.unpack(Scene.drawables) }
  local shaders = { table.unpack(Scene.shaders) }
  local prev_canvas = love.graphics.getCanvas()
  for _, layer in ipairs(Scene.getLayers()) do
    love.graphics.setCanvas(Scene.layer_canvas[2])
    love.graphics.origin()
    love.graphics.clear()
    love.graphics.setCanvas({ Scene.layer_canvas[1], stencil = true })
    love.graphics.origin()
    love.graphics.clear()

    for _, drawable in ipairs(drawables) do
      if drawable:isVisible() and drawable:getParent() == nil and drawable:getLayer() == layer then
        love.graphics.push()
        drawable:draw()
        love.graphics.pop()
      end
    end

    -- switch between 2 canvases to draw the shaders one after the other
    local layer_canvas_index = 1
    for _, shader in ipairs(shaders) do
      local layer_min, layer_max = shader:getLayers()
      if shader:isActive() and layer >= layer_min and layer <= layer_max then
        love.graphics.setCanvas(Scene.layer_canvas[(layer_canvas_index % 2) + 1])
        love.graphics.clear()
        love.graphics.setShader(shader:getShader())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(Scene.layer_canvas[layer_canvas_index])
        love.graphics.setBlendMode("alpha", "alphamultiply")
        love.graphics.setShader()

        layer_canvas_index = (layer_canvas_index % 2) + 1
      end
    end

    love.graphics.setCanvas({ prev_canvas, stencil = true })
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(Scene.layer_canvas[layer_canvas_index])
    love.graphics.setBlendMode("alpha", "alphamultiply")
  end
end

--- Gets the current scene name
--- @return string
function Scene.getCurrentSceneName()
  return Scene.scene_name
end

--- Gets the previous scene name
--- @return string
function Scene.getPreviousSceneName()
  return Scene.previous_scene_name
end

--- Gets the current scene
--- @return Dummy.Scene.Scene
function Scene.getCurrentScene()
  return Scene.scene
end

--- Adds a scene
--- @param scene_name string
--- @param scene Dummy.Scene.Scene
function Scene.addScene(scene_name, scene)
  scene_name = tostring(scene_name):upper()

  Scene.scenes[scene_name] = scene
end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable
--- @return Dummy.Drawable|nil
function Scene.addDrawable(drawable)
  if drawable == nil or table.contains(Scene.drawables, drawable) then return end

  table.insert(Scene.drawables, drawable)

  Scene.sortDrawables()

  return drawable
end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function Scene.removeDrawable(drawable)
  if drawable == nil then return end

  table.removeByValue(Scene.drawables, drawable)

  Scene.sortDrawables()
end

--- Sorts current scene drawables
function Scene.sortDrawables()
  table.stable_sort(Scene.drawables, function(a, b) return (a:getLayer() or 0) < (b:getLayer() or 0) end)
end

--- Gets the current scene layers
--- @return number[]
function Scene.getLayers()
  local layers = {}
  for _, drawable in ipairs(Scene.drawables) do
    if not table.contains(layers, drawable:getLayer()) then
      table.insert(layers, drawable:getLayer())
    end
  end
  table.stable_sort(layers, function(a, b) return a < b end)
  return layers
end

--- Adds a shader in the current scene
--- @param shader Dummy.Shader
--- @return Dummy.Shader|nil
function Scene.addShader(shader)
  if shader == nil or table.contains(Scene.shaders, shader) then return end

  table.insert(Scene.shaders, shader)

  Scene.sortShaders()

  return shader
end

--- Removes a shader in the current scene
--- @param shader Dummy.Shader
function Scene.removeShader(shader)
  if shader == nil then return end

  table.removeByValue(Scene.shaders, shader)

  Scene.sortShaders()
end

--- Sorts shaders in the current scene by priority
function Scene.sortShaders()
  table.stable_sort(Scene.shaders, function(a, b)
    return (a:getPriority() or 0) > (b:getPriority() or 0)
  end)
end

--- Cleans the current scene
function Scene.clean()
  local tmp_drawables = {}
  for _, drawable in ipairs(Scene.drawables or {}) do
    if drawable:isPersistent() then
      table.insert(tmp_drawables, drawable)
    end
  end
  Scene.drawables = tmp_drawables
  Scene.shaders = {}

  Scene.sortDrawables()

  Sprite.clear()
  Assets.clear()
  Timer.clear()
end

return Scene
