local lang = {}

local self = {}

--- Gets the current language code
--- @return string
function self.getLanguage()
  return language_code
end

--- Gets the current language name
--- @return string
function self.getLanguageName()
  return language_name
end

--- Sets the current language
--- @param code string language code
function self.setLanguage(code)
  if type(code) ~= "string" then return end

  language_code = code
  language_name = self.translate("LANGUAGE_" .. language_code:upper())

  Config.language = language_code
end

--- Switches current language
function self.switchLanguage()
  local lang_index = 1
  for i, l in ipairs(lang.languages) do
    if l == language_code then
      lang_index = i
      break
    end
  end
  self.setLanguage(lang.languages[lang_index + 1] or lang.languages[1])
end

--- Translate a key in the current language
--- @param key string|table|function key to translate
--- @param ... table additional data passed along the key
--- @return string
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

  local txt = (lang.translations[language_code] and lang.translations[language_code][key]) or key or ""
  local i = 1

  return (txt:gsub("{}", function()
    local str = tostring(data[i])
    i = i + 1
    return str
  end))
end

function self.load()
  lang.translations = {}
  lang.languages = {}
  lang.language_code = ""
  lang.language_name = ""

  local files = love.filesystem.getDirectoryItems("assets/lang")
  for _, filename in pairs(files) do
    if filename:sub(-4) == ".txt" then
      local code = filename:sub(1, #filename - 4)
      table.insert(lang.languages, code)
      lang.translations[code] = {}
      for txt in love.filesystem.lines("assets/lang/" .. filename) do
        if txt:sub(1, 1) ~= "#" and txt ~= "" then -- comment
          local t = {}
          for str in string.gmatch(txt, "([^=]+)") do table.insert(t, str) end
          lang.translations[code][t[1]:trim()] = t[2]:trim()
        end
      end
    end
  end

  self.setLanguage(Config.language)
end

return self
