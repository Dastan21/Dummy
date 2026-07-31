--- @class Dummy.Lang.Language
---
--- @field language_base string
--- @field language_code string
--- @field timestamp number

--- @class Dummy.Lang
---
--- @field protected translations table<string, table<string, string>>
--- @field protected languages string[]
--- @field protected language_code string
--- @field protected language_name string
--- @field protected switch_callbacks function[]
--- @field protected hmr_languages table<string, Dummy.Lang.Language>
local Lang = {}

--- Gets the current language name
--- @return string
function Lang.getLanguageName()
  return Lang.language_name
end

--- Gets the current language code
--- @return string
function Lang.getLanguage()
  return Lang.language_code
end

--- Sets the current language
--- @param code string language code
function Lang.setLanguage(code)
  if type(code) ~= "string" then return end

  Lang.language_code = code
  Lang.language_name = Lang.translate("LANGUAGE_" .. Lang.language_code:upper())

  Config.getSettings()["language"] = Lang.language_code
end

--- Switches current language
--- @param delta? integer
function Lang.switchLanguage(delta)
  delta = Utils.getOrDefault(delta, 1)
  local lang_index = 0
  for i, l in ipairs(Lang.languages) do
    if l == Lang.language_code then
      lang_index = i - 1
      break
    end
  end
  Lang.setLanguage(Lang.languages[(lang_index + #Lang.languages + delta) % #Lang.languages + 1])
  for _, callback in ipairs(Lang.switch_callbacks) do
    pcall(callback)
  end
end

--- Add a callback to be called when switching language
function Lang.onSwitchLanguage(func)
  assert(type(func) == "function", "Function callback must be a function")
  table.insert(Lang.switch_callbacks, func)
end

--- Translate a key in the current language
--- @param key Dummy.Text.Text key to translate
--- @param ... any additional data passed along the key
--- @return string
function Lang.translate(key, ...)
  local data = { ... }

  if type(key) == "table" then
    for i, v in pairs(key) do
      if i > 1 then
        table.insert(data, v)
      end
    end
    key = key[1]
  end

  key = tostring(key)
  for i, v in pairs(data) do
    if type(v) == "string" then
      data[i] = Lang.translate(v)
    end
  end

  local txt = (Lang.translations[Lang.language_code] and Lang.translations[Lang.language_code][key]) or key or ""
  local i = 1

  return (txt:gsub("\\n", "\n"):gsub("{}", function()
    local str = tostring(data[i])
    i = i + 1
    return str
  end))
end

--- Reloads the translations if they have changed
function Lang.hotReload()
  for _, language in pairs(Lang.hmr_languages) do
    local info = love.filesystem.getInfo(language.language_base .. "/" .. language.language_code .. ".txt")
    if info ~= nil and info.modtime ~= language.timestamp then
      Lang.loadLanguage(language.language_base, language.language_code)

      Signal.emit("hot_reload_language", language.language_code)
    end
  end
end

--- Loads a language
--- @param base_folder string
--- @param language_code string
function Lang.loadLanguage(base_folder, language_code)
  if Lang.translations[language_code] == nil then
    Lang.translations[language_code] = {}
    table.insert(Lang.languages, language_code)
  end
  local language_path = base_folder .. "/" .. language_code .. ".txt"
  Lang.hmr_languages[language_path] = {
    language_base = base_folder,
    language_code = language_code,
    timestamp = love.filesystem.getInfo(language_path).modtime
  }
  for txt in love.filesystem.lines(language_path) do
    if txt ~= "" and txt:sub(1, 1) ~= "#" then -- for comments
      local t = {}
      for str in string.gmatch(txt, "([^=]+)") do table.insert(t, str) end
      Lang.translations[language_code][t[1]] = t[2]
    end
  end
end

--- Adds a translation to the current language
--- @param key string key to translate
--- @param value string translation
--- @param lang? string language code to use
function Lang.addTranslation(key, value, lang)
  lang = Utils.getOrDefault(lang, Lang.language_code)
  assert(Lang.translations[lang] ~= nil, "Cannot add translation to unexisting language")
  Lang.translations[lang][key] = value
end

--- Loads languages from a folder
--- @param base_folder string
function Lang.loadLanguagesFromFolder(base_folder)
  for _, filename in pairs(love.filesystem.getDirectoryItems(base_folder)) do
    if Utils.checkExtension(filename, "txt") then
      Lang.loadLanguage(base_folder, filename:sub(1, #filename - 4))
    end
  end
end

--- Loads languages from the lang folder
function Lang.loadLanguages()
  Lang.loadLanguagesFromFolder("assets/langs")

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    Lang.loadLanguagesFromFolder("mods/" .. mod:getId() .. "/assets/langs")
  end

  Lang.setLanguage(Config.getSettings()["language"])
end

--- Loads languages
function Lang.load()
  Lang.translations = {}
  Lang.languages = {}
  Lang.language_code = ""
  Lang.language_name = ""
  Lang.switch_callbacks = {}
  Lang.hmr_languages = {}

  Lang.loadLanguages()
end

return Lang
