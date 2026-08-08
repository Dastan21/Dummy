--[[
  Generated from ..\engine\editor\ui\window.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/editor/ui/window.lua
]]

---@meta

Button = {}

--- @class Dummy.Editor.Window.Inputs
---
--- @field next string|string[]
--- @field up string|string[]
--- @field down string|string[]
--- @field left string|string[]
--- @field right string|string[]

--- Creates a window
--- @return Dummy.Editor.Window
function Window:new() end

--- Gets the active windows
--- @return Dummy.Editor.Window[]
function Window.getActiveWindows() end

--- Sets wether the window is visible
--- @param visible boolean
--- @param i? number
--- @param j? number
function Window:setVisible(visible, i, j) end

--- Sets the window's width
--- @param width number
function Window:setWidth(width) end

--- Sets the window's height
--- @param height number
function Window:setHeight(height) end

--- Gets the window's virtual width
--- @return number
function Window:getVirtualWidth() end

--- Gets the window's virtual height
--- @return number
function Window:getVirtualHeight() end

--- Gets the window's visible width
--- @return number
function Window:getVisibleWidth() end

--- Gets the window's visible height
--- @return number
function Window:getVisibleHeight() end

--- Gets the window's scroll width
--- @return number
function Window:getScrollWidth() end

--- Gets the window's scroll height
--- @return number
function Window:getScrollHeight() end

--- Wether the window can be scrolled
--- @return boolean
function Window:canScroll() end

--- Scrolls the window
--- @param delta_x number
--- @param delta_y number
--- @param absolute? boolean
function Window:scroll(delta_x, delta_y, absolute) end

--- Resets the window's scroll
function Window:resetScroll() end

--- Sets the window's padding
--- @overload fun(self: Dummy.Editor.Window, padding: [number, number, number, number])
--- @param padding_top number
--- @param padding_right number
--- @param padding_bottom number
--- @param padding_left number
function Window:setPadding(padding_top, padding_right, padding_bottom, padding_left) end

--- Gets the window's padding
--- @return [number, number, number, number]
function Window:getPadding() end

--- Adds a child to the window
--- @param child Dummy.Drawable
function Window:addChild(child) end

--- Wether the window has one of its element focused
--- @return boolean
function Window:isFocused() end

--- Gets the window's focusable UI element at the given index
--- @param i number
--- @param j number
--- @return Dummy.Editor.Button|nil
function Window:getUIElement(i, j) end

--- Gets the window's focusable UI elements
--- @return Dummy.Editor.Button[][]
function Window:getUIElements() end

--- Sets the window's focusable UI elements
--- @param elements Dummy.Editor.Button[][]
--- @param focus_element_hover? boolean wether to focus element on hover (Defaults to `false`)
function Window:setUIElements(elements, focus_element_hover) end

--- Gets the focused UI element index
--- @return number, number
function Window:getFocusedIndex() end

--- Focuses the specific UI element
--- @param i number
--- @param j number
--- @param init? boolean wether to init the focus (Defaults to `false`)
function Window:focusAt(i, j, init) end

--- Focuses the next element
function Window:focusNext() end

--- Focuses the previous element
function Window:focusPrevious() end

--- Focuses the window
--- @param i? number
--- @param j? number
function Window:focus(i, j) end

--- Unfocuses the window
function Window:unfocus() end

--- Gets the control inputs
--- @return Dummy.Editor.Window.Inputs
function Window:getControlInputs() end

--- Sets the control inputs
--- @param next? string|string[]
--- @param up? string|string[]
--- @param down? string|string[]
--- @param left? string|string[]
--- @param right? string|string[]
function Window:setControlInputs(next, up, down, left, right) end

--- Called when the window is removed from the scene
function Window:onRemoved() end

--- Draws to the window's mask
function Window:drawMask() end

--- Draws the window
--- @param camera Dummy.Camera
function Window:draw(camera) end

--- Updates the window, called on every frame
--- @param dt number
function Window:update(dt) end

