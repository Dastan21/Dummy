--- @class Dummy.Lang
---
--- @field private translations table<string, table<string, string>>
--- @field private languages string[]
--- @field private language_code string
--- @field private language_name string
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

  Config["language"] = Lang.language_code
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

  if type(key) == "function" then
    key = key()
  end

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

--- Loads languages from the lang folder
function Lang.loadLanguages()
  for _, filename in pairs(love.filesystem.getDirectoryItems("assets/lang")) do
    if Utils.checkExtension(filename, "txt") then
      local code = filename:sub(1, #filename - 4)
      if Lang.translations[code] == nil then
        Lang.translations[code] = {}
        table.insert(Lang.languages, code)
      end
      for txt in love.filesystem.lines("assets/lang/" .. filename) do
        if txt ~= "" and txt:sub(1, 1) ~= "#" then -- for comments
          local t = {}
          for str in string.gmatch(txt, "([^=]+)") do table.insert(t, str) end
          Lang.translations[code][t[1]] = t[2]
        end
      end
    end
  end

  Lang.setLanguage(Config["language"])
end

--- Loads languages
function Lang.load()
  Lang.translations  = {}
  Lang.languages     = {}
  Lang.language_code = ""
  Lang.language_name = ""

  Lang.loadLanguages()
end

return Lang
