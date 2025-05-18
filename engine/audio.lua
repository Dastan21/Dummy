local AUDIO_EXTS = { "mp3", "wav", "ogg" }

local cache = {}
local self = {}

local function getFilenameWithExt(name)
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

local function playAudio(folder, audio_name, type, play, loop)
  local filename = getFilenameWithExt(folder .. audio_name)

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
---@param music_name string
---@param play? boolean (Defaults to `true`)
---@param loop? boolean (Defaults to `true`)
---@return love.Source
function self.playMusic(music_name, play, loop)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, true)
  return playAudio("assets/music/", music_name, "stream", play, loop)
end

--- Plays a sound
---@param sound_name string
---@param play? boolean (Defaults to `true`)
---@param loop? boolean (Defaults to `false`)
---@return love.Source
function self.playSound(sound_name, play, loop)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, false)
  return playAudio("assets/sounds/", sound_name, "static", play, loop)
end

return self
