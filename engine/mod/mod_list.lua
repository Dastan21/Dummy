local self = {
  mods = {}
}

function self.load()
  local mods_dirs = love.filesystem.getDirectoryItems("mods")
  for _, mod_dir in ipairs(mods_dirs) do
    mod_dir_info = love.filesystem.getInfo("mods/" .. mod_dir)
    if mod_dir_info.type == "directory" then
      local success, mod = pcall(require, "mods." .. mod_dir .. ".mod")
      if self.isValidMod(success, mod) then
        self.mods[mod_dir] = mod
      else
        self.mods[mod_dir] = false
      end
    end
  end
end

function self.isValidMod(success, mod)
  return success and type(mod) == "table" and mod.name ~= nil
end

return self
