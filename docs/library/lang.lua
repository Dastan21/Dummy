--[[
  Generated from ..\engine\lang.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/lang.lua
]]

---@meta

--- @class Dummy.Lang
---
--- @field protected translations table<string, table<string, string>>
--- @field protected languages string[]
--- @field protected language_code string
--- @field protected language_name string
--- @field protected switch_callbacks function[]
--- @field protected hmr_languages table<string, Dummy.Lang.Language>
Lang = {}

--- @class Dummy.Lang.Language
---
--- @field language_base string
--- @field language_code string
--- @field timestamp number

--- Gets the current language name
--- @return string
function Lang.getLanguageName() end

--- Gets the current language code
--- @return string
function Lang.getLanguage() end

--- Sets the current language
--- @param code string language code
function Lang.setLanguage(code) end

--- Switches current language
--- @param delta? integer
function Lang.switchLanguage(delta) end

--- Add a callback to be called when switching language
function Lang.onSwitchLanguage(func) end

--- Translate a key in the current language
--- @param key Dummy.Text.Text key to translate
--- @param ... any additional data passed along the key
--- @return string
function Lang.translate(key, ...) end

--- Reloads the translations if they have changed
function Lang.hotReload() end

--- Loads a language
--- @param base_folder string
--- @param language_code string
function Lang.loadLanguage(base_folder, language_code) end

--- Adds a translation to the current language
--- @param key string key to translate
--- @param value string translation
--- @param lang? string language code to use
function Lang.addTranslation(key, value, lang) end

--- Loads languages from a folder
--- @param base_folder string
function Lang.loadLanguagesFromFolder(base_folder) end

--- Loads languages from the lang folder
function Lang.loadLanguages() end

--- Loads languages
function Lang.load() end

