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
  if Scene.audios[audio_name] ~= nil then return Scene.audios[audio_name] end

  local filename = getFilenameWithExt(folder .. audio_name)
  local source = love.audio.newSource(filename, type)
  Scene.audios[audio_name] = source

  play = play == nil and true or play
  loop = loop == nil and true or loop
  if loop then source:setLooping(loop) end
  if play then source:play() end

  return source
end

function self.playMusic(music_name, play, loop)
  return playAudio("assets/music/", music_name, "stream", play, loop)
end

function self.playSound(sound_name, play, loop)
  return playAudio("assets/sounds/", sound_name, "static", play, loop)
end

function self.stop()
  love.audio.stop()
end

return self
