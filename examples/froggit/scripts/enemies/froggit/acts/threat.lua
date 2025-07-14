-- talk act
local act = ACT:new("FROGGIT_MOD_ENCOUNTER_THREAT_ACT")

--- Called when the ACT is used
function act:onUse()
  Encounter.playDialogueText("FROGGIT_MOD_ENCOUNTER_THREAT_TEXT")
  self:getEnemy():setCanBeSpared(true)
end

return act
