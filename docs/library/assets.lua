--[[
  Generated from ..\engine\assets.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/assets.lua
]]

---@meta

--- @class Dummy.Assets
---
--- @field protected fonts table<Dummy.Assets.Font, love.Font>
--- @field protected current_music love.Source|nil
--- @field protected current_sound love.Source|nil
Assets = {}

--- @alias Dummy.Assets.Font "main" | "main_text" | "main_text_mono" | "small" | "curs" | "wonder" | "damage" | "plain"

function Assets.load() end

--- Gets a font
--- @param name Dummy.Assets.Font
--- @return love.Font
function Assets.getFont(name) end

--- Adds a font
--- @param font_name string
--- @param font love.Font
function Assets.addFont(font_name, font) end

--- Checks which extension to use
--- @param name string
--- @param exts table<string, string>
--- @return string
function Assets.checkFilenameExt(name, exts) end

--- Plays an audio
--- @param folder string
--- @param audio_name string
--- @param type "queue" | "static" | "stream"
--- @param play boolean
--- @param loop boolean
--- @return love.Source
function Assets.playAudio(folder, audio_name, type, play, loop) end

--- Plays a music
--- @param music_name string the music name to play
--- @param play? boolean wether the music should play instantly (Defaults to `true`)
--- @param loop? boolean wether the music should loop (Defaults to `true`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `true`)
--- @return love.Source
function Assets.playMusic(music_name, play, loop, replace) end

--- Plays a sound
--- @param sound_name string the sound name to play
--- @param play? boolean wether the sound should play instantly (Defaults to `true`)
--- @param loop? boolean wether the sound should loop (Defaults to `false`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `false`)
--- @return love.Source
function Assets.playSound(sound_name, play, loop, replace) end

--- Clears the cache
function Assets.clear() end

