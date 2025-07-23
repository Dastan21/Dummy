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
    local mod_dir_info = love.filesystem.getInfo("mods/" .. mod_dir)
    local is_folder = mod_dir_info.type == "directory"
    local is_symlink = mod_dir_info.type == "symlink"
    local is_zip = mod_dir_info.type == "file" and Utils.checkExtension(mod_dir, "zip")
    local ignore = mod_dir:sub(1, 1) == "#"
    if not ignore and (is_folder or is_symlink or is_zip) then
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
--- @param mod Dummy.Mod
function ModList.loadMod(mod)
  if mod == nil then return end


  if type(mod.load) == "function" then
    ModList.mountMod(mod)

    ModList.current_mod = mod
    Lang.loadLanguages(mod:getId())
    mod:load()
  end
end

--- Mounts a mod
--- @param mod Dummy.Mod
function ModList.mountMod(mod)
  if mod == nil then return end

  ModList.unloadMod(mod)

  love.filesystem.mount("mods/" .. mod:getId() .. "/assets", "assets")
  love.filesystem.mount("mods/" .. mod:getId() .. "/scripts", "scripts")
  love.filesystem.mount("mods/" .. mod:getId() .. ".zip", "")
end

--- Unloads a mod
--- @param mod Dummy.Mod
function ModList.unloadMod(mod)
  if mod == nil then return end

  love.filesystem.unmount("mods/" .. mod:getId() .. "/scripts")
  love.filesystem.unmount("mods/" .. mod:getId() .. "/assets")
  love.filesystem.unmount("mods/" .. mod:getId() .. ".zip")

  Lang.clearModsTranslations()

  -- uncache mod scripts modules
  for modname in pairs(package.loaded) do
    if modname:sub(1, 8) == "scripts." then
      package.loaded[modname] = nil
    end
  end
end

--- Unloads all mods
function ModList.unloadMods()
  ModList.current_mod = nil

  if ModList.mods == nil then return end

  for _, mod in ipairs(ModList.mods) do
    ModList.unloadMod(mod)
  end

  ModList.unloadMod(ModList.standalone)
end

--- Wether a mod is valid
--- @param success boolean
--- @param mod Dummy.Mod
--- @return boolean
function ModList.isModValid(success, mod)
  if not success then return false end
  if type(mod) ~= "table" then return false end
  if type(mod.getClassName) ~= "function" then return false end
  if mod.getClassName() ~= "Dummy.Mod" then return false end

  return true
end

--- Sets the window title and icon
--- @param title Dummy.Text.Text|nil
function ModList.setWindowTitleAndIcon(title)
  if title ~= nil then
    love.window.setTitle(Lang.translate(title))
  end

  love.window.setIcon(love.image.newImageData("assets/icon.png"))
end

return ModList
