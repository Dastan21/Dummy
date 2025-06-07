--[[
  Generated from ..\engine\lang.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/lang.lua
]]

---@meta

--- @class Dummy.Lang
---
--- @field private translations table<string, table<string, string>>
--- @field private languages table<number, string>
--- @field private language_code string
--- @field private language_name string
Lang = {}

--- Gets the current language code
--- @return string
function Lang.getLanguage() end

--- Gets the current language name
--- @return string
function Lang.getLanguageName() end

--- Sets the current language
--- @param code string language code
function Lang.setLanguage(code) end

--- Switches current language
function Lang.switchLanguage() end

--- Translate a key in the current language
--- @param key string|table|function key to translate
--- @param ... table additional data passed along the key
--- @return string
function Lang.translate(key, ...) end

--- Loads languages
function Lang.load() end

