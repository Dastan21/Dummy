--- @class Item.ToyKnife : Dummy.Item.Equipment
local ToyKnifeItem = Class(ItemEquipment, "Item.ToyKnife")

--- Creates a toy knife
--- @return Item.ToyKnife
function ToyKnifeItem:new()
  self = Class:new(ToyKnifeItem, {
    "toy_knife", -- item identifier
    "ITEM_TOY_KNIFE_NAME", -- item name
    "ITEM_TOY_KNIFE_SHORTNAME", -- item short name
    "ITEM_TOY_KNIFE_DESCRIPTION", -- item descriptions
    3, -- item value (ATK or DEF)
    "weapon" -- item type (armor or weapon)
  })

  -- the price the player will pay to buy the item in the shop
  self:setBuyPrice(1)
  -- the price at which the item will be sold in the shop
  self:setSellPrice(100)
  -- the text that will appear in the shop item info at the top right on the buy menu when hovering an item
  self:setShopDescription("ITEM_TOY_KNIFE_DESCRIPTION_SHOP")
  -- the text that will appear when the item is used
  --self:setUseText("ITEM_TOY_KNIFE_USE")

  return self
end

--[[ function ToyKnifeItem:GetAttackEffect()

  local attack_speed = 11 * 1.25
  local style = "left_to_right"
  local rand = love.math.random(2)
  if rand == 1 then
    style = "right_to_left"
  end

  if style == "left_to_right" then
    Battle.target_bar_sprite:setPosition(22, 320)
  else
    Battle.target_bar_sprite:setPosition(592, 320)
  end
  Battle.target_bar_sprite:setVisible(true)
  Battle.target_bar_sprite:stop()
  Battle.target_bar_sprite:setFrame(1)

  local bar_speed = attack_speed + (love.math.random() * 2)
  Battle.attack_window_timer = Timer.during(2, function(dt)
    local x, y = Battle.target_bar_sprite:getPosition()
    local target_bar_x
    if style == "right_to_left" then
      target_bar_x = x - bar_speed * dt * 30
    else
      target_bar_x = x + bar_speed * dt * 30
    end
    Battle.target_bar_sprite:setPosition(target_bar_x, y)

    local target_x = Battle.target_sprite:getPosition()
    local width = Battle.target_sprite:getWidth()
    if style == "left_to_right" and (target_bar_x > target_x + width / 2) then
      Battle.attack(true)
    elseif style == "right_to_left" and (target_bar_x < target_x - width / 2) then
      Battle.attack(true)
    end

    if Input.isPressed(Input.Confirm) then
      Battle.attack()
    end
  end)

  return true
end ]]

return ToyKnifeItem
