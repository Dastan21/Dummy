local translations = {}
local languages = {}
local language_code = ""
local language_name = ""

local self = {}

function self.getLanguage()
  return language_code
end

function self.getLanguageName()
  return language_name
end

--- Set the current language
--- @param lang string
function self.setLanguage(lang)
  if type(lang) ~= "string" then return end

  language_code = lang
  language_name = self.translate("LANGUAGE_" .. language_code:upper())

  Config.language = language_code
end

function self.switchLanguage()
  local lang_index = 1
  for i, l in ipairs(languages) do
    if l == language_code then
      lang_index = i
      break
    end
  end
  self.setLanguage(languages[lang_index + 1] or languages[1])
end

function self.translate(key, ...)
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

  local txt = (translations[language_code] and translations[language_code][key]) or key or ""
  local i = 1

  return (txt:gsub("{}", function()
    local str = tostring(data[i])
    i = i + 1
    return str
  end))
end

-- Initialize languages from the Langs folder
function self.load()
  local files = love.filesystem.getDirectoryItems("assets/lang")
  for _, filename in pairs(files) do
    if filename:sub(-4) == ".txt" then
      local lang = filename:sub(1, #filename - 4)
      table.insert(languages, lang)
      translations[lang] = {}
      for txt in love.filesystem.lines("assets/lang/" .. filename) do
        if txt:sub(1, 1) ~= "#" then -- comment
          local t = {}
          for str in string.gmatch(txt, "([^=]+)") do table.insert(t, str) end
          translations[lang][string.trim(t[1])] = string.trim(t[2])
        end
      end
    end
  end

  self.setLanguage(Config.language)
end

return self
