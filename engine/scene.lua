--- @class Dummy.Scene
---
--- @field private drawables table<number, Dummy.Drawable>
local scene = {}

local scenes = {}

local SCENE_QUITTING_DELAY = 0.8

function scene.load()
  scene.clean()

  scenes.MAIN_MENU = require "engine.scene.main_menu"
  scenes.ENCOUNTER = require "engine.scene.encounter"
  scenes.GAME_OVER = require "engine.scene.game_over"
  scenes.ERROR = require "engine.scene.error"

  scene.quitting_delay = SCENE_QUITTING_DELAY
  scene.quitting_timer = 0
end

--- Changes scene
--- @param scene_name string
--- @param ... any data to pass to the scene
function scene.change(scene_name, ...)
  assert(type(scene_name) == "string", "Cannot change scene: invalid type \"" .. tostring(scene_name) .. "\"")
  assert(scenes[scene_name:upper()] ~= nil, "Cannot change scene: unkwown scene \"" .. scene_name .. "\"")

  if scene.scene_name == scene_name then return end

  scene.clean()
  scene.scene = scenes[scene_name]
  scene.scene_name = scene_name
  scene.scene.load(...)

  scene.quitting_delay = SCENE_QUITTING_DELAY
  scene.quitting_timer = 0
  scene.quitting_sprite = Sprite:new("quitting1")
  scene.quitting_sprite:setPosition(1, 1)
  scene.quitting_sprite:setOrigin(0)
  scene.quitting_sprite:setAlpha(0)
end

function scene.resetQuitting()
  scene.quitting_timer = 0
  scene.quitting_sprite:setAlpha(0)
  scene.quitting_sprite:setSprite("quitting1")
end

function scene.updateQuitting(dt)
  if scene.scene_name == "MAIN_MENU" then
    if Input.isPressed("escape") then
      love.event.quit()
    end
  else
    if Input.isDown("escape") and scene.quitting_timer < scene.quitting_delay then
      scene.quitting_timer = scene.quitting_timer + dt
      scene.quitting_sprite:setAlpha(scene.quitting_timer / scene.quitting_delay)
    elseif Input.isReleased("escape") then
      scene.resetQuitting()
    end

    if scene.quitting_timer >= scene.quitting_delay then
      scene.resetQuitting()
      Scene.change("MAIN_MENU")
    elseif scene.quitting_timer > scene.quitting_delay * 2 / 3 then
      scene.quitting_sprite:setSprite("quitting3")
    elseif scene.quitting_timer > scene.quitting_delay * 1 / 3 then
      scene.quitting_sprite:setSprite("quitting2")
    end
  end
end

function scene.update(dt)
  if scene.scene == nil then return end

  for _, dialogue_text in ipairs(scene.dialogues) do
    dialogue_text:update(dt)
  end

  scene.scene.update(dt)
  scene.updateQuitting(dt)
end

function scene.draw()
  if scene.scene == nil then return end

  for _, drawable in pairs(scene.drawables) do
    if drawable:isVisible() then
      local draw = drawable:getDraw()
      if type(draw) == "function" then
        draw()
      else
        love.graphics.setColor(1, 1, 1, drawable:getAlpha())

        local sprite = drawable:getSprite()
        if sprite ~= nil then
          local x, y = drawable:getPosition()
          local sx, sy = drawable:getScale()
          local ox, oy = drawable:getOrigin()
          love.graphics.draw(sprite,
            x, y,
            drawable:getRotation(),
            sx, sy,
            ox * sprite:getWidth(), oy * sprite:getHeight()
          )
        end
      end

      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

--- Adds a drawable in the current scene
--- @param drawable Dummy.Drawable|fun()
--- @param layer? number
function scene.addDrawable(drawable, layer)
  layer = Utils.getOrDefault(layer, 0)

  table.insert(scene.drawables, drawable)

  scene.sortDrawables()

  return drawable
end

--- Removes a drawable in the current scene
--- @param drawable Dummy.Drawable
function scene.removeDrawable(drawable)
  local index = 0
  for i, d in ipairs(scene.drawables) do
    if d == drawable then
      index = i
      break
    end
  end

  if index > 0 then
    table.remove(scene.drawables, index)
  end

  scene.sortDrawables()
end

--- Sorts drawables by layer in the current scene
function scene.sortDrawables()
  table.stable_sort(scene.drawables, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

--- Adds a dialogue text in the current scene
--- @param dialogue_text Dummy.DialogueText
function scene.addDialogue(dialogue_text)
  table.insert(scene.dialogues, dialogue_text)
end

function scene.clean()
  scene.drawables = {}
  scene.dialogues = {}
  love.audio.stop()
  Timer.clear()
end

return scene
