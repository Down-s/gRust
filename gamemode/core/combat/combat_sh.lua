local PLAYER = FindMetaTable("Player")
function PLAYER:IsCombatBlocked()
    return self.CombatBlockEnd and self.CombatBlockEnd > CurTime()
end

function PLAYER:GetCombatBlockEnd()
    return self.CombatBlockEnd
end