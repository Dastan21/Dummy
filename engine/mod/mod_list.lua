--- @class Dummy.ModList
---
--- @field protected mods Dummy.Mod[]
--- @field protected current_mod Dummy.Mod|nil
--- @field protected standalone Dummy.Mod|nil
local ModList = {}

--- Gets the mods
--- @return Dummy.Mod[]
function ModList.getMods()
  return ModList.mods
end

--- Gets the standalone mod
--- @return Dummy.Mod|nil
function ModList.getStandalone()
  return ModList.standalone
end

--- Gets the current loaded mod
--- @return Dummy.Mod|nil
function ModList.getCurrentMod()
  return ModList.standalone or ModList.current_mod
end

--- Loads the mod list
function ModList.load()
  ModList.unloadMods()
  ModList.mods = {}
  ModList.current_mod = nil
  ModList.standalone = nil

  local mods_dirs = love.filesystem.getDirectoryItems("mods")
  for _, mod_dir in ipairs(mods_dirs) do
    mod_dir_info = love.filesystem.getInfo("mods/" .. mod_dir)
    local is_folder = mod_dir_info.type == "directory"
    local is_zip = mod_dir_info.type == "file" and Utils.checkExtension(mod_dir, "zip")
    if is_folder or is_zip then
      if is_zip then
        local mod_name = mod_dir:sub(1, #mod_dir - 4)
        love.filesystem.mount("mods/" .. mod_dir, "mods/" .. mod_name)
        mod_dir = mod_name
      end

      if love.filesystem.getInfo("mods/" .. mod_dir .. "/mod.lua") ~= nil then
        ModList.preloadMod(mod_dir)
      end

      if ModList.standalone ~= nil then return end
    end
  end
end

--- Preloads a mod
--- @param mod_id string
--- @private
function ModList.preloadMod(mod_id)
  local success, mod = pcall(require, "mods." .. mod_id .. ".mod")
  if ModList.isModValid(success, mod) then
    if mod.standalone == true then
      ModList.mods = {}
      mod.id = mod_id
      ModList.standalone = mod
      return
    end
  else
    mod = {
      name = { "MAIN_MENU_MODLIST_MOD_ERROR", mod_id },
      error = mod
    }
    if type(mod.error) == "table" then
      print(table.tostring(mod.error))
    else
      print(mod.error)
    end
  end

  mod.id = mod_id
  table.insert(ModList.mods, mod)
end

--- Loads a mod
---@param mod Dummy.Mod
function ModList.loadMod(mod)
  ModList.unloadMod(mod)

  if type(mod.load) == "function" then
    love.filesystem.mount("mods/" .. mod:getId() .. "/assets", "assets")
    love.filesystem.mount("mods/" .. mod:getId() .. "/scripts", "scripts")

    ModList.current_mod = mod
    Lang.loadLanguages()
    mod:load()
  end
end

--- Unloads a mod
--- @param mod Dummy.Mod
function ModList.unloadMod(mod)
  love.filesystem.unmount("mods/" .. mod:getId() .. "/scripts")
  love.filesystem.unmount("mods/" .. mod:getId() .. "/assets")
  love.filesystem.unmount("mods/" .. mod:getId() .. ".zip")
end

--- Unloads all mods
function ModList.unloadMods()
  ModList.current_mod = nil

  if ModList.mods == nil then return end

  for _, mod in ipairs(ModList.mods) do
    ModList.unloadMod(mod)
  end
end

--- Wether a mod is valid
--- @param success boolean
--- @param mod Dummy.Mod
--- @return boolean
function ModList.isModValid(success, mod)
  if not success then return false end
  if type(mod) ~= "table" then return false end
  if type(mod.getClass) ~= "function" then return false end
  if mod:getClass() ~= "Dummy.Mod" then return false end

  return true
end

--- Sets the window title and icon
--- @param title string|nil
function ModList.setWindowTitleAndIcon(title)
  if title ~= nil then
    love.window.setTitle(title)
  end

  love.window.setIcon(love.image.newImageData("assets/icon.png"))
end

return ModList
