local Button = require "editor.ui.button"
local InputText = require "editor.ui.input_text"
local Window = require "editor.ui.window"
local Confirm = require "editor.ui.confirm"

--- @alias Dummy.Editor.Metadata.Value string|number|boolean|love.Color|Dummy.Editor.Metadata.Value[]
--- @alias Dummy.Editor.Metadata.Type "string" | "number" | "integer" | "boolean" | "button" | "form" | "list"
--- @alias Dummy.Editor.Cell.Action "pointer" | "pen" | "eraser"

--- @class Dummy.Editor.Menu.Button
---
--- @field id string
--- @field text Dummy.Text.Text
--- @field action fun(self: Dummy.Editor.Menu.Button)
--- @field button Dummy.Editor.Button

--- @class Dummy.Editor.Metadata
---
--- @field id string|number
--- @field label Dummy.Text.Text
--- @field type Dummy.Editor.Metadata.Type
--- @field default? Dummy.Editor.Metadata.Value
--- @field placeholder? string
--- @field text? string
--- @field options? Dummy.Editor.Select.Option[]
--- @field formatter? fun(value: string): string|nil
--- @field validate? fun(value: Dummy.Editor.Metadata.Value): boolean
--- @field onclick? fun(self: Dummy.Editor.Metadata, button: Dummy.Editor.Button)
--- @field list_type? Dummy.Editor.Metadata.Type
--- @field form? string

--- @class Dummy.Editor.Action
---
--- @field id Dummy.Editor.Cell.Action
--- @field button Dummy.Editor.Button
--- @field keybinds string[]|nil

--- @class Dummy.Editor.Snapshot
---
--- @field room_id string
--- @field width number
--- @field height number
--- @field tileset string
--- @field tiles table<integer, Dummy.Tileset.TileData[]>
--- @field objects table<integer, Dummy.Object.Data[]>

--- @class Dummy.Editor
---
--- @field protected mod_id string
--- @field protected map_camera Dummy.GameCamera
--- @field protected ui_camera Dummy.GameCamera
--- @field protected room_data Dummy.Room.Data
--- @field protected room_id_prev string
--- @field protected room_id_input Dummy.Editor.InputText
--- @field protected room_width number
--- @field protected room_height number
--- @field protected room_tileset string
--- @field protected room_music string
--- @field protected tiles table<integer, Dummy.Tileset.TileData[]>
--- @field protected tileset Dummy.Tileset
--- @field protected grip_pos [number, number]
--- @field protected prev_map_pos [number, number]
--- @field protected actions Dummy.Editor.Action[]
--- @field protected action_hovered Dummy.Editor.Action
--- @field protected action_selected string|nil
--- @field protected cell_hovered [number, number]
--- @field protected cell_hovered_text Dummy.Text
--- @field protected cursor_preview_draw Dummy.Drawable
--- @field protected room_preview_draw Dummy.Drawable
--- @field protected center_btn Dummy.Editor.Button
--- @field protected reset_zoom_btn Dummy.Editor.Button
--- @field protected zoom_level_text Dummy.Text
--- @field protected history Dummy.Editor.Snapshot[]
--- @field protected history_index integer
--- @field protected history_time number
--- @field protected history_changed boolean
--- @field protected tile_selector_window Dummy.Editor.Window
--- @field protected tile_selected integer|nil
--- @field protected tile_selection_time number
--- @field protected layer_selected integer
--- @field protected layer_text Dummy.Text
--- @field protected layer_up_btn Dummy.Editor.Button
--- @field protected layer_down_btn Dummy.Editor.Button
--- @field protected add_object_btn Dummy.Editor.Button
--- @field protected show_object_editor_draw_btn Dummy.Editor.Button
--- @field protected enable_objects_draw boolean
--- @field protected objects Dummy.Object.Data[]
--- @field protected hovered_obj Dummy.Object.Data|nil
--- @field protected hovered_obj_text Dummy.Text
--- @field protected selected_object Dummy.Object.Data|nil
--- @field protected selected_object_pos [number, number]
--- @field protected selected_object_cursor_pos [number, number]
--- @field protected render_objects_draw Dummy.Drawable
--- @field protected object_form Editor.ObjectForm
--- @field protected missing_image Dummy.Sprite.Image
--- @field protected keybinds_window Dummy.Editor.KeybindsWindow
--- @field protected main_controller "keyboard" | "gamepad"
local Editor = {}

Editor.MAX_LAYERS = 10

Editor.ZOOM_MIN = 0.125
Editor.ZOOM_MAX = 4
Editor.ZOOM_STEP = 1.25

Editor.CURSOR_SIZE_MAX = 8
Editor.CURSOR_SIZE_MIN = 1
Editor.CURSOR_SIZE_STEP = 1

Editor.MENU_BUTTON_SIZE = 16
Editor.MENU_BUTTON_MARGIN = 4
Editor.MENU_BUTTON_PADDING_X = 8
Editor.MENU_BUTTON_PADDING_Y = 2

Editor.ROOM_LIST_WINDOW_MAX_WIDTH = 196
Editor.ROOM_BUTTON_PADDING_X = 4
Editor.ROOM_BUTTON_PADDING_Y = 2

Editor.TILE_SELECTOR_HEIGHT = 23
Editor.TILE_BUTTON_SIZE = 20
Editor.TILE_BUTTON_MARGIN = 1

Editor.TILESET_VIEW_WIDTH = 96
Editor.TILESET_VIEW_HEIGHT = 96

Editor.HISTORY_START_DELAY = 0.5
Editor.HISTORY_DELAY = 0.05

Editor.TILE_SELECTION_START_DELAY = 0.5
Editor.TILE_SELECTION_DELAY = 0.05

--- Loads the editor
--- @param mod_id string
--- @param room_id? string
function Editor.load(mod_id, room_id)
  assert(ModList.getMod(mod_id) ~= nil, "Cannot load editor for an unknown mod")
  Editor.mod_id = mod_id

  Editor.map_camera = GameCamera:new(Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT)
  Editor.ui_camera = GameCamera:new(Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT, "UI")

  Editor.grip_pos = { 0, 0 }
  Editor.prev_map_pos = { 0, 0 }

  Cursor.setIcon("default")
  Cursor.setVisible(true)

  Editor.initRoomData()
  Editor.initMenu()
  Editor.initLaunchMod()
  Editor.initTiles()
  Editor.initCells()
  Editor.initHistory()
  Editor.initActions()
  Editor.initObjects()

  if room_id ~= nil and room_id ~= "" then
    local room_data = Room.parseRoomData(mod_id, room_id)
    assert(room_data ~= nil, "Failed to load room \"" .. room_id .. "\"")

    Editor.loadRoom(room_data)
  else
    Editor.pushHistorySnapshot()
    Editor.hasUnsavedChanges()

    if room_id == nil then
      local room_list = Editor.loadRoomsList()
      if #room_list > 0 then
        Timer.next(function()
          Scene.reloadWithData(Editor.mod_id, Utils.getFilenameWithoutExt(room_list[1].filename))
        end)
      end
    end
  end
end

--- Gets the editor's mod id
--- @return string
function Editor.getModId()
  return Editor.mod_id
end

--- Initializes the room data
function Editor.initRoomData()
  local mod = ModList.getMod(Editor.mod_id)
  if mod == nil then return end

  love.filesystem.createDirectory("mods/" .. Editor.mod_id .. "/assets/sprites/world/tileset")
  love.filesystem.createDirectory("mods/" .. Editor.mod_id .. "/scripts/world/room")

  Editor.room_data = {
    id = "unnamed_room",
    width = 320,
    height = 240,
    tileset = "default",
    music = "none",
    tiles = {},
    objects = {},
  }

  local left_margin = Editor.MENU_BUTTON_SIZE + Editor.MENU_BUTTON_MARGIN * 2
  Editor.mod_name_text = Text:new(mod:getName() .. " / ", true)
  Editor.mod_name_text:setOrigin(0, 0)
  Editor.mod_name_text:setFont("main_text")
  Editor.mod_name_text:setPosition(left_margin, Editor.MENU_BUTTON_MARGIN - 1)
  Editor.mod_name_text:setTag("UI")

  Editor.room_id_prev = Editor.room_data.id
  Editor.room_id_input = InputText:new()
  Editor.room_id_input:setPosition(Editor.mod_name_text:getWidth() + left_margin - 4, Editor.MENU_BUTTON_MARGIN - 1)
  Editor.room_id_input:setBorder(0)
  Editor.room_id_input:setAlpha(0)
  Editor.room_id_input:setMaxCharacters(32)
  Editor.room_id_input:setValue(Editor.room_data.id)
  local room_id_text = Editor.room_id_input:getText()
  room_id_text:setFont("main_text")

  function Editor.room_id_input.onInput()
    Editor.hasUnsavedChanges()
  end

  function Editor.room_id_input.onBlur(input)
    local value = input:getValue()
    if UTF8.len(input:getValue()) <= 0 then
      value = Editor.room_id_prev
    end
    input:setValue(UTF8.lower(Utils.sanitizeFilename(value)))

    if value ~= Editor.room_id_prev then
      Editor.room_id_prev = value
      Editor.pushHistorySnapshot()
    end
  end

  function Editor.room_id_input.onPointerEnter() end

  function Editor.room_id_input.onPointerLeave() end

  function Editor.room_id_input.onFocus() end

  Editor.room_width = Editor.room_data.width
  Editor.room_height = Editor.room_data.height
  Editor.room_tileset = Editor.room_data.tileset
  Editor.room_music = Editor.room_data.music
end

--- Initialize the menu window
function Editor.initMenu()
  -- menu window
  Editor.menu_window = Window:new()
  Editor.menu_window:setVisible(false)

  Editor.menu_btn = Button:new()
  Editor.menu_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.menu_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.menu_btn:setPosition(Editor.MENU_BUTTON_MARGIN + Editor.MENU_BUTTON_SIZE / 2,
    Editor.MENU_BUTTON_MARGIN + Editor.MENU_BUTTON_SIZE / 2)
  Editor.menu_btn:setSprite(Sprite:new({
    "editor/menu",
    "editor/cross"
  }, 0, false, false))
  Editor.menu_btn:setTooltip("EDITOR_TOOLTIP_MENU")
  Editor.menu_btn:getTooltip():setOffset(Editor.MENU_BUTTON_SIZE / 2)
  Editor.menu_btn:getTooltip():setDirection("right")

  function Editor.menu_btn.onClick(btn)
    Editor.toggleMenu()
    btn:setFocused(false)
  end

  Editor.menu_btns = {
    {
      id = "NEW",
      text = "EDITOR_MENU_FILE_NEW",
      button = Button:new(),
      action = Editor.newRoom
    },
    {
      id = "OPEN",
      text = "EDITOR_MENU_FILE_OPEN",
      button = Button:new(),
      action = function()
        if Editor.room_list_window:isVisible() then
          Editor.room_list_window:setVisible(false)
        else
          Editor.showRoomsList()
        end
      end
    },
    {
      id = "PROPERTIES",
      text = "EDITOR_MENU_FILE_PROPERTIES",
      button = Button:new(),
      action = Editor.openRoomForm
    },
    {
      id = "SAVE",
      text = "EDITOR_MENU_FILE_SAVE",
      button = Button:new(),
      action = Editor.saveRoom
    },
    {
      id = "PLAYTEST_ROOM",
      text = "EDITOR_MENU_PLAYTEST_ROOM",
      button = Button:new(),
      action = Editor.playRoom
    },
    {
      id = "KEYBINDS",
      text = "EDITOR_MENU_KEYBINDS",
      button = Button:new(),
      action = Editor.openKeybindsMenu
    },
    {
      id = "QUIT",
      text = "EDITOR_MENU_QUIT",
      button = Button:new(),
      action = function()
        Editor.toggleMenu(false)

        Editor.confirmSaveBeforeQuitting(function()
          Scene.change("MAIN_MENU")
        end)
      end
    },
  }

  local menu_btns = {}
  local menu_window_width = 0
  local menu_window_height = 0
  local menu_btn_offset = 0
  for _, menu_btn in ipairs(Editor.menu_btns) do
    menu_btn.button:setParent(Editor.menu_window)
    menu_btn.button:setOrigin(0, 0)
    local text = Text:new(menu_btn.text)
    menu_btn.button:setText(text)
    text:setOrigin(0, 0)
    text:setPosition(Editor.MENU_BUTTON_PADDING_X, Editor.MENU_BUTTON_PADDING_Y)
    menu_btn.button:setWidth(text:getWidth() + Editor.MENU_BUTTON_PADDING_X * 2)
    menu_btn.button:setHeight(text:getHeight() + Editor.MENU_BUTTON_PADDING_Y * 2)
    menu_btn.button:setPosition(0, menu_btn_offset)
    menu_btn.button:setBorder(0)

    menu_btn_offset = menu_btn_offset + text:getHeight() + Editor.MENU_BUTTON_PADDING_Y * 2

    function menu_btn.button.onClick()
      if type(menu_btn.action) == "function" then
        menu_btn:action()
      end
    end

    menu_window_width = math.max(menu_window_width, menu_btn.button:getWidth())
    menu_window_height = menu_window_height + menu_btn.button:getHeight()

    table.insert(menu_btns, { menu_btn.button })
  end

  Editor.menu_window:setWidth(menu_window_width)
  Editor.menu_window:setHeight(menu_window_height)
  Editor.menu_window:setPosition(Editor.MENU_BUTTON_MARGIN * 2 + Editor.MENU_BUTTON_SIZE + 1,
    Editor.MENU_BUTTON_MARGIN + 1)

  Editor.menu_window:setUIElements(menu_btns, true)

  for _, menu_btn in ipairs(Editor.menu_btns) do
    menu_btn.button:setWidth(menu_window_width)
  end

  -- room list window
  Editor.room_list_window = Window:new()
  Editor.room_list_window:setVisible(false)

  -- confirm modal
  Editor.confirm_modal = Confirm:new()

  -- room form
  local RoomForm = require "editor.ui.form.room_form"
  Editor.room_form = RoomForm:new()

  function Editor.room_form.onConfirm(_, data)
    Editor.room_width = data.width
    Editor.room_height = data.height
    local prev_tileset = Editor.room_tileset
    Editor.room_tileset = data.tileset
    Editor.room_music = data.music

    if prev_tileset ~= data.tileset then
      Editor.loadTileset()
    end

    Editor.pushHistorySnapshot()
    Editor.hasUnsavedChanges()
  end

  function Editor.room_form.onClose()
    Editor.selectAction("pointer")
    Editor.toggleEditorButtons(true)

    Cursor.setIcon("default")
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end
  end

  -- keybinds window
  local KeybindsWindow = require "editor.ui.keybinds_window"
  Editor.keybinds_window = KeybindsWindow:new()

  function Editor.keybinds_window.onClose()
    Editor.selectAction("pointer")
    Editor.toggleEditorButtons(true)

    Cursor.setIcon("default")
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end
  end
end

--- Initializes the play room button
function Editor.initLaunchMod()
  Editor.play_room_btn = Button:new()
  Editor.play_room_btn:setSprite(Sprite:new("editor/play"))
  Editor.play_room_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.play_room_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.play_room_btn:setPosition(Editor.MENU_BUTTON_MARGIN + Editor.MENU_BUTTON_SIZE / 2,
    Editor.MENU_BUTTON_MARGIN * 2 + Editor.MENU_BUTTON_SIZE * 1.5)
  Editor.play_room_btn:setTooltip("EDITOR_TOOLTIP_PLAYTEST_ROOM")
  Editor.play_room_btn:getTooltip():setOffset(Editor.MENU_BUTTON_SIZE / 2)
  Editor.play_room_btn:getTooltip():setDirection("right")

  function Editor.play_room_btn.onClick()
    Editor.playRoom()
  end
end

--- Initializes the room tiles
function Editor.initTiles()
  Editor.tileset = nil
  Editor.tiles = {}
  Editor.tile_selection_time = 0

  local map_width, map_height = Editor.getMapDimensions()

  Editor.tile_selector_window = Window:new()
  Editor.tile_selector_window:setTag("UI")
  Editor.tile_selector_window:setWidth(map_width)
  Editor.tile_selector_window:setHeight(Editor.TILE_SELECTOR_HEIGHT)
  Editor.tile_selector_window:setPosition(0, map_height - Editor.TILE_SELECTOR_HEIGHT)

  function Editor.tile_selector_window.isFocused() return false end

  Editor.tile_selector_window.SCROLL_DELTA = Editor.TILE_BUTTON_SIZE + Editor.TILE_BUTTON_MARGIN

  Editor.tileset_warning_text = Text:new("EDITOR_TILESET_DEFAULT_WARNING")
  Editor.tileset_warning_text:setPosition(map_width / 2, map_height - Editor.TILE_SELECTOR_HEIGHT / 2)
  Editor.tileset_warning_text:setFont("small")
  Editor.tileset_warning_text:setLayer(Constants.LAYERS.WINDOW)
  Editor.tileset_warning_text:setTag("UI")
  Editor.tileset_warning_text:setVisible(false)

  Editor.loadTileset()

  -- layers
  local layer_btn_x = map_width - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN
  local layer_btn_y = map_height - Editor.TILE_SELECTOR_HEIGHT - Editor.MENU_BUTTON_SIZE * 5 / 2 -
      Editor.MENU_BUTTON_MARGIN * 5

  Editor.layer_text = Text:new("1")
  Editor.layer_text:setPosition(layer_btn_x, layer_btn_y - Editor.MENU_BUTTON_SIZE * 2 - Editor.MENU_BUTTON_MARGIN - 1)
  Editor.layer_text:setFont("main_text")
  Editor.layer_text:setTag("UI")

  Editor.layer_up_btn = Button:new()
  Editor.layer_up_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.layer_up_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.layer_up_btn:setPosition(layer_btn_x,
    layer_btn_y - Editor.MENU_BUTTON_SIZE * 2.5 - Editor.MENU_BUTTON_MARGIN * 3)
  Editor.layer_up_btn:setSprite(Sprite:new({ "editor/arrow_full" }, 0, false, false))
  Editor.layer_up_btn:getSprite():setAngle(180)
  Editor.layer_up_btn:getSprite():setPosition(-1, 0)
  Editor.layer_up_btn:setTooltip("EDITOR_TOOLTIP_LAYER_UP")
  Editor.layer_up_btn:getTooltip():setDirection("left")

  function Editor.layer_up_btn.onClick(btn)
    Editor.selectLayer(Editor.getSelectedLayer() + 1)
    btn:setFocused(false)

    if not btn:isDisabled() then
      btn:onPointerEnter()
    else
      Cursor.setIcon("default")
    end
  end

  Editor.layer_down_btn = Button:new()
  Editor.layer_down_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.layer_down_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.layer_down_btn:setPosition(layer_btn_x, layer_btn_y - Editor.MENU_BUTTON_SIZE - Editor.MENU_BUTTON_MARGIN)
  Editor.layer_down_btn:setSprite(Sprite:new({ "editor/arrow_full" }, 0, false, false))
  Editor.layer_down_btn:setTooltip("EDITOR_TOOLTIP_LAYER_DOWN")
  Editor.layer_down_btn:getTooltip():setDirection("left")
  Editor.layer_down_btn:setDisabled(true)

  function Editor.layer_down_btn.onClick(btn)
    Editor.selectLayer(Editor.getSelectedLayer() - 1)
    btn:setFocused(false)

    if not btn:isDisabled() then
      btn:onPointerEnter()
    else
      Cursor.setIcon("default")
    end
  end

  Editor.selectLayer(0)
end

--- Initializes the cells
function Editor.initCells()
  Editor.cell_hovered = { 0, 0 }

  Editor.center_btn = Button:new()
  Editor.center_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.center_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  local map_width, map_height = Editor.getMapDimensions()
  local center_btn_x = map_width - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN
  local center_btn_y = map_height - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN -
      Editor.TILE_SELECTOR_HEIGHT - 1
  Editor.center_btn:setPosition(center_btn_x, center_btn_y)
  Editor.center_btn:setSprite(Sprite:new({ "editor/center" }, 0, false, false))
  Editor.center_btn:setTooltip("EDITOR_TOOLTIP_CENTER_VIEW")

  function Editor.center_btn.onClick(btn)
    Editor.center()
    btn:setFocused(false)
    btn:onPointerEnter()
  end

  Editor.cell_hovered_text = Text:new()
  local cell_hovered_text_x = center_btn_x - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN / 2
  Editor.cell_hovered_text:setPosition(cell_hovered_text_x, center_btn_y + Editor.MENU_BUTTON_SIZE / 2)
  Editor.cell_hovered_text:setOrigin(1, 1)
  Editor.cell_hovered_text:setFont("small")
  Editor.cell_hovered_text:setTag("UI")

  Editor.reset_zoom_btn = Button:new()
  Editor.reset_zoom_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.reset_zoom_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.reset_zoom_btn:setPosition(center_btn_x, center_btn_y - Editor.MENU_BUTTON_SIZE - Editor.MENU_BUTTON_MARGIN)
  Editor.reset_zoom_btn:setSprite(Sprite:new({ "editor/zoom" }, 0, false, false))
  Editor.reset_zoom_btn:setTooltip("EDITOR_TOOLTIP_RESET_ZOOM_VIEW")

  function Editor.reset_zoom_btn.onClick(btn)
    Editor.setZoom(1)
    btn:setFocused(false)
    btn:onPointerEnter()
  end

  local _, reset_zoom_btn_y = Editor.reset_zoom_btn:getPosition()
  Editor.zoom_level_text = Text:new("100%")
  local zoom_level_text_x = center_btn_x - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN / 2
  local zoom_level_text_y = reset_zoom_btn_y + Editor.MENU_BUTTON_SIZE / 2
  Editor.zoom_level_text:setPosition(zoom_level_text_x, zoom_level_text_y)
  Editor.zoom_level_text:setOrigin(1, 1)
  Editor.zoom_level_text:setFont("small")
  Editor.zoom_level_text:setTag("UI")

  Editor.cursor_preview_draw = Drawable:new()
  Editor.cursor_preview_draw:setLayer(Constants.LAYERS.CURSOR)
  function Editor.cursor_preview_draw.draw(_self)
    if not _self:isVisible() or Editor.tileset == nil or not Editor.canUseEditor() or not Editor.canHover() or Editor.isActionSelected("pointer") then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")

    local cell_x, cell_y = Editor.getHoveredCell()
    local point_x = cell_x - Constants.TILE_SIZE
    local point_y = cell_y - Constants.TILE_SIZE
    love.graphics.rectangle("line", point_x + 0.5, point_y + 0.5, Constants.TILE_SIZE - 1, Constants.TILE_SIZE - 1)
  end

  Editor.room_preview_draw = Drawable:new()
  Editor.room_preview_draw:setLayer(Constants.LAYERS.WORLD_BACKGROUND)
  function Editor.room_preview_draw.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.setColor(0.15, 0.15, 0.15)
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")

    love.graphics.rectangle("line", -0.5, -0.5, Editor.room_width + 1, Editor.room_height + 1)
  end
end

--- Initialize the history
function Editor.initHistory()
  Editor.history = {}
  Editor.history_index = 0
  Editor.history_changed = false
  Editor.history_time = 0

  local map_width = Editor.getMapDimensions()
  local history_btn_left = map_width - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN
  local history_btn_bottom = Editor.MENU_BUTTON_SIZE / 2 + Editor.MENU_BUTTON_MARGIN

  -- init undo/redo buttons
  Editor.undo_btn = Button:new()
  Editor.undo_btn:setSprite(Sprite:new("editor/undo"))
  Editor.undo_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.undo_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.undo_btn:setPosition(history_btn_left - Editor.MENU_BUTTON_MARGIN - Editor.MENU_BUTTON_SIZE, history_btn_bottom)
  Editor.undo_btn:setTooltip("EDITOR_TOOLTIP_HISTORY_UNDO")
  Editor.undo_btn:getTooltip():setOffset(Editor.MENU_BUTTON_SIZE / 2)
  Editor.undo_btn:getTooltip():setDirection("left")
  function Editor.undo_btn.onClick(btn)
    Editor.undo()
    btn:setFocused(false)

    if not btn:isDisabled() then
      btn:onPointerEnter()
    else
      Cursor.setIcon("default")
    end
  end

  Editor.redo_btn = Button:new()
  Editor.redo_btn:setSprite(Sprite:new("editor/redo"))
  Editor.redo_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.redo_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  Editor.redo_btn:setPosition(history_btn_left, history_btn_bottom)
  Editor.redo_btn:setTooltip("EDITOR_TOOLTIP_HISTORY_REDO")
  Editor.redo_btn:getTooltip():setOffset(Editor.MENU_BUTTON_SIZE / 2)
  Editor.redo_btn:getTooltip():setDirection("left")
  function Editor.redo_btn.onClick(btn)
    Editor.redo()
    btn:setFocused(false)

    if not btn:isDisabled() then
      btn:onPointerEnter()
    else
      Cursor.setIcon("default")
    end
  end

  Editor.updateHistoryButtons()
end

--- Initialize the actions
function Editor.initActions()
  Editor.actions = {
    {
      id = "pointer",
      button = Button:new(),
      keybinds = { "f" }
    },
    {
      id = "pen",
      button = Button:new(),
      keybinds = { "b" }
    },
    {
      id = "eraser",
      button = Button:new(),
      keybinds = { "e" }
    },
  }

  local map_width = Editor.getMapDimensions()
  local action_btn_left = map_width - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN
  local action_btn_bottom = Editor.MENU_BUTTON_SIZE * 1.5 + Editor.MENU_BUTTON_MARGIN * 2
  for i, action in ipairs(Editor.actions) do
    action.button:setWidth(Editor.MENU_BUTTON_SIZE)
    action.button:setHeight(Editor.MENU_BUTTON_SIZE)
    action.button:setSprite(Sprite:new("editor/" .. action.id))
    local btn_offset = (Editor.MENU_BUTTON_SIZE + Editor.MENU_BUTTON_MARGIN) * (i - 1)
    action.button:setPosition(action_btn_left, action_btn_bottom + btn_offset)
    action.button:setTooltip("EDITOR_TOOLTIP_ACTION_" .. UTF8.upper(action.id))
    action.button:getTooltip():setDirection("left")
    action.button:setDisabled(Editor.tileset == nil)

    function action.button.onClick(btn)
      Editor.selectAction(action.id)
      btn:setFocused(false)
      btn:onPointerEnter()
    end
  end

  Editor.hasUnsavedChanges()

  Editor.selectAction("pointer")
end

--- Initializes the objects
function Editor.initObjects()
  Editor.objects = {}

  Editor.add_object_btn = Button:new()
  Editor.add_object_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.add_object_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  local _, map_height = Editor.getMapDimensions()
  local add_object_btn_x = Editor.MENU_BUTTON_SIZE / 2 + Editor.MENU_BUTTON_MARGIN
  local add_object_btn_y = map_height - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN -
      Editor.TILE_SELECTOR_HEIGHT - 1
  Editor.add_object_btn:setPosition(add_object_btn_x, add_object_btn_y)
  Editor.add_object_btn:setSprite(Sprite:new({ "editor/plus" }, 0, false, false))
  Editor.add_object_btn:setTooltip("EDITOR_TOOLTIP_ADD_OBJECT")

  function Editor.add_object_btn.onClick(btn)
    btn:setFocused(false)
    btn:onPointerEnter()
    Editor.openObjectAddModal()
  end

  Editor.objects_count_text = Text:new("", true)
  local objects_count_text_x = add_object_btn_x + Editor.MENU_BUTTON_SIZE / 2 + Editor.MENU_BUTTON_MARGIN / 2
  local objects_count_text_y = add_object_btn_y + Editor.MENU_BUTTON_SIZE / 2
  Editor.objects_count_text:setPosition(objects_count_text_x, objects_count_text_y)
  Editor.objects_count_text:setOrigin(0, 1)
  Editor.objects_count_text:setFont("small")
  Editor.objects_count_text:setTag("UI")


  Editor.show_object_editor_draw_btn = Button:new()
  Editor.show_object_editor_draw_btn:setWidth(Editor.MENU_BUTTON_SIZE)
  Editor.show_object_editor_draw_btn:setHeight(Editor.MENU_BUTTON_SIZE)
  local show_object_editor_draw_btn_y = add_object_btn_y - Editor.MENU_BUTTON_SIZE - Editor.MENU_BUTTON_MARGIN
  Editor.show_object_editor_draw_btn:setPosition(add_object_btn_x, show_object_editor_draw_btn_y)
  Editor.show_object_editor_draw_btn:setSprite(Sprite:new({ "editor/hitbox" }, 0, false, false))
  Editor.show_object_editor_draw_btn:setTooltip("")

  Editor.toggleObjectsDraw(true)

  function Editor.show_object_editor_draw_btn.onClick(btn)
    Editor.toggleObjectsDraw()
    btn:setFocused(false)
    btn:onPointerEnter()
  end

  -- object add modal
  local ObjectAddModal = require "editor.ui.object_add_modal"
  Editor.object_add_modal = ObjectAddModal:new()

  function Editor.object_add_modal.onConfirm(_, object_id)
    local obj_data = Editor.addObject(object_id)
    if obj_data ~= nil then
      Editor.pushHistorySnapshot()
      Editor.hasUnsavedChanges()
    end
  end

  function Editor.object_add_modal.onClose()
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end

    Editor.toggleEditorButtons(true)

    Cursor.setIcon("default")
  end

  Editor.render_objects_draw = Drawable:new()
  Editor.render_objects_draw:setLayer(Constants.LAYERS.WORLD_OBJECT)
  function Editor.render_objects_draw.draw(_self)
    if not _self:isVisible() then return end

    local objects = Editor.object_add_modal:getObjects()
    for _, obj_data in ipairs(Editor.objects) do
      local object = objects[obj_data.type]
      if object ~= nil then
        if object.class.EDITOR_SPRITE ~= nil then
          local image = Sprite.loadImage(object.class.EDITOR_SPRITE)
          if image.image ~= nil then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(image.image, obj_data.x, obj_data.y)
          end
        elseif type(object.class.drawEditor) == "function" then
          if Editor.enable_objects_draw then
            object.class.drawEditor(obj_data)
          end
        else
          love.graphics.setColor(1, 1, 1)
          love.graphics.draw(Editor.missing_image.image, obj_data.x, obj_data.y)
        end
      end
    end

    local hov_obj = Editor.getSelectedObject() or Editor.hovered_obj
    if hov_obj ~= nil then
      love.graphics.setColor(1, 1, 1)
      love.graphics.setLineWidth(1)
      love.graphics.setLineStyle("rough")
      love.graphics.rectangle("line", hov_obj.x + 0.5, hov_obj.y + 0.5, hov_obj.width - 1, hov_obj.height - 1)
    end
  end

  -- object form
  local ObjectForm = require "editor.ui.form.object_form"
  Editor.object_form = ObjectForm:new()

  function Editor.object_form.onConfirm(_, data)
    local obj_index = -1
    for i, obj_data in ipairs(Editor.objects) do
      if obj_data.id == data.id then
        obj_index = i
      end
    end
    if obj_index <= -1 then return end

    local objects = Editor.object_add_modal:getObjects()
    local object = objects[data.type]
    if object ~= nil and type(object.class.onFormConfirm) == "function" then
      object.class.onFormConfirm(data)
    end

    Editor.objects[obj_index] = table.copy(data)

    Editor.pushHistorySnapshot()
    Editor.hasUnsavedChanges()
  end

  function Editor.object_form.onDuplicate(_, data)
    local obj_data = Editor.addObject(data.type)
    if obj_data ~= nil then
      local id = obj_data.id
      table.merge(obj_data, data)
      obj_data.id = id

      Editor.pushHistorySnapshot()
      Editor.hasUnsavedChanges()
    end
  end

  function Editor.object_form.onDelete(_, data)
    local removed = Editor.removeObject(data.id)
    if removed ~= nil then
      Editor.pushHistorySnapshot()
      Editor.hasUnsavedChanges()
    end
  end

  function Editor.object_form.onClose()
    Editor.toggleEditorButtons(true)

    Cursor.setIcon("default")
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end
  end

  Editor.missing_image = Sprite.loadImage("editor/missing")

  Editor.hovered_obj_text = Text:new()
  Editor.hovered_obj_text:setFont("small")
  Editor.hovered_obj_text:setOrigin(0, 1)
  Editor.hovered_obj_text:setLayer(Constants.LAYERS.CURSOR)
end

--- Creates a room
function Editor.newRoom()
  Editor.confirmSaveBeforeQuitting(function()
    Scene.reloadWithData(Editor.mod_id, "")
  end)
end

--- Load a room into the editor
--- @param room_data Dummy.Room.Data
function Editor.loadRoom(room_data)
  Editor.room_data.id = room_data.id
  Editor.room_data.width = room_data.width
  Editor.room_data.height = room_data.height
  Editor.room_data.tileset = room_data.tileset
  Editor.room_data.music = room_data.music
  Editor.room_data.music = room_data.music
  Editor.room_data.tiles = room_data.tiles or {}
  Editor.room_data.objects = room_data.objects or {}

  Editor.room_width = Editor.room_data.width
  Editor.room_height = Editor.room_data.height
  Editor.room_tileset = Editor.room_data.tileset
  Editor.room_music = Editor.room_data.music

  Editor.room_id_prev = Editor.room_data.id
  Editor.room_id_input:setValue(Editor.room_data.id)

  Editor.tileset = nil
  Editor.tiles = table.copy(Editor.room_data.tiles)
  Editor.objects = table.copy(Editor.room_data.objects)
  Editor.prev_tile_selected = nil

  Editor.loadTileset()
  Editor.updateTiles()

  Editor.history = {}
  Editor.history_index = 0
  Editor.pushHistorySnapshot()
  Editor.hasUnsavedChanges()

  Editor.selectLayer(0)

  for _, action in ipairs(Editor.actions) do
    action.button:setDisabled(Editor.tileset == nil)
  end
end

--- Saves the room
--- @return boolean
function Editor.saveRoom()
  Editor.toggleMenu(false)

  if not Editor.hasUnsavedChanges() then return true end

  local old_room_id = Editor.room_data.id
  Editor.room_data.id = UTF8.lower(Utils.sanitizeFilename(Editor.room_id_input:getValue()))
  Editor.room_data.width = Editor.room_width
  Editor.room_data.height = Editor.room_height
  Editor.room_data.tileset = Editor.room_tileset
  Editor.room_data.music = Editor.room_music

  Editor.room_data.tiles = table.copy(Editor.tiles)
  Editor.room_data.objects = table.copy(Editor.objects)

  Editor.updateWindowTitle(false)

  local filename = "mods/" .. Editor.mod_id .. "/scripts/world/room/" .. Editor.room_data.id .. ".json"
  love.filesystem.write(filename, JSON.encode(Editor.room_data))

  if old_room_id ~= Editor.room_data.id then
    love.filesystem.remove("mods/" .. Editor.mod_id .. "/scripts/world/room/" .. old_room_id .. ".json")
  end

  return true
end

--- Deletes a room
--- @param room_id string
function Editor.deleteRoom(room_id)
  love.filesystem.remove("mods/" .. Editor.mod_id .. "/scripts/world/room/" .. room_id .. ".json")

  -- refresh room list
  Editor.toggleMenu(false)
  Editor.toggleMenu(true)
  Editor.showRoomsList()
end

--- Plays the current room
function Editor.playRoom()
  local success = Editor.saveRoom()
  if not success then return end

  Scene.change("WORLD", ModList.getMod(Editor.mod_id), Editor.room_data.id)
end

--- Opens the room form
function Editor.openRoomForm()
  Editor.updateMainController()
  if Editor.main_controller == "gamepad" then
    Cursor.setPosition(320, 240)
  end

  Editor.room_form:open({
    width = Editor.room_width,
    height = Editor.room_height,
    tileset = Editor.room_tileset,
    music = Editor.room_music,
  })
  Editor.toggleMenu(false)
  Editor.toggleEditorButtons(false)
  Editor.menu_btn:setDisabled(true)
end

--- Opens the keybinds menu
function Editor.openKeybindsMenu()
  Editor.updateMainController()
  if Editor.main_controller == "gamepad" then
    Cursor.setPosition(320, 240)
  end

  Editor.selectAction("pointer")
  Editor.toggleMenu(false)
  Editor.toggleEditorButtons(false)
  Editor.menu_btn:setDisabled(true)
  Editor.keybinds_window:setVisible(true)
end

--- Opens the object add modal
function Editor.openObjectAddModal()
  Editor.updateMainController()
  if Editor.main_controller == "gamepad" then
    Cursor.setPosition(320, 240)
  end

  Editor.selectAction("pointer")
  Editor.toggleEditorButtons(false)
  Editor.menu_btn:setDisabled(true)
  Editor.object_add_modal:open()
end

--- Opens the object form
--- @param obj_data Dummy.Object.Data
function Editor.openObjectForm(obj_data)
  Editor.updateMainController()
  if Editor.main_controller == "gamepad" then
    Cursor.setPosition(320, 240)
  end

  local objects = Editor.object_add_modal:getObjects()
  local object = objects[obj_data.type]
  if object == nil then return end

  Editor.object_form:open(object, obj_data)
  Editor.toggleMenu(false)
  Editor.toggleEditorButtons(false)
  Editor.menu_btn:setDisabled(true)
end

--- Toggles the custom objects editor draw
--- @param enable? boolean
function Editor.toggleObjectsDraw(enable)
  enable = Utils.getOrDefault(enable, not Editor.enable_objects_draw)

  Editor.enable_objects_draw = enable

  Editor.show_object_editor_draw_btn:setTooltip(enable and "EDITOR_TOOLTIP_SHOW_OBJECT_DRAW_DISABLE" or
    "EDITOR_TOOLTIP_SHOW_OBJECT_DRAW_ENABLE")

  if enable then
    Editor.show_object_editor_draw_btn:getSprite():setColor(1, 1, 1)
  else
    Editor.show_object_editor_draw_btn:getSprite():setColor(0.4, 0.4, 0.4)
  end
end

--- Loads the room tileset
function Editor.loadTileset()
  if Editor.room_tileset == "default" then
    Editor.tileset_warning_text:setVisible(true)
    return
  end


  local base_folder = "mods/" .. Editor.mod_id .. "/assets/sprites/"
  local image = Sprite.loadImage("world/tileset/" .. Editor.room_tileset, false, base_folder)
  assert(image.image ~= nil, "Tileset \"" .. Editor.room_tileset .. "\" not found")

  if Editor.tileset ~= nil then
    Editor.tileset:remove()
  end

  local map_width, map_height = Editor.getMapDimensions()
  Editor.tileset = Tileset:new(image, map_width, map_height)
  Editor.tiles = Editor.tileset:loadTileset(Editor.tiles)

  function Editor.tileset.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.applyTransform(_self:getTransform())

    for layer in pairs(Editor.tiles) do
      local batch = _self:getBatch(layer)
      if batch ~= nil then
        local alpha = 1
        local current_layer = Editor.getSelectedLayer()
        if current_layer > 0 and current_layer ~= layer then
          alpha = 0.1
        end
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.draw(batch)
      end
    end
  end

  for _, container in ipairs(Editor.tile_selector_window:getChildren()) do
    for _, child in ipairs(container:getChildren()) do
      child:remove()
    end
  end

  --- @type Dummy.Editor.Button[]
  local tiles_btns = {}
  local tile_btn_left = Editor.TILE_BUTTON_SIZE / 2 + Editor.TILE_BUTTON_MARGIN
  local rows = math.ceil(image.image:getWidth() / Constants.TILE_SIZE)
  local cols = math.ceil(image.image:getHeight() / Constants.TILE_SIZE)
  for y = 0, (rows - 1) do
    for x = 0, (cols - 1) do
      local index = x + y * cols
      local button = Button:new()
      button:setParent(Editor.tile_selector_window)
      button:setWidth(Editor.TILE_BUTTON_SIZE)
      button:setHeight(Editor.TILE_BUTTON_SIZE)
      local btn_offset = (Editor.TILE_BUTTON_SIZE + Editor.TILE_BUTTON_MARGIN) * index
      button:setPosition(tile_btn_left + btn_offset, math.floor(Editor.TILE_SELECTOR_HEIGHT / 2))
      button:setBorderColor(0, 0, 0, 0)
      button["tile_index"] = index

      function button.draw(btn, camera)
        if not btn:isVisible() then return end

        local quad = Editor.tileset:getQuad(index)
        if quad == nil then return end

        love.graphics.applyTransform(btn:getTransform())

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image.image, quad, -Constants.TILE_SIZE / 2, -Constants.TILE_SIZE / 2)

        local width, height = btn:getWidth(), btn:getHeight()
        local origin_x, origin_y = btn:getOrigin()
        local btn_x, btn_y = -width * origin_x, -height * origin_y

        -- highlight
        if (Editor.isActionSelected("pen") and btn["tile_index"] == Editor.getSelectedTile()) or btn:isHovered() then
          love.graphics.setColor(1, 1, 1, 0.25)
          love.graphics.rectangle("fill", btn_x, btn_y, width, height)
        end

        btn:drawChildren(camera)
        btn:drawDebug(camera)
      end

      function button.onClick(btn)
        if Editor.main_controller == "gamepad" then return end

        Editor.prev_tile_selected = btn["tile_index"]
        Editor.selectTile(btn["tile_index"])
      end

      table.insert(tiles_btns, button)
    end
  end

  Editor.tile_selector_window:setUIElements({ tiles_btns })
  Editor.tile_selector_window:setVisible(true)

  Editor.tileset_warning_text:setVisible(false)
end

--- Updates the tiles
--- @param layer? integer
function Editor.updateTiles(layer)
  if layer == nil then
    for l in pairs(Editor.tiles) do
      Editor.tileset:build(Editor.tiles[l] or {}, l)
    end
  else
    layer = math.max(1, layer)
    Editor.tileset:build(Editor.tiles[layer] or {}, layer)
  end
end

--- Sets the grip position
--- @return number, number
function Editor.getGripPosition()
  return Editor.grip_pos[1], Editor.grip_pos[2]
end

--- Sets the grip position
--- @param x number
--- @param y number
function Editor.setGripPosition(x, y)
  Editor.grip_pos[1] = x
  Editor.grip_pos[2] = y
end

--- Gets the map dimensions
--- @return number, number
function Editor.getMapDimensions()
  return Editor.map_camera:getDimensions()
end

--- Gets the grip position
--- @return number, number
function Editor.getMapPosition()
  return Editor.map_camera:getViewportPosition()
end

--- Sets the camera position
--- @param x number
--- @param y number
function Editor.setMapPosition(x, y)
  local map_width, map_height = Editor.getMapDimensions()
  local zoom = Editor.getZoom()
  Editor.map_camera:setViewportPosition(x + map_width / 2 * zoom, y + map_height / 2 * zoom)
end

--- Moves the map
--- @param delta_x number
--- @param delta_y number
function Editor.moveMap(delta_x, delta_y)
  if not Input.isDown({ "shift", "gamepad:1:b" }) then
    delta_x = Editor.snapToGrid(delta_x * Constants.TILE_SIZE)
    delta_y = Editor.snapToGrid(delta_y * Constants.TILE_SIZE)
  end

  local map_x, map_y = Editor.getMapPosition()
  local x, y = map_x + delta_x, map_y + delta_y
  Editor.map_camera:setViewportPosition(x, y)

  local grip_x, grip_y = Editor.getGripPosition()
  Editor.setGripPosition(grip_x - delta_x, grip_y - delta_y)

  Editor.prev_map_pos[1], Editor.prev_map_pos[2] = Editor.getMapPosition()
end

--- Gets the hovered cell
--- @return number, number
function Editor.getHoveredCell()
  return Editor.cell_hovered[1] + Constants.TILE_SIZE, Editor.cell_hovered[2] + Constants.TILE_SIZE
end

--- Sets the hovered cell
--- @param x number
--- @param y number
function Editor.setHoveredCell(x, y)
  if Editor.cell_hovered[1] == x and Editor.cell_hovered[2] == y then return end

  Editor.cell_hovered = { x, y }
  Editor.cell_hovered_text:setText(x .. "," .. y)
end

--- Snaps a value to the map
--- @param v number
--- @return number
function Editor.snapToGrid(v)
  return math.floor(v / Constants.TILE_SIZE) * Constants.TILE_SIZE
end

--- Gets the zoom room
--- @return number
function Editor.getZoom()
  return Editor.map_camera:getZoom()
end

--- Changes the zoom room
--- @param zoom number
function Editor.setZoom(zoom)
  if zoom > Editor.ZOOM_MAX then return end
  if zoom < Editor.ZOOM_MIN then return end

  Editor.map_camera:setZoom(zoom)
  Editor.zoom_level_text:setText(math.round(zoom * 100) .. "%")
end

--- Centers the map
function Editor.center()
  Editor.setMapPosition(0, 0)
  Editor.setGripPosition(0, 0)
end

--- Centers the cursor
function Editor.centerCursor()
  local map_width, map_height = Editor.getMapDimensions()
  local zoom = Editor.getZoom()
  local cx, cy = map_width / 2 * zoom, map_height / 2 * zoom
  Cursor.setPosition(cx, cy)
end

--- Wether the action is selected
--- @param action Dummy.Editor.Cell.Action
--- @return boolean
function Editor.isActionSelected(action)
  return Editor.action_selected == action
end

--- Selects an action
--- @param action Dummy.Editor.Cell.Action|nil
function Editor.selectAction(action)
  if Editor.tileset == nil and action ~= "pointer" then return end

  local prev_action = Editor.action_selected
  Editor.action_selected = action

  if action == "pen" then
    Editor.selectTile(Utils.getOrDefault(Editor.prev_tile_selected, 0))
  elseif action == "eraser" then
    if prev_action ~= "eraser" then
      Editor.prev_tile_selected = Editor.getSelectedTile()
    end
    Editor.selectTile(nil)
  end
end

--- Gets the selected tile
--- @return integer|nil
function Editor.getSelectedTile()
  return Editor.tile_selected
end

--- Sets the selected tile
--- @param tile_index integer|nil
--- @param delta? integer
function Editor.selectTile(tile_index, delta)
  if Editor.tileset == nil then return end

  if tile_index ~= nil then
    Editor.action_selected = "pen"

    delta = Utils.getOrDefault(delta, 0)
    local total_tiles = Editor.tileset:getTotalTiles()
    tile_index = (tile_index + delta + total_tiles) % total_tiles
    Editor.tile_selector_window:focusAt(1, tile_index + 1)
  end

  Editor.tile_selected = tile_index
end

--- Gets the selected layer
--- @return integer
function Editor.getSelectedLayer()
  return Editor.layer_selected
end

--- Sets the selected layer
--- @param layer integer
function Editor.selectLayer(layer)
  layer = math.clamp(layer, 0, Editor.MAX_LAYERS)

  Editor.layer_selected = layer

  local layer_text = tostring(layer)
  local _, y = Editor.layer_text:getPosition()
  local map_width = Editor.getMapDimensions()
  local zoom = Editor.getZoom()
  if layer == 0 then
    layer_text = "EDITOR_LAYER_ALL"
    Editor.layer_text:setOrigin(1, 0.5)
    Editor.layer_text:setPosition(map_width * zoom - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN + 8, y)
  else
    Editor.layer_text:setOrigin(0.5, 0.5)
    Editor.layer_text:setPosition(map_width * zoom - Editor.MENU_BUTTON_SIZE / 2 - Editor.MENU_BUTTON_MARGIN, y)
  end
  Editor.layer_text:setText(layer_text)

  Editor.updateLayerButtons()
end

--- Updates the layer buttons
--- @param enabled? boolean
function Editor.updateLayerButtons(enabled)
  if enabled == false then
    Editor.layer_up_btn:setDisabled(true)
    Editor.layer_up_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.layer_up_btn:setBorderColor(0.4, 0.4, 0.4)
    Editor.layer_down_btn:setDisabled(true)
    Editor.layer_down_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.layer_down_btn:setBorderColor(0.4, 0.4, 0.4)
    return
  end

  Editor.layer_up_btn:setDisabled(false)
  Editor.layer_up_btn:getSprite():setColor(1, 1, 1)
  Editor.layer_up_btn:setBorderColor(1, 1, 1)
  Editor.layer_down_btn:setDisabled(false)
  Editor.layer_down_btn:getSprite():setColor(1, 1, 1)
  Editor.layer_down_btn:setBorderColor(1, 1, 1)

  local layer = Editor.getSelectedLayer()
  if layer <= 0 then
    Editor.layer_down_btn:setDisabled(true)
    Editor.layer_down_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.layer_down_btn:setBorderColor(0.4, 0.4, 0.4)
  end
  if layer >= Editor.MAX_LAYERS then
    Editor.layer_up_btn:setDisabled(true)
    Editor.layer_up_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.layer_up_btn:setBorderColor(0.4, 0.4, 0.4)
  end
end

--- Does an action on a cell
function Editor.actionOnCell()
  if Editor.tileset == nil then return end

  local layer = Editor.getSelectedLayer()
  local cell_x, cell_y = Editor.getHoveredCell()
  local x, y = cell_x - Constants.TILE_SIZE, cell_y - Constants.TILE_SIZE

  if Input.isDown("alt") then
    if Input.isPressed("mouse:left") then
      Editor.copyTileOnCell()
    end
    return
  end

  local has_changed = false
  if Editor.isActionSelected("pen") then
    local tile_index = Editor.getSelectedTile()
    if tile_index ~= nil then
      local added = Editor.addTile(tile_index, x, y, layer)
      if added then
        has_changed = true
      end
    end
  elseif Editor.isActionSelected("eraser") then
    local removed = Editor.removeTile(x, y, layer)
    if removed then
      has_changed = true
    end
  end

  if has_changed then
    Editor.updateTiles(Editor.getSelectedLayer())
    Editor.hasUnsavedChanges()
  end
end

--- Adds a tile to the room
--- @param tile integer
--- @param x number
--- @param y number
--- @param layer? integer
--- @return boolean
function Editor.addTile(tile, x, y, layer)
  layer = math.max(1, Utils.getOrDefault(layer, 1))

  if Editor.tiles[layer] == nil then
    Editor.tiles[layer] = {}
  end

  local tiles = Editor.tiles[layer]
  local key = x .. "," .. y
  if tiles[key] ~= nil and tiles[key].index == tile then return false end

  tiles[key] = {
    index = tile,
    x = x,
    y = y
  }

  Editor.history_changed = true

  return tiles[key] ~= nil
end

--- Removes a tile from the room
--- @param x number
--- @param y number
--- @param layer? integer
--- @return boolean
function Editor.removeTile(x, y, layer)
  layer = math.max(1, Utils.getOrDefault(layer, 1))

  if Editor.tiles[layer] == nil then
    Editor.tiles[layer] = {}
  end

  local tiles = Editor.tiles[layer]
  local key = x .. "," .. y
  local old_tile = tiles[key]

  if old_tile ~= nil then
    Editor.history_changed = true
  end

  tiles[key] = nil
  return old_tile ~= nil
end

--- Copies the tile on the hovered cell
function Editor.copyTileOnCell()
  local layer = Editor.getSelectedLayer()
  local tiles = Editor.tiles[math.max(1, layer)]
  if tiles == nil then return end

  local x, y = Editor.getHoveredCell()
  x = x - Constants.TILE_SIZE
  y = y - Constants.TILE_SIZE
  local key = x .. "," .. y
  local tile = tiles[key]
  if tile == nil then return end

  Editor.selectTile(tile.index)
end

--- Gets an available object id
--- @return integer
function Editor.getAvailabeObjectId()
  local used = {}

  for _, data in ipairs(Editor.objects) do
    used[data.id] = true
  end

  local id = 1
  while used[id] do
    id = id + 1
  end

  return id
end

--- Adds an object to the room
--- @param object_id string
--- @return Dummy.Object.Data|nil
function Editor.addObject(object_id)
  local objects = Editor.object_add_modal:getObjects()
  local object = objects[object_id]
  if object == nil then return end

  local zoom = Editor.getZoom()
  local map_width, map_height = Editor.getMapDimensions()
  local grip_x, grip_y = Editor.getGripPosition()
  local x = Editor.snapToGrid(-grip_x + map_width * zoom / 2)
  local y = Editor.snapToGrid(-grip_y + map_height * zoom / 2)
  local width = Constants.TILE_SIZE
  local height = Constants.TILE_SIZE
  if object.class.EDITOR_SPRITE ~= nil then
    local image = Sprite.loadImage(object.class.EDITOR_SPRITE)
    if image.image ~= nil then
      width = math.max(width, image.image:getWidth())
      height = math.max(height, image.image:getHeight())
    end
  end

  --- @type Dummy.Object.Data
  local obj_data = {
    id = Editor.getAvailabeObjectId(),
    type = object_id,
    x = x,
    y = y,
    width = width,
    height = height,
    mod_id = object.mod_id
  }
  table.insert(Editor.objects, obj_data)

  return obj_data
end

--- Removes an object from the room
--- @param id integer
--- @return Dummy.Object.Data|nil
function Editor.removeObject(id)
  local obj_index = -1
  for i, obj_data in ipairs(Editor.objects) do
    if obj_data.id == id then
      obj_index = i
    end
  end
  if obj_index <= -1 then return end

  return table.remove(Editor.objects, obj_index)
end

function Editor.updateObjectsCount()
  Editor.objects_count_text:setText(tostring(#Editor.objects))
end

--- Wether to handle user events in the editor
--- @return boolean
function Editor.canUseEditor()
  if Editor.menu_window:isVisible() then return false end
  if Editor.confirm_modal:isVisible() then return false end
  if Editor.keybinds_window:isVisible() then return false end
  if Editor.room_form:isOpen() then return false end
  if Editor.object_add_modal:isVisible() then return false end
  if Editor.object_form:isOpen() then return false end
  if Editor.room_id_input:isFocused() then return false end

  return true
end

--- Wether the editor menu can be toggled
--- @return boolean
function Editor.canToggleMenu()
  return not Editor.confirm_modal:isVisible() and
      not Editor.keybinds_window:isVisible() and
      not Editor.object_add_modal:isVisible() and
      not Editor.object_form:isVisible()
end

--- Toggles the menu
--- @param visible? boolean
function Editor.toggleMenu(visible)
  visible = Utils.getOrDefault(visible, not Editor.menu_window:isVisible())

  if not visible then
    Editor.selectAction("pointer")
    Cursor.setIcon("default")

    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end
  else
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Cursor.setPosition(320, 240)
    end
  end

  Editor.menu_window:setVisible(visible)

  -- menu icon
  Editor.menu_btn:getSprite():setFrame(visible and 2 or 1)

  -- hide sub windows
  Editor.room_list_window:setVisible(false)

  Editor.toggleEditorButtons(not visible)
end

--- Disables the editor buttons
--- @param enabled boolean
function Editor.toggleEditorButtons(enabled)
  if enabled then
    Editor.menu_btn:setDisabled(false)
    if Editor.main_controller == "gamepad" then
      Cursor.show()
    end
  else
    if Editor.main_controller == "gamepad" then
      Cursor.hide()
    end
  end

  Editor.play_room_btn:setDisabled(not enabled)

  -- actions
  for _, action in ipairs(Editor.actions) do
    action.button:setDisabled(not enabled)
  end

  Editor.updateHistoryButtons(enabled)
  Editor.updateLayerButtons(enabled)
  Editor.reset_zoom_btn:setDisabled(not enabled)
  Editor.center_btn:setDisabled(not enabled)
  Editor.add_object_btn:setDisabled(not enabled)
  Editor.show_object_editor_draw_btn:setDisabled(not enabled)
  Editor.room_id_input:setDisabled(not enabled)
end

--- Loads the rooms list
--- @return { file: { modtime: number }, filename: string }[]
function Editor.loadRoomsList()
  --- @type { file: { modtime: number }, filename: string }[]
  local room_list = {}
  for _, filename in pairs(love.filesystem.getDirectoryItems("mods/" .. Editor.mod_id .. "/scripts/world/room")) do
    if Utils.checkExtension(filename, "json") then
      local file_info = love.filesystem.getInfo("mods/" .. Editor.mod_id .. "/scripts/world/room/" .. filename, "file")
      if file_info ~= nil then
        table.insert(room_list, {
          file = file_info,
          filename = filename
        })
      end
    end
  end

  -- sort by most recently modified
  table.stable_sort(room_list, function(a, b)
    return a.file.modtime > b.file.modtime
  end)

  return room_list
end

--- Show the rooms list
function Editor.showRoomsList()
  if Editor.room_list_window:isVisible() then return end

  local room_list = Editor.loadRoomsList()

  for _, room_list_btn in ipairs(Editor.room_list_btns or {}) do
    room_list_btn:remove()
  end
  Editor.room_list_btns = {}
  for _, room_list_delete_btn in ipairs(Editor.room_list_delete_btns or {}) do
    room_list_delete_btn:remove()
  end
  Editor.room_list_delete_btns = {}

  local room_list_window_width = 0
  local room_list_window_height = 0
  if #room_list <= 0 then
    local no_room_btn = Button:new()
    no_room_btn:setParent(Editor.room_list_window)
    no_room_btn:setOrigin(0, 0)
    local no_room_text = Text:new("EDITOR_MENU_ROOM_LIST_NO_ROOM")
    no_room_text:setOrigin(0, 0)
    no_room_text:setOverflow("ellipsis")
    no_room_text:setPosition(Editor.ROOM_BUTTON_PADDING_X, 0)
    no_room_btn:setText(no_room_text)
    no_room_btn:setBorder(0)
    no_room_btn:setDisabled(true)
    no_room_btn:setWidth(no_room_btn:getWidth() + Editor.ROOM_BUTTON_PADDING_X * 2)
    no_room_btn:setHeight(no_room_btn:getHeight() + Editor.ROOM_BUTTON_PADDING_Y * 2)

    function no_room_btn.setFocused() end

    room_list_window_width = no_room_btn:getWidth()
    room_list_window_height = no_room_btn:getHeight()

    table.insert(Editor.room_list_btns, no_room_btn)
  else
    local room_btn_offset = 0
    for _, room_file in ipairs(room_list) do
      local room_id = Utils.getFilenameWithoutExt(room_file.filename)
      local room_data = Room.parseRoomData(Editor.mod_id, room_id)
      if room_data ~= nil then
        -- room button
        local room_btn = Button:new()
        room_btn:setParent(Editor.room_list_window)
        room_btn:setOrigin(0, 0)
        local text = Text:new(room_data.id)
        text:setOrigin(0, 0)
        text:setPosition(Editor.ROOM_BUTTON_PADDING_X, Editor.ROOM_BUTTON_PADDING_Y)
        text:setOverflow("ellipsis")
        room_btn:setText(text)
        room_btn:setPosition(0, room_btn_offset)
        room_btn:setBorder(0)
        room_btn:setWidth(text:getWidth() + Editor.ROOM_BUTTON_PADDING_X * 2)
        room_btn:setHeight(text:getHeight() + Editor.ROOM_BUTTON_PADDING_Y * 2)

        room_btn_offset = room_btn_offset + text:getHeight() + Editor.ROOM_BUTTON_PADDING_Y * 2

        function room_btn.onClick()
          Editor.toggleMenu(false)
          if room_id == Editor.room_data.id then return end

          Editor.confirmSaveBeforeQuitting(function()
            Scene.reloadWithData(Editor.mod_id, room_id)
          end)
        end

        room_list_window_width = math.max(room_list_window_width, room_btn:getWidth() + Editor.ROOM_BUTTON_PADDING_X * 2)
        room_list_window_height = room_list_window_height + room_btn:getHeight()

        table.insert(Editor.room_list_btns, room_btn)

        -- delete room button
        local delete_room_btn = Button:new()
        delete_room_btn:setParent(room_btn)
        delete_room_btn:setHeight(room_btn:getHeight())
        delete_room_btn:setWidth(delete_room_btn:getHeight())
        delete_room_btn:setSprite(Sprite:new("editor/bin"))
        delete_room_btn:getSprite():setColor(0.9, 0.2, 0.2)
        delete_room_btn:setBorder(0)

        function delete_room_btn.onClick(btn)
          btn:setFocused(false)
          Editor.toggleMenu(false)
          Editor.toggleEditorButtons(false)
          Editor.menu_btn:setDisabled(true)

          function Editor.confirm_modal.onConfirm()
            Editor.deleteRoom(room_data.id)
          end

          function Editor.confirm_modal.onCancel() end

          function Editor.confirm_modal.onClose()
            Editor.selectAction("pointer")
            Editor.toggleEditorButtons(true)

            Cursor.setIcon("default")
            Editor.updateMainController()
            if Editor.main_controller == "gamepad" then
              Editor.centerCursor()
            end
          end

          Editor.confirm_modal:open(Lang.translate("EDITOR_CONFIRM_MODAL_DELETE_ROOM", room_data.id),
            "EDITOR_CONFIRM_MODAL_DELETE_ROOM_CONFIRM")
        end

        table.insert(Editor.room_list_delete_btns, delete_room_btn)
      end
    end

    room_list_window_width = math.min(Editor.ROOM_LIST_WINDOW_MAX_WIDTH, room_list_window_width)
    for _, room_list_btn in ipairs(Editor.room_list_btns) do
      room_list_btn:getText():setMaxWidth(room_list_window_width - Editor.ROOM_BUTTON_PADDING_X)
      room_list_btn:setWidth(room_list_window_width)
    end

    for _, room_list_delete_btn in ipairs(Editor.room_list_delete_btns) do
      local width, height = room_list_delete_btn:getWidth(), room_list_delete_btn:getHeight()
      room_list_delete_btn:setPosition(room_list_window_width + width / 2, height / 2)
    end

    room_list_window_width = room_list_window_width + Editor.room_list_btns[1]:getHeight()
  end

  local _, map_height = Editor.getMapDimensions()
  local menu_window_x, menu_window_y = Editor.menu_window:getPosition()
  Editor.room_list_window:setWidth(room_list_window_width)
  Editor.room_list_window:setHeight(math.min(room_list_window_height,
    map_height - menu_window_y - Editor.MENU_BUTTON_MARGIN * 2))
  Editor.room_list_window:setPosition(menu_window_x + Editor.menu_window:getWidth() + Editor.MENU_BUTTON_MARGIN * 2,
    menu_window_y)

  local elements = {}
  for i = 1, #Editor.room_list_btns do
    table.insert(elements, {
      Editor.room_list_btns[i],
      Editor.room_list_delete_btns[i]
    })
  end
  Editor.room_list_window:setUIElements(elements, true)
  Editor.room_list_window:setVisible(true)
end

--- Wether the room has unsaved changes
--- @return boolean
function Editor.hasUnsavedChanges()
  local has_unsaved_changes = false
  if Editor.room_data.id ~= Editor.room_id_input:getValue() then
    has_unsaved_changes = true
  elseif Editor.hasRoomFormChanges() then
    has_unsaved_changes = true
  elseif Editor.hasUnsavedTilesChanges() then
    has_unsaved_changes = true
  elseif Editor.hasUnsavedObjectsChanges() then
    has_unsaved_changes = true
  end

  Editor.updateWindowTitle(has_unsaved_changes)

  return has_unsaved_changes
end

--- Wether the room form has unsaved changes
function Editor.hasRoomFormChanges()
  if Editor.room_width ~= Editor.room_data.width then return true end
  if Editor.room_height ~= Editor.room_data.height then return true end
  if Editor.room_tileset ~= Editor.room_data.tileset then return true end
  if Editor.room_music ~= Editor.room_data.music then return true end

  return false
end

--- Wether the room has unsaved tiles
function Editor.hasUnsavedTilesChanges()
  return not table.equal(Editor.room_data.tiles, Editor.tiles)
end

--- Wether the room has unsaved objects
function Editor.hasUnsavedObjectsChanges()
  return not table.equal(Editor.room_data.objects, Editor.objects)
end

--- Updates the window title
--- @param has_unsaved_changes? boolean
function Editor.updateWindowTitle(has_unsaved_changes)
  local title = string.format("%s - %s", Constants.CREDITS.NAME, Lang.translate("EDITOR_TITLE"))
  if has_unsaved_changes then
    title = "● " .. title
  end
  love.setTitle(title)
end

--- Opens the confirm modal before quitting
--- @param on_confirm? fun()
--- @param on_cancel? fun()
function Editor.confirmSaveBeforeQuitting(on_confirm, on_cancel)
  if not Editor.hasUnsavedChanges() then
    if type(on_confirm) == "function" then
      on_confirm()
    end
    return
  end

  Editor.toggleMenu(false)
  Editor.menu_btn:setDisabled(true)

  function Editor.confirm_modal.onConfirm()
    Editor.toggleEditorButtons(true)

    if type(on_confirm) == "function" then
      on_confirm()
    end
  end

  function Editor.confirm_modal.onCancel()
    if type(on_cancel) == "function" then
      on_cancel()
    end
  end

  function Editor.confirm_modal.onClose()
    Editor.selectAction("pointer")
    Editor.toggleEditorButtons(true)

    Cursor.setIcon("default")
    Editor.updateMainController()
    if Editor.main_controller == "gamepad" then
      Editor.centerCursor()
    end
  end

  Editor.confirm_modal:open("EDITOR_CONFIRM_MODAL_BEFORE_QUITTING", "EDITOR_CONFIRM_MODAL_BEFORE_QUITTING_QUIT")
end

--- Pushes a snapshot to the history
function Editor.pushHistorySnapshot()
  Editor.history = table.slice(Editor.history, 1, Editor.history_index)

  --- @type Dummy.Editor.Snapshot
  local snapshot = {
    room_id = Editor.room_id_input:getValue(),
    width = Editor.room_width,
    height = Editor.room_height,
    tileset = Editor.room_tileset,
    tiles = table.copy(Editor.tiles),
    objects = table.copy(Editor.objects),
  }
  table.insert(Editor.history, snapshot)

  Editor.history_index = Editor.history_index + 1
  Editor.history_changed = false

  Editor.updateHistoryButtons()
  Editor.updateObjectsCount()
end

--- Applies a snapshot
--- @param snapshot Dummy.Editor.Snapshot
function Editor.applySnapshot(snapshot)
  Editor.room_id_input:setValue(snapshot.room_id)
  Editor.room_width = snapshot.width
  Editor.room_height = snapshot.height

  local old_tileset = Editor.room_tileset
  Editor.room_tileset = snapshot.tileset
  if old_tileset ~= Editor.room_tileset then
    Editor.loadTileset()
  end

  Editor.tiles = table.copy(snapshot.tiles)
  Editor.updateTiles()

  Editor.objects = table.copy(snapshot.objects)
end

--- Updates the history buttons
--- @param enabled? boolean
function Editor.updateHistoryButtons(enabled)
  if enabled == false then
    Editor.undo_btn:setDisabled(true)
    Editor.undo_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.undo_btn:setBorderColor(0.4, 0.4, 0.4)
    Editor.redo_btn:setDisabled(true)
    Editor.redo_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.redo_btn:setBorderColor(0.4, 0.4, 0.4)
    return
  end

  Editor.undo_btn:setDisabled(false)
  Editor.undo_btn:getSprite():setColor(1, 1, 1)
  Editor.undo_btn:setBorderColor(1, 1, 1)
  Editor.redo_btn:setDisabled(false)
  Editor.redo_btn:getSprite():setColor(1, 1, 1)
  Editor.redo_btn:setBorderColor(1, 1, 1)

  if Editor.history_index <= 1 then
    Editor.undo_btn:setDisabled(true)
    Editor.undo_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.undo_btn:setBorderColor(0.4, 0.4, 0.4)
  end
  if Editor.history_index >= #Editor.history then
    Editor.redo_btn:setDisabled(true)
    Editor.redo_btn:getSprite():setColor(0.4, 0.4, 0.4)
    Editor.redo_btn:setBorderColor(0.4, 0.4, 0.4)
  end
end

--- Undoes the last action
function Editor.undo()
  local history_index = Editor.history_index - 1
  if history_index < 1 then return end

  local snapshot = Editor.history[history_index]
  if snapshot == nil then return end

  Editor.applySnapshot(snapshot)

  Editor.history_index = history_index
  Editor.hasUnsavedChanges()

  Editor.updateHistoryButtons()
end

--- Redoes the last action
function Editor.redo()
  local history_index = Editor.history_index + 1
  if history_index > #Editor.history then return end

  local snapshot = Editor.history[history_index]
  if snapshot == nil then return end

  Editor.applySnapshot(snapshot)

  Editor.history_index = history_index
  Editor.hasUnsavedChanges()

  Editor.updateHistoryButtons()
end

--- Gets the selected object's id
--- @return Dummy.Object.Data|nil
function Editor.getSelectedObject()
  return Editor.selected_object
end

--- Selects an object
--- @param object Dummy.Object.Data
function Editor.selectObject(object)
  Editor.selected_object = object
  Editor.selected_object_pos = { object.x, object.y }
  Editor.selected_object_cursor_pos = { 0, 0 }

  local cursor_x, cursor_y = Cursor:getPosition()
  local grip_x, grip_y = Editor.getGripPosition()
  local zoom = Editor.getZoom()
  local map_width, map_height = Editor.getMapDimensions()
  Editor.selected_object_cursor_pos[1] = math.floor(cursor_x / zoom - grip_x - (1 - zoom) * map_width / 2 -
    Constants.TILE_SIZE / 2)
  Editor.selected_object_cursor_pos[2] = math.floor(cursor_y / zoom - grip_y - (1 - zoom) * map_height / 2 -
    Constants.TILE_SIZE / 2)
  Editor.prev_map_pos[1], Editor.prev_map_pos[2] = Editor.getMapPosition()
end

--- Unselects the selected object
function Editor.unselectObject()
  Editor.selected_object = nil
  Editor.hovered_obj = nil
end

--- Wether the editor can hover
--- @return boolean
function Editor.canHover()
  if Editor.room_form:isOpen() then return false end
  if Editor.menu_window:isVisible() or Editor.menu_btn:isHovered() then return false end
  if Editor.room_id_input:isHovered() then return false end
  if Editor.play_room_btn:isHovered() then return false end
  if Editor.undo_btn:isHovered() or Editor.redo_btn:isHovered() then return false end
  if Editor.layer_up_btn:isHovered() or Editor.layer_down_btn:isHovered() then return false end
  if Editor.reset_zoom_btn:isHovered() then return false end
  if Editor.center_btn:isHovered() then return false end
  if Editor.add_object_btn:isHovered() then return false end

  -- actions
  for _, action in ipairs(Editor.actions) do
    if action.button:isHovered() then return false end
  end

  -- tile selector
  if Editor.isHoveringTileSelector() then return false end

  return true
end

--- Wether the cursor is hovering the tile selector
--- @return boolean
function Editor.isHoveringTileSelector()
  local map_width, map_height = Editor.getMapDimensions()
  local cursor_x, cursor_y = Cursor:getPosition()
  local zoom = Editor.getZoom()
  local y = map_height * zoom - Editor.TILE_SELECTOR_HEIGHT - 1
  return Utils.isPointInRect(cursor_x, cursor_y, 0, y, map_width * zoom, Editor.TILE_SELECTOR_HEIGHT)
end

--- Called when the pointer is hovering the editor
function Editor.onHover()
  if Input.isPressed({ "mouse:wheel_y_up", "joystick:1:triggerright" }) then
    Editor.setZoom(Editor.getZoom() * Editor.ZOOM_STEP)
  elseif Input.isPressed({ "mouse:wheel_y_down", "joystick:1:triggerleft" }) then
    Editor.setZoom(Editor.getZoom() / Editor.ZOOM_STEP)
  end

  if (Input.isPressed("joystick:1:triggerright") and Input.isDown("joystick:1:triggerleft")) or (Input.isPressed("joystick:1:triggerleft") and Input.isDown("joystick:1:triggerright")) then
    Editor.setZoom(1)
  end

  if Input.isPressed({ "mouse:left", "gamepad:1:a" }) then
    Editor.actionOnCell()
  elseif Input.isReleased({ "mouse:left", "gamepad:1:a" }) and Editor.history_changed then
    Editor.pushHistorySnapshot()
  elseif Input.isDown({ "mouse:left", "gamepad:1:a" }) then
    Editor.actionOnCell()
  end

  if Editor.isActionSelected("pointer") then
    Editor.onHoverObject()

    local hovered_obj = Editor.getSelectedObject() or Editor.hovered_obj
    Editor.hovered_obj_text:setVisible(hovered_obj ~= nil)
    if hovered_obj ~= nil then
      Editor.hovered_obj_text:setText(hovered_obj.x .. "," .. hovered_obj.y)
      Editor.hovered_obj_text:setPosition(hovered_obj.x, hovered_obj.y - 1)
    end
  else
    Editor.unselectObject()
  end
end

--- Handles hovering over an object
function Editor.onHoverObject()
  if Input.isReleased({ "mouse:left", "gamepad:1:a" }) then
    if Editor.getSelectedObject() ~= nil then
      if Editor.selected_object_pos[1] ~= Editor.selected_object.x or Editor.selected_object_pos[2] ~= Editor.selected_object.y then
        Editor.pushHistorySnapshot()
        Editor.hasUnsavedChanges()
      end

      Editor.unselectObject()
    end
  elseif Input.isDown({ "mouse:left", "gamepad:1:a" }) then
    local object = Editor.getSelectedObject()
    if object ~= nil then
      local map_width, map_height = Editor.getMapDimensions()
      local grip_x, grip_y = Editor.getGripPosition()
      local zoom = Editor.getZoom()
      local cursor_x, cursor_y = Cursor.getPosition()
      cursor_x = cursor_x / zoom - grip_x - (1 - zoom) * map_width / 2
      cursor_y = cursor_y / zoom - grip_y - (1 - zoom) * map_height / 2
      local cursor_pos_x = Editor.selected_object_cursor_pos[1]
      local cursor_pos_y = Editor.selected_object_cursor_pos[2]
      local new_x = Editor.selected_object_pos[1] + math.floor(cursor_x - Constants.TILE_SIZE / 2) - cursor_pos_x
      local new_y = Editor.selected_object_pos[2] + math.floor(cursor_y - Constants.TILE_SIZE / 2) - cursor_pos_y
      if not Input.isDown({ "shift", "gamepad:1:b" }) then
        new_x = Editor.snapToGrid(new_x)
        new_y = Editor.snapToGrid(new_y)
      end
      object.x = new_x
      object.y = new_y
    end
  end

  local map_width, map_height = Editor.getMapDimensions()
  local grip_x, grip_y = Editor.getGripPosition()
  local cursor_x, cursor_y = Cursor.getPosition()
  local zoom = Editor.getZoom()
  cursor_x = cursor_x / zoom - grip_x - (1 - zoom) * map_width / 2
  cursor_y = cursor_y / zoom - grip_y - (1 - zoom) * map_height / 2
  --- @type Dummy.Object.Data|nil
  local hovered_obj = nil
  for i = #Editor.objects, 1, -1 do
    local obj_data = Editor.objects[i]
    if Utils.isPointInRect(cursor_x, cursor_y, obj_data.x, obj_data.y, obj_data.width, obj_data.height) then
      hovered_obj = obj_data
      break
    end
  end

  Editor.hovered_obj = hovered_obj
  if hovered_obj ~= nil then
    local objects = Editor.object_add_modal:getObjects()
    if objects[hovered_obj.type] == nil then return end

    local map_x, map_y = Editor.getMapPosition()
    local has_moved_map = map_x ~= Editor.prev_map_pos[1] or map_y ~= Editor.prev_map_pos[2]
    if Editor.getSelectedObject() == nil and not has_moved_map and (Input.isReleased({ "mouse:right" }) or Input.isPressed("gamepad:1:y")) then
      Editor.openObjectForm(hovered_obj)
    elseif Input.isPressed({ "mouse:left", "gamepad:1:a" }) then
      Editor.selectObject(hovered_obj)
    end
  end
end

--- Updates the main controller
function Editor.updateMainController()
  local key_pressed = Input.getKeyPressed() or ""
  if select(2, key_pressed:gsub("gamepad:", "")) ~= 0 or select(2, key_pressed:gsub("joystick:", "")) ~= 0 then
    if Editor.main_controller ~= "gamepad" then
      Editor.main_controller = "gamepad"
      Editor.centerCursor()
    end
  elseif Editor.main_controller ~= "keyboard" then
    if key_pressed ~= "" then
      Editor.main_controller = "keyboard"
    else
      local prev_cursor_x, prev_cursor_y = Cursor.getPreviousPosition()
      local cursor_x, cursor_y = Cursor.getPosition()
      if prev_cursor_x ~= cursor_x or prev_cursor_y ~= cursor_y then
        Editor.main_controller = "keyboard"
      end
    end
  end
end

--- Updates the editor, called on every game update
--- @param dt number
function Editor.update(dt)
  local cursor_x, cursor_y = Cursor.getPosition()
  local grip_x, grip_y = Editor.getGripPosition()
  local map_width, map_height = Editor.getMapDimensions()
  local zoom = Editor.getZoom()
  local cell_x = Editor.snapToGrid(cursor_x / zoom - grip_x - (1 - zoom) * map_width / 2)
  local cell_y = Editor.snapToGrid(cursor_y / zoom - grip_y - (1 - zoom) * map_height / 2)
  local ctrl_down = Input.isDown("ctrl")

  if Editor.canUseEditor() then
    if (Input.isDown("ctrl") and (Input.isPressed("y") or (Input.isDown("shift") and Input.isPressed("w")))) or Input.isPressed("gamepad:1:rightshoulder") then
      Editor.redo()
      Editor.history_time = 0
    elseif (Input.isDown("ctrl") and (Input.isDown("y") or (Input.isDown("shift") and Input.isDown("w")))) or Input.isDown("gamepad:1:rightshoulder") then
      if Editor.history_time >= Editor.HISTORY_START_DELAY then
        if Editor.history_time >= Editor.HISTORY_START_DELAY + Editor.HISTORY_DELAY then
          Editor.redo()
          Editor.history_time = Editor.HISTORY_START_DELAY
        end
      end

      Editor.history_time = Editor.history_time + dt
    elseif (Input.isDown("ctrl") and Input.isPressed("w")) or Input.isPressed("gamepad:1:leftshoulder") then
      Editor.undo()
      Editor.history_time = 0
    elseif (Input.isDown("ctrl") and Input.isDown("w")) or Input.isDown("gamepad:1:leftshoulder") then
      if Editor.history_time >= Editor.HISTORY_START_DELAY then
        if Editor.history_time >= Editor.HISTORY_START_DELAY + Editor.HISTORY_DELAY then
          Editor.undo()
          Editor.history_time = Editor.HISTORY_START_DELAY
        end
      end

      Editor.history_time = Editor.history_time + dt
    end

    if not Input.isDown("mouse:left") then
      if Input.isPressed("mouse:right") or Input.isReleased("mouse:right") then
        if Input.isPressed("mouse:right") then
          Editor.prev_map_pos[1], Editor.prev_map_pos[2] = Editor.getMapPosition()
        end
        Editor.setGripPosition(cursor_x / zoom - grip_x, cursor_y / zoom - grip_y)
      elseif Input.isDown("mouse:right") then
        Editor.setMapPosition(grip_x - cursor_x / zoom, grip_y - cursor_y / zoom)
      end
    end

    -- tile selector override horizontal scroll behavior
    if Editor.isHoveringTileSelector() then
      if Input.isPressed("mouse:wheel_x_up") or Input.isPressed("mouse:wheel_y_down") then
        Editor.tile_selector_window:scroll(-Editor.tile_selector_window.SCROLL_DELTA, 0)
      elseif Input.isPressed("mouse:wheel_x_down") or Input.isPressed("mouse:wheel_y_up") then
        Editor.tile_selector_window:scroll(Editor.tile_selector_window.SCROLL_DELTA, 0)
      end
    end

    -- actions shortcuts and colors
    for _, action in ipairs(Editor.actions) do
      if Input.isPressed(action.keybinds) then
        Editor.selectAction(action.id)
      end

      if not action.button:isDisabled() then
        action.button:getSprite():setColor(1, 1, 1)
        action.button:setBorderColor(1, 1, 1)
        if Editor.isActionSelected(action.id) or action.button:isHovered() then
          action.button:setColor(0.2, 0.2, 0.2)
        else
          action.button:setColor(0, 0, 0)
        end
      else
        action.button:getSprite():setColor(0.4, 0.4, 0.4)
        action.button:setBorderColor(0.4, 0.4, 0.4)
      end
    end

    -- menu shortcuts
    if ctrl_down then
      if Input.isPressed("n") then
        Editor.newRoom()
      elseif Input.isPressed("o") and not Editor.menu_window:isVisible() then
        Editor.toggleMenu(true)
        Editor.showRoomsList()
      elseif Input.isPressed("i") and not Editor.menu_window:isVisible() then
        Editor.toggleMenu(true)
        Editor.openRoomForm()
      elseif Input.isPressed("s") then
        Editor.saveRoom()
      elseif Input.isPressed("return") or Input.isPressed("kpenter") then
        Editor.playRoom()
      end
    else
      -- other shortcuts
      if Input.isPressed({ "pageup", "t", "joystick:1:rsup" }) then
        Editor.selectLayer(Editor.getSelectedLayer() + 1)
      elseif Input.isPressed({ "pagedown", "g", "joystick:1:rsdown" }) then
        Editor.selectLayer(Editor.getSelectedLayer() - 1)
      elseif Input.isPressed("h") then
        Editor.toggleObjectsDraw()
      elseif Input.isPressed("gamepad:1:rightstick") then
        Editor.copyTileOnCell()
      elseif Input.isPressed("gamepad:1:x") then
        if Editor.isActionSelected("pointer") then
          Editor.selectAction("pen")
        elseif Editor.isActionSelected("pen") then
          Editor.selectAction("eraser")
        else
          Editor.selectAction("pointer")
        end
      elseif Input.isPressed(";") then
        Editor.setZoom(1)
      elseif Input.isPressed("gamepad:1:back") then
        Editor.playRoom()
      elseif Input.isPressed("c") then
        Editor.center()
      elseif Input.isPressed({ "a", "gamepad:1:dpleft", "joystick:1:lsleft" }) then
        Editor.moveMap(-1, 0)
      elseif Input.isPressed({ "d", "gamepad:1:dpright", "joystick:1:lsright" }) then
        Editor.moveMap(1, 0)
      elseif Input.isPressed({ "w", "gamepad:1:dpup", "joystick:1:lsup" }) then
        Editor.moveMap(0, -1)
      elseif Input.isPressed({ "s", "gamepad:1:dpdown", "joystick:1:lsdown" }) then
        Editor.moveMap(0, 1)
      elseif Input.isPressed("gamepad:1:leftstick") then
        Editor.center()
      elseif (Input.isDown("shift") and Input.isPressed("space")) or Input.isPressed("joystick:1:rsleft") then
        local tile_index = Editor.getSelectedTile()
        if tile_index ~= nil then
          Editor.tile_selection_time = 0

          Editor.selectTile(tile_index, -1)
          Editor.prev_tile_selected = Editor.getSelectedTile()
        end
      elseif (Input.isDown("shift") and Input.isDown("space")) or Input.isDown("joystick:1:rsleft") then
        local tile_index = Editor.getSelectedTile()
        if tile_index ~= nil then
          if Editor.tile_selection_time >= Editor.TILE_SELECTION_START_DELAY then
            if Editor.tile_selection_time >= Editor.TILE_SELECTION_START_DELAY + Editor.TILE_SELECTION_DELAY then
              Editor.selectTile(tile_index, -1)
              Editor.prev_tile_selected = Editor.getSelectedTile()
              Editor.tile_selection_time = Editor.TILE_SELECTION_START_DELAY
            end
          end
        end

        Editor.tile_selection_time = Editor.tile_selection_time + dt
      elseif Input.isPressed({ "space", "joystick:1:rsright" }) then
        local tile_index = Editor.getSelectedTile()
        if tile_index ~= nil then
          Editor.tile_selection_time = 0

          Editor.selectTile(tile_index, 1)
          Editor.prev_tile_selected = Editor.getSelectedTile()
        end
      elseif Input.isDown({ "space", "joystick:1:rsright" }) then
        local tile_index = Editor.getSelectedTile()
        if tile_index ~= nil then
          if Editor.tile_selection_time >= Editor.TILE_SELECTION_START_DELAY then
            if Editor.tile_selection_time >= Editor.TILE_SELECTION_START_DELAY + Editor.TILE_SELECTION_DELAY then
              Editor.selectTile(tile_index, 1)
              Editor.prev_tile_selected = Editor.getSelectedTile()
              Editor.tile_selection_time = Editor.TILE_SELECTION_START_DELAY
            end
          end
        end

        Editor.tile_selection_time = Editor.tile_selection_time + dt
      end
    end

    if not Input.isDown("mouse:right") and not Input.isReleased("mouse:right") then
      grip_x, grip_y = Editor.getGripPosition()
      cell_x = Editor.snapToGrid(cursor_x / zoom - grip_x - (1 - zoom) * map_width / 2)
      cell_y = Editor.snapToGrid(cursor_y / zoom - grip_y - (1 - zoom) * map_height / 2)
      Editor.setHoveredCell(cell_x, cell_y)
    end

    if Editor.canHover() then
      Editor.onHover()
    end

    if Input.isPressed({ "o", "gamepad:1:y" }) and Editor.canUseEditor() then
      Editor.openObjectAddModal()
    end
  end

  if Input.isPressed(Input.Escape) and Editor.canToggleMenu() then
    Editor.toggleMenu()
  end

  Editor.updateMainController()
end

return Editor
