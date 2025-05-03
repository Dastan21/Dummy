local self = {}

function self.load()
  self.quitting_delay = 1
  self.quitting_timer = 0
  self.quitting_sprite = Sprite.createSprite("quitting1")
  self.quitting_sprite.x = 1
  self.quitting_sprite.y = 1
  self.quitting_sprite.alpha = 0
  self.quitting_sprite.origin = { 0, 0 }

  self.player = {}
  self.player.sprite = Sprite.createSprite("heart")
  self.player.sprite.x = 320
  self.player.sprite.y = 240
end

function self.unload()
end

local function checkQuitting(dt)
  if Input.isKeyDown("escape") and self.quitting_timer < self.quitting_delay then
    self.quitting_timer = self.quitting_timer + dt
    self.quitting_sprite.alpha = self.quitting_timer / self.quitting_delay
  elseif Input.isKeyReleased("escape") then
    self.quitting_timer = 0
    self.quitting_sprite.alpha = 0
  end

  if self.quitting_timer >= self.quitting_delay then
    Scene.load("main_menu")
  end
end

function self.update(dt)
  if Input.Up.isDown() then
    self.player.sprite.y = self.player.sprite.y - 1
  end
  if Input.Down.isDown() then
    self.player.sprite.y = self.player.sprite.y + 1
  end
  if Input.Left.isDown() then
    self.player.sprite.x = self.player.sprite.x - 1
  end
  if Input.Right.isDown() then
    self.player.sprite.x = self.player.sprite.x + 1
  end

  checkQuitting(dt)
end

return self
