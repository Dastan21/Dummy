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
--- @field protected dialogues Dummy.DialogueText[]
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
  Scene.scenes.MAIN_MENU = require "scene.main_menu_scene"
  Scene.scenes.ENCOUNTER = require "scene.encounter_scene"
  Scene.scenes.GAME_OVER = require "scene.game_over_scene"
  Scene.scenes.ERROR = require "scene.error_scene"

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
  Debugger.resume()
  Fader.reset()
  Shaker.reset()
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

  for _, dialogue_text in ipairs(Scene.dialogues) do
    dialogue_text:update(dt)
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
      if type(drawable.draw) == "function" then
        drawable:draw()
      end

      local color = drawable:getColor()
      love.graphics.setColor(color[1], color[2], color[3], drawable:getAlpha())

      local sprite = drawable:getSprite()
      if sprite ~= nil then
        local x, y = drawable:getPosition()
        local width, height = drawable:getWidth(), drawable:getHeight()
        local angle = math.rad(drawable:getAngle())
        local scale_x, scale_y = drawable:getScale()
        local origin_x, origin_y = drawable:getOrigin()
        love.graphics.draw(sprite,
          x, y,
          angle,
          scale_x, scale_y,
          origin_x * width, origin_y * height
        )

        if Debugger.shouldDisplayHitbox() then
          love.graphics.setColor(0, 0, 1, 0.5)

          if angle % (2 * math.pi) == 0 then
            local hitbox_x = x - width * origin_x * scale_x
            local hitbox_y = y - height * origin_y * scale_y
            love.graphics.rectangle("line", hitbox_x, hitbox_y, width * scale_x, height * scale_y)
          else
            local points = Utils.getPolygonPoints(x, y, width, height, scale_x, scale_y, origin_x, origin_y, angle)
            love.graphics.polygon("line", table.unpack(points))
          end
        end
      end

      love.graphics.setColor(1, 1, 1, 1)
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
--- @param drawable Dummy.Drawable|fun()
function Scene.addDrawable(drawable)
  if drawable == nil then return end

  Scene.removeDrawable(drawable)
  table.insert(Scene.drawables, drawable)

  Scene.sortDrawables()

  return drawable
end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable|fun()
function Scene.removeDrawable(drawable)
  if drawable == nil then return end

  for i, d in ipairs(Scene.drawables) do
    if d == drawable then
      table.remove(Scene.drawables, i)
      break
    end
  end

  Scene.sortDrawables()
end

--- Sorts drawables by layer in the current scene
function Scene.sortDrawables()
  table.stable_sort(Scene.drawables, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Adds a dialogue text in the current scene
--- @param dialogue_text Dummy.DialogueText
function Scene.addDialogue(dialogue_text)
  table.insert(Scene.dialogues, dialogue_text)
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

  Scene.dialogues = {}
  Sprite.clear()
  Assets.clear()
  love.audio.stop()
  Timer.clear()
end

return Scene
