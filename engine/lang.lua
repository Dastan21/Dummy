--- @class Dummy.Lang
---
--- @field protected translations table<string, table<string, string>>
--- @field protected languages string[]
--- @field protected language_code string
--- @field protected language_name string
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
function Lang.switchLanguage()
  local lang_index = 1
  for i, l in ipairs(Lang.languages) do
    if l == Lang.language_code then
      lang_index = i
      break
    end
  end
  Lang.setLanguage(Lang.languages[lang_index + 1] or Lang.languages[1])
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

  local txt = (Lang.translations[Lang.language_code] and Lang.translations[Lang.language_code][key]) or key or ""
  local i = 1

  return (txt:gsub("\\n", "\n"):gsub("{}", function()
    local str = tostring(data[i])
    i = i + 1
    return str
  end))
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

--- Loads languages from the lang folder
function Lang.loadLanguages()
  Lang.loadLanguagesFromFolder("assets/langs")

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    Lang.loadLanguagesFromFolder("mods/" .. mod:getId() .. "/assets/langs")
  end

  Lang.setLanguage(Config.getSettings()["language"])
end

function Lang.loadLanguagesFromFolder(base_folder)
  for _, filename in pairs(love.filesystem.getDirectoryItems(base_folder)) do
    if Utils.checkExtension(filename, "txt") then
      local code = filename:sub(1, #filename - 4)
      if Lang.translations[code] == nil then
        Lang.translations[code] = {}
        table.insert(Lang.languages, code)
      end
      for txt in love.filesystem.lines(base_folder .. "/" .. filename) do
        if txt ~= "" and txt:sub(1, 1) ~= "#" then -- for comments
          local t = {}
          for str in string.gmatch(txt, "([^=]+)") do table.insert(t, str) end
          Lang.translations[code][t[1]] = t[2]
        end
      end
    end
  end
end

--- Loads languages
function Lang.load()
  Lang.translations = {}
  Lang.languages = {}
  Lang.language_code = ""
  Lang.language_name = ""

  Lang.loadLanguages()
end

return Lang
