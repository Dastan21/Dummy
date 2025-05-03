local self = {
  fonts = {}
}

function self.load()
  self.fonts.main = love.graphics.newImageFont("assets/fonts/main.png",
    " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÇÈÉÊËÌÍÎÏÔÙÚÛÜàáâäçèéêëìíîïôùúûü")
  self.fonts.maintext = love.graphics.newImageFont("assets/fonts/maintext.png",
    " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~ÀÁÂÇÈÉÊËÌÍÎÏÔÙÚÛÜàáâäæçèéêëìíîïôùúûü")
  self.fonts.small = love.graphics.newImageFont("assets/fonts/small.png",
    " !\"$'()+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]_`abcdefghijklmnopqrstuvwxyz")

  love.graphics.setFont(self.fonts.main)

  -- Antialiazing
  for _, font in pairs(self.fonts) do
    font:setFilter("nearest", "nearest")
  end
end

return self
