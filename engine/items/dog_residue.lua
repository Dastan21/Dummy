--- @class Item.DogResidue : Dummy.Item.Consumable
local DogResidueItem = Class(Item, "Item.DogResidue")

--- Creates a dog residue
--- @return Item.DogResidue
function DogResidueItem:new()
  self = Class:new(DogResidueItem, {
    "dog_residue",                                     -- item identifier
    "ITEM_DOG_RESIDUE_NAME",         -- item name
    "ITEM_DOG_RESIDUE_SHORTNAME",    -- item short name
    "ITEM_DOG_RESIDUE_DESCRIPTION"  -- item description
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(love.math.random(4))
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_DOG_RESIDUE_DESCRIPTION_SHOP")
  -- the text that will appear when the item is used
  self:setUseText("ITEM_DOG_RESIDUE_USE")
  -- descriptions for each dog residue type
  self.descriptions = {
    "ITEM_DOG_RESIDUE_DESCRIPTION",
    "ITEM_DOG_RESIDUE_DESCRIPTION_2",
    "ITEM_DOG_RESIDUE_DESCRIPTION_3",
    "ITEM_DOG_RESIDUE_DESCRIPTION_4",
    "ITEM_DOG_RESIDUE_DESCRIPTION_5",
    "ITEM_DOG_RESIDUE_DESCRIPTION_6"
  }
  -- Random description when a new version of the object is added (copies will retain the same description)
  local rand = love.math.random(6)
  self:setDescription(self.descriptions[rand])

  return self
end

function DogResidueItem:getDialogueTexts()
  -- define dialogue_text as an empty table because it keeps adding to it if we don't. For some reason.
  local dialogue_text = {}
  table.insert(dialogue_text, self:getUseTexts())
  -- Show mini-cutscene depending on if the item can create clones
  if #Player.getItems() == Player.getMaxItems() then
    table.insert(dialogue_text, Lang.translate("ITEM_DOG_RESIDUE_USE_FAIL"))
    table.insert(dialogue_text, Lang.translate("ITEM_DOG_RESIDUE_USE_FAIL_2"))
    table.insert(dialogue_text, Lang.translate("ITEM_DOG_RESIDUE_USE_FAIL_3"))
  else
    table.insert(dialogue_text, Lang.translate("ITEM_DOG_RESIDUE_USE_SUCCESS"))
  end
  return dialogue_text
end

function DogResidueItem:onUse()
  -- Clone the item to all empty slots in the player's inventory
  Assets.playSound("dogresidue")
  for i = 1, Player.getMaxItems() - #Player.getItems() do
    local rand = love.math.random(8)
    local dog_salad = require("items.dog_salad"):new()
    local dog_residue = require("items.dog_residue"):new()
    if rand == 1 then
      Player.addItem(dog_salad)
    else
      Player.addItem(dog_residue)
    end
  end
end

return DogResidueItem
