--- @class Dummy.Item.DogResidue : Dummy.Item.Consumable
local DogResidueItem = Class(Item, "Dummy.Item.DogResidue")

--- Creates a dog residue
--- @return Dummy.Item.DogResidue
function DogResidueItem:new()
  self = Class:new(DogResidueItem, {
    "dog_residue",
    "ITEM_DOG_RESIDUE_NAME",
    "ITEM_DOG_RESIDUE_SHORTNAME",
    "ITEM_DOG_RESIDUE_DESCRIPTION"
  })

  self:setBuyPrice(1)
  self:setSellPrice(love.math.random(4))
  self:setShopDescription("ITEM_DOG_RESIDUE_DESCRIPTION_SHOP")
  self:setUseText("ITEM_DOG_RESIDUE_USE")

  local rand = love.math.random(6)
  self:setDescriptions("ITEM_DOG_RESIDUE_DESCRIPTION_" .. rand)

  return self
end

--- Gets the dog residue's dialogue texts
--- @return Dummy.Text.Text[]
function DogResidueItem:getDialogueTexts()
  local dialogue_texts = table.copy(self:getUseTexts())

  -- dialogues depending on if the item can create clones
  if #Player.getItems() == Player.getMaxItems() then
    table.insert(dialogue_texts, "ITEM_DOG_RESIDUE_USE_FAIL_1")
    table.insert(dialogue_texts, "ITEM_DOG_RESIDUE_USE_FAIL_2")
    table.insert(dialogue_texts, "ITEM_DOG_RESIDUE_USE_FAIL_3")
  else
    table.insert(dialogue_texts, "ITEM_DOG_RESIDUE_USE_SUCCESS")
  end

  return dialogue_texts
end

--- Called when the dog residue is used
function DogResidueItem:onUse()
  Assets.playSound("dogresidue")

  DogSaladItem = require("items.dog_salad"):new()

  -- clone the item to all empty slots in the player's inventory
  for _ = 1, Player.getMaxItems() - #Player.getItems() do
    local rand = love.math.random(8)
    if rand == 1 then
      Player.addItem(DogSaladItem:new())
    else
      Player.addItem(DogResidueItem:new())
    end
  end
end

return DogResidueItem
