local Editor = require "editor.editor"

--- @class Dummy.Scene.Editor : Dummy.Scene.Scene
---
--- @field protected quitting boolean
local EditorScene = {}

--- Loads the editor scene
--- @param mod_id string
--- @param room_id? string
function EditorScene.load(mod_id, room_id)
  EditorScene.quitting = false

  Input.setGamepadDeadzone(0.75)
  Input.setTriggerTreshold(0.9)

  -- editor should not be accessible for standalone mods
  -- so we can override the current mod for assets loading
  ---@diagnostic disable-next-line: invisible
  ModList.current_mod = ModList.getMod(mod_id)
  Lang.loadLanguages()

  Editor.load(mod_id, room_id)
end

--- Unloads the editor scene
function EditorScene.unload()
  Input.setGamepadDeadzone(0.2)
  Input.setTriggerTreshold(0.5)

  ---@diagnostic disable-next-line: invisible
  ModList.current_mod = nil
  Lang.loadLanguages()
end

--- Updates the editor scene, called on every game update
--- @param dt number
function EditorScene.update(dt)
  Editor.update(dt)
end

--- Wether the game can quit
--- @return boolean
function EditorScene.canQuit()
  if not EditorScene.quitting and Editor.hasUnsavedChanges() then
    Editor.confirmSaveBeforeQuitting(function()
      EditorScene.quitting = true
      love.event.quit()
    end)

    return false
  end

  return true
end

return EditorScene
