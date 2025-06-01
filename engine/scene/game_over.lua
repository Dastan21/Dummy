--- @class Dummy.GameOver
---
--- @field private player_sprite Dummy.Sprite
--- @field private player_shards table<number, table>
--- @field private title_game_text Dummy.Text
--- @field private title_over_text Dummy.Text
--- @field private title_delay number
--- @field private title_timer number
--- @field private game_over_music love.Source
local self = {}

--- Loads the game over scene
--- @param x number
--- @param y number
function self.load(x, y)
  x, y = Utils.getOrDefault(x, 320), Utils.getOrDefault(y, 240)

  -- GAME OVER title
  self.title_game_text = Text:new("GAME_OVER_TITLE_GAME")
  self.title_game_text:setPosition(330, 76)
  self.title_game_text:setFont(Font.FONTS.WONDER)
  self.title_game_text:setScale(8)
  self.title_game_text:setAlpha(0)
  self.title_game_text:setVisible(false)
  self.title_over_text = Text:new("GAME_OVER_TITLE_OVER")
  self.title_over_text:setPosition(324, 172)
  self.title_over_text:setFont(Font.FONTS.WONDER)
  self.title_over_text:setScale(8)
  self.title_over_text:setAlpha(0)
  self.title_over_text:setVisible(false)
  self.title_delay = 1.7
  self.title_timer = 0

  -- heart
  self.player_sprite = Sprite:new("heart")
  self.player_sprite:setPosition(x, y)
  -- heart shards
  self.player_shards = {}
  for i = 1, 6 do
    local shard_sprite = Sprite:new({
      "heart_shard1",
      "heart_shard2",
      "heart_shard3",
      "heart_shard4"
    }, 4 / 30)
    shard_sprite:stop()
    shard_sprite:setPosition(x, y)
    shard_sprite:setVisible(false)
    self.player_shards[i] = {
      sprite = shard_sprite,
      vel_x = (math.random() - 0.5) * 7,
      vel_y = (math.random() - 0.5) * 7
    }
  end

  -- black fade
  self.black_sprite = Sprite:new("black")
  self.black_sprite:setOrigin(0, 0)
  self.black_sprite:setVisible(false)
  self.black_sprite:setAlpha(0)
  self.black_sprite:setLayer(Constants.LAYERS.TOP)
  self.fade_time = 1

  -- dialogue
  self.dialogue_text = DialogueText:new("")
  self.dialogue_text:setPosition(120, 320)
  self.dialogue_text:setOrigin(0, 0)
  self.dialogue_text:setFont(Font.FONTS.MAIN_TEXT_MONO)
  self.dialogue_text:setScale(2)
  self.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  self.dialogue_text:setVoice("asgore_voice")
  self.dialogue_text:setCanSkip(false)
  self.dialogue_text:setMaxWidth(400)
  self.dialogue_text:setText(Lang.translate("GAME_OVER_TEXT_1"))
  self.dialogue_text:setVisible(false)
  self.dialogue_index = 1

  self.game_over_music = Audio.playMusic("game_over", false)

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
        self.game_over_music:play()

        Timer.after(2.7, function()
          self.dialogue_text:setVisible(true)
          self.dialogue_text:reset()
        end)
      end)
    end)
  end)
end

function self.update(dt)
  if self.dialogue_text:isVisible() then
    if Input.isPressed(Input.Confirm) and self.dialogue_text:isDone() then
      self.dialogue_index = self.dialogue_index + 1

      if self.dialogue_index == 2 then
        local name = Player and Player.getName() or "Frisk"
        self.dialogue_text:setText(Lang.translate({ "GAME_OVER_TEXT_2", name }))
      elseif self.dialogue_index == 3 then
        self.dialogue_text:setText("")
      elseif self.dialogue_index == 4 then
        self.black_sprite:setVisible(true)
      end
    end
  end

  if self.title_game_text:isVisible() and self.title_over_text:isVisible() and self.title_timer < self.title_delay then
    self.title_timer = self.title_timer + dt
    self.title_game_text:setAlpha(self.title_timer / self.title_delay)
    self.title_over_text:setAlpha(self.title_timer / self.title_delay)
  end

  if not self.player_sprite:isVisible() then
    for i, shard in ipairs(self.player_shards) do
      if shard.sprite:isVisible() then
        local x, y = shard.sprite:getPosition()
        x = x + shard.vel_x * dt * 30
        y = y + shard.vel_y * dt * 30
        shard.sprite:setPosition(x, y)
        shard.vel_y = shard.vel_y + 0.2 * dt * 30

        if y > 500 then
          shard.sprite:setVisible(false)
        end
      end
    end
  end

  if self.black_sprite:isVisible() then
    self.fade_time = math.max(0, self.fade_time - 0.02 * dt * 30)
    self.black_sprite:setAlpha(1 - self.fade_time)
    self.game_over_music:setVolume(self.fade_time)

    if self.fade_time <= 0 then
      Scene.change("MAIN_MENU")
    end
  end
end

return self
