--- @class Dummy.Scene.GameOver : Dummy.Scene.Scene
---
--- @field private title_game_text Dummy.Text
--- @field private title_over_text Dummy.Text
--- @field private title_delay number
--- @field private title_timer number
--- @field private player_sprite Dummy.Sprite
--- @field private player_shards table<number, table>
--- @field private black_sprite Dummy.Sprite
--- @field private fade_time number
--- @field private dialogue_text Dummy.DialogueText
--- @field private dialogue_index number
--- @field private game_over_music love.Source
local game_over = {}

--- Loads the game over scene
--- @param x number
--- @param y number
function game_over.load(x, y)
  x, y = Utils.getOrDefault(x, 320), Utils.getOrDefault(y, 240)

  -- GAME OVER title
  game_over.title_game_text = Text:new("GAME_OVER_TITLE_GAME")
  game_over.title_game_text:setPosition(330, 76)
  game_over.title_game_text:setFont(Font.FONTS.WONDER)
  game_over.title_game_text:setScale(8)
  game_over.title_game_text:setAlpha(0)
  game_over.title_game_text:setVisible(false)
  game_over.title_over_text = Text:new("GAME_OVER_TITLE_OVER")
  game_over.title_over_text:setPosition(324, 172)
  game_over.title_over_text:setFont(Font.FONTS.WONDER)
  game_over.title_over_text:setScale(8)
  game_over.title_over_text:setAlpha(0)
  game_over.title_over_text:setVisible(false)
  game_over.title_delay = 1.7
  game_over.title_timer = 0

  -- heart
  game_over.player_sprite = Sprite:new("heart")
  game_over.player_sprite:setPosition(x, y)
  -- heart shards
  game_over.player_shards = {}
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
    game_over.player_shards[i] = {
      sprite = shard_sprite,
      vel_x = (math.random() - 0.5) * 7,
      vel_y = (math.random() - 0.5) * 7
    }
  end

  -- black fade
  game_over.black_sprite = Sprite:new("black")
  game_over.black_sprite:setOrigin(0, 0)
  game_over.black_sprite:setVisible(false)
  game_over.black_sprite:setAlpha(0)
  game_over.black_sprite:setLayer(Constants.LAYERS.TOP)
  game_over.fade_time = 1

  -- dialogue
  game_over.dialogue_text = DialogueText:new("")
  game_over.dialogue_text:setPosition(120, 320)
  game_over.dialogue_text:setOrigin(0, 0)
  game_over.dialogue_text:setFont(Font.FONTS.MAIN_TEXT_MONO)
  game_over.dialogue_text:setScale(2)
  game_over.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  game_over.dialogue_text:setVoice("asgore_voice")
  game_over.dialogue_text:setCanSkip(false)
  game_over.dialogue_text:setMaxWidth(400)
  game_over.dialogue_text:setText(Lang.translate("GAME_OVER_TEXT_1"))
  game_over.dialogue_text:setVisible(false)
  game_over.dialogue_index = 1

  game_over.game_over_music = Audio.playMusic("game_over", false)

  Timer.after(0.6, function()
    game_over.player_sprite:setSprite("heart_break")
    Audio.playSound("heart_break")

    Timer.after(1.3, function()
      game_over.player_sprite:setVisible(false)
      for i, shard in ipairs(game_over.player_shards) do
        shard.sprite:setVisible(true)
        shard.sprite:play()
      end
      Audio.playSound("heart_explode")

      Timer.after(1.5, function()
        game_over.title_game_text:setVisible(true)
        game_over.title_over_text:setVisible(true)
        game_over.game_over_music:play()

        Timer.after(2.7, function()
          game_over.dialogue_text:setVisible(true)
          game_over.dialogue_text:reset()
        end)
      end)
    end)
  end)
end

function game_over.update(dt)
  if game_over.dialogue_text:isVisible() then
    if Input.isPressed(Input.Confirm) and game_over.dialogue_text:isDone() then
      game_over.dialogue_index = game_over.dialogue_index + 1

      if game_over.dialogue_index == 2 then
        local name = Utils.getOrDefault(Player.getName(), "Frisk")
        game_over.dialogue_text:setText(Lang.translate({ "GAME_OVER_TEXT_2", name }))
      elseif game_over.dialogue_index == 3 then
        game_over.dialogue_text:setText("")
      elseif game_over.dialogue_index == 4 then
        game_over.black_sprite:setVisible(true)
      end
    end
  end

  if game_over.title_game_text:isVisible() and game_over.title_over_text:isVisible() and game_over.title_timer < game_over.title_delay then
    game_over.title_timer = game_over.title_timer + dt
    local alpha = math.min(1, game_over.title_timer / game_over.title_delay)
    game_over.title_game_text:setAlpha(alpha)
    game_over.title_over_text:setAlpha(alpha)
  end

  if not game_over.player_sprite:isVisible() then
    for i, shard in ipairs(game_over.player_shards) do
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

  if game_over.black_sprite:isVisible() then
    game_over.fade_time = math.max(0, game_over.fade_time - 0.02 * dt * 30)
    game_over.black_sprite:setAlpha(1 - game_over.fade_time)
    game_over.game_over_music:setVolume(game_over.fade_time)

    if game_over.fade_time <= 0 then
      Scene.change("MAIN_MENU")
    end
  end
end

return game_over
