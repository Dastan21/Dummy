--[[
  Generated from ..\engine\editor\editor.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/editor.lua
]]

---@meta

Button = {}

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

--- Loads the editor
--- @param mod_id string
--- @param room_id? string
function Editor.load(mod_id, room_id) end

--- Gets the editor's mod id
--- @return string
function Editor.getModId() end

--- Initializes the room data
function Editor.initRoomData() end

--- Initialize the menu window
function Editor.initMenu() end

--- Initializes the play room button
function Editor.initLaunchMod() end

--- Initializes the room tiles
function Editor.initTiles() end

--- Initializes the cells
function Editor.initCells() end

--- Initialize the history
function Editor.initHistory() end

--- Initialize the actions
function Editor.initActions() end

--- Initializes the objects
function Editor.initObjects() end

--- Creates a room
function Editor.newRoom() end

--- Load a room into the editor
--- @param room_data Dummy.Room.Data
function Editor.loadRoom(room_data) end

--- Saves the room
--- @return boolean
function Editor.saveRoom() end

--- Deletes a room
--- @param room_id string
function Editor.deleteRoom(room_id) end

--- Plays the current room
function Editor.playRoom() end

--- Opens the room form
function Editor.openRoomForm() end

--- Opens the object add modal
function Editor.openObjectAddModal() end

--- Opens the object form
--- @param obj_data Dummy.Object.Data
function Editor.openObjectForm(obj_data) end

--- Toggles the custom objects editor draw
--- @param enable? boolean
function Editor.toggleObjectsDraw(enable) end

--- Loads the room tileset
function Editor.loadTileset() end

--- Updates the tiles
--- @param layer? integer
function Editor.updateTiles(layer) end

--- Sets the grip position
--- @return number, number
function Editor.getGripPosition() end

--- Sets the grip position
--- @param x number
--- @param y number
function Editor.setGripPosition(x, y) end

--- Gets the map dimensions
--- @return number, number
function Editor.getMapDimensions() end

--- Gets the grip position
--- @return number, number
function Editor.getMapPosition() end

--- Sets the camera position
--- @param x number
--- @param y number
function Editor.setMapPosition(x, y) end

--- Moves the map
--- @param delta_x number
--- @param delta_y number
function Editor.moveMap(delta_x, delta_y) end

--- Gets the hovered cell
--- @return number, number
function Editor.getHoveredCell() end

--- Sets the hovered cell
--- @param x number
--- @param y number
function Editor.setHoveredCell(x, y) end

--- Snaps a value to the grid
--- @param v number
--- @return number
function Editor.snapToGrid(v) end

--- Gets the zoom room
--- @return number
function Editor.getZoom() end

--- Changes the zoom room
--- @param zoom number
function Editor.setZoom(zoom) end

--- Centers the map
function Editor.center() end

--- Centers the cursor
function Editor.centerCursor() end

--- Wether the action is selected
--- @param action Dummy.Editor.Cell.Action
--- @return boolean
function Editor.isActionSelected(action) end

--- Selects an action
--- @param action Dummy.Editor.Cell.Action|nil
function Editor.selectAction(action) end

--- Gets the selected tile
--- @return integer|nil
function Editor.getSelectedTile() end

--- Sets the selected tile
--- @param tile_index integer|nil
--- @param delta? integer
function Editor.selectTile(tile_index, delta) end

--- Gets the selected layer
--- @return integer
function Editor.getSelectedLayer() end

--- Sets the selected layer
--- @param layer integer
function Editor.selectLayer(layer) end

--- Updates the layer buttons
--- @param enabled? boolean
function Editor.updateLayerButtons(enabled) end

--- Does an action on a cell
function Editor.actionOnCell() end

--- Adds a tile to the room
--- @param tile integer
--- @param x number
--- @param y number
--- @param layer? integer
--- @return boolean
function Editor.addTile(tile, x, y, layer) end

--- Removes a tile from the room
--- @param x number
--- @param y number
--- @param layer? integer
--- @return boolean
function Editor.removeTile(x, y, layer) end

--- Copies the tile on the hovered cell
function Editor.copyTileOnCell() end

--- Gets an available object id
--- @return integer
function Editor.getAvailabeObjectId() end

--- Adds an object to the room
--- @param object_id string
--- @return Dummy.Object.Data|nil
function Editor.addObject(object_id) end

--- Removes an object from the room
--- @param id integer
--- @return Dummy.Object.Data|nil
function Editor.removeObject(id) end

function Editor.updateObjectsCount() end

--- Wether to handle user events in the editor
--- @return boolean
function Editor.canUseEditor() end

--- Wether the editor menu can be toggled
--- @return boolean
function Editor.canToggleMenu() end

--- Toggles the menu
--- @param visible? boolean
function Editor.toggleMenu(visible) end

--- Disables the editor buttons
--- @param enabled boolean
function Editor.toggleEditorButtons(enabled) end

--- Loads the rooms list
--- @return { file: { modtime: number }, filename: string }[]
function Editor.loadRoomsList() end

--- Show the rooms list
function Editor.showRoomsList() end

--- Wether the room has unsaved changes
--- @return boolean
function Editor.hasUnsavedChanges() end

--- Wether the room form has unsaved changes
function Editor.hasRoomFormChanges() end

--- Wether the room has unsaved tiles
function Editor.hasUnsavedTilesChanges() end

--- Wether the room has unsaved objects
function Editor.hasUnsavedObjectsChanges() end

--- Updates the window title
--- @param has_unsaved_changes? boolean
function Editor.updateWindowTitle(has_unsaved_changes) end

--- Opens the confirm modal before quitting
--- @param on_confirm? fun()
--- @param on_cancel? fun()
function Editor.confirmSaveBeforeQuitting(on_confirm, on_cancel) end

--- Pushes a snapshot to the history
function Editor.pushHistorySnapshot() end

--- Applies a snapshot
--- @param snapshot Dummy.Editor.Snapshot
function Editor.applySnapshot(snapshot) end

--- Updates the history buttons
--- @param enabled? boolean
function Editor.updateHistoryButtons(enabled) end

--- Undoes the last action
function Editor.undo() end

--- Redoes the last action
function Editor.redo() end

--- Gets the selected object's id
--- @return Dummy.Object.Data|nil
function Editor.getSelectedObject() end

--- Selects an object
--- @param object Dummy.Object.Data
function Editor.selectObject(object) end

--- Unselects the selected object
function Editor.unselectObject() end

--- Wether the editor can hover
--- @return boolean
function Editor.canHover() end

--- Wether the cursor is hovering the tile selector
--- @return boolean
function Editor.isHoveringTileSelector() end

--- Called when the pointer is hovering the editor
function Editor.onHover() end

--- Handles hovering over an object
function Editor.onHoverObject() end

--- Updates the main controller
function Editor.updateMainController() end

--- Updates the editor, called on every game update
--- @param dt number
function Editor.update(dt) end

