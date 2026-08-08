--- @class WorldExampleMod.ACT.Talk : Dummy.Battle.ACT
local TalkACT = ACT:new("WORLD_EXAMPLE_MOD_ENCOUNTER_TALK_ACT")

--- Called when the ACT is used
function TalkACT:onUse()
  -- you can play multiples dialogues one after the other
  Battle.playDialogueText(
    "WORLD_EXAMPLE_MOD_ENCOUNTER_TALK_TEXT_1",
    "WORLD_EXAMPLE_MOD_ENCOUNTER_TALK_TEXT_2",
    "WORLD_EXAMPLE_MOD_ENCOUNTER_TALK_TEXT_3"
  )
  Battle.getEncounter():setReward(0, 150)

  -- set the Dummy as spared, to end the encounter after the dialogues are done
  self:getEnemy():setSpared(true)
end

return TalkACT
