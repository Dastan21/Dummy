local self = {
  FONT = {
    MAIN = love.graphics.newImageFont("assets/fonts/main.png",
      " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÇÈÉÊËÌÍÎÏÔÙÚÛÜàáâäçèéêëìíîïôùúûü"),
    MAIN_TEXT = love.graphics.newImageFont("assets/fonts/main_text.png",
      " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÇÈÉÊËÌÍÎÏÔÙÚÛÜàáâäçèéêëìíîïôùúûü"),
    SMALL = love.graphics.newImageFont("assets/fonts/small.png",
      " !\"$'()+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]_`abcdefghijklmnopqrstuvwxyz"),
    CURS = love.graphics.newImageFont("assets/fonts/curs.png",
      " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),
    WONDER = love.graphics.newImageFont("assets/fonts/wonder.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
  }
}

function self.load()
  love.graphics.setFont(self.FONT.MAIN)

  -- Antialiazing
  for _, font in pairs(self.FONT) do
    font:setFilter("nearest", "nearest")
  end
end

return self
