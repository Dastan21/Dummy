--- @class FroggitMod.ACT.Threat : Dummy.Battle.ACT
local ThreatACT = ACT:new("FROGGIT_MOD_ENCOUNTER_THREAT_ACT")

--- Called when the ACT is used
function ThreatACT:onUse()
  Battle.playDialogueText("FROGGIT_MOD_ENCOUNTER_THREAT_TEXT")
  self:getEnemy():setCanBeSpared(true)
end

return ThreatACT
