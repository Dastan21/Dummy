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

--- Gets a mod by id
--- @param mod_id string
--- @return Dummy.Mod|nil
function ModList.getMod(mod_id)
  if #ModList.mods <= 0 then return end
  return table.find(ModList.mods, function(mod) return mod:getId() == mod_id end)
end

--- Loads the mod list
function ModList.load()
  ModList.unloadMods()
  ModList.mods = {}
  ModList.current_mod = nil
  ModList.standalone = nil

  --- @type table<string, boolean>
  local registered_mods = {}
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

      if not registered_mods[mod_dir] then
        if love.filesystem.getInfo("mods/" .. mod_dir .. "/mod.lua") ~= nil then
          ModList.preloadMod(mod_dir)
          registered_mods[mod_dir] = true
        end
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
      error = mod,
      getId = function(self) return self.id end,
      getName = function(self) return self.name end
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
    ModList.current_mod = mod
    Lang.loadLanguages()
    ---@diagnostic disable-next-line: invisible
    mod.config = Config.loadConfig("configs/" .. mod:getId())
    mod:load()
  end
end

--- Unloads a mod
--- @param mod Dummy.Mod
function ModList.unloadMod(mod)
  if mod == nil then return end

  Lang.load()

  -- uncache mod scripts modules
  for modname in pairs(package.loaded) do
    if modname:sub(1, 8) == "mods." .. mod:getId() .. ".scripts." then
      package.loaded[modname] = nil
    end
  end

  package.loaded["mods." .. mod:getId() .. ".mod"] = nil
end

--- Unloads all mods
function ModList.unloadMods()
  ModList.current_mod = nil

  if ModList.mods == nil then return end

  for _, mod in ipairs(ModList.mods) do
    ModList.unloadMod(mod)
  end

  ModList.unloadMod(ModList.standalone)

  -- reset hooks
  ---@diagnostic disable-next-line: invisible
  for hook in pairs(Utils.__hooks) do
    hook.target[hook.name] = hook.original
  end
  ---@diagnostic disable-next-line: invisible
  Utils.__hooks = {}
end

--- Wether a mod is valid
--- @param success boolean
--- @param mod Dummy.Mod
--- @return boolean
function ModList.isModValid(success, mod)
  if not success then return false end
  if type(mod) ~= "table" then return false end
  if not mod:is(Mod) then return false end

  return true
end

--- Sets the window title and icon
function ModList.setWindowTitleAndIcon()
  local title = Constants.CREDITS.NAME
  local icon = love.image.newImageData("assets/icon.png")

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    local mod_title = mod:getTitle()
    if mod_title ~= nil then
      title = Lang.translate(mod_title)
    end

    local icon_info = love.filesystem.getInfo("mods/" .. mod:getId() .. "/assets/icon.png")
    if icon_info ~= nil and icon_info.type == "file" then
      icon = love.image.newImageData("mods/" .. mod:getId() .. "/assets/icon.png")
    end
  end

  love.setTitle(title)
  love.window.setIcon(icon)
end

--- Copies a mod zip file into the mods folder
--- @param file love.File
function ModList.copyModZip(file)
  if not Utils.checkExtension(file:getFilename(), "zip") then return end

  local name = file:getFilename():match("([^/\\]+)$")
  file:open("r")
  love.filesystem.write("mods/" .. name, file:read())
end

return ModList
