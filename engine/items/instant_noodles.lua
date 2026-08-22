--- @class Dummy.Item.InstantNoodles : Dummy.Item.Consumable
local InstantNoodlesItem = Class(ConsumableItem, "Dummy.Item.InstantNoodles")

--- Creates an instant noodles
--- @return Dummy.Item.InstantNoodles
function InstantNoodlesItem:new()
  self = Class:new(InstantNoodlesItem, {
    "instant_noodles",
    "ITEM_INSTANT_NOODLES_NAME",
    "ITEM_INSTANT_NOODLES_SHORTNAME",
    "ITEM_INSTANT_NOODLES_DESCRIPTION",
    4,
    "food"
  })

  self:setBuyPrice(1)
  self:setSellPrice(50)
  self:setShopDescription("ITEM_INSTANT_NOODLES_DESCRIPTION_SHOP")

  return self
end

--- Gets the instant noodles's heal amount
--- @return number
function InstantNoodlesItem:getHeal()
  return World.isInBattle() and 4 or 15
end

--- Gets the instant noodles's dialogue texts
--- @return Dummy.Text.Text[]
function InstantNoodlesItem:getDialogueTexts()
  local texts = ConsumableItem.getDialogueTexts(self)
  if not World.isInBattle() then return texts end

  local dialogue_texts = {
    "ITEM_INSTANT_NOODLES_USE_1",
    "ITEM_INSTANT_NOODLES_USE_2",
    "ITEM_INSTANT_NOODLES_USE_3",
    "ITEM_INSTANT_NOODLES_USE_4",
    "ITEM_INSTANT_NOODLES_USE_5",
    "ITEM_INSTANT_NOODLES_USE_6",
    "ITEM_INSTANT_NOODLES_USE_7",
    "ITEM_INSTANT_NOODLES_USE_8",
    "ITEM_INSTANT_NOODLES_USE_9",
    "ITEM_INSTANT_NOODLES_USE_10",
    "ITEM_INSTANT_NOODLES_USE_11",
    "ITEM_INSTANT_NOODLES_USE_12",
    "ITEM_INSTANT_NOODLES_USE_13",
    "ITEM_INSTANT_NOODLES_USE_14",
    "ITEM_INSTANT_NOODLES_USE_15",
    "ITEM_INSTANT_NOODLES_USE_16",
  }
  table.insertall(dialogue_texts, texts)
  return dialogue_texts
end

--- Uses the instant noodles item
--- @param bypass? boolean
function InstantNoodlesItem:use(bypass)
  if type(self.onBeforeUse) == "function" then
    self:onBeforeUse()
  end

  local texts = self:getDialogueTexts()
  if World.isInBattle() and bypass ~= true then
    local dialogue = Battle.playDialogueText(table.unpack(texts))
    dialogue:registerCommand("instantnoodles", function(node)
      if node.arguments[1] == "pause" then
        Assets.getCurrentMusic():pause()
      elseif node.arguments[1] == "use" then
        Assets.getCurrentMusic():play()
        dialogue:unregisterCommand("instantnoodles")
        self:use(true)
      end
    end)
    return
  end

  World.playDialogue(texts)
  Player.removeItem(self)

  local swallow_sound = self:getSwallowSound()
  if swallow_sound ~= nil then
    Assets.playSound(swallow_sound)
  end

  Soul.heal(self:getHeal(), true)

  local heal_sound = self:getHealSound()
  if heal_sound ~= nil then
    Timer.after(0.5, function()
      Assets.playSound(heal_sound)
    end)
  end

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

return InstantNoodlesItem
