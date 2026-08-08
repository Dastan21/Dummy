local Editor = require "editor.editor"
local Form = require "editor.ui.form.form"

--- @class Editor.RoomForm : Dummy.Editor.Form
---
--- @field protected data Dummy.Room.Data.Form
local RoomForm = Class(Form, "Dummy.Editor.RoomForm")

--- Creates a room form
--- @return Editor.RoomForm
function RoomForm:new()
  self = Class:new(RoomForm)

  self.title:setText("EDITOR_ROOM_FORM_TITLE")

  return self
end

--- Gets the room form's metadata
--- @return Dummy.Editor.Metadata[]
function RoomForm:getMetadata()
  --- @type Dummy.Editor.Select.Option[]
  local tileset_options = {}
  for _, tileset in ipairs(love.filesystem.getDirectoryItems("mods/" .. Editor.getModId() .. "/assets/sprites/world/tileset")) do
    local tileset_id = Utils.getFilenameWithoutExt(tileset)
    --- @type Dummy.Editor.Select.Option
    local option = {
      value = tileset_id,
      label = tileset_id
    }
    table.insert(tileset_options, option)
  end

  --- @type table<string, boolean>
  local musics = {}
  --- @type Dummy.Editor.Select.Option[]
  local music_options = {}
  for _, music in ipairs(love.filesystem.getDirectoryItems("mods/" .. Editor.getModId() .. "/assets/musics")) do
    musics[Utils.getFilenameWithoutExt(music)] = true
  end
  for _, music in ipairs(love.filesystem.getDirectoryItems("assets/musics")) do
    musics[Utils.getFilenameWithoutExt(music)] = true
  end
  for music in pairs(musics) do
    --- @type Dummy.Editor.Select.Option
    local option = {
      value = music,
      label = music
    }
    table.insert(music_options, option)
  end
  table.stable_sort(music_options, function(a, b)
    return a.label < b.label
  end)
  table.insert(music_options, 1, { value = "none", label = "EDITOR_ROOM_FORM_MUSIC_NONE" })

  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "width",
      label = "EDITOR_ROOM_FORM_WIDTH",
      type = "integer",
      default = 320,
      placeholder = "320",
      validate = function(value)
        return value >= 320
      end
    },
    {
      id = "height",
      label = "EDITOR_ROOM_FORM_HEIGHT",
      type = "integer",
      default = 240,
      placeholder = "240",
      validate = function(value)
        return value >= 240
      end
    },
    {
      id = "tileset",
      label = "EDITOR_ROOM_FORM_TILESET",
      type = "string",
      options = tileset_options,
    },
    {
      id = "music",
      label = "EDITOR_ROOM_FORM_MUSIC",
      type = "string",
      default = "none",
      options = music_options,
    },
  }
end

--- Called when the room form is confirmed
--- @param data Dummy.Room.Data.Form
function RoomForm:onConfirm(data) end

return RoomForm
