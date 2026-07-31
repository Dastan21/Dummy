--[[
  Generated from ..\engine\player.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/player.lua
]]

---@meta

--- @class Dummy.Player
---
--- @field protected lv number
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected exp number
--- @field protected gold number
--- @field protected object Dummy.Object.Player
--- @field protected name string
--- @field protected weapon Dummy.Item.Equipment
--- @field protected armor Dummy.Item.Equipment
--- @field protected items Dummy.Item[]
--- @field protected has_cellphone boolean
--- @field protected phone_calls Dummy.Player.Phonecall[]
Player = {}

--- @class Dummy.Player.Phonecall
---
--- @field name Dummy.Text.Text
--- @field texts Dummy.Text.Text[]
--- @field callback? fun(phonecall: Dummy.Player.Phonecall)

--- Initializes the player
function Player.load() end

--- Gets the player's object
--- @return Dummy.Object.Player
function Player.getObject() end

--- Sets the player's object
--- @param object Dummy.Object.Player
function Player.setObject(object) end

--- Gets the player's name
--- @return string
function Player.getName() end

--- Sets the player's name
--- @param name string name displayed
function Player.setName(name) end

--- Gets the player's LV
--- @return number
function Player.getLV() end

--- Sets the player's LV
--- @param lv number level
--- @param silent? boolean wether to play level up sound (Defaults to `true`)
function Player.setLV(lv, silent) end

--- Gets the player's HP
--- @return number
function Player.getHP() end

--- Sets the player's HP
--- @param hp number health points
function Player.setHP(hp) end

--- Gets the player's max HP
--- @return number
function Player.getMaxHP() end

--- Sets the player's max HP
--- @param max_hp number maximum health points
function Player.setMaxHP(max_hp) end

--- Gets the player's AT
--- @return number
function Player.getAT() end

--- Sets the player's AT
--- @param at number attack point
function Player.setAT(at) end

--- Gets the player's DE
--- @return number
function Player.getDF() end

--- Sets the player's DE
--- @param df number defense point
function Player.setDF(df) end

--- Gets the player's EXP
--- @return number
function Player.getEXP(exp) end

--- Sets the player's EXP
--- @param exp number
function Player.setEXP(exp) end

--- Gets the player's gold
--- @return number
function Player.getGold() end

--- Sets the player's gold
--- @param gold number
function Player.setGold(gold) end

--- Gets the player's weapon
--- @return Dummy.Item.Equipment
function Player.getWeapon() end

--- Sets the player's weapon
--- @param weapon Dummy.Item.Equipment
function Player.setWeapon(weapon) end

--- Gets the player's armor
--- @return Dummy.Item.Equipment
function Player.getArmor() end

--- Sets the player's armor
--- @param armor Dummy.Item.Equipment
function Player.setArmor(armor) end

--- Gets the player's max items
--- @return number
function Player.getMaxItems() end

--- Sets the player's max items
--- @param max_items number
function Player.setMaxItems(max_items) end

--- Gets the player's items
--- @return Dummy.Item[]
function Player.getItems() end

--- Adds one or more items to the player
--- @param item Dummy.Item|Dummy.Item[]
--- @param index? integer
function Player.addItem(item, index) end

--- Removes an item from the player
--- @param item Dummy.Item|integer
function Player.removeItem(item) end

--- Wether the player has the cellphone
--- @return boolean
function Player.hasCellphone() end

--- Sets wether the player has the cellphone
--- @param has_cellphone boolean
function Player.setCellphone(has_cellphone) end

--- Gets the player's phone calls
--- @return Dummy.Player.Phonecall[]
function Player.getPhoneCalls() end

--- Adds a phone call
--- @overload fun(name: Dummy.Text.Text, on_call: fun(phonecall: Dummy.Player.Phonecall), index?: integer)
--- @param name Dummy.Text.Text
--- @param texts Dummy.Text.Text[]
--- @param index? integer
function Player.addPhoneCall(name, texts, index) end

--- Removes a phone call
--- @param index integer
function Player.removePhoneCall(index) end

--- Makes a phone call
--- @param index integer
function Player.call(index) end

