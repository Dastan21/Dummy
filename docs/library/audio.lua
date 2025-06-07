--[[
  Generated from ..\engine\audio.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/audio.lua
]]

---@meta

--- @class Dummy.Audio
---
--- @field private current_music love.Source
Audio = {}

--- Plays an audio
--- @param folder string
--- @param audio_name string
--- @param type "queue"|"static"|"stream"
--- @param play boolean
--- @param loop boolean
--- @return love.Source
function Audio.playAudio(folder, audio_name, type, play, loop) end

--- Plays a music
--- @param music_name string the music name to play
--- @param play? boolean wether the music should play instantly (Defaults to `true`)
--- @param loop? boolean wether the music should loop (Defaults to `true`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `true`)
--- @return love.Source
function Audio.playMusic(music_name, play, loop, replace) end

--- Plays a sound
--- @param sound_name string the sound name to play
--- @param play? boolean wether the sound should play instantly (Defaults to `true`)
--- @param loop? boolean wether the sound should loop (Defaults to `false`)
--- @return love.Source
function Audio.playSound(sound_name, play, loop) end

--- Clears the cache
function Audio.clear() end

