--- @class WorldExample.Object.Chestbox : Dummy.Object.NPC
local ChestboxObject = Class(NPCObject, "WorldExample.Object.NPC.Chestbox")

ChestboxObject.ALLOW_EDITOR = true

-- sprite to show in the editor
ChestboxObject.EDITOR_SPRITE = "world/object/chestbox"

--- Creates a chestbox
--- @param x number
--- @param y number
function ChestboxObject:new(x, y)
  self = Class:new(ChestboxObject, { "chestbox" })

  self:setSprite("world/object/chestbox")
  self:setPosition(x, y)
  self:setHitbox(2, 8, 16, 12)

  return self
end

--- Called when the chestbox is interacted by the player
function ChestboxObject:onInteract()
  World.playDialogue({ "WORLD_CHESTBOX_USE" }, function(_, choice)
    if choice == 1 then return end

    if #Player.getItems() <= 0 and #World.getItemsInChestbox() <= 0 then
      local rand = math.floor(love.math.random(3))
      World.playDialogue({ "WORLD_CHESTBOX_USE_EMPTY_" .. rand })
      return
    end

    World.openChestboxMenu()
  end)
end

return ChestboxObject
