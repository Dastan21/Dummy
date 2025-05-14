local self = {}

function self.load()
  self.mods = {}
  self.standalone = nil

  local mods_dirs = love.filesystem.getDirectoryItems("mods")
  for _, mod_dir in ipairs(mods_dirs) do
    mod_dir_info = love.filesystem.getInfo("mods/" .. mod_dir)
    if mod_dir_info.type == "directory" then
      self.loadMod(mod_dir)
      if self.standalone ~= nil then return end
    end
  end
end

function self.loadMod(mod_dir)
  local success, mod = pcall(require, "mods." .. mod_dir .. ".mod")
  if success and type(mod) == "table" and mod.name ~= nil then
    if mod.standalone == true then
      self.mods = {}
      self.standalone = mod
      return
    end

    table.insert(self.mods, mod)
  else
    table.insert(self.mods, { "MAIN_MENU_MODLIST_MOD_ERROR", mod_dir })
  end
end

return self
