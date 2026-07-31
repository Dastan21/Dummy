--- @class WorldExampleMod.Portrait
---
--- @field protected blink_timer Dummy.Timer.Handle|nil
local Portrait = {}

--- Loads the portraits
function Portrait.load()
  Portrait.loadTorielPortrait()
end

--- Loads the toriel portrait
function Portrait.loadTorielPortrait()
  World.getTextbox():addPortrait("toriel", function(textbox, action, emotion)
    --- @type string[]
    local frames = {}
    local speed = 4 / 30
    local loop = true
    if action == "talk" then
      if emotion == "normal" then
        frames = {
          "world/portrait/toriel/talk_1",
          "world/portrait/toriel/talk_2",
        }
      elseif emotion == "side" then
        frames = {
          "world/portrait/toriel/talk_side_1",
          "world/portrait/toriel/talk_side_2",
        }
      elseif emotion == "happy" then
        frames = {
          "world/portrait/toriel/talk_happy_1",
          "world/portrait/toriel/talk_happy_2",
        }
      end
    elseif action == "blink" then
      speed = 5 / 30
      loop = false
      if emotion == "normal" then
        frames = {
          "world/portrait/toriel/blink_1",
          "world/portrait/toriel/blink_2",
          "world/portrait/toriel/blink_3",
          "world/portrait/toriel/blink_4",
        }
      elseif emotion == "happy" then
        frames = {
          "world/portrait/toriel/blink_happy_1",
          "world/portrait/toriel/blink_happy_2",
          "world/portrait/toriel/blink_happy_3",
          "world/portrait/toriel/blink_happy_4",
        }
      elseif emotion == "side" then
        frames = {
          "world/portrait/toriel/blink_side_1",
          "world/portrait/toriel/blink_side_2",
          "world/portrait/toriel/blink_side_3",
          "world/portrait/toriel/blink_side_4",
        }
      end
    end

    local dialogue = textbox:getDialogue()
    dialogue:setVoice("voice_toriel")
    dialogue:setPosition(69, 7)

    local portrait_sprite = textbox:getPortrait()
    portrait_sprite:setPosition(32, 30.5)
    portrait_sprite:setSprite(frames, speed, loop, true, true)
    portrait_sprite:setVisible(true)

    if action == "talk" then
      Portrait.startTalking()
    elseif action == "blink" then
      Portrait.startBlinking()
    end
  end)
end

--- Starts the portrait's talking animation
function Portrait.startTalking()
  Portrait.stopBlinking()

  local portrait_sprite = World.getTextbox():getPortrait()
  portrait_sprite:play()
end

--- Stops the portrait's blinking animation
function Portrait.stopBlinking()
  if Portrait.blink_timer ~= nil then
    Timer.cancel(Portrait.blink_timer)
    Portrait.blink_timer = nil
  end
end

--- Starts the portrait's blinking animation
function Portrait.startBlinking()
  Portrait.stopBlinking()

  local delay = (20 + math.round(love.math.random(30))) / 30
  Portrait.blink_timer = Timer.after(delay, function()
    Portrait.blink()
  end)
end

--- Makes the portrait blink
function Portrait.blink()
  World.getTextbox():getPortrait():play()
  local delay = (30 + math.round(love.math.random(60))) / 30
  Portrait.blink_timer = Timer.after(delay, function()
    if not World.getTextbox():getDialogue():isVisible() then
      Timer.cancel(Portrait.blink_timer)
      Portrait.blink_timer = nil
      return
    end
    Portrait.blink()
  end)
end

return Portrait
