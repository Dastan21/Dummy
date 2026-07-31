--- @class Dummy.Scene.Frozen
---
--- @field scene Dummy.Scene.Scene
--- @field drawables table<string, Dummy.Drawable[]>
--- @field cameras Dummy.Camera[]

--- @class Dummy.Scene.Scene
---
--- @field load? fun(...)
--- @field unload? fun()
--- @field update? fun(dt: number)
--- @field isPersistent? fun(): boolean Wether the world scene is persistent
--- @field onPause? fun() Called when the scene is paused
--- @field onResume? fun() Called when the scene is resumed

--- @class Dummy.Scene
---
--- @field protected available_scenes table<string, Dummy.Scene.Scene>
--- @field protected frozen_scenes table<string, Dummy.Scene.Frozen>
--- @field protected current_scene Dummy.Scene.Scene|nil
--- @field protected current_scene_data table
--- @field protected current_scene_id string|nil
--- @field protected previous_scene_id string|nil
--- @field protected next_scene_id string|nil
--- @field protected quit_was_pressed boolean
--- @field protected quitting_delay number
--- @field protected quitting_time number
--- @field protected quitting_sprite Dummy.Sprite
--- @field protected layers table<string, number[]>
--- @field protected drawables table<string, Dummy.Drawable[]>
--- @field protected drawables_to_add Dummy.Drawable[]
--- @field protected drawables_to_remove Dummy.Drawable[]
--- @field protected next_drawables table<string, table<number, Dummy.Drawable[]>>
--- @field protected shaders Dummy.Shader[]
--- @field protected cameras Dummy.Camera[]
--- @field protected timers table<string, Dummy.Timer>
local Scene = {}

--- Delay before quitting the game
Scene.SCENE_QUITTING_DELAY = 0.8

--- Loads the scene manager
function Scene.load()
  Scene.layers = {}
  Scene.drawables = {}
  Scene.next_drawables = {}

  Scene.available_scenes = {}
  Scene.frozen_scenes = {}
  Scene.current_scene = nil
  Scene.current_scene_data = {}
  Scene.reloading = false
  Scene.timers = {}

  Scene.quit_was_pressed = false
  Scene.quitting_delay = Scene.SCENE_QUITTING_DELAY
  Scene.quitting_time = 0

  Lang.onSwitchLanguage(function()
    Scene.quitting_sprite:setSprite({ "quitting1", "quitting2", "quitting3" }, 0, false, false, true)
  end)

  Scene.clean()
end

--- Changes scene
--- @param scene_id string
--- @param ... any data to pass to the scene
function Scene.change(scene_id, ...)
  scene_id = tostring(scene_id):upper()
  assert(Scene.available_scenes[scene_id] ~= nil, "Cannot change scene: unkwown scene \"" .. scene_id .. "\"")
  if not Scene.reloading and Scene.current_scene_id == scene_id then return end

  Scene.next_scene_id = scene_id
  Scene.next_scene_data = { ... }
end

--- Resets the quitting timer
function Scene.resetQuitting()
  Scene.quit_was_pressed = false
  Scene.quitting_time = 0
  Scene.quitting_sprite:setFrame(1)
  Scene.quitting_sprite:setAlpha(0)
  Scene.quitting_sprite:setVisible(false)
end

--- Updates the quitting timer
function Scene.updateQuitting(dt)
  if Scene.getCurrentSceneId() == "MAIN_MENU" and love.system.getOS() == "Web" then return end

  if Scene.quit_was_pressed and Input.isDown(Input.Escape) and Scene.quitting_time < Scene.quitting_delay then
    Scene.quitting_sprite:setVisible(true)
    Scene.quitting_time = Scene.quitting_time + dt
    Scene.quitting_sprite:setAlpha(Scene.quitting_time / Scene.quitting_delay)
  elseif Input.isReleased(Input.Escape) then
    Scene.resetQuitting()
  end

  if Scene.quitting_time >= Scene.quitting_delay then
    Scene.resetQuitting()

    if Scene.current_scene_id == "MAIN_MENU" then
      love.event.quit()
    else
      Scene.change("MAIN_MENU")
    end
  elseif Scene.quitting_time > Scene.quitting_delay * 2 / 3 then
    Scene.quitting_sprite:setFrame(3)
  elseif Scene.quitting_time > Scene.quitting_delay * 1 / 3 then
    Scene.quitting_sprite:setFrame(2)
  end

  if Input.isPressed(Input.Escape) then
    Scene.quit_was_pressed = true
  end
end

--- Reloads the current scene
function Scene.reload()
  if Scene.current_scene_id == nil then return end

  Scene.previous_scene_id = Scene.current_scene_id
  Scene.reloading = true
  Scene.change(Scene.previous_scene_id, table.unpack(Scene.current_scene_data))
end

--- Fully reloads the engine
function Scene.fullReload()
  Scene.reloading = true
  Scene.change("MAIN_MENU")
end

--- Releases a frozen scene
--- @param scene_id string
function Scene.release(scene_id)
  Scene.frozen_scenes[scene_id] = nil
end

--- Applies the next scene change
function Scene.applyChange()
  Fader.reset()
  Shaker.reset()

  --- @type Dummy.Scene.Frozen|nil
  local frozen_scene = nil
  if not Scene.reloading then
    local current_scene_is_persistent = Scene.current_scene ~= nil and
        type(Scene.current_scene.isPersistent) == "function" and
        Scene.current_scene:isPersistent()
    if not current_scene_is_persistent then
      local timer = Scene.timers[Scene.current_scene_id or ""]
      if timer ~= nil then
        timer:clear()
      end
      if Scene.current_scene ~= nil and type(Scene.current_scene.unload) == "function" then
        Scene.current_scene.unload()
      end
    end

    frozen_scene = Scene.frozen_scenes[Scene.next_scene_id]
    if frozen_scene ~= nil then
      for tag in pairs(Scene.drawables or {}) do
        for _, drawable in ipairs(Scene.keepPersistents(Scene.drawables[tag], true, false)) do
          table.insert(frozen_scene.drawables[tag], drawable)
        end
      end
      local cameras = Scene.keepPersistents(Scene.cameras, true, false)
      for _, camera in ipairs(cameras) do
        table.insert(frozen_scene.cameras, camera)
      end
    end

    if current_scene_is_persistent then
      local frozen_drawables = {}
      for tag in pairs(Scene.drawables or {}) do
        frozen_drawables[tag] = Scene.keepPersistents(Scene.drawables[tag], false, false)
        Scene.drawables[tag] = Scene.keepPersistents(Scene.drawables[tag], true, false)
      end
      Scene.frozen_scenes[tostring(Scene.current_scene_id)] = {
        scene = Scene.current_scene,
        drawables = frozen_drawables,
        cameras = Scene.keepPersistents(Scene.cameras, false, false)
      }
      if type(Scene.current_scene.onPause) == "function" then
        Scene.current_scene.onPause()
      end
    end
  end

  Scene.clean()

  Scene.current_scene = Scene.available_scenes[Scene.next_scene_id]
  Scene.previous_scene_id = Scene.current_scene_id
  Scene.current_scene_id = Scene.next_scene_id
  Scene.current_scene_data = table.copy(Scene.next_scene_data)

  if frozen_scene ~= nil then
    Scene.drawables = table.copy(frozen_scene.drawables)
    Scene.sortDrawables()
    Scene.prepareNextDrawables()
    Scene.cameras = table.copy(frozen_scene.cameras)
    Scene.sortCameras()
    if type(Scene.current_scene.onResume) == "function" then
      Scene.current_scene.onResume()
    end
  end
  if (not Scene.frozen_scenes[Scene.next_scene_id] or Scene.reloading) and type(Scene.current_scene.load) == "function" then
    if Scene.timers[Scene.next_scene_id] == nil then
      Scene.timers[Scene.next_scene_id] = Timer:new()
    else
      Scene.timers[Scene.next_scene_id]:clear()
    end
    Scene.current_scene.load(table.unpack(Scene.next_scene_data))
  end

  Scene.quit_was_pressed = false
  Scene.quitting_delay = Scene.SCENE_QUITTING_DELAY
  Scene.quitting_time = 0
  Scene.quitting_sprite = Sprite:new({ "quitting1", "quitting2", "quitting3" }, 0, false, false, true)
  Scene.quitting_sprite:setPosition(1, 1)
  Scene.quitting_sprite:setOrigin(0)
  Scene.quitting_sprite:setLayer(Constants.LAYERS.TOP)
  Scene.quitting_sprite:setAlpha(0)
  Scene.quitting_sprite:setVisible(false)
  Scene.quitting_sprite:setTag("DEBUG")

  Scene.reloading = false
end

--- Updates the current scene, called on every game update
--- @param dt number
function Scene.update(dt)
  if Scene.reloading or Scene.current_scene_id ~= Scene.next_scene_id then
    Scene.applyChange()
  end

  if Scene.current_scene == nil then return end

  if #Scene.drawables_to_remove > 0 or #Scene.drawables_to_add > 0 then
    for _, drawable in ipairs(Scene.drawables_to_remove) do
      table.removebyvalue(Scene.drawables[drawable:getTag()], drawable)
    end
    Scene.drawables_to_remove = {}

    for _, drawable in ipairs(Scene.drawables_to_add) do
      local tag = drawable:getTag()
      if Scene.drawables[tag] == nil then
        Scene.drawables[tag] = {}
      end
      table.insert(Scene.drawables[tag], drawable)
    end
    Scene.drawables_to_add = {}

    Scene.sortDrawables()
    Scene.prepareNextDrawables()
  end

  for tag in pairs(Scene.drawables) do
    for _, drawable in ipairs(Scene.drawables[tag]) do
      if drawable:getParent() == nil then
        if type(drawable.update) == "function" then
          drawable:update(dt)
        end
      end
    end
  end

  for _, shader in ipairs(Scene.shaders) do
    if type(shader.update) == "function" then
      shader:update(dt)
    end
  end

  for _, camera in ipairs(Scene.cameras) do
    if type(camera.update) == "function" then
      camera:update(dt)
    end
  end

  if type(Scene.current_scene.update) == "function" then
    Scene.current_scene.update(dt)
  end

  Scene.updateQuitting(dt)
end

--- Draws the current scene
function Scene.draw()
  if Scene.current_scene == nil then return end

  for _, camera in ipairs(Scene.cameras) do
    Scene.drawCamera(camera)
  end
end

--- Draws the given camera
--- @param camera Dummy.Camera
function Scene.drawCamera(camera)
  if not camera:isActive() then return end

  local tag = camera:getTag()
  local layers = Scene.layers[tag] or {}
  if #layers <= 0 then return end

  local canvases = camera:getCanvas()
  local prev_canvas = love.graphics.getCanvas()

  local current_drawables = table.copy(Scene.next_drawables[tag])
  for _, layer in ipairs(layers) do
    love.graphics.setCanvas(canvases[2])
    love.graphics.origin()
    love.graphics.clear()
    love.graphics.setCanvas({ canvases[1], stencil = true })
    love.graphics.origin()
    love.graphics.clear()

    -- draw game objects
    love.graphics.push()
    camera:apply()
    for _, drawable in ipairs(current_drawables[layer]) do
      love.graphics.push()
      drawable:draw(camera)
      love.graphics.pop()
    end
    love.graphics.pop()

    -- switch between 2 canvases to draw the shaders one after the other
    local layer_canvas_index = 1
    for _, shader in ipairs(Scene.shaders) do
      local layer_min, layer_max = shader:getLayers()
      if shader:isActive() and layer >= layer_min and layer <= layer_max then
        love.graphics.setCanvas(canvases[(layer_canvas_index % 2) + 1])
        love.graphics.clear()
        love.graphics.setShader(shader:getShader())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setBlendMode("alpha", "premultiplied")
        love.graphics.draw(canvases[layer_canvas_index])
        love.graphics.setBlendMode("alpha", "alphamultiply")
        love.graphics.setShader()

        layer_canvas_index = (layer_canvas_index % 2) + 1
      end
    end

    love.graphics.setCanvas({ prev_canvas, stencil = true })
    love.graphics.setColor(1, 1, 1, 1)
    camera:applyCanvas()
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(canvases[layer_canvas_index])
    love.graphics.setBlendMode("alpha", "alphamultiply")
    love.graphics.origin()
    camera:drawDebug()
  end
end

--- Gets the current scene name
--- @return string
function Scene.getCurrentSceneId()
  return Scene.current_scene_id
end

--- Gets the previous scene name
--- @return string
function Scene.getPreviousSceneId()
  return Scene.previous_scene_id
end

--- Gets the current scene
--- @return Dummy.Scene.Scene
function Scene.getCurrentScene()
  return Scene.current_scene
end

--- Adds a scene
--- @param scene_id string
--- @param scene Dummy.Scene.Scene
function Scene.addScene(scene_id, scene)
  scene_id = tostring(scene_id):upper()

  Scene.available_scenes[scene_id] = scene
end

--- Gets the drawables
--- @return table<string, Dummy.Drawable[]>
function Scene.getDrawables()
  return Scene.drawables
end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable
--- @return Dummy.Drawable|nil
function Scene.addDrawable(drawable)
  if drawable == nil then return end

  table.removebyvalue(Scene.drawables_to_add, drawable)
  table.insert(Scene.drawables_to_add, drawable)

  return drawable
end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function Scene.removeDrawable(drawable)
  if drawable == nil or table.contains(Scene.drawables_to_remove, drawable) then return end

  table.removebyvalue(Scene.drawables_to_add, drawable)

  if not table.contains(Scene.drawables[drawable:getTag()] or {}, drawable) then return end

  table.insert(Scene.drawables_to_remove, drawable)
end

--- Sorts current scene drawables
function Scene.sortDrawables()
  for tag in pairs(Scene.drawables) do
    table.stable_sort(Scene.drawables[tag], function(a, b) return (a:getLayer() or 0) < (b:getLayer() or 0) end)
  end
end

--- Prepares the next scene drawables
function Scene.prepareNextDrawables()
  for tag in pairs(Scene.drawables or {}) do
    Scene.layers[tag] = Scene.getLayers(tag)
  end

  Scene.next_drawables = {}
  for tag in pairs(Scene.drawables or {}) do
    Scene.next_drawables[tag] = {}

    for _, layer in ipairs(Scene.layers[tag]) do
      Scene.next_drawables[tag][layer] = {}

      for _, drawable in ipairs(Scene.drawables[tag]) do
        if tostring(drawable:getLayer()) == tostring(layer) and drawable:getParent() == nil then
          table.insert(Scene.next_drawables[tag][layer], drawable)
        end
      end
    end
  end
end

--- Gets the current scene layers for a tag
--- @param tag string
--- @return number[]
function Scene.getLayers(tag)
  --- @type table<number, boolean>
  local layers_keys = {}
  --- @type number[]
  local layers = {}
  for _, drawable in ipairs(Scene.drawables[tag]) do
    if not layers_keys[drawable:getLayer()] then
      layers_keys[drawable:getLayer()] = true
    end
  end
  for layer in pairs(layers_keys) do
    table.insert(layers, layer)
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

  table.removebyvalue(Scene.shaders, shader)

  Scene.sortShaders()
end

--- Sorts shaders in the current scene by priority
function Scene.sortShaders()
  table.stable_sort(Scene.shaders, function(a, b)
    return (a:getPriority() or 0) > (b:getPriority() or 0)
  end)
end

--- Gets the current scene cameras
--- @return Dummy.Camera[]
function Scene.getCameras()
  return Scene.cameras
end

--- Gets a camera by tag
--- @param tag string
--- @return Dummy.Camera|nil
function Scene.getCameraByTag(tag)
  for _, camera in ipairs(Scene.cameras) do
    if camera:getTag() == tag then
      return camera
    end
  end
end

--- Adds a camera to the current scene
--- @param camera Dummy.Camera
--- @return Dummy.Camera|nil
function Scene.addCamera(camera)
  if camera == nil or table.contains(Scene.cameras, camera) then return end

  table.insert(Scene.cameras, camera)

  Scene.sortCameras()

  return camera
end

--- Removes a camera from the current scene
--- @param camera Dummy.Camera
function Scene.removeCamera(camera)
  if camera == nil then return end

  table.removebyvalue(Scene.cameras, camera)

  Scene.sortCameras()
end

--- Sorts cameras in the current scene by layer
function Scene.sortCameras()
  table.stable_sort(Scene.cameras, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Gets the timer of the current scene
--- @return table
function Scene.getTimer()
  return Scene.timers[Scene.current_scene_id]
end

--- Keeps only drawables that are persistent
--- @generic T : Dummy.Drawable|Dummy.Camera
--- @param drawables T[]
--- @param persistent? boolean
--- @param delete_others? boolean
--- @return T[]
function Scene.keepPersistents(drawables, persistent, delete_others)
  persistent = Utils.getOrDefault(persistent, true)
  delete_others = Utils.getOrDefault(delete_others, true)

  local t = {}
  for _, drawable in ipairs(drawables or {}) do
    if drawable:isPersistent() == persistent then
      table.insert(t, drawable)
    elseif delete_others and drawable:is(Drawable) then
      drawable:remove()
    end
  end
  return t
end

--- Cleans the current scene
function Scene.clean()
  for tag in pairs(Scene.drawables or {}) do
    Scene.drawables[tag] = Scene.keepPersistents(Scene.drawables[tag])
  end
  Scene.drawables_to_add = Scene.keepPersistents(Scene.drawables_to_add)
  Scene.drawables_to_remove = Scene.keepPersistents(Scene.drawables_to_remove)
  Scene.sortDrawables()

  Scene.shaders = {}

  Scene.cameras = Scene.keepPersistents(Scene.cameras)

  Sprite.clear()
  Assets.clear()
end

return Scene
