--- @class Threat : Dummy.ACT
local Threat = ACT:new("FROGGIT_MOD_ENCOUNTER_THREAT_ACT")

--- Called when the ACT is used
function Threat:onUse()
  Encounter.playDialogueText("FROGGIT_MOD_ENCOUNTER_THREAT_TEXT")
  self:getEnemy():setCanBeSpared(true)
end

return Threat
