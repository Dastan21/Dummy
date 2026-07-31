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
local Shop = Class(Drawable, "Dummy.Shop")

--- Creates a shop
--- @param shop_id string
--- @return Dummy.Shop
function Shop:new(shop_id)
  self = Class:new(Shop)

  self.id = shop_id
  self.width = 320
  self.height = 120

  self.background_sprite = Sprite:new()
  self.background_sprite:setOrigin(0, 0)
  self.background_sprite:setLayer(Constants.LAYERS.BOTTOM)

  -- main
  self.heart_sprite = Sprite:new("heartsmall")
  self.heart_sprite:setParent(self)

  self.main_dialogue_text = DialogueText:new("")
  self.main_dialogue_text:setPosition(20, 130)
  self.main_dialogue_text:setOrigin(0, 0)
  self.main_dialogue_text:setFont("main_text")
  self.main_dialogue_text:setCharacterWidth(8)
  self.main_dialogue_text:setCharacterHeight(18)
  self.main_dialogue_text:setParent(self)

  -- side
  self.side_container = Drawable:new()
  self.side_container:setParent(self)

  self.side_dialogue_text = DialogueText:new("")
  self.side_dialogue_text:setPosition(230, 130)
  self.side_dialogue_text:setOrigin(0, 0)
  self.side_dialogue_text:setFont("main_text")
  self.side_dialogue_text:setCharacterHeight(15)
  self.side_dialogue_text:setParent(self.side_container)

  self.buy_action_text = Text:new("WORLD_SHOP_ACTION_BUY")
  self.buy_action_text:setOrigin(0, 0.5)
  self.buy_action_text:setPosition(240, 138)
  self.buy_action_text:setFont("main_text")
  self.buy_action_text:setParent(self.side_container)

  self.sell_action_text = Text:new("WORLD_SHOP_ACTION_SELL")
  self.sell_action_text:setOrigin(0, 0.5)
  self.sell_action_text:setPosition(240, 158)
  self.sell_action_text:setFont("main_text")
  self.sell_action_text:setParent(self.side_container)

  self.talk_action_text = Text:new("WORLD_SHOP_ACTION_TALK")
  self.talk_action_text:setOrigin(0, 0.5)
  self.talk_action_text:setPosition(240, 178)
  self.talk_action_text:setFont("main_text")
  self.talk_action_text:setParent(self.side_container)

  self.exit_action_text = Text:new("WORLD_SHOP_ACTION_EXIT")
  self.exit_action_text:setOrigin(0, 0.5)
  self.exit_action_text:setPosition(240, 198)
  self.exit_action_text:setFont("main_text")
  self.exit_action_text:setParent(self.side_container)

  self.player_gold_text = Text:new()
  self.player_gold_text:setOrigin(0, 0.5)
  self.player_gold_text:setPosition(230, 218)
  self.player_gold_text:setFont("main_text")
  self.player_gold_text:setParent(self.side_container)

  self.player_stock_text = Text:new("", true)
  self.player_stock_text:setOrigin(0, 0.5)
  self.player_stock_text:setPosition(280, 218)
  self.player_stock_text:setFont("main_text")
  self.player_stock_text:setParent(self.side_container)

  self.buy_action_confirm_yes_text = Text:new("WORLD_SHOP_ACTION_BUY_YES")
  self.buy_action_confirm_yes_text:setOrigin(0, 0.5)
  self.buy_action_confirm_yes_text:setPosition(240, 178)
  self.buy_action_confirm_yes_text:setFont("main_text")
  self.buy_action_confirm_yes_text:setParent(self.side_container)
  self.buy_action_confirm_yes_text:setVisible(false)

  self.buy_action_confirm_no_text = Text:new("WORLD_SHOP_ACTION_BUY_NO")
  self.buy_action_confirm_no_text:setOrigin(0, 0.5)
  self.buy_action_confirm_no_text:setPosition(240, 193)
  self.buy_action_confirm_no_text:setFont("main_text")
  self.buy_action_confirm_no_text:setParent(self.side_container)
  self.buy_action_confirm_no_text:setVisible(false)

  self.menu_container = Drawable:new()
  self.menu_container:setParent(self)
  self.menu_container:setVisible(false)

  self.menu_exit_text = Text:new("WORLD_SHOP_ACTION_EXIT")
  self.menu_exit_text:setOrigin(0, 0.5)
  self.menu_exit_text:setPosition(30, 218)
  self.menu_exit_text:setFont("main_text")
  self.menu_exit_text:setParent(self.menu_container)

  self.sell_player_gold_text = Text:new()
  self.sell_player_gold_text:setOrigin(0, 0.5)
  self.sell_player_gold_text:setPosition(200, 218)
  self.sell_player_gold_text:setColor(1, 1, 0)
  self.sell_player_gold_text:setFont("main_text")
  self.sell_player_gold_text:setParent(self.menu_container)

  self.sell_confirm_text = Text:new()
  self.sell_confirm_text:setOrigin(0, 0.5)
  self.sell_confirm_text:setPosition(55, 158)
  self.sell_confirm_text:setFont("main_text")
  self.sell_confirm_text:setParent(self.menu_container)
  self.sell_confirm_text:setVisible(false)

  self.sell_action_confirm_yes_text = Text:new("WORLD_SHOP_ACTION_SELL_YES")
  self.sell_action_confirm_yes_text:setOrigin(0, 0.5)
  self.sell_action_confirm_yes_text:setPosition(80, 188)
  self.sell_action_confirm_yes_text:setFont("main_text")
  self.sell_action_confirm_yes_text:setParent(self.menu_container)
  self.sell_action_confirm_yes_text:setVisible(false)

  self.sell_action_confirm_no_text = Text:new("WORLD_SHOP_ACTION_SELL_NO")
  self.sell_action_confirm_no_text:setOrigin(0, 0.5)
  self.sell_action_confirm_no_text:setPosition(190, 188)
  self.sell_action_confirm_no_text:setFont("main_text")
  self.sell_action_confirm_no_text:setParent(self.menu_container)
  self.sell_action_confirm_no_text:setVisible(false)

  self.item_info_container = Drawable:new()
  self.item_info_container:setPosition(210, 120)
  self.item_info_container["move_y"] = 120
  self.item_info_container.width = 110
  self.item_info_container.height = 85
  self.item_info_container:setLayer(self:getLayer() - 0.01)
  self.item_info_container:setVisible(false)

  function self.item_info_container.draw(_self, camera)
    if not _self:isVisible() then return end

    love.graphics.applyTransform(_self:getTransform())

    local width, height = _self:getWidth(), _self:getHeight()

    -- outline
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, width, height)
    -- background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 4, 4, width - 7, height - 8)

    _self:drawChildren(camera)
  end

  self.item_info_text = Text:new()
  self.item_info_text:setOrigin(0, 0)
  self.item_info_text:setPosition(14, 14)
  self.item_info_text:setFont("main_text")
  self.item_info_text:setParent(self.item_info_container)

  self.current_menu = "main"
  self.previous_menu = "main"
  self.action_index = 0
  self.total_actions = 4

  self.item_buy_index = 0
  self.item_buy_action_index = 0
  self.items_to_buy = {}
  self.items_buy_texts = {}
  self.max_items_to_buy = 4
  self.buy_sold_out_text = "WORLD_SHOP_ITEM_BUY_SOLD_OUT"
  self.buy_description_sold_out_text = "WORLD_SHOP_ITEM_BUY_DESCRIPTION_SOLD_OUT"

  self.item_sell_index = 0
  self.item_sell_action_index = 0
  self.items_sell_texts = {}
  self.items_sell_sold_out_texts = {}
  self.items_sell_sold_out_total = 0
  self.max_items_to_sell = 8
  self.sell_sold_out_text = "WORLD_SHOP_ITEM_SELL_SOLD_OUT"

  self.talk_index = 0
  self.talks = {}
  self.talks_texts = {}
  self.max_talks = 4

  self.exiting = false
  self.leaving = false

  self.timer = Timer:new()

  self:updateHeartPosition()

  return self
end

--- Gets the shop's id
--- @return string
function Shop:getId()
  return self.id
end

--- Gets the shop's background
--- @return Dummy.Sprite
function Shop:getBackground()
  return self.background_sprite
end

--- Sets the shop's background
--- @param background string
function Shop:setBackground(background)
  self.background_sprite:setSprite(background)
end

--- Gets the shop's music
--- @return love.Source
function Shop:getMusic()
  return self.music
end

--- Sets the shop's music
--- @param music string
function Shop:setMusic(music)
  self.music = Assets.playMusic(music)
  self.music:setVolume(0.8)
end

--- Gets the buy action labels
--- @return Dummy.Text.Text yes, Dummy.Text.Text no
function Shop:getBuyActionLabels()
  return self.buy_action_confirm_yes_text:getText(), self.buy_action_confirm_no_text:getText()
end

--- Sets the buy action labels
--- @param yes Dummy.Text.Text
--- @param no Dummy.Text.Text
function Shop:setBuyActionLabels(yes, no)
  self.buy_action_confirm_yes_text:setText(yes)
  self.buy_action_confirm_no_text:setText(no)
end

--- Gets the sell action labels
--- @return Dummy.Text.Text yes, Dummy.Text.Text no
function Shop:getSellActionLabels()
  return self.sell_action_confirm_yes_text:getText(), self.sell_action_confirm_no_text:getText()
end

--- Sets the sell action labels
--- @param yes Dummy.Text.Text
--- @param no Dummy.Text.Text
function Shop:setSellActionLabels(yes, no)
  self.sell_action_confirm_yes_text:setText(yes)
  self.sell_action_confirm_no_text:setText(no)
end

--- Gets the buy sold out labels
--- @return Dummy.Text.Text name, Dummy.Text.Text description
function Shop:getBuySoldOutLabels()
  return self.buy_sold_out_text, self.buy_description_sold_out_text
end

--- Sets the buy sold out labels
--- @param name Dummy.Text.Text
--- @param description Dummy.Text.Text
function Shop:setBuySoldOutLabels(name, description)
  self.buy_sold_out_text = name
  self.buy_description_sold_out_text = description
end

--- Gets the sell sold out label
--- @return Dummy.Text.Text buy
function Shop:getSellSoldOutLabel()
  return self.sell_sold_out_text
end

--- Sets the sell sold out label
--- @param name Dummy.Text.Text
function Shop:setSellSoldOutLabel(name)
  self.sell_sold_out_text = name
end

--- Gets the sell confirm text
--- @return Dummy.Text.Text
function Shop:getSellConfirmText()
  return self.sell_confirm_text:getText()
end

--- Sets the sell confirm text
--- @param text Dummy.Text.Text
function Shop:setSellConfirmText(text)
  self.sell_confirm_text:setText(text)
end

--- Gets the heart sprite
--- @return Dummy.Sprite
function Shop:getHeartSprite()
  return self.heart_sprite
end

--- Gets all items available to buy in the shop
--- @return Dummy.Shop.ItemStock[]
function Shop:getItems()
  return self.items_to_buy
end

--- Adds an item to the shop
--- @param ItemClass Dummy.Item
--- @param stock? integer the amount of items the shop has in stock, `-1` for infinite stock (Defaults to `-1`)
--- @param index? integer
function Shop:addItem(ItemClass, stock, index)
  if #self:getItems() >= self.max_items_to_buy then return end

  --- @type Dummy.Shop.ItemStock
  local item_stock = {
    ---@diagnostic disable-next-line: missing-parameter
    item = ItemClass:new(),
    stock = Utils.getOrDefault(stock, -1)
  }
  table.insert(self.items_to_buy, Utils.getOrDefault(index, #self:getItems() + 1), item_stock)
end

--- Removes an item from the shop
--- @param item integer
function Shop:removeItem(item)
  table.remove(self.items_to_buy, item)
end

--- Gets all talks available in the shop
--- @return Dummy.Shop.Talk[]
function Shop:getTalks()
  return self.talks
end

--- Adds a talk to the shop
--- @param name Dummy.Text.Text
--- @param texts Dummy.Text.Text[]
--- @param index? integer
function Shop:addTalk(name, texts, index)
  if #self:getTalks() >= self.max_talks then return end

  --- @type Dummy.Shop.Talk
  local talk = {
    name = name,
    texts = table.copy(texts)
  }
  table.insert(self.talks, Utils.getOrDefault(index, #self:getTalks() + 1), talk)
end

--- Removes a talk from the shop
--- @param index integer
function Shop:removeTalk(index)
  table.remove(self.talks, index)
end

--- Called when the main dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
function Shop:onMainDialogue(menu) end

--- Called when the side dialogue should dialogue
--- @param menu Dummy.Shop.MenuType
--- @param old_menu Dummy.Shop.MenuType|nil
function Shop:onSideDialogue(menu, old_menu) end

--- Gets the main dialogue text
--- @return Dummy.DialogueText
function Shop:getMainDialogueText()
  return self.main_dialogue_text
end

--- Plays a shop's dialogue
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playDialogue(text, ...)
  self.playing_full = false
  self.main_dialogue_text:setText(text, ...)
  self.main_dialogue_text:setVisible(true)
  return self.main_dialogue_text
end

--- Plays a shop's dialogue on the full width
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playDialogueFull(text, ...)
  self.playing_full = true
  self.main_dialogue_text:setText(text, ...)
  self.main_dialogue_text:setVisible(true)
  self.menu_container:setVisible(false)
  self.side_container:setVisible(false)
  self.item_info_container:setVisible(false)
  self.heart_sprite:setVisible(false)
  return self.main_dialogue_text
end

--- Gets the side dialogue text
--- @return Dummy.DialogueText
function Shop:getSideDialogueText()
  return self.side_dialogue_text
end

--- Plays a shop's side dialogue
--- @param text Dummy.Text.Text
--- @param ... Dummy.Text.Text
--- @return Dummy.DialogueText
function Shop:playSideDialogue(text, ...)
  self.playing_full = false
  self.side_dialogue_text:setText(text, ...)
  self.side_dialogue_text:setVisible(true)
  return self.side_dialogue_text
end

--- Shows the menu texts
--- @param texts_list Dummy.Text[]
--- @param actual_length integer
function Shop:showMenuTexts(texts_list, actual_length)
  local total_texts = #texts_list
  if total_texts > actual_length then
    for _ = 1, total_texts - actual_length do
      texts_list[1]:remove()
      table.remove(texts_list, 1)
    end
  elseif total_texts < actual_length then
    for _ = 1, actual_length - total_texts do
      local text = Text:new()
      text:setOrigin(0, 0.5)
      text:setFont("main_text")
      text:setParent(self.menu_container)

      table.insert(texts_list, text)
    end
  end

  self:updateMenuTexts()
end

--- Hides the menu texts
function Shop:hideMenuTexts()
  for _, text in ipairs(self.items_buy_texts) do
    text:setVisible(false)
  end

  for _, text in ipairs(self.items_sell_texts) do
    text:setVisible(false)
  end
  for _, text in ipairs(self.items_sell_sold_out_texts) do
    text:setVisible(false)
  end

  for _, text in ipairs(self.talks_texts) do
    text:setVisible(false)
  end
end

--- Updates the shop's menu texts
function Shop:updateMenuTexts()
  self.player_gold_text:setText({ "WORLD_SHOP_INFO_GOLD", Player.getGold() })
  self.player_stock_text:setText(#Player.getItems() .. "/" .. Player.getMaxItems())

  if self.current_menu == "buy" then
    local font = self.items_buy_texts[1]:getFont()
    local max_price_width = 0
    for _, item_stock in ipairs(self:getItems()) do
      max_price_width = math.max(font:getWidth(tostring(item_stock.item:getBuyPrice())), max_price_width)
    end

    for i, item_stock in ipairs(self:getItems()) do
      local offset_x = 0
      if item_stock.stock == 0 then
        self.items_buy_texts[i]:setText(self.buy_sold_out_text)
        self.items_buy_texts[i]:setColor(0.5, 0.5, 0.5)
      else
        offset_x = max_price_width - font:getWidth(tostring(item_stock.item:getBuyPrice()))
        local value = Lang.translate({ "WORLD_SHOP_ITEM_NAME", item_stock.item:getBuyPrice(), item_stock.item:getName() })
        self.items_buy_texts[i]:setText(value)
        self.items_buy_texts[i]:setColor(1, 1, 1)
      end
      self.items_buy_texts[i]:setPosition(30 + offset_x, 138 + 20 * (i - 1))
      self.items_buy_texts[i]:setVisible(true)
    end
  elseif self.current_menu == "sell" and #self.items_sell_texts > 0 then
    local font = self.items_sell_texts[1]:getFont()
    local max_price_width_left = 0
    local max_price_width_right = 0
    for i, item in ipairs(Player.getItems()) do
      if i % 2 == 0 then
        max_price_width_left = math.max(font:getWidth(tostring(item:getSellPrice())), max_price_width_left)
      else
        max_price_width_right = math.max(font:getWidth(tostring(item:getSellPrice())), max_price_width_right)
      end
    end

    for index, item in ipairs(Player.getItems()) do
      local offset_x = 0
      if index % 2 == 0 then
        offset_x = max_price_width_left - font:getWidth(tostring(item:getSellPrice()))
      else
        offset_x = max_price_width_right - font:getWidth(tostring(item:getSellPrice()))
      end
      local value = Lang.translate({ "WORLD_SHOP_ITEM_NAME", item:getSellPrice(), item:getShortName() })
      self.items_sell_texts[index]:setText(value)
      self.items_sell_texts[index]:setColor(1, 1, 1)
      local i = (index - 1) % 2
      local j = math.floor((index - 1) / 2)
      self.items_sell_texts[index]:setPosition(30 + 140 * i + offset_x, 138 + 20 * j)
      self.items_sell_texts[index]:setVisible(true)
    end
    self.sell_player_gold_text:setText({ "WORLD_SHOP_SELL_INFO_GOLD", Player.getGold() })

    if #self.items_sell_sold_out_texts == self.items_sell_sold_out_total then
      for n = 1, self.items_sell_sold_out_total do
        local offset_x = 0
        local index = 8 - (n - 1)
        if index % 2 == 0 then
          offset_x = max_price_width_left
        else
          offset_x = max_price_width_right
        end
        self.items_sell_sold_out_texts[n]:setText(self.sell_sold_out_text)
        self.items_sell_sold_out_texts[n]:setColor(0.5, 0.5, 0.5)
        local i = (index - 1) % 2
        local j = math.floor((index - 1) / 2)
        self.items_sell_sold_out_texts[n]:setPosition(30 + 140 * i + offset_x, 138 + 20 * j)
        self.items_sell_sold_out_texts[n]:setVisible(true)
      end
    end
  elseif self.current_menu == "talk" then
    for i, talk in ipairs(self:getTalks()) do
      self.talks_texts[i]:setText(talk.name)
      self.talks_texts[i]:setPosition(30, 138 + 20 * (i - 1))
      self.talks_texts[i]:setVisible(true)
    end
  end
end

--- Updates the shop's menu heart position
function Shop:updateHeartPosition()
  if self.playing_full then return end

  local x, y = 0, 0
  local ox, oy = -10.5, 1.5

  if self.current_menu == "main" then
    if self.action_index == 0 then
      x, y = self.buy_action_text:getPosition()
    elseif self.action_index == 1 then
      x, y = self.sell_action_text:getPosition()
    elseif self.action_index == 2 then
      x, y = self.talk_action_text:getPosition()
    elseif self.action_index == 3 then
      x, y = self.exit_action_text:getPosition()
    end
  elseif self.current_menu == "buy" and #self:getItems() > 0 then
    if self.item_buy_index == #self.items_buy_texts then
      x, y = self.menu_exit_text:getPosition()
    else
      x = 30
      _, y = self.items_buy_texts[self.item_buy_index + 1]:getPosition()
    end
  elseif self.current_menu == "buy:confirm" then
    if self.item_buy_action_index == 0 then
      x, y = self.buy_action_confirm_yes_text:getPosition()
    elseif self.item_buy_action_index == 1 then
      x, y = self.buy_action_confirm_no_text:getPosition()
    end
    oy = 0.5
  elseif self.current_menu == "sell" and #Player.getItems() > 0 then
    if self.item_sell_index == -1 or #Player.getItems() <= 0 then
      x, y = self.menu_exit_text:getPosition()
    else
      if self.item_sell_index % 2 == 0 then
        x = 30
      else
        x = 170
      end
      _, y = self.items_sell_texts[self.item_sell_index + 1]:getPosition()
    end
    oy = 0.5
  elseif self.current_menu == "sell:confirm" then
    if self.item_sell_action_index == 0 then
      x, y = self.sell_action_confirm_yes_text:getPosition()
    elseif self.item_sell_action_index == 1 then
      x, y = self.sell_action_confirm_no_text:getPosition()
    end
  elseif self.current_menu == "talk" then
    if self.talk_index == #self.talks_texts then
      x, y = self.menu_exit_text:getPosition()
    else
      x, y = self.talks_texts[self.talk_index + 1]:getPosition()
    end
  end

  self.heart_sprite:setPosition(x + ox, y + oy)
  self.heart_sprite:setVisible(true)
end

--- Toggles the actions
--- @param visible boolean
function Shop:toggleActions(visible)
  self.main_dialogue_text:setVisible(visible)
  self.side_dialogue_text:setVisible(not visible)
  self.buy_action_text:setVisible(visible)
  self.sell_action_text:setVisible(visible)
  self.talk_action_text:setVisible(visible)
  self.exit_action_text:setVisible(visible)
end

--- Updates the buy item info
function Shop:updateBuyItemInfo()
  local item_stock = self:getSelectedItemToBuy()
  if item_stock == nil or item_stock.item == nil then return end

  --- @type Dummy.Text.Text
  local sold_out_text = "WORLD_SHOP_ITEM_BUY_DESCRIPTION_SOLD_OUT"
  if item_stock.stock ~= 0 then
    local desc = item_stock.item:getShopDescription()
    if desc ~= nil then
      if item_stock.item:is(ItemEquipment) then
        local equipement = item_stock.item --[[@as Dummy.Item.Equipment]]
        --- @type number|string
        local diff = 0
        if equipement:getType() == "weapon" then
          diff = equipement:getValue() - Player.getWeapon():getValue()
        elseif equipement:getType() == "armor" then
          diff = equipement:getValue() - Player.getArmor():getValue()
        end
        if diff >= 0 then
          diff = "+" .. diff
        end
        sold_out_text = { desc, diff }
      else
        sold_out_text = desc
      end
    end
  end
  self.item_info_text:setText(sold_out_text)
end

--- Gets the selected item to buy
--- @return Dummy.Shop.ItemStock
function Shop:getSelectedItemToBuy()
  return self:getItems()[self.item_buy_index + 1]
end

--- Gets the selected item to sell
--- @return Dummy.Item
function Shop:getSelectedItemToSell()
  return Player.getItems()[self.item_sell_index + 1]
end

--- Changes the selected action
--- @param delta integer
function Shop:changeAction(delta)
  local new_index = (self.action_index + delta + self.total_actions) % self.total_actions

  if self.action_index == new_index then return end
  self.action_index = new_index

  self:updateHeartPosition()
end

--- Does an action on the selected action
function Shop:doActionOnSelectedAction()
  if self.action_index == 0 and #self:getItems() > 0 then
    self:changeMenu("buy")
  elseif self.action_index == 1 then
    self:changeMenu("sell")
  elseif self.action_index == 2 and #self:getTalks() > 0 then
    self:changeMenu("talk")
  elseif self.action_index == 3 then
    self:exit()
  end
end

--- Changes the current menu
--- @param menu Dummy.Shop.MenuType
--- @param keep_index? boolean
function Shop:changeMenu(menu, keep_index)
  self.previous_menu = self.current_menu
  self.current_menu = menu

  self.playing_full = false
  self:toggleActions(menu == "main")

  if type(self.onMainDialogue) == "function" then
    self:onMainDialogue(menu)
  end

  if menu == "main" then
    self.main_dialogue_text:reset()
    self.menu_container:setVisible(false)
    self.side_container:setVisible(true)
    self.buy_action_confirm_yes_text:setVisible(false)
    self.buy_action_confirm_no_text:setVisible(false)
    self.item_info_container:setVisible(false)
    self.items_sell_sold_out_total = 0
    self:showMenuTexts(self.items_sell_sold_out_texts, 0)
    self:hideMenuTexts()
  elseif menu == "buy" then
    if keep_index ~= true then
      self.item_buy_index = 0
    end
    self:loadMenuBuy()
  elseif menu == "buy:confirm" then
    if keep_index ~= true then
      self.item_buy_action_index = 0
    end
    self:loadMenuBuyConfirm()
  elseif menu == "sell" and not self.main_dialogue_text:isVisible() then
    if keep_index ~= true then
      self.item_sell_index = 0
    end
    self:loadMenuSell()
  elseif menu == "sell:confirm" then
    if keep_index ~= true then
      self.item_sell_action_index = 0
    end
    self:loadMenuSellConfirm()
  elseif menu == "talk" then
    if keep_index ~= true then
      self.talk_index = 0
    end
    self:loadMenuTalk()
  end

  self:updateHeartPosition()
end

--- Initializes the menu buy
function Shop:loadMenuBuy()
  self:showMenuTexts(self.items_buy_texts, #self:getItems())
  self:updateBuyItemInfo()
  self:updateHeartPosition()
  self.main_dialogue_text:setVisible(false)
  self.menu_container:setVisible(true)
  self.buy_action_confirm_yes_text:setVisible(false)
  self.buy_action_confirm_no_text:setVisible(false)
  self.sell_player_gold_text:setVisible(false)
  self.sell_confirm_text:setVisible(false)
  self.sell_action_confirm_yes_text:setVisible(false)
  self.sell_action_confirm_no_text:setVisible(false)
  self.side_container:setVisible(true)
  self.side_dialogue_text:reset()
  self.item_info_container:setVisible(true)
  self:slideItemInfo()

  if type(self.onSideDialogue) == "function" then
    self:onSideDialogue("buy", self.previous_menu)
  end
end

--- Initializes the menu buy confirm
function Shop:loadMenuBuyConfirm()
  self.menu_container:setVisible(true)
  self.buy_action_confirm_yes_text:setVisible(true)
  self.buy_action_confirm_no_text:setVisible(true)

  local item_stock = self:getSelectedItemToBuy()
  self:playSideDialogue({ "WORLD_SHOP_ITEM_BUY_SIDE", item_stock.item:getBuyPrice() })

  if type(self.onSideDialogue) == "function" then
    self:onSideDialogue("buy:confirm", self.previous_menu)
  end
end

--- Initializes the menu sell
function Shop:loadMenuSell()
  if #Player.getItems() <= 0 then
    self.item_sell_index = -1
  end

  self:showMenuTexts(self.items_sell_texts, #Player.getItems())
  self:showMenuTexts(self.items_sell_sold_out_texts, self.items_sell_sold_out_total)
  self:updateHeartPosition()
  self.main_dialogue_text:setVisible(false)
  self.menu_container:setVisible(true)
  self.sell_player_gold_text:setVisible(true)
  self.sell_confirm_text:setVisible(false)
  self.sell_action_confirm_yes_text:setVisible(false)
  self.sell_action_confirm_no_text:setVisible(false)
  self.menu_exit_text:setVisible(true)
  self.side_container:setVisible(false)
end

--- Initializes the menu sell confirm
function Shop:loadMenuSellConfirm()
  self:hideMenuTexts()
  self.menu_container:setVisible(true)
  self.sell_confirm_text:setVisible(true)
  self.sell_action_confirm_yes_text:setVisible(true)
  self.sell_action_confirm_no_text:setVisible(true)
  self.menu_exit_text:setVisible(false)
end

--- Initializes the menu talk
function Shop:loadMenuTalk()
  self:showMenuTexts(self.talks_texts, #self:getTalks())
  self:updateHeartPosition()
  self.main_dialogue_text:setVisible(false)
  self.menu_container:setVisible(true)
  self.buy_action_confirm_yes_text:setVisible(false)
  self.buy_action_confirm_no_text:setVisible(false)
  self.sell_player_gold_text:setVisible(false)
  self.sell_confirm_text:setVisible(false)
  self.sell_action_confirm_yes_text:setVisible(false)
  self.sell_action_confirm_no_text:setVisible(false)
  self.menu_exit_text:setVisible(true)
  self.side_container:setVisible(true)
  self.side_dialogue_text:reset()

  if type(self.onSideDialogue) == "function" then
    self:onSideDialogue("talk", self.previous_menu)
  end
end

--- Changes the selected item to buy
--- @param delta integer
function Shop:changeItemToBuy(delta)
  local max_items = math.min(#self.items_buy_texts, self.max_items_to_buy) + 1
  local new_index = (self.item_buy_index + delta + max_items) % max_items

  if self.item_buy_index == new_index then return end
  self.item_buy_index = new_index

  self:updateHeartPosition()
  self:updateBuyItemInfo()

  if self.item_buy_index == #self.items_buy_texts then
    if self.item_info_timer ~= nil then
      self.timer:cancel(self.item_info_timer)
      self.item_info_timer = nil
    end
    self.item_info_container["move_y"] = 120
  elseif self.item_info_container["move_y"] == 120 then
    self:slideItemInfo()
  end
end

--- Does an action on the selected item to buy
function Shop:doActionOnSelectedItemToBuy()
  -- exit
  if self.item_buy_index == #self.items_buy_texts then
    self:changeMenu("main")
  else
    local item_stock = self:getSelectedItemToBuy()
    if item_stock.stock == 0 then
      self:changeMenu("buy", true)

      if type(self.onBuyItem) == "function" then
        self:onBuyItem(item_stock.item, false, false, true)
      end
    else
      self:changeMenu("buy:confirm")
    end
  end
end

--- Changes the selected item to buy action
--- @param delta integer
function Shop:changeItemToBuyAction(delta)
  local new_index = (self.item_buy_action_index + delta + 2) % 2

  if self.item_buy_action_index == new_index then return end
  self.item_buy_action_index = new_index

  self:updateHeartPosition()
end

--- Does an action on the selected item to buy action
function Shop:doActionOnSelectedItemToBuyAction()
  if self.item_buy_action_index == 0 then
    self:changeMenu("buy", true)
    self:buyItem()
  elseif self.item_buy_action_index == 1 then
    self:changeMenu("buy", true)
  end
end

--- Buys the selected item
function Shop:buyItem()
  local item_stock = self:getSelectedItemToBuy()
  local sold_out = item_stock.stock == 0
  local not_enough_gold = Player.getGold() < item_stock.item:getBuyPrice()
  local inventory_full = #Player.getItems() >= Player.getMaxItems()

  if not sold_out and not not_enough_gold and not inventory_full then
    Player.addItem(item_stock.item)
    if item_stock.stock > 0 then
      item_stock.stock = item_stock.stock - 1
    end
    Player.setGold(Player.getGold() - item_stock.item:getBuyPrice())
    Assets.playSound("buy_item")
    self:updateMenuTexts()
    self:updateBuyItemInfo()
  end

  if type(self.onBuyItem) == "function" then
    self:onBuyItem(item_stock.item, not_enough_gold, inventory_full, sold_out)
  end
end

--- Changes the selected item to sell
--- @param delta_x integer
--- @param delta_y integer
function Shop:changeItemToSell(delta_x, delta_y)
  if #Player.getItems() <= 0 then return end

  local i = self.item_sell_index % 2
  local j = math.floor(self.item_sell_index / 2)
  i = math.clamp(i + delta_x, 0, 1)
  j = math.clamp(j + delta_y, 0, 4)
  local new_index = i + 2 * j

  if self.item_sell_index == -1 then
    if delta_y ~= -1 then return end
    if #self.items_sell_texts % 2 == 0 then
      new_index = #self.items_sell_texts - 2
    else
      new_index = #self.items_sell_texts - 1
    end
  elseif new_index == #self.items_sell_texts then
    if i == 1 then
      new_index = #self.items_sell_texts - 1
    else
      new_index = -1
    end
  elseif new_index > #self.items_sell_texts then
    if delta_y ~= 1 then return end
    new_index = -1
  end

  if self.item_sell_index == new_index then return end
  self.item_sell_index = new_index

  self:updateHeartPosition()
end

--- Does an action on the selected item to sell
function Shop:doActionOnSelectedItemToSell()
  -- exit
  if self.item_sell_index == -1 then
    self:changeMenu("main")
  else
    self:changeMenu("sell:confirm")
  end
end

--- Changes the selected item to sell action
--- @param delta integer
function Shop:changeItemToSellAction(delta)
  local new_index = (self.item_sell_action_index + delta + 2) % 2

  if self.item_sell_action_index == new_index then return end
  self.item_sell_action_index = new_index

  self:updateHeartPosition()
end

--- Does an action on the selected item to sell action
function Shop:doActionOnSelectedItemToSellAction()
  if self.item_sell_action_index == 0 then
    self:sellItem()
    if #Player.getItems() <= 0 then
      self:changeMenu("main")
    else
      self:changeMenu("sell", true)
    end
  elseif self.item_sell_action_index == 1 then
    self:changeMenu("sell", true)
  end
end

--- Sells the selected item
function Shop:sellItem()
  local selected_item = self:getSelectedItemToSell()
  Player.setGold(Player.getGold() + selected_item:getSellPrice())
  Player.removeItem(selected_item)
  Assets.playSound("buy_item")

  self.item_sell_index = math.clamp(self.item_sell_index, 0, #Player.getItems() - 1)
  self.items_sell_sold_out_total = self.items_sell_sold_out_total + 1
  self:updateMenuTexts()

  if type(self.onSellItem) == "function" then
    self:onSellItem(selected_item)
  end
end

--- Changes the selected talk
--- @param delta integer
function Shop:changeTalk(delta)
  local max_talks = math.min(#self.talks_texts, self.max_talks) + 1
  local new_index = (self.talk_index + delta + max_talks) % max_talks

  if self.talk_index == new_index then return end
  self.talk_index = new_index

  self:updateHeartPosition()
end

--- Does an action on the selected talk
function Shop:doActionOnSelectedTalk()
  -- exit
  if self.talk_index == #self.talks_texts then
    self:changeMenu("main")
  else
    self.side_container:setVisible(false)
    self.menu_container:setVisible(false)
    self.heart_sprite:setVisible(false)
    self:playDialogue(table.unpack(self.talks[self.talk_index + 1].texts))
  end
end

--- Slides the item info box in view
function Shop:slideItemInfo()
  if self.item_info_timer ~= nil then return end

  self.item_info_timer = self.timer:tween(0.5, self.item_info_container, { move_y = 39 }, "out-quad", function()
    self.item_info_container["move_y"] = 39
    self.item_info_timer = nil
  end)
end

--- Exits the shop
function Shop:exit()
  self.exiting = true
  self.menu_container:setVisible(false)
  self.side_container:setVisible(false)
  self.heart_sprite:setVisible(false)

  if type(self.onExit) == "function" then
    self:onExit()
  end
end

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
function Shop:remove()
  if self:isRemoved() then return end

  Drawable.remove(self)

  self.item_info_container:remove()
end

--- Draws the shop
--- @param camera Dummy.Camera
function Shop:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getWidth(), self:getHeight()

  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 120, width, height)
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 4, 124, width - 7, height - 7)

  if self.side_container:isVisible() then
    -- separator
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 210, 120, 4, height)
  end

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Handles the menu actions
function Shop:handleMenuActions()
  if self.playing_full then return end

  if self.current_menu == "main" then
    if Input.isPressed(Input.Up) then
      self:changeAction(-1)
    elseif Input.isPressed(Input.Down) then
      self:changeAction(1)
    elseif Input.isPressed(Input.Confirm) then
      self:doActionOnSelectedAction()
    end
  elseif self.current_menu == "buy" then
    if self.menu_container:isVisible() then
      if Input.isPressed(Input.Up) then
        self:changeItemToBuy(-1)
      elseif Input.isPressed(Input.Down) then
        self:changeItemToBuy(1)
      elseif Input.isPressed(Input.Confirm) then
        self:doActionOnSelectedItemToBuy()
      elseif Input.isPressed(Input.Cancel) then
        self:changeMenu("main")
      end
    elseif self.main_dialogue_text:isDone() then
      self:loadMenuBuy()
    end
  elseif self.current_menu == "buy:confirm" then
    if Input.isPressed(Input.Up) then
      self:changeItemToBuyAction(-1)
    elseif Input.isPressed(Input.Down) then
      self:changeItemToBuyAction(1)
    elseif Input.isPressed(Input.Confirm) then
      self:doActionOnSelectedItemToBuyAction()
    elseif Input.isPressed(Input.Cancel) then
      self:changeMenu("buy", true)
    end
  elseif self.current_menu == "sell" then
    if self.menu_container:isVisible() then
      if Input.isPressed(Input.Left) then
        self:changeItemToSell(-1, 0)
      elseif Input.isPressed(Input.Right) then
        self:changeItemToSell(1, 0)
      elseif Input.isPressed(Input.Up) then
        self:changeItemToSell(0, -1)
      elseif Input.isPressed(Input.Down) then
        self:changeItemToSell(0, 1)
      elseif Input.isPressed(Input.Confirm) then
        self:doActionOnSelectedItemToSell()
      elseif Input.isPressed(Input.Cancel) then
        self:changeMenu("main")
      end
    elseif self.main_dialogue_text:isDone() then
      self:loadMenuSell()
    end
  elseif self.current_menu == "sell:confirm" then
    if Input.isPressed(Input.Left) then
      self:changeItemToSellAction(-1)
    elseif Input.isPressed(Input.Right) then
      self:changeItemToSellAction(1)
    elseif Input.isPressed(Input.Confirm) then
      self:doActionOnSelectedItemToSellAction()
    elseif Input.isPressed(Input.Cancel) then
      self:changeMenu("sell", true)
    end
  elseif self.current_menu == "talk" then
    if self.menu_container:isVisible() then
      if Input.isPressed(Input.Up) then
        self:changeTalk(-1)
      elseif Input.isPressed(Input.Down) then
        self:changeTalk(1)
      elseif Input.isPressed(Input.Confirm) then
        self:doActionOnSelectedTalk()
      elseif Input.isPressed(Input.Cancel) then
        self:changeMenu("main")
      end
    elseif self.main_dialogue_text:isDone() then
      self:loadMenuTalk()
    end
  end
end

--- Updates the shop, called on every game update
--- @param dt number
function Shop:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.leaving then return end

  if self.exiting and self.main_dialogue_text:isDone() then
    self.leaving = true
    Assets.fadeOutMusic(40 / 30, self:getMusic())
    Fader.fadeIn(12 / 30, "linear")
    Timer.after(40 / 30, function()
      Scene.change("WORLD", ModList.getCurrentMod())
    end)
  elseif self.playing_full and self.main_dialogue_text:isDone() then
    self.playing_full = false
    Timer.next(function()
      self:changeMenu("main")
    end)
  end

  if self.exiting then return end

  if self.item_info_container:isVisible() then
    self.timer:update(dt)
    local x = self.item_info_container:getPosition()
    self.item_info_container:setPosition(x, self.item_info_container["move_y"])
  end

  self:handleMenuActions()
end

return Shop
