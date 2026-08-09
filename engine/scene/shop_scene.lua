--- @class Dummy.Scene.Shop : Dummy.Scene.Scene
---
--- @field protected camera Dummy.WorldCamera
--- @field protected shop Dummy.Shop
local ShopScene = {}

--- Loads the shop scene
--- @param shop_id string
function ShopScene.load(shop_id)
  ShopScene.camera = WorldCamera:new()

  Cursor.setVisible(false)

  local ShopClass = World.getShop(shop_id)
  assert(ShopClass ~= nil, "Shop \"" .. shop_id .. "\" not found")

  ShopScene.shop = ShopClass:new(shop_id)

  Assets.fadeInMusic(10 / 30, ShopScene.shop:getMusic())
end

--- Updates the shop scene, called on every game update
--- @param dt number
function ShopScene.update(dt)
end

return ShopScene
