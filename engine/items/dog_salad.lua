--- @class Item.DogSalad : Dummy.Item.Consumable
local DogSaladItem = Class(ItemConsumable, "Item.DogSalad")

--- Creates a dog salad
--- @return Item.DogSalad
function DogSaladItem:new()
  self = Class:new(DogSaladItem, {
    "dog_salad",                                     -- item identifier
    "ITEM_DOG_SALAD_NAME",         -- item name
    "ITEM_DOG_SALAD_SHORTNAME",    -- item short name
    "ITEM_DOG_SALAD_DESCRIPTION", -- item description
    15,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(2)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_DOG_SALAD_DESCRIPTION_SHOP")
  -- Random comments on use
  self.use_comments = {
    "ITEM_DOG_SALAD_USE",
    "ITEM_DOG_SALAD_USE_2",
    "ITEM_DOG_SALAD_USE_3",
    "ITEM_DOG_SALAD_USE_4"
  }
  -- Random comments on use
  self.rand = love.math.random(4)

  return self
end

function DogSaladItem:getDialogueTexts()
  -- Select a random comment when getting dialogue text
  local dialogue_text = Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) .. "\n" ..
  Lang.translate(self.use_comments[self.rand]) .. "\n" .. self:getHealText()

  return {dialogue_text}
end

function DogSaladItem:onUse()
  Assets.playSound("dogresidue")
end

function DogSaladItem:getHeal()
  local val
  if self.rand == 1 then
    val = 2
  end
  if self.rand == 2 then
    val = 10
  end
  if self.rand == 3 then
    val = 30
  end
  if self.rand == 4 then
    val = Player.getMaxHP()
  end
  return val
end

return DogSaladItem
