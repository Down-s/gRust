util.AddNetworkString("gRust.Combat.UpdateBlock")

local COMBAT_BLOCK_TIME
hook.Add("gRust.Loaded", "gRust.CreateCombatConfig", function()
    gRust.CreateConfigValue("combat/combat_block.time", 600)
    COMBAT_BLOCK_TIME = gRust.GetConfigValue("combat/combat_block.time")
end)

hook.Add("EntityTakeDamage", "gRust.Combat", function(target, dmg)
    local attacker = dmg:GetAttacker()
    if (IsValid(attacker) and attacker:IsPlayer()) then
        if (target:IsPlayer() or (target.OwnerID and target.OwnerID ~= attacker:SteamID())) then
            attacker:CombatBlock()
        end
    end
end)

local PLAYER = FindMetaTable("Player")
function PLAYER:CombatBlock()
    self.CombatBlockEnd = CurTime() + COMBAT_BLOCK_TIME

    net.Start("gRust.Combat.UpdateBlock")
    net.WriteFloat(self.CombatBlockEnd)
    net.Send(self)
end

function PLAYER:SetCombatBlockEnd(time)
    if (!time) then return end
    self.CombatBlockEnd = time

    net.Start("gRust.Combat.UpdateBlock")
    net.WriteFloat(time)
    net.Send(self)
end