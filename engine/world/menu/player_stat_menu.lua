--- @class Dummy.PlayerStatMenu : Dummy.Drawable
---
--- @field protected player_name_text Dummy.Text
--- @field protected player_lv_text Dummy.Text
--- @field protected player_hp_text Dummy.Text
--- @field protected player_at_text Dummy.Text
--- @field protected player_df_text Dummy.Text
--- @field protected player_weapon_text Dummy.Text
--- @field protected player_armor_text Dummy.Text
--- @field protected player_gold_text Dummy.Text
--- @field protected player_exp_text Dummy.Text
--- @field protected player_next_text Dummy.Text
--- @field protected closing boolean
local PlayerStatMenu = Class(Drawable, "Dummy.PlayerStatMenu")

--- Creates a player stat menu
--- @return Dummy.PlayerStatMenu
function PlayerStatMenu:new()
  self = Class:new(PlayerStatMenu)

  self.width = 167
  self.height = 203
  self:setPosition(97, 29)
  self:setVisible(false)

  self.player_name_text = Text:new("", true)
  self.player_name_text:setOrigin(0, 0.5)
  self.player_name_text:setPosition(11, 21)
  self.player_name_text:setFont("main_text")
  self.player_name_text:setParent(self)

  self.player_lv_text = Text:new()
  self.player_lv_text:setOrigin(0, 0.5)
  self.player_lv_text:setPosition(11, 51)
  self.player_lv_text:setFont("main_text")
  self.player_lv_text:setParent(self)

  self.player_hp_text = Text:new()
  self.player_hp_text:setOrigin(0, 0.5)
  self.player_hp_text:setPosition(11, 67)
  self.player_hp_text:setFont("main_text")
  self.player_hp_text:setParent(self)

  self.player_at_text = Text:new()
  self.player_at_text:setOrigin(0, 0.5)
  self.player_at_text:setPosition(11, 99)
  self.player_at_text:setFont("main_text")
  self.player_at_text:setParent(self)

  self.player_df_text = Text:new()
  self.player_df_text:setOrigin(0, 0.5)
  self.player_df_text:setPosition(11, 115)
  self.player_df_text:setFont("main_text")
  self.player_df_text:setParent(self)

  self.player_weapon_text = Text:new()
  self.player_weapon_text:setOrigin(0, 0.5)
  self.player_weapon_text:setPosition(11, 145)
  self.player_weapon_text:setFont("main_text")
  self.player_weapon_text:setParent(self)

  self.player_armor_text = Text:new()
  self.player_armor_text:setOrigin(0, 0.5)
  self.player_armor_text:setPosition(11, 161)
  self.player_armor_text:setFont("main_text")
  self.player_armor_text:setParent(self)

  self.player_gold_text = Text:new()
  self.player_gold_text:setOrigin(0, 0.5)
  self.player_gold_text:setPosition(11, 181)
  self.player_gold_text:setFont("main_text")
  self.player_gold_text:setParent(self)

  self.player_exp_text = Text:new()
  self.player_exp_text:setOrigin(0, 0.5)
  self.player_exp_text:setPosition(95, 99)
  self.player_exp_text:setFont("main_text")
  self.player_exp_text:setParent(self)

  self.player_next_text = Text:new()
  self.player_next_text:setOrigin(0, 0.5)
  self.player_next_text:setPosition(95, 115)
  self.player_next_text:setFont("main_text")
  self.player_next_text:setParent(self)

  self.closing = false

  return self
end

--- Updates the save menu's texts
function PlayerStatMenu:updateTexts()
  self.player_name_text:setText("\"" .. Player.getName() .. "\"")
  self.player_lv_text:setText({ "WORLD_PLAYER_MENU_STAT_LV", Player.getLV() })
  self.player_hp_text:setText({ "WORLD_PLAYER_MENU_STAT_HP", Player.getHP(), Player.getMaxHP() })
  self.player_at_text:setText({ "WORLD_PLAYER_MENU_STAT_AT", Player.getAT() - 10, Player.getWeapon():getValue() })
  self.player_df_text:setText({ "WORLD_PLAYER_MENU_STAT_DF", Player.getDF() - 10, Player.getArmor():getValue() })
  self.player_weapon_text:setText({ "WORLD_PLAYER_MENU_STAT_WEAPON", Player.getWeapon():getName() })
  self.player_armor_text:setText({ "WORLD_PLAYER_MENU_STAT_ARMOR", Player.getArmor():getName() })
  self.player_gold_text:setText({ "WORLD_PLAYER_MENU_STAT_GOLD", Player.getGold() })
  self.player_exp_text:setText({ "WORLD_PLAYER_MENU_STAT_EXP", Player.getEXP() })
  self.player_next_text:setText({ "WORLD_PLAYER_MENU_STAT_NEXT", Player.LV_EXP[Player.getLV() + 1] })
end

--- Opens the player stat menu
function PlayerStatMenu:open()
  self:setVisible(true)
  self:updateTexts()
end

--- Closes the player stat menu
function PlayerStatMenu:close()
  self.closing = true
end

--- Draws the player stat menu
--- @param camera Dummy.Camera
function PlayerStatMenu:draw(camera)
  if not self:isVisible() then return end

  love.graphics.applyTransform(self:getTransform())

  local width, height = self:getWidth(), self:getHeight()

  -- outline
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", -3, -3, width + 6, height + 6)
  -- background
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, width, height)

  self:drawChildren(camera)
  self:drawDebug(camera)
end

--- Updates the player stat menu, called on every game update
--- @param dt number
function PlayerStatMenu:update(dt)
  if not self:isVisible() then return end

  Drawable.update(self, dt)

  if self.closing then
    self.closing = false
    self:setVisible(false)
    return
  end

  if Input.isPressed(Input.Cancel) then
    self:close()
  end
end

return PlayerStatMenu
