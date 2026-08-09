--- @class WorldExampleMod.Config : Dummy.Mod.Config
---
--- @field savepoint WorldExampleMod.SaveData

--- @class WorldExampleMod.SaveData : Dummy.Mod.Config.Savepoint
---
--- @field plot number
--- @field flag table<string, number>
--- @field lv number
--- @field exp number
--- @field gold number
--- @field weapon string
--- @field armor string
--- @field items string[]
--- @field storage string[]

--- @class WorldExampleMod : Dummy.Mod
---
--- @field plot number
--- @field flag table<string, number>
--- @field save_data WorldExampleMod.SaveData
--- @field portrait WorldExampleMod.Portrait
--- @field ruins3_enter_count integer
WorldExampleMod = Mod:new({
  name = "World Example",            -- displayed name, in the mods list
  title = "WORLD_EXAMPLE_MOD_TITLE", -- window title
  version = "1.0.0",                 -- mod version
  standalone = false,                -- wether to auto-load this mod when starting the engine
})

--- Loads the mod
function WorldExampleMod:load()
  -- log in the debug console (F8)
  -- logs are saved in "logs.txt" in the save directory
  print("World example loaded!")

  self:loadSaveData()

  -- add custom portraits
  -- Note: it is not built-in has I could not figure out how to do make it
  -- generic and flexible without being too restrictive about the sprites
  -- location and naming. Maybe I'll try with a statemachine one day.
  WorldExampleMod.portrait = modRequire("scripts.portrait")
  WorldExampleMod.portrait.load()

  WorldExampleMod.ruins3_enter_count = 0

  -- loads the room
  local save_data = Utils.getOrDefault(self:getConfig().savepoint, {}) --[[@as WorldExampleMod.SaveData]]
  if save_data.room_id ~= nil then
    if save_data.room_id == "ruins1" then
      World.transitionRoom(save_data.room_id, 65, 90, true)
    elseif save_data.room_id == "ruins3" then
      World.transitionRoom(save_data.room_id, 180, 95, true)
    end
  else
    World.transitionRoom("ruins1", 150, 120, true)
  end
end

--- Loads the save data
function WorldExampleMod:loadSaveData()
  local save_data = Utils.getOrDefault(self:getConfig().savepoint, {}) --[[@as WorldExampleMod.SaveData]]

  self.plot = Utils.getOrDefault(save_data.plot, 3)
  self.flag = table.copy(Utils.getOrDefault(save_data.flag, {}))

  -- player stats
  Player.setName("Frisk")
  Player.setLV(save_data.lv or 1)
  Player.setEXP(save_data.exp or 0)
  Player.setGold(save_data.gold or 0)

  -- player items
  for _, item_id in ipairs(save_data.items or {}) do
    local item = self:loadItem(item_id)
    Player.addItem(item)
  end

  -- equipped weapon
  if save_data.weapon ~= nil then
    if save_data.weapon ~= "stick" then
      Player.setWeapon(tryRequire("scripts.items." .. save_data.weapon, "items." .. save_data.weapon):new())
    end
  end

  -- equipped armor
  if save_data.armor ~= nil then
    if save_data.armor ~= "bandage" then
      Player.setArmor(tryRequire("scripts.items." .. save_data.armor, "items." .. save_data.armor):new())
    end
  end

  -- player items in storage
  for _, item_id in ipairs(save_data.storage or {}) do
    local item = self:loadItem(item_id)
    World.addItemIntoChestbox(item)
  end
end

--- Loads an item
--- @param item_id string
--- @return Dummy.Item
function WorldExampleMod:loadItem(item_id)
  --- @type Dummy.Item
  local item
  if item_id == "stick" or item_id == "bandage" then
    if item_id == "stick" then
      local stick = Item:new(
        "stick",
        "ITEM_STICK_NAME",
        "ITEM_STICK_SHORTNAME",
        "ITEM_STICK_DESCRIPTION"
      )
      stick:setUseText("ITEM_STICK_USE")
      stick:setSellPrice(150)
      item = stick
    elseif item_id == "bandage" then
      local bandage = ItemConsumable:new(
        "bandage",
        "ITEM_BANDAGE_NAME",
        "ITEM_BANDAGE_SHORTNAME",
        "ITEM_BANDAGE_DESCRIPTION",
        10,
        "food"
      )
      bandage:setUseText("ITEM_BANDAGE_USE")
      bandage:setSellPrice(150)
      item = bandage
    end
  else
    item = tryRequire("scripts.items." .. item_id, "items." .. item_id):new()
  end
  return item
end

--- Called before the game is saved
function WorldExampleMod:onGameSave()
  local save_data = self:getConfig().savepoint --[[@as WorldExampleMod.SaveData]]
  save_data.plot = self.plot
  save_data.flag = table.copy(self.flag)

  save_data.lv = Player.getLV()
  save_data.exp = Player.getEXP()
  save_data.gold = Player.getGold()
  save_data.weapon = Player.getWeapon():getId()
  save_data.armor = Player.getArmor():getId()

  --- @type string[]
  local items = {}
  for _, item in ipairs(Player.getItems()) do
    table.insert(items, item:getId())
  end
  save_data.items = items

  --- @type string[]
  local storage = {}
  for _, item in ipairs(World.getItemsInChestbox()) do
    table.insert(storage, item:getId())
  end
  save_data.storage = storage
end

--- Called when the main menu is loaded, for standalone mods only
function WorldExampleMod:preview() end

--- Called when a room is entered
--- @param room Dummy.Room
function WorldExampleMod:onRoomEnter(room) end

--- Called when a room is left
--- @param room Dummy.Room
function WorldExampleMod:onRoomLeave(room) end

--- Called when an encounter starts
--- @param encounter Dummy.Battle.Encounter
function WorldExampleMod:onEncounterStart(encounter)
  local names = {}
  for _, enemy in ipairs(encounter:getEnemies()) do
    table.insert(names, Lang.translate(enemy:getName()))
  end
  WorldExampleMod:setTitle({ "WORLD_EXAMPLE_MOD_BATTLE_TITLE", table.concat(names, ", ") })
end

--- Called when an encounter ends
--- @param encounter Dummy.Battle.Encounter
function WorldExampleMod:onEncounterEnd(encounter)
  WorldExampleMod:setTitle("WORLD_EXAMPLE_MOD_TITLE")
end

--- Updates the mod, called on every game updatez
--- @param dt number
function WorldExampleMod:update(dt)
  if Input.isPressed("f1") then
    if not World.isInBattle() then
      local encounter = modRequire("scripts.encounters.dummy"):new()
      World.startEncounter(encounter)
    end
  end
end

return WorldExampleMod
