--- @alias Dummy.Assets.Font "main" | "main_text" | "main_text_mono" | "small" | "curs" | "wonder" | "damage"

--- @class Dummy.Assets
---
--- @field protected fonts table<Dummy.Assets.Font, love.Font>
--- @field protected current_music love.Source|nil
--- @field protected current_sound love.Source|nil
--- @field protected audio_cache table<string, love.FileData>
local Assets = {}

function Assets.load()
  Assets.fonts = {}
  Assets.fonts.main = love.graphics.newImageFont("assets/fonts/main.png",
    " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜàáâäæçèéêëìíîïòóôöùúûü")
  Assets.fonts.main_text = love.graphics.newImageFont("assets/fonts/main_text.png",
    " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜàáâäæçèéêëìíîïòóôöùúûü")
  Assets.fonts.main_text_mono = love.graphics.newImageFont("assets/fonts/main_text_mono.png",
    " !\"$%'()*+,-./\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^abcdefghijklmnopqrstuvwxyz{|}~_ÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜàáâäæçèéêëìíîïòóôöùúûü")
  Assets.fonts.small = love.graphics.newImageFont("assets/fonts/small.png",
    " !\"$'()+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]_`abcdefghijklmnopqrstuvwxyz")
  Assets.fonts.curs = love.graphics.newImageFont("assets/fonts/curs.png",
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")
  Assets.fonts.wonder = love.graphics.newImageFont("assets/fonts/wonder.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
  Assets.fonts.damage = love.graphics.newImageFont("assets/fonts/damage.png",
    " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")

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
  return Assets.fonts[name]
end

--- Adds a font
--- @param font_name string
--- @param font love.Font
function Assets.addFont(font_name, font)
  Assets.fonts[tostring(font_name):lower()] = font
end

--- Checks which extension to use
---@param name string
---@param exts table<string, string>
---@return string
function Assets.checkFilenameExt(name, exts)
  local ext_index = 1
  local filename = ""
  local fileinfo = nil
  repeat
    filename = name .. "." .. exts[ext_index]
    fileinfo = love.filesystem.getInfo(filename, "file")
    ext_index = ext_index + 1
  until fileinfo ~= nil or ext_index > #exts

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
function Assets.playAudio(folder, audio_name, type, play, loop)
  local filename = Assets.checkFilenameExt(folder .. audio_name, { "mp3", "wav", "ogg" })

  local source = nil
  local success = true
  local file_data = Assets.audio_cache[filename]

  if file_data == nil then
    success, file_data = pcall(love.filesystem.newFileData, filename)
    assert(success, "Audio \"" .. audio_name .. "\" not found")
  end

  success, source = pcall(love.audio.newSource, file_data, type)
  assert(success, "Audio \"" .. audio_name .. "\" not found")

  if Assets.audio_cache[filename] == nil then
    Assets.audio_cache[filename] = file_data
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
function Assets.playMusic(music_name, play, loop, replace)
  play = Utils.getOrDefault(play, true)
  loop = Utils.getOrDefault(loop, true)
  replace = Utils.getOrDefault(replace, true)

  local source = Assets.playAudio("assets/music/", music_name, "stream", play, loop)

  if replace then
    if Assets.current_music ~= nil then
      Assets.current_music:stop()
    end
  end

  Assets.current_music = source
  return source
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

  local source = Assets.playAudio("assets/sounds/", sound_name, "static", play, loop)

  if replace == true then
    if Assets.current_sound ~= nil then
      Assets.current_sound:stop()
    end
  end

  Assets.current_sound = source
  return source
end

--- Clears the cache
function Assets.clear()
  Assets.audio_cache = {}
end

return Assets
