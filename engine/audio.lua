local audio_exts = { "mp3", "wav", "ogg" }

local self = {}

local function getFilenameWithExt(name)
  local ext_index = 1
  local filename = ""
  local fileinfo
  repeat
    filename = name .. "." .. audio_exts[ext_index]
    fileinfo = love.filesystem.getInfo(filename, "file")
    ext_index = ext_index + 1
  until fileinfo ~= nil or ext_index > #audio_exts

  assert(fileinfo ~= nil, "File \"" .. name .. "\" not found")

  return filename
end

local function playAudio(folder, audio_name, type, play, loop)
  local filename = getFilenameWithExt(folder .. audio_name)
  local source = love.audio.newSource(filename, type)
  Scene.addAudio(source)

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

--- Stops and clear all audios
function self.clear()
  love.audio.stop()
  Scene.cleanAudios()
end

return self
