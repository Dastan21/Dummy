--- @class Dummy.Player.Phonecall
---
--- @field name Dummy.Text.Text
--- @field texts Dummy.Text.Text[]
--- @field callback? fun(phonecall: Dummy.Player.Phonecall)

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
local Player = {}

--- The player's overworld speed
Player.SPEED = 4

--- The minimum amount of experience required by level
Player.LV_EXP = {
  [1] = 0,
  [2] = 10,
  [3] = 30,
  [4] = 70,
  [5] = 120,
  [6] = 200,
  [7] = 300,
  [8] = 500,
  [9] = 800,
  [10] = 1200,
  [11] = 1700,
  [12] = 2500,
  [13] = 3500,
  [14] = 5000,
  [15] = 7000,
  [16] = 10000,
  [17] = 15000,
  [18] = 25000,
  [19] = 50000,
  [20] = 99999,
  [21] = math.huge
}

--- Initializes the player
function Player.load()
  Player.lv = 1
  Player.hp = 20
  Player.max_hp = 20
  Player.at = 10
  Player.df = 10
  Player.exp = 0
  Player.gold = 0

  Player.name = "Frisk"

  Player.weapon = ItemEquipment:new(
    "stick",
    "ITEM_STICK_NAME",
    "ITEM_STICK_SHORTNAME",
    "ITEM_STICK_DESCRIPTION",
    0,
    "weapon"
  )
  Player.armor = ItemEquipment:new(
    "bandage",
    "ITEM_BANDAGE_NAME",
    "ITEM_BANDAGE_SHORTNAME",
    "ITEM_BANDAGE_DESCRIPTION",
    0,
    "armor"
  )
  Player.max_items = 8
  Player.items = {}
  Player.has_cellphone = false
  Player.phone_calls = {}

  Player.setLV(1)
end

--- Gets the player's object
--- @return Dummy.Object.Player
function Player.getObject()
  return Player.object
end

--- Sets the player's object
--- @param object Dummy.Object.Player
function Player.setObject(object)
  Player.object = object
end

--- Gets the player's name
--- @return string
function Player.getName()
  return Player.name
end

--- Sets the player's name
--- @param name string name displayed
function Player.setName(name)
  if name == nil then return end

  Player.name = Utils.getOrDefault(name, "Frisk")
end

--- Gets the player's LV
--- @return number
function Player.getLV()
  return Player.lv
end

--- Sets the player's LV
--- @param lv number level
--- @param silent? boolean wether to play level up sound (Defaults to `true`)
function Player.setLV(lv, silent)
  if type(lv) ~= "number" then return end

  local lv_old = Player.lv
  Player.lv = math.max(1, lv)

  if Player.lv < 20 then
    Player.setMaxHP(16 + 4 * Player.lv)
  else
    Player.setMaxHP(99)
  end

  Player.setHP(math.min(Player.hp, Player.max_hp))
  Player.setAT(8 + 2 * Player.lv)
  Player.setDF(9 + math.ceil(Player.lv / 4))

  if Player.exp < Player.LV_EXP[Player.lv] then
    Player.exp = Player.LV_EXP[Player.lv]
  end

  if silent == false and lv_old < Player.lv then
    Assets.playSound("levelup")
  end
end

--- Gets the player's HP
--- @return number
function Player.getHP()
  return Player.hp
end

--- Sets the player's HP
--- @param hp number health points
function Player.setHP(hp)
  if type(hp) ~= "number" then return end

  Player.hp = math.clamp(hp, 0, Player.max_hp)
end

--- Gets the player's max HP
--- @return number
function Player.getMaxHP()
  return Player.max_hp
end

--- Sets the player's max HP
--- @param max_hp number maximum health points
function Player.setMaxHP(max_hp)
  if type(max_hp) ~= "number" then return end

  Player.max_hp = math.max(0, max_hp)
end

--- Gets the player's AT
--- @return number
function Player.getAT()
  return Player.at
end

--- Sets the player's AT
--- @param at number attack point
function Player.setAT(at)
  Player.at = at
end

--- Gets the player's DE
--- @return number
function Player.getDF()
  return Player.df
end

--- Sets the player's DE
--- @param df number defense point
function Player.setDF(df)
  Player.df = df
end

--- Gets the player's EXP
--- @return number
function Player.getEXP(exp)
  return Player.exp
end

--- Sets the player's EXP
--- @param exp number
function Player.setEXP(exp)
  Player.exp = exp

  local lv = 0
  for level, experience in ipairs(Player.LV_EXP) do
    if Player.exp < experience then
      lv = level - 1
      break
    end
  end

  if lv > 0 and lv ~= Player.lv then
    Player.setLV(lv, false)
  end
end

--- Gets the player's gold
--- @return number
function Player.getGold()
  return Player.gold
end

--- Sets the player's gold
--- @param gold number
function Player.setGold(gold)
  Player.gold = gold
end

--- Gets the player's weapon
--- @return Dummy.Item.Equipment
function Player.getWeapon()
  return Player.weapon
end

--- Sets the player's weapon
--- @param weapon Dummy.Item.Equipment
function Player.setWeapon(weapon)
  Player.weapon = weapon
end

--- Gets the player's armor
--- @return Dummy.Item.Equipment
function Player.getArmor()
  return Player.armor
end

--- Sets the player's armor
--- @param armor Dummy.Item.Equipment
function Player.setArmor(armor)
  Player.armor = armor
end

--- Gets the player's max items
--- @return number
function Player.getMaxItems()
  return Player.max_items
end

--- Sets the player's max items
--- @param max_items number
function Player.setMaxItems(max_items)
  Player.max_items = max_items
end

--- Gets the player's items
--- @return Dummy.Item[]
function Player.getItems()
  return Player.items
end

--- Adds one or more items to the player
--- @param item Dummy.Item|Dummy.Item[]
--- @param index? integer
function Player.addItem(item, index)
  if #Player.items >= Player.getMaxItems() then return end

  table.insert(Player.items, Utils.getOrDefault(index, #Player:getItems() + 1), item)
end

--- Removes an item from the player
--- @param item Dummy.Item|integer
function Player.removeItem(item)
  if type(item) == "number" then
    table.remove(Player.items, item)
  else
    table.removebyvalue(Player.items, item)
  end
end

--- Wether the player has the cellphone
--- @return boolean
function Player.hasCellphone()
  return Player.has_cellphone
end

--- Sets wether the player has the cellphone
--- @param has_cellphone boolean
function Player.setCellphone(has_cellphone)
  Player.has_cellphone = has_cellphone
end

--- Gets the player's phone calls
--- @return Dummy.Player.Phonecall[]
function Player.getPhoneCalls()
  return Player.phone_calls
end

--- Adds a phone call
--- @overload fun(name: Dummy.Text.Text, on_call: fun(phonecall: Dummy.Player.Phonecall), index?: integer)
--- @param name Dummy.Text.Text
--- @param texts Dummy.Text.Text[]
--- @param index? integer
function Player.addPhoneCall(name, texts, index)
  local callback = nil
  if type(texts) == "function" then
    callback = texts
    texts = {}
  end

  --- @type Dummy.Player.Phonecall
  local phonecall = {
    name = name,
    texts = table.copy(texts),
    callback = callback --[[@as fun(phonecall: Dummy.Player.Phonecall)|nil]]
  }
  table.insert(Player.phone_calls, Utils.getOrDefault(index, #Player:getPhoneCalls() + 1), phonecall)
end

--- Removes a phone call
--- @param index integer
function Player.removePhoneCall(index)
  table.remove(Player.phone_calls, index)
end

--- Makes a phone call
--- @param index integer
function Player.call(index)
  local phonecall = Player.phone_calls[index]
  if phonecall == nil or World.getCurrentRoom() == nil then return end

  if type(phonecall.callback) == "function" then
    phonecall.callback(phonecall)
    return
  end

  if #phonecall.texts < 1 then return end

  local sound = Assets.playSound("phone")
  sound:setVolume(0.85)
  World.playDialogue(phonecall.texts)

  table.remove(Player.phone_calls, index)
  table.insert(Player.phone_calls, 1, phonecall)
end

return Player
