-- talk act
local act = ACT:new("FROGGIT_MOD_ENCOUNTER_COMPLIMENT_ACT")

--- Called when the ACT is used
function act:onUse()
  Encounter.playDialogueText("FROGGIT_MOD_ENCOUNTER_COMPLIMENT_TEXT")
  self:getEnemy():setCanBeSpared(true)
end

return act
