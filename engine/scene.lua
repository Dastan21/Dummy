--- @class Dummy.Scene
---
--- @field protected scenes table<string, Dummy.Scene.Scene>
--- @field protected scene Dummy.Scene.Scene|nil
--- @field protected scene_name string
--- @field protected scene_data table
--- @field protected quitting_delay number
--- @field protected quitting_timer number
--- @field protected quitting_sprite Dummy.Sprite
--- @field protected drawables Dummy.Drawable[]
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
  local scene_name = Scene.scene_name
  Scene.scene_name = nil
  Scene.change(scene_name, table.unpack(Scene.scene_data))
end

--- Fully reloads the engine
function Scene.fullReload()
  Scene.change("MAIN_MENU")
end

--- Updates the current scene
--- @param dt number
function Scene.update(dt)
  if Scene.scene == nil then return end

  for _, drawable in ipairs(Scene.drawables) do
    if type(drawable.update) == "function" then
      drawable:update(dt)
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
  for _, drawable in pairs(Scene.drawables) do
    if drawable:isVisible() then
      if drawable:getParent() == nil then
        love.graphics.push()
        drawable:draw()
        love.graphics.pop()
      end
    end
  end
end

--- Gets the current scene name
--- @return string
function Scene.getSceneName()
  return Scene.scene_name
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
function Scene.addDrawable(drawable)
  if drawable == nil then return end

  Scene.removeDrawable(drawable)
  table.insert(Scene.drawables, drawable)

  Scene.sortDrawables()

  return drawable
end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function Scene.removeDrawable(drawable)
  if drawable == nil then return end

  if drawable:hasChildren() then
    for _, child in ipairs(drawable:getChildren()) do
      Scene.removeDrawable(child)
    end
  end

  table.removeByValue(Scene.drawables, drawable)

  Scene.sortDrawables()
end

--- Sorts drawables by layer in the current scene
function Scene.sortDrawables()
  table.stable_sort(Scene.drawables, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Cleans the current scene
function Scene.clean()
  local tmp_drawables = {}
  for _, d in ipairs(Scene.drawables or {}) do
    if d:isPersistent() then
      table.insert(tmp_drawables, d)
    end
  end
  Scene.drawables = tmp_drawables

  Sprite.clear()
  Assets.clear()
  love.audio.stop()
  Timer.clear()
end

return Scene
