--- @alias Dummy.Assets.Font "main" | "main_text" | "main_text_mono" | "small" | "curs" | "damage" | "plain" | "wonder"

--- @class Dummy.Assets
---
--- @field protected fonts table<Dummy.Assets.Font|string, love.Font>
--- @field protected current_music love.Source|nil
--- @field protected current_musics table<love.Source, boolean>
--- @field protected current_sound love.Source|nil
--- @field protected current_sounds table<love.Source, boolean>
local Assets = {}

function Assets.load()
  Assets.clear()

  local full_characters =
  " !\"#$%&'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~ÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜàáâäæçèéêëìíîïòóôöùúûü"
  local almost_full_characters =
  " !\"#$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~ÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜàáâäæçèéêëìíîïòóôöùúûü"
  local limited_letters =
  " !\"#$%&'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~"

  Assets.fonts = {
    main = love.graphics.newImageFont("assets/fonts/main.png", almost_full_characters),
    main_text = love.graphics.newImageFont("assets/fonts/main_text.png", almost_full_characters),
    main_text_mono = love.graphics.newImageFont("assets/fonts/main_text_mono.png", almost_full_characters),
    small = love.graphics.newImageFont("assets/fonts/small.png", limited_letters),
    curs = love.graphics.newImageFont("assets/fonts/curs.png", limited_letters),
    damage = love.graphics.newImageFont("assets/fonts/damage.png", limited_letters),
    plain = love.graphics.newImageFont("assets/fonts/plain.png", full_characters),
    wonder = love.graphics.newImageFont("assets/fonts/wonder.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"),
  }

  -- Antialiazing
  for _, font in pairs(Assets.fonts) do
    font:setFilter("nearest", "nearest")
  end

  love.graphics.setFont(Assets.getFont("main"))
end

--- Gets a font
--- @param name Dummy.Assets.Font
--- @return love.Font
function Assets.getFont(name)
  assert(Assets.fonts[name] ~= nil, "Font \"" .. name .. "\" not found")
  return Assets.fonts[name]
end

--- Adds a font
--- @param font_name string
--- @param font love.Font
function Assets.addFont(font_name, font)
  Assets.fonts[tostring(font_name):lower()] = font
  font:setFilter("nearest", "nearest")
end

--- Checks which extension to use
--- @param name string
--- @param exts table<string, string>
--- @return string|nil
function Assets.checkFilenameExt(name, exts)
  local ext_index = 1
  local filename = ""
  local fileinfo = nil
  repeat
    filename = name .. "." .. exts[ext_index]
    fileinfo = love.filesystem.getInfo(filename, "file")
    ext_index = ext_index + 1
  until fileinfo ~= nil or ext_index > #exts

  return fileinfo ~= nil and filename or nil
end

--- @type table<string, love.FileData>
local audio_cache = {}

--- Gets an audio source
--- @param folder string
--- @param audio_name string
--- @param mode "queue" | "static" | "stream"
--- @return love.Source
--- @protected
function Assets.getAudio(folder, audio_name, mode)
  local filename = nil
  local audio_path = folder .. audio_name

  local mod = ModList.getCurrentMod()
  if mod ~= nil then
    filename = Assets.checkFilenameExt("mods/" .. mod:getId() .. "/" .. audio_path, { "mp3", "wav", "ogg" })
  end

  if filename == nil then
    filename = Assets.checkFilenameExt(audio_path, { "mp3", "wav", "ogg" })
  end
  assert(filename ~= nil, "File \"" .. audio_path .. "\" not found")

  local source = nil
  local success = true
  local file_data = audio_cache[filename]

  if file_data == nil then
    success, file_data = pcall(love.filesystem.newFileData, filename)
    assert(success, "Audio \"" .. audio_name .. "\" not found")
  end

  success, source = pcall(love.audio.newSource, file_data, mode)
  assert(success, "Audio \"" .. audio_name .. "\" not found")

  if audio_cache[filename] == nil then
    audio_cache[filename] = file_data
  end

  return source
end

--- Gets a music
--- @param music_name string
--- @return love.Source
function Assets.getMusic(music_name)
  local music_mode = love.system.getOS() == "Web" and "static" or "stream"
  return Assets.getAudio("assets/musics/", music_name, music_mode)
end

--- Plays a music
--- @param music_name string the music name to play
--- @param play? boolean wether the music should play instantly (Defaults to `true`)
--- @param loop? boolean wether the music should loop (Defaults to `true`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `true`)
--- @return love.Source
function Assets.playMusic(music_name, play, loop, replace)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, true)
  replace = Utils.getOrDefault(replace, true)

  local source = Assets.getMusic(music_name)

  if replace then
    if Assets.current_music ~= nil then
      Assets.current_music:stop()
    end

    Assets.current_music = source
    Assets.current_music_name = music_name
  end

  Assets.current_musics[source] = true

  if loop then source:setLooping(loop) end
  if play then source:play() end

  return source
end

--- Gets a sound
--- @param sound_name string
--- @return love.Source
function Assets.getSound(sound_name)
  return Assets.getAudio("assets/sounds/", sound_name, "static")
end

--- Plays a sound
--- @param sound_name string the sound name to play
--- @param play? boolean wether the sound should play instantly (Defaults to `true`)
--- @param loop? boolean wether the sound should loop (Defaults to `false`)
--- @param replace? boolean wether to replace the current playing music (Defaults to `false`)
--- @return love.Source
function Assets.playSound(sound_name, play, loop, replace)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, false)

  local source = Assets.getSound(sound_name)

  if replace == true then
    if Assets.current_sound ~= nil then
      Assets.current_sound:stop()
    end

    Assets.current_sound = source
    Assets.current_sound_name = sound_name
  end

  Assets.current_sounds[source] = true

  if loop then source:setLooping(loop) end
  if play then source:play() end

  return source
end

--- Gets the current music name
--- @return string|nil
function Assets.getCurrentMusicName()
  return Assets.current_music_name
end

--- Gets the current music
--- @return love.Source|nil
function Assets.getCurrentMusic()
  return Assets.current_music
end

--- Gets the current sound name
--- @return string|nil
function Assets.getCurrentSoundName()
  return Assets.current_sound_name
end

--- Gets the current sound
--- @return love.Source|nil
function Assets.getCurrentSound()
  return Assets.current_sound
end

--- Fades the music
--- @param fade_in number
--- @param music love.Source
function Assets.fadeInMusic(fade_in, music)
  if music == nil then return end

  music:setVolume(0)
  Timer.during(fade_in, function(dt, left)
    music:setVolume(1 - left / fade_in)
  end, function()
    music:setVolume(1)
  end)
end

--- Fades the music
--- @param fade_out number
--- @param music love.Source
function Assets.fadeOutMusic(fade_out, music)
  if music == nil then return end

  music:setVolume(1)
  Timer.during(fade_out, function(dt, left)
    music:setVolume(left / fade_out)
  end, function()
    music:setVolume(0)
  end)
end

--- Clears the cache
function Assets.clear()
  audio_cache = {}

  for source, _ in pairs(Assets.current_musics or {}) do
    source:stop()
  end
  Assets.current_musics = {}
  Assets.current_music = nil

  for source, _ in pairs(Assets.current_sounds or {}) do
    source:stop()
  end
  Assets.current_sounds = {}
  Assets.current_sound = nil
end

return Assets
