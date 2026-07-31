--- @class Dummy.World
---
--- @field protected current_room Dummy.Room|nil
--- @field protected rooms table<number, Dummy.Room>
--- @field protected shops table<number, Dummy.Shop>
--- @field protected chestbox_items Dummy.Item[]
--- @field protected cutscene Dummy.Cutscene|nil
--- @field protected starting_encounter boolean
--- @field protected player_sprite Dummy.Sprite
--- @field protected heart_sprite Dummy.Sprite
--- @field protected overlay Dummy.Drawable
--- @field protected textbox Dummy.Textbox
--- @field protected player_menu Dummy.PlayerMenu
--- @field protected save_menu Dummy.SaveMenu
--- @field protected chestbox_menu Dummy.ChestboxMenu
--- @field protected playtime number
local World = {}

--- Loads the world
function World.load()
  World.current_room = nil
  World.rooms = {}
  World.shops = {}
  World.chestbox_items = {}
  World.starting_encounter = false

  -- encounter transition animation
  World.overlay = Drawable:new()
  World.overlay:setLayer(Constants.LAYERS.TOP)
  World.overlay:setVisible(false)
  World.player_sprite = Sprite:new("pixel")
  World.player_sprite:setLayer(Constants.LAYERS.TOP)
  World.player_sprite:setVisible(false)
  World.heart_sprite = Sprite:new("heartsmall")
  World.heart_sprite:setLayer(Constants.LAYERS.TOP)
  World.heart_sprite:setVisible(false)

  World.textbox = Textbox:new("")
  World.textbox:setVisible(false)

  -- menus
  World.player_menu = PlayerMenu:new()
  World.save_menu = SaveMenu:new()
  World.chestbox_menu = ChestboxMenu:new()

  World.playtime = 0
end

--- Wether the player is in an encounter
--- @return boolean
function World.isInBattle()
  if Scene.getCurrentSceneId() ~= "BATTLE" then return false end

  local state = Battle.getCurrentState()
  return state ~= nil and state ~= Constants.BATTLE_STATES.NONE and state ~= Constants.BATTLE_STATES.DONE
end

--- Gets the current room
--- @return Dummy.Room|nil
function World.getCurrentRoom()
  return World.current_room
end

--- Gets a room by id
--- @generic T : Dummy.Room
--- @param room_id string
--- @return T
function World.getRoom(room_id)
  return World.rooms[room_id]
end

--- Adds a room
--- @param room_id string
--- @param room Dummy.Room
function World.addRoom(room_id, room)
  World.rooms[room_id] = room
end

--- Transitions to a room
--- @param room_id string
--- @param spawn_x number
--- @param spawn_y number
--- @param instant? boolean wether the transition is instant (Defaults to `false`)
function World.transitionRoom(room_id, spawn_x, spawn_y, instant)
  local RoomClass = World.getRoom(room_id)
  assert(RoomClass ~= nil, "Room \"" .. room_id .. "\" not found")

  local room = RoomClass:new() --[[@as Dummy.Room]]
  World.handleMusicTransitionOut(room:getMusic(), instant)

  if instant then
    World.enterRoom(room, spawn_x, spawn_y, true)
  else
    Fader.fadeIn(12 / 30, "linear", function()
      World.enterRoom(room, spawn_x, spawn_y)
    end)
  end
end

--- Enters a room
--- @param room Dummy.Room
--- @param spawn_x number
--- @param spawn_y number
--- @param instant? boolean
--- @private
function World.enterRoom(room, spawn_x, spawn_y, instant)
  if World.cutscene ~= nil then
    World.cutscene:attachCamera()
    World.cutscene:stop()
    World.cutscene = nil
  end

  local player_facing = "down"
  local obj_player = Player.getObject()
  if obj_player ~= nil then
    player_facing = obj_player:getFacing()
  end

  if World.current_room ~= nil then
    World.current_room:leave()
  end

  World.handleMusicTransitionIn(room:getMusic(), instant)
  World.current_room = room

  room:enter(spawn_x, spawn_y, player_facing, instant)
end

--- Handles the music transition out
--- @param next_music_name string|nil
--- @param instant? boolean
--- @private
function World.handleMusicTransitionOut(next_music_name, instant)
  local current_music = Assets.getCurrentMusic()
  local current_music_name = World.current_room ~= nil and World.current_room:getMusic()
  if current_music_name ~= next_music_name and Assets.getCurrentMusicName() == current_music_name and current_music ~= nil then
    if not instant then
      Assets.fadeOutMusic(10 / 30, current_music)
    else
      current_music:stop()
    end
  end
end

--- Handles the music transition in
--- @param next_music_name string|nil
--- @param instant? boolean
--- @private
function World.handleMusicTransitionIn(next_music_name, instant)
  local current_music = Assets.getCurrentMusic()
  local current_music_name = World.current_room and World.current_room:getMusic()
  if next_music_name == nil then
    if current_music ~= nil then
      current_music:stop()
    end
  elseif current_music_name ~= next_music_name then
    local music = Assets.playMusic(next_music_name)
    if not instant then
      Assets.fadeInMusic(25 / 30, music)
    end
  end
end

--- Handles the music transition pause
--- @param room Dummy.Room
--- @private
function World.handleMusicTransitionPause(room)
  if Assets.getCurrentMusicName() ~= room:getMusic() then return end

  local current_music = Assets.getCurrentMusic()
  if current_music == nil then return end

  room:setMusicSeek(current_music:tell())
end

--- Handles the music transition resume
--- @param room Dummy.Room
--- @private
function World.handleMusicTransitionResume(room)
  local music_name = room:getMusic()
  if music_name == nil then return end

  local music = Assets.playMusic(music_name)
  music:seek(room:getMusicSeek())
  music:play()
  Assets.fadeInMusic(25 / 30, music)
end

--- Starts an encounter
--- @param encounter Dummy.Battle.Data
--- @param ambush? boolean wether to play the ambush animation (Defaults to `false`)
--- @param ambush_sprite? string custom ambush sprite
function World.startEncounter(encounter, ambush, ambush_sprite)
  if World.starting_encounter then return end
  World.starting_encounter = true

  local obj_player = Player.getObject()
  obj_player:setInteraction("interact")

  local start = function()
    local room_music = Assets.getCurrentMusic()
    if room_music ~= nil then
      room_music:pause()
    end

    local target_x = Utils.getOrDefault(encounter.x, 24)
    local target_y = Utils.getOrDefault(encounter.y, 227)
    local camera = Scene.getCameraByTag("GAME")
    if camera ~= nil then
      local camera_width, camera_height = camera:getDimensions()
      local viewport_x, viewport_y = camera:getViewportPosition()
      target_x = viewport_x - camera_width / 2 + target_x
      target_y = viewport_y - camera_height / 2 + target_y
    end
    World.doEncounterTransitionAnimation(target_x, target_y)

    local current_room
    if World.getCurrentRoom() ~= nil and World.getCurrentRoom():getId() ~= "default" then
      current_room = "WORLD"
    end
    Timer.after(1.1, function()
      World.starting_encounter = false
      Scene.change("BATTLE", encounter, current_room)
    end)
  end

  if ambush == true then
    local sound = Assets.playSound("bip")
    sound:setVolume(0.93)
    local exc_sprite = Utils.getOrDefault(ambush_sprite, "world/exclamation")
    local exclamation = Sprite:new(exc_sprite)
    exclamation:setOrigin(0.5, 1)
    exclamation:setPosition(0, -obj_player:getHeight() / 2 - 1)
    exclamation:setParent(obj_player)

    Timer.after((15 + math.round(love.math.random(0, 5))) / 30, function()
      exclamation:remove()
      start()
    end)
  else
    start()
  end
end

--- Does the transition animation
--- @param target_x number
--- @param target_y number
--- @private
function World.doEncounterTransitionAnimation(target_x, target_y)
  World.overlay:setVisible(true)
  function World.overlay.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.push()
    love.graphics.origin()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)

    love.graphics.pop()
  end

  local obj_player = Player.getObject()
  obj_player:setFrame(1)
  local player_image = obj_player:getImage()
  if player_image ~= nil then
    World.player_sprite:setSprite(player_image)
  end
  World.player_sprite:setVisible(true)
  local player_x, player_y = obj_player:getPosition()
  World.player_sprite:setPosition(player_x, player_y)

  World.heart_sprite:setPosition(math.round(player_x) - 0.5, math.round(player_y) + 6.5)

  local claptimer = 2 / 30
  local clap = 0

  --- @type Dummy.Timer.Handle
  Timer.every(claptimer, function()
    if World.heart_sprite:isVisible() then
      World.heart_sprite:setVisible(false)
      clap = clap + 1
    else
      World.heart_sprite:setVisible(true)
      local sound = Assets.playSound("noise")
      sound:setVolume(0.93)
    end
  end, 5)

  Timer.after(claptimer * 6, function()
    World.player_sprite:setVisible(false)
    Assets.playSound("battlefall")

    target_x = math.round(target_x) + 0.5
    target_y = math.round(target_y) + 0.5

    local heart_x, heart_y = World.heart_sprite:getPosition()
    local dx = target_x - heart_x
    local dy = target_y - heart_y
    local dist = math.dist(heart_x, heart_y, target_x, target_y)
    local speed = dist / 17 * 30

    Timer.during(17 / 30, function(dt)
      if dt <= 0 then return end

      heart_x, heart_y = World.heart_sprite:getPosition()
      if dist > 0 then
        heart_x = heart_x + dx / dist * speed * dt
        heart_y = heart_y + dy / dist * speed * dt
      end
      World.heart_sprite:setPosition(heart_x, heart_y)
    end, function()
      World.heart_sprite:setPosition(target_x, target_y)
    end)
  end)
end

--- Gets a shop by id
--- @param shop_id string
--- @return Dummy.Shop
function World.getShop(shop_id)
  return World.shops[shop_id]
end

--- Adds a shop
--- @param shop_id string
--- @param shop Dummy.Shop
function World.addShop(shop_id, shop)
  World.shops[shop_id] = shop
end

--- Transitions to a shop
--- @param shop_id string
function World.transitionShop(shop_id)
  local ShopClass = World.getShop(shop_id)
  assert(ShopClass ~= nil, "Shop \"" .. shop_id .. "\" not found")

  local music = Assets.getCurrentMusic()
  if music ~= nil then
    Assets.fadeOutMusic(10 / 30, music)
  end

  Fader.fadeIn(12 / 30, "linear", function()
    Scene.change("SHOP", shop_id)
  end)
end

--- Gets the chestbox's items
--- @return Dummy.Item[]
function World.getItemsInChestbox()
  return World.chestbox_items
end

--- Adds an item to the chestbox
--- @param item Dummy.Item
--- @param index? integer
function World.addItemIntoChestbox(item, index)
  table.insert(World.chestbox_items, Utils.getOrDefault(index, #World.getItemsInChestbox() + 1), item)
end

--- Removes an item from the chestbox
--- @param index integer
function World.removeItemFromChestbox(index)
  table.remove(World.chestbox_items, index)
end

--- Wether an object collide another in the world
---@param object Dummy.Object
---@param x? number
---@param y? number
---@return boolean, Dummy.Object|nil
function World.checkCollision(object, x, y)
  local room = World.getCurrentRoom()
  if room == nil or not object:isVisible() or not object:isCollisionEnabled() then return false end

  local object_x, object_y = object:getPosition()
  local left = object:getLeft()
  if x ~= nil then
    left = left - object_x + x
  end
  local top = object:getTop()
  if y ~= nil then
    top = top - object_y + y
  end
  local _, _, hitbox_width, hitbox_height = object:getHitbox()

  local objects = room:getObjects()
  table.stable_sort(objects, function(a, b)
    return (a:getLayer() or 0) > (b:getLayer() or 0)
  end)
  for _, obj in ipairs(objects) do
    if object ~= obj and obj:isVisible() and obj:isCollisionEnabled() and obj:isCollisionSolid() then
      if obj:is(SolidTriangleObject) then
        local obj_left = math.round(obj:getLeft())
        local obj_top = math.round(obj:getTop())
        local obj_tri = obj --[[@as Dummy.Object.SolidTriangle]]
        local ax, ay, bx, by, cx, cy = obj_tri:getHitboxTriangle()
        ax = math.round(obj_left + ax)
        ay = math.round(obj_top + ay)
        bx = math.round(obj_left + bx)
        by = math.round(obj_top + by)
        cx = math.round(obj_left + cx)
        cy = math.round(obj_top + cy)
        for _, points in ipairs({
          { left,                top },
          { left + hitbox_width, top },
          { left,                top + hitbox_height },
          { left + hitbox_width, top + hitbox_height }
        }) do
          if Utils.pointInTriangle(math.round(points[1]), math.round(points[2]), ax, ay, bx, by, cx, cy) then
            return true, obj_tri
          end
        end
        for _, points in ipairs({
          { ax, ay },
          { bx, by },
          { cx, cy },
        }) do
          if Utils.isPointInRect(math.round(points[1]), math.round(points[2]), math.round(left), math.round(top), hitbox_width, hitbox_height) then
            return true, obj
          end
        end
      else
        local _, _, obj_hitbox_width, obj_hitbox_height = obj:getHitbox()
        if Utils.checkCollisionAABB({ math.round(left), math.round(top), hitbox_width, hitbox_height }, { math.round(obj:getLeft()), math.round(obj:getTop()), obj_hitbox_width, obj_hitbox_height }) then
          return true, obj
        end
      end
    end
  end

  return false
end

--- Called when the world is paused
function World.onPause()
  local current_room = World.getCurrentRoom()
  if current_room ~= nil then
    World.handleMusicTransitionPause(current_room)

    if type(current_room.onPause) == "function" then
      current_room:onPause()
    end
  end
end

--- Called when the world is resumed
function World.onResume()
  World.player_sprite:setVisible(false)
  World.heart_sprite:setVisible(false)
  World.overlay:setVisible(false)

  Player.getObject():setInteraction("none")

  local current_room = World.getCurrentRoom()
  if current_room ~= nil then
    World.handleMusicTransitionResume(current_room)

    Fader.fadeOut(12 / 30, "linear")

    if type(current_room.onResume) == "function" then
      current_room:onResume()
    end
  end
end

--- Gets the textbox
--- @return Dummy.Textbox
function World.getTextbox()
  return World.textbox
end

--- Plays a dialogue in the textbox
--- @param texts Dummy.Text.Text[]
--- @param on_done? fun(self: Dummy.DialogueText, choice?: integer)
--- @return Dummy.Textbox
function World.playDialogue(texts, on_done)
  local current_room = World.getCurrentRoom()
  if current_room == nil then return World.textbox end

  World.textbox:playDialogue(texts, on_done)
  return World.textbox
end

--- Plays a cutscene in the world
--- @param cutscene fun(cutscene: Dummy.Cutscene)
function World.playCutscene(cutscene)
  local current_room = World.getCurrentRoom()
  if current_room == nil then return end

  assert(World.cutscene == nil or not World.cutscene:isPlaying(), "Cannot play a cutscene while another one is playing")

  World.cutscene = Cutscene:new(cutscene)
end

--- Stops the current cutscene
function World.stopCutscene()
  if World.cutscene == nil then return end

  World.cutscene:stop()
  World.cutscene = nil
end

--- Shows the save menu
function World.openSaveMenu()
  World.save_menu:open()
end

--- Closes the save menu
function World.closeSaveMenu()
  World.save_menu:close()
end

--- Opens the player menu
function World.openPlayerMenu()
  World.player_menu:open()
end

--- Closes the player menu
function World.closePlayerMenu()
  World.player_menu:close()
end

--- Opens the chestbox menu
--- @param chestbox_list? Dummy.Item[]
--- @param on_add? fun(self: Dummy.ChestboxMenu, item: Dummy.Item)
--- @param on_remove? fun(self: Dummy.ChestboxMenu, index: integer)
function World.openChestboxMenu(chestbox_list, on_add, on_remove)
  World.player_menu:close()

  local list = Utils.getOrDefault(chestbox_list, World.getItemsInChestbox())
  World.chestbox_menu:open(list, on_add, on_remove)
end

--- Closes the chestbox menu
function World.closeChestboxMenu()
  World.chestbox_menu:close()
end

--- Updates the world, called on every game update
--- @param dt number
function World.update(dt)
  if World.current_room ~= nil then
    World.current_room:update(dt)
  end

  if World.cutscene ~= nil then
    World.cutscene:update(dt)
  end

  World.playtime = World.playtime + dt
end

return World
