--- @class FroggitMod.ACT.Compliment : Dummy.Battle.ACT
local ComplimentACT = ACT:new("FROGGIT_MOD_ENCOUNTER_COMPLIMENT_ACT")

--- Called when the ACT is used
function ComplimentACT:onUse()
  Battle.playDialogueText("FROGGIT_MOD_ENCOUNTER_COMPLIMENT_TEXT")
  self:getEnemy():setCanBeSpared(true)
end

return ComplimentACT
