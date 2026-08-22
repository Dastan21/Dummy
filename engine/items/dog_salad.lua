--- @class Dummy.Item.DogSalad : Dummy.Item.Consumable
---
--- @field protected rand number
local DogSaladItem = Class(ConsumableItem, "Dummy.Item.DogSalad")

--- Creates a dog salad
--- @return Dummy.Item.DogSalad
function DogSaladItem:new()
  self = Class:new(DogSaladItem, {
    "dog_salad",
    "ITEM_DOG_SALAD_NAME",
    "ITEM_DOG_SALAD_SHORTNAME",
    "ITEM_DOG_SALAD_DESCRIPTION",
    2,
    "food"
  })

  self:setBuyPrice(15)
  self:setSellPrice(2)
  self:setShopDescription("ITEM_DOG_SALAD_DESCRIPTION_SHOP")
  self:setHealSound("dogresidue")

  self.rand = love.math.random(4)

  self:setUseText("ITEM_DOG_SALAD_USE_" .. self.rand)

  if self.rand == 1 then
    self:setHeal(30)
  elseif self.rand == 2 then
    self:setHeal(10)
  elseif self.rand == 3 then
    self:setHeal(2)
  elseif self.rand == 4 then
    self:setHeal(Player.getMaxHP())
  end

  return self
end

return DogSaladItem
