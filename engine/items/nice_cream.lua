--- @class Item.NiceCream : Dummy.Item.Consumable
local NiceCreamItem = Class(ItemConsumable, "Item.NiceCream")

--- Creates a nice cream
--- @return Item.NiceCream
function NiceCreamItem:new()
  self = Class:new(NiceCreamItem, {
    "nice_cream",                                     -- item identifier
    "ITEM_NICE_CREAM_NAME",         -- item name
    "ITEM_NICE_CREAM_SHORTNAME",    -- item short name
    "ITEM_NICE_CREAM_DESCRIPTION",  -- item description
    15,
    "food"
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(15)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(2)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_NICE_CREAM_DESCRIPTION_SHOP")
  -- Random comments on use
  self.use_comments = {
    "ITEM_NICE_CREAM_USE",
    "ITEM_NICE_CREAM_USE_2",
    "ITEM_NICE_CREAM_USE_3",
    "ITEM_NICE_CREAM_USE_4",
    "ITEM_NICE_CREAM_USE_5",
    "ITEM_NICE_CREAM_USE_6",
    "ITEM_NICE_CREAM_USE_7",
    "ITEM_NICE_CREAM_USE_8"
  }

  return self
end

function NiceCreamItem:getDialogueTexts()
  -- Generate a random number
  local rand = love.math.random(8)
  -- Set Default Dialogue Text
  local dialogue_text = Lang.translate(self:getUseTexts()[1], Lang.translate(self:getName())) ..
      "\n" .. self:getHealText()
  -- Override dialogue text with a random comment based on the random number
  dialogue_text = Lang.translate(self.use_comments[rand])
  return { dialogue_text }
end

return NiceCreamItem
