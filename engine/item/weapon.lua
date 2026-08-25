--- @class Dummy.Item.Weapon : Dummy.Item
---
--- @field protected value number
--- @field protected equip_sound string|nil
--- @field protected crit number
--- @field protected target_bars Dummy.Sprite[]
--- @field protected strike_sprite Dummy.Sprite|nil
local WeaponItem = Class(Item, "Dummy.Item.Weapon")

--- Creates a weapon item
--- @param id string
--- @param name Dummy.Text.Text
--- @param short_name Dummy.Text.Text
--- @param description Dummy.Text.Text
--- @param value number
--- @return Dummy.Item.Weapon
function WeaponItem:new(id, name, short_name, description, value)
  self = Class:new(WeaponItem, { id, name, short_name, description })

  self.value = value
  self.equip_sound = "equip"
  self.crit = 2.2

  return self
end

--- Gets the weapon's value
--- @return number
function WeaponItem:getValue()
  return self.value
end

--- Sets the weapon's value
--- @param value number
function WeaponItem:setValue(value)
  self.value = value
end

--- Gets the weapon's equip sound
--- @return string|nil
function WeaponItem:getEquipSound()
  return self.equip_sound
end

--- Sets the weapon's equip sound
--- @param equip_sound string|nil
function WeaponItem:setEquipSound(equip_sound)
  self.equip_sound = equip_sound
end

--- Gets the weapon's critical bonus factor
--- @return number
function WeaponItem:getCrit()
  return self.crit
end

--- Sets the weapon's critical bonus factor
--- @param crit number
function WeaponItem:setCrit(crit)
  self.crit = crit
end

--- Gets the weapon's dialogue texts
--- @return Dummy.Text.Text[]
function WeaponItem:getDialogueTexts()
  local texts = self:getUseTexts()
  if #texts <= 0 then
    texts = { { "ITEM_ACTION_EQUIPMENT_USE", Lang.translate(self:getName()) } }
  end
  return texts
end

--- Uses the weapon item
function WeaponItem:use()
  local can_use = true
  if type(self.onBeforeUse) == "function" then
    can_use = self:onBeforeUse()
  end
  if not can_use then return end

  local texts = self:getDialogueTexts()
  if World.isInBattle() then
    Battle.playDialogueText(table.unpack(texts))
  else
    World.playDialogue(texts)
  end
  Player.removeItem(self)

  local equip_sound = self:getEquipSound()
  if equip_sound ~= nil then
    Assets.playSound(equip_sound)
  end

  local weapon = Player.getWeapon()
  Player.addItem(weapon)
  if type(weapon.onUnequip) == "function" then
    weapon:onUnequip()
  end

  Player.setWeapon(self)

  if type(self.onUse) == "function" then
    self:onUse()
  end
end

--- Called when the weapon is unequipped
function WeaponItem:onUnequip() end

--- Called when the weapon is used to attack in battle
---
--- Note: this is the default behavior (stick), you can override it
function WeaponItem:onAttackStart()
  local enemy = Battle.getSelectedEnemy()
  if enemy == nil then return end

  local target_bar = Sprite:new({ "target_bar1", "target_bar2" }, 0.1, nil, false)
  target_bar:setVisible(false)
  target_bar:setLayer(Constants.LAYERS.ABOVE_UI)
  target_bar:setPosition(22, 320)
  target_bar:setVisible(true)
  target_bar:stop()
  target_bar:setFrame(1)
  self.target_bars = { target_bar }

  local bars = table.copy(self.target_bars)

  --- @type Dummy.Timer.Handle
  local attack_window_timer
  local bar_speed = 11 + (love.math.random() * 2)

  attack_window_timer = Timer.during(4, function(dt)
    local target_sprite = Battle.getTargetSprite()
    local target_x = target_sprite:getPosition()
    local width = target_sprite:getWidth()

    for _, bar in ipairs(bars) do
      local x, y = bar:getPosition()
      local bar_x = x + bar_speed * dt * 30
      bar:setPosition(bar_x, y)

      if bar_x > target_x + width / 2 then
        Timer.cancel(attack_window_timer)

        if #bars < #self.target_bars then
          self:attack()
        else
          Battle.proceedAttack(enemy, 0, true)
        end
      end
    end

    if Input.isPressed(Input.Confirm) then
      if #bars > 0 then
        table.remove(bars, 1)

        if #bars <= 0 then
          Timer.cancel(attack_window_timer)
          self:attack()
        end
      end
    end
  end, function()
    Battle.proceedAttack(enemy, 0, true)
  end)
end

--- Attacks the enemy
function WeaponItem:attack()
  if not World.isInBattle() then return end

  -- strike
  self.strike_sprite = Sprite:new({
    "strike1",
    "strike2",
    "strike3",
    "strike4",
    "strike5",
    "strike6"
  }, 4 / 30, false, false, false)
  self.strike_sprite:setOrigin(0.5, 0.5)
  self.strike_sprite:setScale(1.5)
  self.strike_sprite:setVisible(false)
  self.strike_sprite:setLayer(Constants.LAYERS.ABOVE_UI)

  local enemy = Battle.getSelectedEnemy()
  if enemy == nil then return end

  if type(enemy.onBeforeAttack) == "function" then
    enemy:onBeforeAttack()
  end

  local target_sprite = Battle.getTargetSprite()
  local target_x = target_sprite:getPosition()
  local target_width = target_sprite:getWidth()
  local target_bar = self.target_bars[1]
  local target_bar_x = target_bar:getPosition()
  local bonus_factor = math.abs(target_x - target_bar_x)
  local stretch = (target_width - bonus_factor) / target_width
  local damage = math.max(0, Player.getAT() - enemy:getDF() + (love.math.random() * 2))
  if bonus_factor <= 12 then
    damage = math.round(damage * self:getCrit())
  else
    damage = math.round(damage * 2 * stretch)
  end

  local enemy_x, enemy_y = enemy:getPosition()
  local enemy_width, enemy_height = enemy:getWidth(), enemy:getHeight()
  local enemy_origin_x, enemy_origin_y = enemy:getOrigin()
  local enemy_scale_x, enemy_scale_y = enemy:getScale()
  local enemy_center_x = enemy_x + (0.5 - enemy_origin_x) * enemy_width * enemy_scale_x
  local enemy_center_y = enemy_y + (0.5 - enemy_origin_y) * enemy_height * enemy_scale_y
  self.strike_sprite:setPosition(enemy_center_x, enemy_center_y)

  self.strike_sprite:setVisible(true)
  self.strike_sprite:setScale(stretch * 2 - 0.5)
  local strike_speed_base = 0.5 - stretch / 4
  local strike_speed = 1 / (strike_speed_base * 30)
  self.strike_sprite:setSpeed(strike_speed)
  self.strike_sprite:play()
  target_bar:play()
  Assets.playSound("strike")
  local damage_delay = (1 / strike_speed_base * 6 + 3) / 30
  Timer.after(damage_delay, function()
    Battle.proceedAttack(enemy, damage, false)
  end)
end

--- Called when the weapon is used to attack in battle
---
--- Note: called when the attack animation ends
function WeaponItem:onAttackEnd()
  if self.target_bars ~= nil then
    for _, target_bar in ipairs(self.target_bars) do
      target_bar:remove()
    end
    self.target_bars = {}
  end

  if self.strike_sprite ~= nil then
    self.strike_sprite:remove()
  end
end

return WeaponItem
