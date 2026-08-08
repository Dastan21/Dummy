local Editor = require "editor.editor"
local Window = require "editor.ui.window"
local Button = require "editor.ui.button"
local InputText = require "editor.ui.input_text"

--- @class Dummy.Editor.ObjectAddModal.Object
---
--- @field id string
--- @field key string
--- @field mod_id string|nil
--- @field class Dummy.Object
--- @field button Dummy.Editor.Button

--- @class Dummy.Editor.ObjectAddModal : Dummy.Editor.Window
---
--- @field protected cancel_btn Dummy.Editor.Button
--- @field protected title Dummy.Text
--- @field protected search_input Dummy.Editor.InputText
--- @field protected objects_map table<string, Dummy.Editor.ObjectAddModal.Object>
--- @field protected objects Dummy.Editor.ObjectAddModal.Object[]
--- @field protected closing boolean
local ObjectAddModal = Class(Window, "Dummy.Editor.ObjectAddModal")

ObjectAddModal.WINDOW_WIDTH = 256
ObjectAddModal.WINDOW_HEIGHT = 160
ObjectAddModal.HEADER_HEIGHT = 18
ObjectAddModal.LABEL_WIDTH_RATIO = 0.65
ObjectAddModal.TEXT_PADDING = 4
ObjectAddModal.INPUT_GAP = 2
ObjectAddModal.SEARCH_HEIGHT = 20
ObjectAddModal.INPUT_HEIGHT = 20

--- Creates an entity window
--- @return Dummy.Editor.ObjectAddModal
function ObjectAddModal:new()
  self = Class:new(ObjectAddModal)

  self:initObjectAddWindow()

  self.objects_map = {}
  self.objects = {}

  self:loadObjects(Editor.getModId())

  return self
end

--- Initializes the object add modal
function ObjectAddModal:initObjectAddWindow()
  self:setVisible(false)
  self:setLayer(Constants.LAYERS.WINDOW + 1)

  self:setWidth(ObjectAddModal.WINDOW_WIDTH)
  self:setHeight(ObjectAddModal.WINDOW_HEIGHT)
  self:setControlInputs(
    nil,
    { "up", "gamepad:1:dpup" },
    { "down", "gamepad:1:dpdown" },
    { "left", "gamepad:1:dpleft" },
    { "right", "gamepad:1:dpright" }
  )

  local window_x = (Constants.WORLD_WIDTH - ObjectAddModal.WINDOW_WIDTH) / 2
  local window_y = (Constants.WORLD_HEIGHT - ObjectAddModal.WINDOW_HEIGHT) / 2
  self:setPosition(window_x, window_y)

  self.closing = false

  self.cancel_btn = Button:new()
  self.cancel_btn:setParent(self)
  self.cancel_btn:setWidth(ObjectAddModal.HEADER_HEIGHT)
  self.cancel_btn:setHeight(ObjectAddModal.HEADER_HEIGHT)
  self.cancel_btn:setSprite(Sprite:new("editor/cross"))
  self.cancel_btn:setBorder(0)
  self.cancel_btn:setColor(0, 0, 0, 0)
  self.cancel_btn:setHoverColor(1, 1, 1, 0.2)
  self.cancel_btn:setPosition(self:getWidth() - ObjectAddModal.HEADER_HEIGHT / 2, ObjectAddModal.HEADER_HEIGHT / 2)
  self.cancel_btn:setTooltip("EDITOR_ADD_OBJECT_MODAL_CLOSE")
  self.cancel_btn:getTooltip():setOffset(ObjectAddModal.HEADER_HEIGHT / 2 - 2)
  function self.cancel_btn.onClick()
    self.closing = true

    if type(self.onCancel) == "function" then
      self:onCancel()
    end
  end

  self.title = Text:new("EDITOR_ADD_OBJECT_MODAL_TITLE")
  self.title:setParent(self)
  self.title:setFont("main_text")
  self.title:setOrigin(0, 0)
  self.title:setMaxWidth(ObjectAddModal.WINDOW_WIDTH - (ObjectAddModal.HEADER_HEIGHT + ObjectAddModal.TEXT_PADDING) * 2)
  self.title:setOverflow("ellipsis")
  self.title:setPosition(ObjectAddModal.TEXT_PADDING, 0)

  self.search_input = InputText:new()
  self.search_input:setParent(self)
  self.search_input:setWidth(self:getWidth())
  self.search_input:setHeight(ObjectAddModal.SEARCH_HEIGHT)
  self.search_input:setMinWidth(self:getWidth())
  self.search_input:setPadding(ObjectAddModal.TEXT_PADDING)
  self.search_input:getText():setMaxWidth(self:getWidth() - ObjectAddModal.TEXT_PADDING * 2)
  self.search_input:getText():setPosition(self.search_input:getPadding(), 1)
  self.search_input:setHeight(ObjectAddModal.SEARCH_HEIGHT)
  self.search_input:setPosition(0, ObjectAddModal.HEADER_HEIGHT)
  self.search_input:setPlaceholder(Lang.translate("EDITOR_ADD_OBJECT_MODAL_SEARCH_PLACEHOLDER"))
  self.search_input:setBorder(1)

  function self.search_input.onInput()
    self:resetScroll()
    self:filterObjects()
  end
end

--- Loads objects from a folder
--- @param folder string
--- @param mod_id? string
function ObjectAddModal:loadObjectsFromFolder(folder, mod_id)
  for _, filename in ipairs(love.filesystem.getDirectoryItems(folder)) do
    if Utils.checkExtension(filename, "lua") and filename ~= "object.lua" then
      local object_id = UTF8.lower(Utils.getFilenameWithoutExt(filename))
      local key = object_id:gsub("^obj_", "")
      local ObjectClass = require(folder .. object_id) --[[@as Dummy.Object]]

      if ObjectClass.ALLOW_EDITOR == true then
        local button = Button:new()
        button:setParent(self)
        button:setHeight(ObjectAddModal.INPUT_HEIGHT)
        button:setWidth(self:getWidth())

        local label = key
        if mod_id ~= nil then
          label = "mod/" .. label
        end
        local text = Text:new(label, true)
        text:setOrigin(0, 0.5)
        text:setPosition(ObjectAddModal.TEXT_PADDING - button:getWidth() / 2, 0)
        text:setMaxWidth(self:getWidth() - ObjectAddModal.TEXT_PADDING * 2)
        text:setOverflow("ellipsis")
        button:setText(text)
        button:setBorder(0)
        button["object_id"] = object_id

        function button.onClick(btn)
          self.closing = true

          if type(self.onConfirm) == "function" then
            self:onConfirm(btn["object_id"])
          end
        end

        self.objects_map[object_id] = {
          id = object_id,
          key = key,
          mod_id = mod_id,
          class = ObjectClass,
          button = button
        }
      end
    end
  end
end

--- Loads objects
--- @param mod_id string
function ObjectAddModal:loadObjects(mod_id)
  self.objects_map = {}

  self:loadObjectsFromFolder("world/object/")
  self:loadObjectsFromFolder("mods/" .. mod_id .. "/scripts/world/object/", mod_id)
end

--- Filters objects by id
function ObjectAddModal:filterObjects()
  self.objects = {}

  local search = UTF8.lower(self.search_input:getValue())
  for _, object in pairs(self.objects_map) do
    if search == "" or object.key:find(search, 1, true) then
      table.insert(self.objects, object)
    end
  end

  table.stable_sort(self.objects, function(a, b)
    if a.mod_id == nil and b.mod_id == nil then
      return a.key < b.key
    elseif a.mod_id == nil then
      return true
    elseif b.mod_id == nil then
      return false
    end
    return a.key < b.key
  end)

  self:updateUIElements()
end

--- Updates the object add modal's UI elements
function ObjectAddModal:updateUIElements()
  --- @type Dummy.Editor.Button[][]
  local elements = {
    { self.cancel_btn },
    { self.search_input },
  }

  for _, object in pairs(self.objects_map) do
    object.button:setPosition(0, 0)
    object.button:setVisible(false)
  end

  for i, object in ipairs(self.objects) do
    local button_y = (i - 0.5) * ObjectAddModal.INPUT_HEIGHT + ObjectAddModal.SEARCH_HEIGHT +
        ObjectAddModal.HEADER_HEIGHT
    object.button:setPosition(self:getWidth() / 2, button_y)
    object.button:setVisible(true)

    table.insert(elements, { object.button })
  end

  self:setUIElements(elements)
end

--- Gets the objects
--- @return table<string, Dummy.Editor.ObjectAddModal.Object>
function ObjectAddModal:getObjects()
  return self.objects_map
end

--- Opens the object add modal
function ObjectAddModal:open()
  if self.search_input:getValue() ~= "" then
    self.search_input:setValue("")
  end

  self:filterObjects()
  self:setVisible(true, 2, 1)
end

--- Closes the object add modal
function ObjectAddModal:close()
  self.closing = false

  self:setVisible(false)

  if type(self.onClose) == "function" then
    self:onClose()
  end
end

--- Called when the object add modal is canceled
function ObjectAddModal:onCancel() end

--- Called when the object add modal is confirmed
--- @param object_id string
function ObjectAddModal:onConfirm(object_id) end

--- Called when the object add modal is closed
function ObjectAddModal:onClose() end

--- Updates the object add modal
function ObjectAddModal:update(dt)
  if not self:isVisible() then return end

  if self.closing then
    self:close()
    return
  end

  if Input.isPressed(Input.Escape) then
    self.closing = true
  end

  Window.update(self, dt)
end

return ObjectAddModal
