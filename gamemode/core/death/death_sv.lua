util.AddNetworkString("gRust.PlayerDeathScreen")
hook.Add("PlayerDeath", "gRust.PlayerDeathScreen", function(victim, inflictor, attacker)
    inflictor = victim.LastInflictor
    attacker = victim.LastAttacker

    if (!IsValid(victim) or !victim:IsPlayer()) then return end

    local timeAlive = CurTime() - victim:GetSpawnTime()
    local weapon = 0
    local dist = 0
    if (inflictor and IsValid(inflictor) and inflictor.Item) then
        weapon = inflictor.Item:GetIndex()
        dist = inflictor:GetPos():Distance(victim:GetPos())
    elseif (attacker and IsValid(attacker) and attacker:IsPlayer() and attacker.ActiveWeaponItem) then
        weapon = attacker.ActiveWeaponItem:GetIndex()
        dist = attacker:GetPos():Distance(victim:GetPos())
    end

    net.Start("gRust.PlayerDeathScreen")
        net.WriteFloat(timeAlive, 32)
        net.WriteEntity(attacker)
        net.WriteUInt(weapon, gRust.ItemIndexBits)
        net.WriteFloat(dist)
    net.Send(victim)
end)

util.AddNetworkString("gRust.Respawn")
net.Receive("gRust.Respawn", function(len, pl)
    if (pl:Alive()) then return end
    pl:Spawn()
end)