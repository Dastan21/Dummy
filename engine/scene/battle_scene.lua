--- @class Dummy.Scene.Battle : Dummy.Scene.Scene
---
--- @field protected camera Dummy.GameCamera
--- @field protected previous_scene string
--- @field protected mod Dummy.Mod
--- @field protected encounter Dummy.Battle.Encounter
--- @field protected previous_state string
--- @field protected fader_alpha number
--- @field protected fader_drawable Dummy.Drawable
local BattleScene = {}

--- Loads the battle scene
--- @param EncounterClass Dummy.Battle.Encounter
--- @param previous_scene? string
function BattleScene.load(EncounterClass, previous_scene)
  BattleScene.camera = GameCamera:new()

  BattleScene.previous_scene = Utils.getOrDefault(previous_scene, "MAIN_MENU")

  Arena.load()
  Soul.load()
  Battle.load()
  BattleScene.previous_state = Battle.getCurrentState()

  local mod = ModList.getCurrentMod()
  assert(mod ~= nil, "Cannot start battle outside of a mod")
  BattleScene.mod = mod

  BattleScene.encounter = EncounterClass:new()
  Battle.start(BattleScene.encounter)

  if type(BattleScene.mod.onEncounterStart) == "function" then
    BattleScene.mod:onEncounterStart(BattleScene.encounter)
  end

  ModList.setWindowTitleAndIcon()
  Battle.updatePlayerUI()

  BattleScene.fadeOut()
end

--- Fades out the battle scene
--- @private
function BattleScene.fadeOut()
  BattleScene.fader_alpha = 1
  BattleScene.fader_drawable = Drawable:new()
  BattleScene.fader_drawable:setLayer(Constants.LAYERS.TOP)
  function BattleScene.fader_drawable.draw(_self)
    if not _self:isVisible() then return end

    love.graphics.setColor(0, 0, 0, BattleScene.fader_alpha)
    love.graphics.rectangle("fill", 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)
  end

  local soul_layer = Soul.getSprite():getLayer()
  Soul.getSprite():setLayer(Constants.LAYERS.TOP)
  Timer.tween(12 / 30, BattleScene, { fader_alpha = 0 }, "linear", function()
    Soul.getSprite():setLayer(soul_layer)
  end)
end

--- Updates the battle scene, called on every game update
--- @param dt number
function BattleScene.update(dt)
  if type(BattleScene.mod.update) == "function" then
    BattleScene.mod:update(dt)
  end

  if type(BattleScene.encounter.update) == "function" then
    BattleScene.encounter:update(dt)
  end

  local current_state = Battle.getCurrentState()
  if current_state ~= BattleScene.previous_state then
    if BattleScene.previous_state == Constants.BATTLE_STATES.FIGHT_ENEMY_MENU and current_state == Constants.BATTLE_STATES.ATTACKING then
      if type(BattleScene.encounter.onEnemyAttackSelected) == "function" then
        local enemy = Battle.getSelectedEnemy()
        if enemy ~= nil then
          BattleScene.encounter:onEnemyAttackSelected(enemy)
        end
      end
    elseif BattleScene.previous_state == Constants.BATTLE_STATES.ACT_ENEMY_MENU and current_state == Constants.BATTLE_STATES.ACT_MENU then
      if type(BattleScene.encounter.onEnemyActSelected) == "function" then
        local enemy = Battle.getSelectedEnemy()
        if enemy ~= nil then
          BattleScene.encounter:onEnemyActSelected(enemy)
        end
      end
    elseif BattleScene.previous_state == Constants.BATTLE_STATES.TEXT_DIALOGUE and current_state == Constants.BATTLE_STATES.ENEMY_DIALOGUE then
      if type(BattleScene.encounter.onTextEnd) == "function" then
        BattleScene.encounter:onTextEnd()
      end
    elseif BattleScene.previous_state == Constants.BATTLE_STATES.ENEMY_DIALOGUE and (current_state == Constants.BATTLE_STATES.ACTION_SELECT or current_state == Constants.BATTLE_STATES.DEFENDING) then
      if type(BattleScene.encounter.onEnemyDialoguesEnd) == "function" then
        BattleScene.encounter:onEnemyDialoguesEnd()
      end
    elseif BattleScene.previous_state == Constants.BATTLE_STATES.DEFENDING and current_state == Constants.BATTLE_STATES.ACTION_SELECT then
      if type(BattleScene.encounter.onDefendingEnd) == "function" then
        BattleScene.encounter:onDefendingEnd()
      end
    end

    if type(BattleScene.encounter.onStateChange) == "function" then
      BattleScene.encounter:onStateChange(current_state, BattleScene.previous_state)
    end

    if Battle.getCurrentState() == Constants.BATTLE_STATES.DONE then
      if type(BattleScene.encounter.onEnd) == "function" then
        BattleScene.encounter:onEnd()
      end

      if type(BattleScene.mod.onEncounterEnd) == "function" then
        BattleScene.mod:onEncounterEnd(BattleScene.encounter)
      end
    end

    if Battle.getCurrentState() == Constants.BATTLE_STATES.DONE then
      Scene.change(BattleScene.previous_scene, BattleScene.mod)
      return
    end

    BattleScene.previous_state = current_state
  end

  if Scene.getCurrentSceneId() ~= "BATTLE" then return end

  Battle.update(dt)
end

return BattleScene
