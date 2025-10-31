--- @class Dummy.Config.Settings
---
--- @field language string
--- @field fps number
--- @field window_scale number
--- @field fullscreen boolean

--- @class Dummy.Config
---
--- @field protected configs table<string, table<string, any>>[]
local Config = {}

--- Gets the engine settings
--- @return Dummy.Config.Settings
function Config.getSettings()
  return Config.configs["settings"]
end

--- Loads the main config
function Config.load()
  Config.configs = {
    settings = {
      language = "en",
      fps = 30,
      volume = 100,
      fullscreen = false,
      window_scale = 1
    }
  }

  Config.loadConfig("settings")
end

--- Saves the configs
function Config.save()
  for config_path, config in pairs(Config.configs) do
    local config_file = config_path .. ".json"
    if not Config.isEmpty(config) then
      love.filesystem.write(config_file, JSON.encode(config))
    else
      love.filesystem.remove(config_file)
    end
  end
end

--- Loads a config
--- @param config_path string
function Config.loadConfig(config_path)
  local config_file = config_path .. ".json"

  Config.configs[config_path] = Config.configs[config_path] or {}
  if love.filesystem.getInfo(config_file) ~= nil then
    table.merge(Config.configs[config_path], JSON.decode(love.filesystem.read(config_file)))
  end

  return Config.configs[config_path]
end

--- Wether a config is empty
--- @param config table<string, any>
--- @return boolean
function Config.isEmpty(config)
  for _, value in pairs(config) do
    if value ~= nil then return false end
  end
  return true
end

return Config
