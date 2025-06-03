--- @class Dummy.Audio
---
--- @field private current_music love.Source
local Audio = {}

local AUDIO_EXTS = { "mp3", "wav", "ogg" }

---@type table<string, love.FileData>
local cache = {}

--- Checks which extension to use
---@param name string
---@return string
---@private
function Audio.checkFilenameExt(name)
  local ext_index = 1
  local filename = ""
  local fileinfo = nil
  repeat
    filename = name .. "." .. AUDIO_EXTS[ext_index]
    fileinfo = love.filesystem.getInfo(filename, "file")
    ext_index = ext_index + 1
  until fileinfo ~= nil or ext_index > #AUDIO_EXTS

  assert(fileinfo ~= nil, "File \"" .. name .. "\" not found")

  return filename
end

--- Plays an audio
--- @param folder string
--- @param audio_name string
--- @param type "queue"|"static"|"stream"
--- @param play boolean
--- @param loop boolean
--- @return love.Source
function Audio.playAudio(folder, audio_name, type, play, loop)
  local filename = Audio.checkFilenameExt(folder .. audio_name)

  local source = nil
  local success = true
  local file_data = cache[filename]

  if file_data == nil then
    success, file_data = pcall(love.filesystem.newFileData, filename)
    assert(success, "Audio \"" .. audio_name .. "\" not found")
  end

  success, source = pcall(love.audio.newSource, file_data, type)
  assert(success, "Audio \"" .. audio_name .. "\" not found")

  if cache[filename] == nil then
    cache[filename] = file_data
  end

  if loop then source:setLooping(loop) end
  if play then source:play() end

  return source
end

--- Plays a music
--- @param music_name string the music name to play
--- @param play? boolean wether the music should play instantly (Defaults to `true`)
--- @param loop? boolean wether the music should loop (Defaults to `true`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `true`)
--- @return love.Source
function Audio.playMusic(music_name, play, loop, replace)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, true)
  replace = Utils.getOrDefault(replace, true)

  if replace and Audio.current_music ~= nil then
    Audio.current_music:stop()
  end

  Audio.current_music = Audio.playAudio("assets/music/", music_name, "stream", play, loop)
  return Audio.current_music
end

--- Plays a sound
--- @param sound_name string the sound name to play
--- @param play? boolean wether the sound should play instantly (Defaults to `true`)
--- @param loop? boolean wether the sound should loop (Defaults to `false`)
--- @return love.Source
function Audio.playSound(sound_name, play, loop)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, false)

  return Audio.playAudio("assets/sounds/", sound_name, "static", play, loop)
end

--- Clears the cache
function Audio.clear()
  cache = {}
end

return Audio
