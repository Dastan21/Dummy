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
Lang = {}

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
function Lang.switchLanguage() end

--- Translate a key in the current language
--- @param key Dummy.Text.Text key to translate
--- @param ... any additional data passed along the key
--- @return string
function Lang.translate(key, ...) end

--- Loads languages from the lang folder
function Lang.loadLanguages() end

--- Loads languages
function Lang.load() end

