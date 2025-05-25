local self = {}

--- Loads the mod list
function self.load()
  self.unloadMods()
  self.mods = {}
  self.standalone = nil

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
        self.preloadMod(mod_dir)
      end
      if self.standalone ~= nil then return end
    end
  end
end

--- Preloads a mod
--- @param mod_id string
--- @private
function self.preloadMod(mod_id)
  local success, mod = pcall(require, "mods." .. mod_id .. ".mod")
  if success and type(mod) == "table" and mod.name ~= nil then
    if mod.standalone == true then
      self.mods = {}
      mod.id = mod_id
      self.standalone = mod
      self.loadMod(mod)
      return
    end
  else
    mod = {
      name = { "MAIN_MENU_MODLIST_MOD_ERROR", mod_id },
      error = mod
    }
  end

  mod.id = mod_id
  table.insert(self.mods, mod)
end

--- Loads a mod
---@param mod Dummy.Mod
function self.loadMod(mod)
  love.filesystem.mount("mods/" .. mod.id .. "/assets", "assets")

  if type(mod.load) == "function" then
    mod.load()
  end
end

--- Unloads all mods
function self.unloadMods()
  if self.mods == nil then return end

  for _, mod in ipairs(self.mods) do
    love.filesystem.unmount("mods/" .. mod.id .. "/assets")
    love.filesystem.unmount("mods/" .. mod.id .. ".zip")
  end
end

return self
