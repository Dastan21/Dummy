local Window = require "editor.ui.window"
local Button = require "editor.ui.button"

--- @class Dummy.Editor.KeybindGroup
---
--- @field id Dummy.Text.Text
--- @field keybinds Dummy.Editor.Keybind[]

--- @class Dummy.Editor.Keybind
---
--- @field id Dummy.Text.Text
--- @field key string

--- @class Dummy.Editor.KeybindsWindow : Dummy.Editor.Window
---
--- @field protected keybinds Dummy.Editor.KeybindGroup[]
local KeybindsWindow = Class(Window, "Dummy.Editor.KeybindsWindow")

KeybindsWindow.WINDOW_WIDTH = 256
KeybindsWindow.WINDOW_HEIGHT = 180
KeybindsWindow.CLOSE_BUTTON_SIZE = 20
KeybindsWindow.WINDOW_PADDING = 6
KeybindsWindow.KEYBIND_GROUP_HEIGHT = 24
KeybindsWindow.KEYBIND_GROUP_MARGIN = 12
KeybindsWindow.KEYBIND_HEIGHT = 20

--- Creates a keybinds window
--- @return Dummy.Editor.KeybindsWindow
function KeybindsWindow:new()
  self = Class:new(KeybindsWindow, Window:new())

  self.keybinds = {
    {
      id = "MENU",
      keybinds = {
        {
          id = "MENU",
          key = "ESC"
        },
        {
          id = "NEW",
          key = "CTRL_N"
        },
        {
          id = "OPEN",
          key = "CTRL_O"
        },
        {
          id = "PROPERTIES",
          key = "CTRL_I"
        },
        {
          id = "SAVE",
          key = "CTRL_S"
        },
        {
          id = "PLAYTEST_ROOM",
          key = "CTRL_ENTER"
        }
      }
    },
    {
      id = "ACTIONS",
      keybinds = {
        {
          id = "POINTER",
          key = "F"
        },
        {
          id = "PEN",
          key = "B"
        },
        {
          id = "ERASER",
          key = "E"
        },
        {
          id = "COPY_TILE",
          key = "ALT_LEFT_CLICK"
        },
        {
          id = "UNDO",
          key = "CTRL_Z"
        },
        {
          id = "REDO",
          key = "CTRL_Y"
        }
      }
    },
    {
      id = "VIEW",
      keybinds = {
        {
          id = "CENTER",
          key = "C"
        },
        {
          id = "RESET_ZOOM",
          key = "M"
        },
        {
          id = "LAYER_UP",
          key = "PG_UP"
        },
        {
          id = "LAYER_DOWN",
          key = "PG_DOWN"
        }
      }
    },
    {
      id = "MISC",
      keybinds = {
        {
          id = "ADD_OBJECT",
          key = "O"
        },
        {
          id = "OBJECTS_DRAW",
          key = "H"
        }
      }
    },
    {
      id = "ENGINE",
      keybinds = {
        {
          id = "FULLSCREEN",
          key = "F4"
        },
        {
          id = "FPS",
          key = "F6"
        },
        {
          id = "TAKE_SCREENSHOT",
          key = "F9"
        },
        {
          id = "OPEN_SCREENSHOT_FOLDER",
          key = "F10"
        },
        {
          id = "MUTE",
          key = "CTRL_M"
        }
      }
    },
    {
      id = "DEBUG",
      keybinds = {
        {
          id = "TOGGLE",
          key = "CTRL_ALT_SHIFT_D"
        },
        {
          id = "SHOW_DEBUG",
          key = "F7"
        },
        {
          id = "LOGGING",
          key = "F8"
        },
        {
          id = "CLEAR_LOGS",
          key = "CTRL_F8"
        },
        {
          id = "HEAL_PLAYER",
          key = "CTRL_H"
        },
        {
          id = "GAME_OVER",
          key = "CTRL_G"
        },
        {
          id = "RELOAD",
          key = "CTRL_R"
        },
        {
          id = "FULL_RELOAD",
          key = "CTRL_SHIFT_R"
        }
      }
    }
  }

  self:initKeybindsWindow()

  return self
end

--- Initializes the keybinds window
function KeybindsWindow:initKeybindsWindow()
  self:setVisible(false)

  self:setWidth(KeybindsWindow.WINDOW_WIDTH)
  self:setHeight(KeybindsWindow.WINDOW_HEIGHT)
  self:setPadding(0, 0, KeybindsWindow.WINDOW_PADDING, 0)

  local window_x = (Constants.WORLD_WIDTH - KeybindsWindow.WINDOW_WIDTH) / 2
  local window_y = (Constants.WORLD_HEIGHT - KeybindsWindow.WINDOW_HEIGHT) / 2
  self:setPosition(window_x, window_y)

  local offset_y = KeybindsWindow.WINDOW_PADDING
  for _, keybind_group in ipairs(self.keybinds) do
    local keybind_group_title_text = "EDITOR_KEYBINDS_" .. UTF8.upper(keybind_group.id)
    local keybind_group_title = Text:new(keybind_group_title_text)
    keybind_group_title:setParent(self)
    keybind_group_title:setFont("main_text")
    keybind_group_title:setOrigin(0, 0)
    keybind_group_title:setPosition(KeybindsWindow.WINDOW_PADDING, offset_y)
    keybind_group_title:setTag("UI")

    offset_y = offset_y + KeybindsWindow.KEYBIND_GROUP_HEIGHT

    for _, keybind in ipairs(keybind_group.keybinds) do
      local keybind_title = Text:new(keybind_group_title_text .. "_" .. UTF8.upper(keybind.id))
      keybind_title:setParent(self)
      keybind_title:setFont("main_text")
      keybind_title:setOrigin(0, 0)
      keybind_title:setPosition(KeybindsWindow.KEYBIND_GROUP_HEIGHT / 2, offset_y)
      keybind_title:setTag("UI")

      local keybind_keys = Text:new("EDITOR_KEYBINDS_" .. UTF8.upper(keybind.key))
      keybind_keys:setParent(self)
      keybind_keys:setFont("main_text")
      keybind_keys:setOrigin(1, 0)
      keybind_keys:setPosition(self:getWidth() - KeybindsWindow.WINDOW_PADDING, offset_y)
      keybind_keys:setTag("UI")

      offset_y = offset_y + KeybindsWindow.KEYBIND_HEIGHT
    end

    offset_y = offset_y + KeybindsWindow.KEYBIND_GROUP_MARGIN
  end
end

--- Called when the keybinds window is closed
function KeybindsWindow:onClose() end

--- Updates the keybinds window, called on every frame
--- @param dt number
function KeybindsWindow:update(dt)
  if not self:isVisible() then return end

  Window.update(self, dt)

  if self.closing then
    self.closing = false

    self:setVisible(false)

    if type(self.onClose) == "function" then
      self:onClose()
    end
  end

  if Input.isPressed(Input.Escape) then
    self.closing = true
  end
end

return KeybindsWindow
