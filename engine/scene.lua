---@class Dummy.Scene
---
---@field private drawables table<number, Dummy.Drawable>
---@field private audios table<string, love.Source>
local scene = {}

local self = {}

function self.load()
  self.SCENES = {
    MAIN_MENU = require "engine.scene.main_menu",
    ENCOUNTER = require "engine.scene.encounter",
    GAME_OVER = require "engine.scene.game_over",
  }

  self.clean()

  scene.quitting_delay = 1
  scene.quitting_timer = 0
end

--- Changes scene
---@param scene_name string
---@param ... table data to pass to the scene
function self.change(scene_name, ...)
  assert(self.SCENES[scene_name:upper()] ~= nil, "Cannot change scene: unkwown scene \"" .. scene_name .. "\"")

  self.clean()
  scene.scene = self.SCENES[scene_name]
  scene.scene_name = scene_name
  scene.scene.load(...)

  scene.quitting_delay = 1
  scene.quitting_timer = 0
  scene.quitting_sprite = Sprite.new("quitting1")
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

function self.update(dt)
  if scene.scene == nil then return end

  scene.scene.update(dt)
  scene.updateQuitting(dt)
end

function self.draw()
  if scene.scene == nil then return end

  for _, drawable in ipairs(scene.drawables) do
    if drawable:isActive() then
      if type(drawable.draw) == "function" then
        drawable.draw()
      else
        love.graphics.setColor(1, 1, 1, drawable:getAlpha())

        local sprite = drawable:getSprite()
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

      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

--- Adds a drawable in the current scene
---@param drawable Dummy.Drawable|fun()
---@param layer? number
function self.addDrawable(drawable, layer)
  if type(drawable) == "function" then
    local d = Drawable.new()
    d.draw = drawable
    d:setLayer(Utils.getOrDefault(layer, 0))
    drawable = d
  end

  table.insert(scene.drawables, drawable)

  self.sortDrawables()
end

--- Removes a drawable in the current scene
---@param drawable Dummy.Drawable
function self.removeDrawable(drawable)
  local index = 0
  for i, d in ipairs(drawable) do
    if d == drawable then
      index = i
      break
    end
  end

  if index > 0 then
    table.remove(scene.drawables, index)
  end

  self.sortDrawables()
end

--- Sorts drawable list in ascending order
function self.sortDrawables()
  table.sort(scene.drawables, function(a, b)
    return (a:getLayer() or 0) < (b:getLayer() or 0)
  end)
end

function self.cleanDrawables()
  scene.drawables = {}
end

--- Adds an audio in the current scene
---@param source love.Source
function self.addAudio(source)
  scene.audios[source] = true
end

function self.cleanAudios()
  scene.audios = {}
end

function self.clean()
  self.cleanDrawables()
  Audio.clear()
end

return self
