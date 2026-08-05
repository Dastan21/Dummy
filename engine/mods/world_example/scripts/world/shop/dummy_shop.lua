--- @class WorldExample.DummyShop : Dummy.Shop
---
--- @field protected shopkeeper Dummy.Sprite
local DummyShop = Class(Shop, "WorldExample.DummyShop")

--- Creates the dummy shop
--- @return WorldExample.DummyShop
function DummyShop:new()
  self = Class:new(DummyShop, { "dummy_shop" })

  -- set the background (recommended 320x120)
  self:setBackground("world/shop/dummy/background")
  -- set the music playing in the shop
  self:setMusic("shop")

  -- add the shopkeeper manually, for better customization
  self.shopkeeper = Sprite:new("world/shop/dummy/shopkeeper")
  self.shopkeeper:setPosition(160, 110)
  self.shopkeeper:setOrigin(0.5, 1)
  self.shopkeeper:setParent(self)

  -- little prop animation
  self.cooler_water = Sprite:new({
    "world/shop/dummy/cooler_water_1",
    "world/shop/dummy/cooler_water_2"
  }, 1)
  self.cooler_water:setPosition(120.5, 20.5)
  self.cooler_water:setParent(self)

  self:prepareItems()
  self:prepareTalks()

  -- the first dialogue to show when entering the shop
  self:playDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_ENTER_TEXT")

  --
  self:setSellConfirmText("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_SELL_CONFIRM_TEXT")

  return self
end

--- Prepares the shop items
function DummyShop:prepareItems()
  local MonsterCandy = require("items.monster_candy")
  local SpiderDonut = require("items.spider_donut")
  local bisicle = tryRequire("scripts.items.bisicle", "items.bisicle")
  local nice_cream = require("items.nice_cream")
  local quiche = require("items.abandoned_quiche")
  local dog_residue = require("items.dog_residue")
  local instant_noodles = require("items.instant_noodles")
  local hot_dog = require("items.hot_dog")
  local hot_cat = require("items.hot_cat")
  local sea_tea = require("items.sea_tea")
  local bad_memory = require("items.bad_memory")
  -- amount `-1` for infinite stock
  self:addItem(bad_memory, -1)
  self:addItem(sea_tea, -1)
  self:addItem(instant_noodles, -1)
  self:addItem(dog_residue, -1)
  self:addItem(hot_dog, -1)

  local BlanketItem = require("items.blanket")
  local blanket_amount = 1
  -- track wether the blanket has been bought
  if WorldExampleMod.flag["dummy_shop_blanket"] == 1 then
    blanket_amount = 0
  end
  self:addItem(BlanketItem, blanket_amount)
end

--- Prepares the shop talks
function DummyShop:prepareTalks()
  self:addTalk("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_SAY_HELLO_NAME", {
    "WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_SAY_HELLO_TEXT_1",
    "WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_SAY_HELLO_TEXT_2"
  })
  self:addTalk("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_PAT_NAME", {
    "WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_PAT_TEXT_1",
    "WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_PAT_TEXT_2",
  })
end

--- Called when the main dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
function DummyShop:onMainDialogue(menu)
  if menu == "main" then
    self:playDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_MAIN_TEXT")
  elseif menu == "sell" then
    -- you can use `playDialogueFull` to play a dialogue instead of showing a menu
    -- if you don't want the player to sell their items
    -- self:playDialogueFull("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_SELL_TEXT")

    if #Player.getItems() <= 0 then
      self:playDialogueFull("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_SELL_NO_ITEMS_TEXT")
    end
  end
end

--- Called when the side dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
--- @param old_menu Dummy.Shop.MenuType|nil
function DummyShop:onSideDialogue(menu, old_menu)
  -- all side dialogues are optional
  if menu == "buy" then
    if old_menu == "buy:confirm" then
      self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_SIDE_CANCEL_TEXT")
    else
      self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_SIDE_TEXT")
    end
  elseif menu == "talk" then
    self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_TALK_SIDE_TEXT")
  end
end

--- Called when an item is bought
--- @param item Dummy.Item
--- @param not_enough_gold boolean
--- @param inventory_full boolean
--- @param sold_out boolean
function DummyShop:onBuyItem(item, not_enough_gold, inventory_full, sold_out)
  -- all side dialogues are optional
  if sold_out then
    self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_SOLD_OUT_TEXT")
  elseif not_enough_gold then
    self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_NOT_ENOUGH_GOLD_TEXT")
  elseif inventory_full then
    self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_INVENTORY_FULL_TEXT")
  else
    if item:getId() == "blanket" then
      WorldExampleMod.flag["dummy_shop_blanket"] = 1
    end

    self:playSideDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_BUY_SUCCESS_TEXT")
  end
end

--- Called when the shop is exited
function DummyShop:onExit()
  self:playDialogue("WORLD_EXAMPLE_MOD_WORLD_SHOP_DUMMY_EXIT_TEXT")
end

return DummyShop
