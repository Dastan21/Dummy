--- @class Dummy.GameOver
---
--- @field private player_sprite Dummy.Sprite
--- @field private player_shards table<number, table>
--- @field private title_game_text Dummy.Text
--- @field private title_over_text Dummy.Text
--- @field private title_delay number
--- @field private title_timer number
local self = {}

--- Loads the game over scene
--- @param x number
--- @param y number
function self.load(x, y)
  x, y = Utils.getOrDefault(x, 320), Utils.getOrDefault(y, 240)

  -- GAME OVER title
  self.title_game_text = Text.new("GAME_OVER_TITLE_GAME")
  self.title_game_text:setPosition(330, 76)
  self.title_game_text:setFont(Font.FONT.WONDER)
  self.title_game_text:setScale(8)
  self.title_game_text:setAlpha(0)
  self.title_game_text:setVisible(false)
  self.title_over_text = Text.new("GAME_OVER_TITLE_OVER")
  self.title_over_text:setPosition(324, 172)
  self.title_over_text:setFont(Font.FONT.WONDER)
  self.title_over_text:setScale(8)
  self.title_over_text:setAlpha(0)
  self.title_over_text:setVisible(false)
  self.title_delay = 1.7
  self.title_timer = 0

  -- heart
  self.player_sprite = Sprite.new("heart")
  self.player_sprite:setPosition(x, y)
  -- heart shards
  self.player_shards = {}
  self.player_shards_speed = 100
  for i = 1, 6 do
    local shard_sprite = Sprite.new({
      "heart_shard1",
      "heart_shard2",
      "heart_shard3",
      "heart_shard4"
    }, 1 / 7)
    shard_sprite:stop()
    shard_sprite:setPosition(x, y)
    shard_sprite:setVisible(false)
    self.player_shards[i] = {
      sprite = shard_sprite,
      vel_x = (math.random() - 0.5) * 4,
      vel_y = (math.random() - 0.5) * 4
    }
  end

  Timer.after(0.6, function()
    self.player_sprite:setSprite("heart_break")
    Audio.playSound("heart_break")

    Timer.after(1.3, function()
      self.player_sprite:setVisible(false)
      for i, shard in ipairs(self.player_shards) do
        shard.sprite:setVisible(true)
        shard.sprite:play()
      end
      Audio.playSound("heart_explode")

      Timer.after(1.5, function()
        self.title_game_text:setVisible(true)
        self.title_over_text:setVisible(true)
        Audio.playMusic("game_over")
      end)
    end)
  end)
end

function self.update(dt)
  if self.title_game_text:isVisible() and self.title_over_text:isVisible() and self.title_timer < self.title_delay then
    self.title_timer = self.title_timer + dt
    self.title_game_text:setAlpha(self.title_timer / self.title_delay)
    self.title_over_text:setAlpha(self.title_timer / self.title_delay)
  end

  if not self.player_sprite:isVisible() then
    for i, shard in ipairs(self.player_shards) do
      if shard.sprite:isVisible() then
        local x, y = shard.sprite:getPosition()
        x = x + shard.vel_x * self.player_shards_speed * dt
        y = y + shard.vel_y * self.player_shards_speed * dt
        shard.sprite:setPosition(x, y)
        shard.vel_y = shard.vel_y + dt * 2

        if y > 500 then
          shard.sprite:setVisible(false)
        end
      end
    end
  end
end

return self
