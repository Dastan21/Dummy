--- @class Dummy.Item.MonsterCandy : Dummy.Item.Consumable
local MonsterCandyItem = Class(ConsumableItem, "Dummy.Item.MonsterCandy")

--- Creates a monster candy
--- @return Dummy.Item.MonsterCandy
function MonsterCandyItem:new()
  self = Class:new(MonsterCandyItem, {
    "monster_candy",
    "ITEM_MONSTER_CANDY_NAME",
    "ITEM_MONSTER_CANDY_SHORTNAME",
    "ITEM_MONSTER_CANDY_DESCRIPTION",
    10,
    "food"
  })

  self:setBuyPrice(15)
  self:setSellPrice(25)
  self:setShopDescription("ITEM_MONSTER_CANDY_DESCRIPTION_SHOP")

  local rand = love.math.random(0, 15)
  if rand <= 2 then
    self:setUseText("ITEM_MONSTER_CANDY_USE_1")
  elseif rand == 15 then
    self:setUseText("ITEM_MONSTER_CANDY_USE_2")
  end

  return self
end

return MonsterCandyItem
