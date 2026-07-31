--[[
  Generated from ..\engine\world\shop.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/world/shop.lua
]]

---@meta

--- @class Dummy.Shop : Dummy.Drawable
---
--- @field protected id string
--- @field protected background_sprite Dummy.Sprite
--- @field protected heart_sprite Dummy.Sprite
--- @field protected main_dialogue_text Dummy.DialogueText
--- @field protected side_container Dummy.Drawable
--- @field protected side_dialogue_text Dummy.DialogueText
--- @field protected buy_action_text Dummy.Text
--- @field protected sell_action_text Dummy.Text
--- @field protected talk_action_text Dummy.Text
--- @field protected exit_action_text Dummy.Text
--- @field protected player_gold_text Dummy.Text
--- @field protected player_stock_text Dummy.Text
--- @field protected buy_action_confirm_yes_text Dummy.Text
--- @field protected buy_action_confirm_no_text Dummy.Text
--- @field protected menu_container Dummy.Drawable
--- @field protected menu_exit_text Dummy.Text
--- @field protected sell_player_gold_text Dummy.Text
--- @field protected sell_confirm_text Dummy.Text
--- @field protected sell_action_confirm_yes_text Dummy.Text
--- @field protected sell_action_confirm_no_text Dummy.Text
--- @field protected item_info_container Dummy.Drawable
--- @field protected item_info_timer Dummy.Timer.Handle|nil
--- @field protected current_menu Dummy.Shop.MenuType
--- @field protected previous_menu Dummy.Shop.MenuType
--- @field protected action_index integer
--- @field protected total_actions integer
--- @field protected item_buy_index integer
--- @field protected item_buy_action_index integer
--- @field protected items_to_buy Dummy.Shop.ItemStock[]
--- @field protected items_buy_texts Dummy.Text[]
--- @field protected max_items_to_buy integer
--- @field protected buy_sold_out_text Dummy.Text.Text
--- @field protected buy_description_sold_out_text Dummy.Text.Text
--- @field protected item_sell_index integer
--- @field protected item_sell_action_index integer
--- @field protected items_sell_texts Dummy.Text[]
--- @field protected max_items_to_sell integer
--- @field protected sell_sold_out_text Dummy.Text.Text
--- @field protected talk_index integer
--- @field protected talks Dummy.Shop.Talk[]
--- @field protected talks_texts Dummy.Text[]
--- @field protected max_talks integer
--- @field protected exiting boolean
--- @field protected leaving boolean
--- @field protected timer Dummy.Timer
Shop = {}

--- @alias Dummy.Shop.MenuType "main" | "buy" | "buy:confirm" | "sell" | "sell:confirm" | "talk"
--- @alias Dummy.Shop.DialogueContext "menu:main" | "menu:buy" | "menu:buy:confirm" | "buy:cannot-afford" | "buy:full" | "buy:success" | "menu:sell" | "menu:sell:confirm" | "menu:talk"

--- @class Dummy.Shop.ItemStock
---
--- @field item Dummy.Item
--- @field stock integer

--- @class Dummy.Shop.Talk
---
--- @field name Dummy.Text.Text
--- @field texts Dummy.Text.Text[]

--- Creates a shop
--- @param shop_id string
--- @return Dummy.Shop
function Shop:new(shop_id) end

--- Gets the shop's id
--- @return string
function Shop:getId() end

--- Gets the shop's background
--- @return Dummy.Sprite
function Shop:getBackground() end

--- Sets the shop's background
--- @param background string
function Shop:setBackground(background) end

--- Gets the shop's music
--- @return love.Source
function Shop:getMusic() end

--- Sets the shop's music
--- @param music string
function Shop:setMusic(music) end

--- Gets the buy action labels
--- @return Dummy.Text.Text yes, Dummy.Text.Text no
function Shop:getBuyActionLabels() end

--- Sets the buy action labels
--- @param yes Dummy.Text.Text
--- @param no Dummy.Text.Text
function Shop:setBuyActionLabels(yes, no) end

--- Gets the sell action labels
--- @return Dummy.Text.Text yes, Dummy.Text.Text no
function Shop:getSellActionLabels() end

--- Sets the sell action labels
--- @param yes Dummy.Text.Text
--- @param no Dummy.Text.Text
function Shop:setSellActionLabels(yes, no) end

--- Gets the buy sold out labels
--- @return Dummy.Text.Text name, Dummy.Text.Text description
function Shop:getBuySoldOutLabels() end

--- Sets the buy sold out labels
--- @param name Dummy.Text.Text
--- @param description Dummy.Text.Text
function Shop:setBuySoldOutLabels(name, description) end

--- Gets the sell sold out label
--- @return Dummy.Text.Text buy
function Shop:getSellSoldOutLabel() end

--- Sets the sell sold out label
--- @param name Dummy.Text.Text
function Shop:setSellSoldOutLabel(name) end

--- Gets the sell confirm text
--- @return Dummy.Text.Text
function Shop:getSellConfirmText() end

--- Sets the sell confirm text
--- @param text Dummy.Text.Text
function Shop:setSellConfirmText(text) end

--- Gets the heart sprite
--- @return Dummy.Sprite
function Shop:getHeartSprite() end

--- Gets all items available to buy in the shop
--- @return Dummy.Shop.ItemStock[]
function Shop:getItems() end

--- Adds an item to the shop
--- @param ItemClass Dummy.Item
--- @param stock? integer the amount of items the shop has in stock, `-1` for infinite stock (Defaults to `-1`)
--- @param index? integer
function Shop:addItem(ItemClass, stock, index) end

--- Removes an item from the shop
--- @param item integer
function Shop:removeItem(item) end

--- Gets all talks available in the shop
--- @return Dummy.Shop.Talk[]
function Shop:getTalks() end

--- Adds a talk to the shop
--- @param name Dummy.Text.Text
--- @param texts Dummy.Text.Text[]
--- @param index? integer
function Shop:addTalk(name, texts, index) end

--- Removes a talk from the shop
--- @param index integer
function Shop:removeTalk(index) end

--- Called when the main dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
function Shop:onMainDialogue(menu) end

--- Called when the side dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
--- @param old_menu Dummy.Shop.MenuType|nil
function Shop:onSideDialogue(menu, old_menu) end

--- Gets the main dialogue text
--- @return Dummy.DialogueText
function Shop:getMainDialogueText() end

--- Plays a shop's dialogue
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playDialogue(text, ...) end

--- Plays a shop's dialogue on the full width
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playDialogueFull(text, ...) end

--- Gets the side dialogue text
--- @return Dummy.DialogueText
function Shop:getSideDialogueText() end

--- Plays a shop's side dialogue
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playSideDialogue(text, ...) end

--- Shows the menu texts
--- @param texts_list Dummy.Text[]
--- @param actual_length integer
function Shop:showMenuTexts(texts_list, actual_length) end

--- Hides the menu texts
function Shop:hideMenuTexts() end

--- Updates the shop's menu texts
function Shop:updateMenuTexts() end

--- Updates the shop's menu heart position
function Shop:updateHeartPosition() end

--- Toggles the actions
--- @param visible boolean
function Shop:toggleActions(visible) end

--- Updates the buy item info
function Shop:updateBuyItemInfo() end

--- Gets the selected item to buy
--- @return Dummy.Shop.ItemStock
function Shop:getSelectedItemToBuy() end

--- Gets the selected item to sell
--- @return Dummy.Item
function Shop:getSelectedItemToSell() end

--- Changes the selected action
--- @param delta integer
function Shop:changeAction(delta) end

--- Does an action on the selected action
function Shop:doActionOnSelectedAction() end

--- Changes the current menu
--- @param menu Dummy.Shop.MenuType
--- @param keep_index? boolean
function Shop:changeMenu(menu, keep_index) end

--- Initializes the menu buy
function Shop:loadMenuBuy() end

--- Initializes the menu buy confirm
function Shop:loadMenuBuyConfirm() end

--- Initializes the menu sell
function Shop:loadMenuSell() end

--- Initializes the menu sell confirm
function Shop:loadMenuSellConfirm() end

--- Initializes the menu talk
function Shop:loadMenuTalk() end

--- Changes the selected item to buy
--- @param delta integer
function Shop:changeItemToBuy(delta) end

--- Does an action on the selected item to buy
function Shop:doActionOnSelectedItemToBuy() end

--- Changes the selected item to buy action
--- @param delta integer
function Shop:changeItemToBuyAction(delta) end

--- Does an action on the selected item to buy action
function Shop:doActionOnSelectedItemToBuyAction() end

--- Buys the selected item
function Shop:buyItem() end

--- Changes the selected item to sell
--- @param delta_x integer
--- @param delta_y integer
function Shop:changeItemToSell(delta_x, delta_y) end

--- Does an action on the selected item to sell
function Shop:doActionOnSelectedItemToSell() end

--- Changes the selected item to sell action
--- @param delta integer
function Shop:changeItemToSellAction(delta) end

--- Does an action on the selected item to sell action
function Shop:doActionOnSelectedItemToSellAction() end

--- Sells the selected item
function Shop:sellItem() end

--- Changes the selected talk
--- @param delta integer
function Shop:changeTalk(delta) end

--- Does an action on the selected talk
function Shop:doActionOnSelectedTalk() end

--- Slides the item info box in view
function Shop:slideItemInfo() end

--- Exits the shop
function Shop:exit() end

--- Called when an item is bought
--- @param item Dummy.Item
--- @param not_enough_gold boolean
--- @param inventory_full boolean
--- @param sold_out boolean
function Shop:onBuyItem(item, not_enough_gold, inventory_full, sold_out) end

--- Called when en item is sold
--- @param item Dummy.Item
function Shop:onSellItem(item) end

--- Called when the shop is exited
function Shop:onExit() end

--- Removes the shop from the current scene
function Shop:remove() end

--- Draws the shop
--- @param camera Dummy.Camera
function Shop:draw(camera) end

--- Handles the menu actions
function Shop:handleMenuActions() end

--- Updates the shop, called on every game update
--- @param dt number
function Shop:update(dt) end

