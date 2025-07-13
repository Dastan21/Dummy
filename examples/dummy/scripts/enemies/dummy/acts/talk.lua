-- talk act
local act = ACT:new("DUMMY_MOD_ENCOUNTER_TALK_ACT")

--- Called when the ACT is used
function act:onUse()
  -- you can play multiples dialogues one after the other
  Encounter.playDialogueText(
    "DUMMY_MOD_ENCOUNTER_TALK_TEXT_1",
    "DUMMY_MOD_ENCOUNTER_TALK_TEXT_2",
    "DUMMY_MOD_ENCOUNTER_TALK_TEXT_3"
  )

  -- set the Dummy as spared, to end the encounter after the dialogues are done
  self:getEnemy():setSpared(true)
end

return act
