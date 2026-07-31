--[[
  Generated from ..\engine\assets.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/assets.lua
]]

---@meta

--- @class Dummy.Assets
---
--- @field protected fonts table<Dummy.Assets.Font|string, love.Font>
--- @field protected current_music love.Source|nil
--- @field protected current_musics table<love.Source, boolean>
--- @field protected current_sound love.Source|nil
--- @field protected current_sounds table<love.Source, boolean>
Assets = {}

--- @alias Dummy.Assets.Font "main" | "main_text" | "main_text_mono" | "small" | "curs" | "damage" | "plain" | "wonder"

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
--- @return string|nil
function Assets.checkFilenameExt(name, exts) end

--- Gets an audio source
--- @param folder string
--- @param audio_name string
--- @param mode "queue" | "static" | "stream"
--- @return love.Source
--- @protected
function Assets.getAudio(folder, audio_name, mode) end

--- Gets a music
--- @param music_name string
--- @return love.Source
function Assets.getMusic(music_name) end

--- Plays a music
--- @param music_name string the music name to play
--- @param play? boolean wether the music should play instantly (Defaults to `true`)
--- @param loop? boolean wether the music should loop (Defaults to `true`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `true`)
--- @return love.Source
function Assets.playMusic(music_name, play, loop, replace) end

--- Gets a sound
--- @param sound_name string
--- @return love.Source
function Assets.getSound(sound_name) end

--- Plays a sound
--- @param sound_name string the sound name to play
--- @param play? boolean wether the sound should play instantly (Defaults to `true`)
--- @param loop? boolean wether the sound should loop (Defaults to `false`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `false`)
--- @return love.Source
function Assets.playSound(sound_name, play, loop, replace) end

--- Gets the current music name
--- @return string|nil
function Assets.getCurrentMusicName() end

--- Gets the current music
--- @return love.Source|nil
function Assets.getCurrentMusic() end

--- Gets the current sound name
--- @return string|nil
function Assets.getCurrentSoundName() end

--- Gets the current sound
--- @return love.Source|nil
function Assets.getCurrentSound() end

--- Fades the music
--- @param fade_in number
--- @param music love.Source
function Assets.fadeInMusic(fade_in, music) end

--- Fades the music
--- @param fade_out number
--- @param music love.Source
function Assets.fadeOutMusic(fade_out, music) end

--- Clears the cache
function Assets.clear() end

