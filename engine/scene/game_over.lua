local game_over = {}

local self = {}

function self.load()
  game_over.title_game = Text.new("GAME_OVER_TITLE_GAME")
  game_over.title_game:setPosition(330, 76)
  game_over.title_game:setFont(Font.FONT.WONDER)
  game_over.title_game:setScale(8)
  game_over.title_game:setAlpha(0)

  game_over.title_over = Text.new("GAME_OVER_TITLE_OVER")
  game_over.title_over:setPosition(324, 172)
  game_over.title_over:setFont(Font.FONT.WONDER)
  game_over.title_over:setScale(8)
  game_over.title_over:setAlpha(0)

  game_over.title_delay = 2
  game_over.title_timer = 0

  Audio.playMusic("game_over")
end

function self.update(dt)
  if game_over.title_timer < game_over.title_delay then
    game_over.title_timer = game_over.title_timer + dt
    game_over.title_game:setAlpha(game_over.title_timer / game_over.title_delay)
    game_over.title_over:setAlpha(game_over.title_timer / game_over.title_delay)
  end
end

return self
