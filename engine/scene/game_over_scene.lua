--- @class Dummy.Scene.GameOver : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected title_game_text Dummy.Text
--- @field protected title_over_text Dummy.Text
--- @field protected show_title boolean
--- @field protected hide_title boolean
--- @field protected alpha number
--- @field protected player_sprite Dummy.Sprite
--- @field protected player_shards table[]
--- @field protected dialogue_text Dummy.DialogueText
--- @field protected dialogue_index number
--- @field protected game_over_music love.Source
local GameOverScene = {}

--- Loads the game over scene
--- @param x number
--- @param y number
function GameOverScene.load(x, y)
  x, y = Utils.getOrDefault(x, 320), Utils.getOrDefault(y, 240)

  GameOverScene.camera = GameCamera:new()

  Cursor.setVisible(false)

  -- GAME OVER title
  GameOverScene.title_game_text = Text:new("GAME_OVER_TITLE_GAME")
  GameOverScene.title_game_text:setPosition(330, 76)
  GameOverScene.title_game_text:setFont("wonder")
  GameOverScene.title_game_text:setScale(8)
  GameOverScene.title_game_text:setAlpha(0)
  GameOverScene.title_game_text:setVisible(false)
  GameOverScene.title_over_text = Text:new("GAME_OVER_TITLE_OVER")
  GameOverScene.title_over_text:setPosition(324, 172)
  GameOverScene.title_over_text:setFont("wonder")
  GameOverScene.title_over_text:setScale(8)
  GameOverScene.title_over_text:setAlpha(0)
  GameOverScene.title_over_text:setVisible(false)

  GameOverScene.show_title = false
  GameOverScene.hide_title = false
  GameOverScene.alpha = 0

  -- heart
  GameOverScene.player_sprite = Sprite:new("heart")
  GameOverScene.player_sprite:setPosition(x, y)
  -- heart shards
  GameOverScene.player_shards = {}
  for i = 1, 6 do
    local shard_sprite = Sprite:new({
      "heart_shard1",
      "heart_shard2",
      "heart_shard3",
      "heart_shard4"
    }, 4 / 30, nil, false)
    shard_sprite:setPosition(x, y)
    shard_sprite:setVisible(false)
    GameOverScene.player_shards[i] = {
      ["sprite"] = shard_sprite,
      ["vel_x"] = (love.math.random() - 0.5) * 14,
      ["vel_y"] = (love.math.random() - 0.5) * 14
    }
  end

  -- dialogue
  GameOverScene.dialogue_text = DialogueText:new({ "GAME_OVER_TEXT_1" })
  GameOverScene.dialogue_text:setPosition(120, 320)
  GameOverScene.dialogue_text:setOrigin(0, 0)
  GameOverScene.dialogue_text:setFont("main_text_mono")
  GameOverScene.dialogue_text:setScale(2)
  GameOverScene.dialogue_text:setLayer(Constants.LAYERS.ABOVE_ARENA)
  GameOverScene.dialogue_text:setVoice("voice_asgore")
  GameOverScene.dialogue_text:setVisible(false)
  GameOverScene.dialogue_index = 1

  GameOverScene.game_over_music = Assets.playMusic("game_over", false)

  Timer.after(0.6, function()
    GameOverScene.player_sprite:setSprite("heart_break")
    Assets.playSound("heart_break")

    Timer.after(1.3, function()
      GameOverScene.player_sprite:setVisible(false)
      for _, shard in ipairs(GameOverScene.player_shards) do
        shard["sprite"]:setVisible(true)
        shard["sprite"]:play()
      end
      Assets.playSound("heart_explode")

      Timer.after(1.5, function()
        GameOverScene.alpha = 0
        GameOverScene.show_title = true
        GameOverScene.title_game_text:setVisible(true)
        GameOverScene.title_over_text:setVisible(true)
        GameOverScene.game_over_music:play()

        Timer.after(2.7, function()
          GameOverScene.dialogue_text:setVisible(true)
          GameOverScene.dialogue_text:reset()
        end)
      end)
    end)
  end)
end

--- Updates the game over scene, called on every game update
--- @param dt number
function GameOverScene.update(dt)
  if GameOverScene.dialogue_text:isVisible() then
    if GameOverScene.dialogue_text:isDone() then
      GameOverScene.dialogue_index = GameOverScene.dialogue_index + 1

      if GameOverScene.dialogue_index == 2 then
        local name = Utils.getOrDefault(Player.getName(), "Frisk")
        GameOverScene.dialogue_text:setText(Lang.translate("GAME_OVER_TEXT_2", name))
      elseif GameOverScene.dialogue_index == 3 then
        GameOverScene.dialogue_text:setText("")
      elseif GameOverScene.dialogue_index == 4 then
        GameOverScene.alpha = 1
        GameOverScene.hide_title = true
      end
    end
  end

  if GameOverScene.show_title then
    GameOverScene.alpha = math.max(0, GameOverScene.alpha + 0.02 * dt * 30)
    GameOverScene.title_game_text:setAlpha(GameOverScene.alpha)
    GameOverScene.title_over_text:setAlpha(GameOverScene.alpha)

    if GameOverScene.alpha >= 1 then
      GameOverScene.show_title = false
    end
  end

  if not GameOverScene.player_sprite:isVisible() then
    for _, shard in ipairs(GameOverScene.player_shards) do
      if shard["sprite"]:isVisible() then
        local x, y = shard["sprite"]:getPosition()
        x = x + shard["vel_x"] * dt * 30
        y = y + shard["vel_y"] * dt * 30
        shard["sprite"]:setPosition(x, y)
        shard["vel_y"] = shard["vel_y"] + 0.2 * dt * 30

        if y > 500 then
          shard["sprite"]:setVisible(false)
        end
      end
    end
  end

  if GameOverScene.hide_title then
    GameOverScene.alpha = math.max(0, GameOverScene.alpha - 0.02 * dt * 30)
    GameOverScene.title_game_text:setAlpha(GameOverScene.alpha)
    GameOverScene.title_over_text:setAlpha(GameOverScene.alpha)
    GameOverScene.game_over_music:setVolume(GameOverScene.alpha)

    if GameOverScene.alpha <= 0 then
      Scene.change("MAIN_MENU")
    end
  end
end

return GameOverScene
