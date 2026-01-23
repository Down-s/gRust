util.AddNetworkString("RustHitmarker")

hook.Add("EntityTakeDamage", "RustHitmarker_Server", function(ent, dmg)
    local attacker = dmg:GetAttacker()
    if not IsValid(attacker) or not attacker:IsPlayer() then return end
    if not (ent:IsPlayer() or ent:IsNPC()) then return end

    net.Start("RustHitmarker")
    net.Send(attacker)
end)