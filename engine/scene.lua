local self = {}

function self.load(scene_name)
  local scene = require("scene." .. scene_name)
  assert(scene ~= nil, "Scene \"" .. "\" failed to load")

  if self.scene ~= nil then
    self.scene.unload()
  end
  self.clean()
  self.scene = scene
  self.scene.load()
end

function self.update(dt)
  if self.scene == nil then return end

  self.scene.update(dt)
end

function self.draw()
  if self.scene == nil then return end

  for drawable, data in pairs(self.drawables) do
    if data.active then
      love.graphics.setColor(1, 1, 1, data.alpha)

      love.graphics.draw(drawable,
        data.x,
        data.y,
        data.rotation,
        data.scale[1],
        data.scale[2],
        data.origin[1] * drawable:getWidth(),
        data.origin[2] * drawable:getHeight()
      )

      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end

function self.clean()
  self.drawables = self.drawables or {}
  for drawable in pairs(self.drawables) do
    self.drawables[drawable].sprite:release()
    self.drawables[drawable] = nil
  end

  self.audios = self.audios or {}
  for source in pairs(self.audios) do
    self.audios[source]:release()
    self.audios[source] = nil
  end
end

return self
