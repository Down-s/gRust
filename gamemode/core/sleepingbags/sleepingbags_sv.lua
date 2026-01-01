local PLAYER = FindMetaTable("Player")
util.AddNetworkString("gRust.AddSleepingBag")
function PLAYER:AddSleepingBag(ent)
    self.SleepingBags = self.SleepingBags or {}
    table.insert(self.SleepingBags, ent:EntIndex())

    ent.OwnerID = self:SteamID()

    net.Start("gRust.AddSleepingBag")
    net.WriteUInt(ent:EntIndex(), 16)
    net.Send(self)
end

util.AddNetworkString("gRust.RemoveSleepingBag")
function PLAYER:RemoveSleepingBag(ent)
    self.SleepingBags = self.SleepingBags or {}
    for k, v in pairs(self.SleepingBags) do
        if (v == ent:EntIndex()) then
            table.remove(self.SleepingBags, k)
            break
        end
    end

    ent.OwnerID = nil

    net.Start("gRust.RemoveSleepingBag")
    net.WriteUInt(ent:EntIndex(), 16)
    net.Send(self)
end

util.AddNetworkString("gRust.SyncSleepingBags")
function PLAYER:LoadSleepingBags()
    self.SleepingBags = self.SleepingBags or {}
    
    for _, ent in ents.Iterator() do
        if (ent.SleepingBag and ent.OwnerID == self:SteamID()) then
            table.insert(self.SleepingBags, ent:EntIndex())
        end
    end

    net.Start("gRust.SyncSleepingBags")
    net.WriteUInt(#self.SleepingBags, 8)
    for k, v in ipairs(self.SleepingBags) do
        net.WriteUInt(v, 16)
    end
    net.Send(self)
end

util.AddNetworkString("gRust.BagRespawn")
net.Receive("gRust.BagRespawn", function(len, pl)
    if (pl:Alive()) then return end
    local index = net.ReadUInt(8)
    local ent = pl:GetSleepingBags()[index]
    if (!IsValid(ent)) then return end
    if ((ent:GetRespawnTime() + ent.BagSpawnTime) > CurTime()) then return end

    pl:Spawn()
    pl:SetPos(ent:GetPos())
    ent:SetRespawnTime(CurTime())
end)

hook.Add("PlayerNetworkReady", "gRust.LoadSleepingBags", function(pl)
    pl:LoadSleepingBags()
end)

hook.Add("EntityRemoved", "gRust.RemoveSleepingBag", function(ent)
    if (ent.SleepingBag) then
        local owner = player.GetBySteamID(ent.OwnerID)
        if (IsValid(owner)) then
            owner:RemoveSleepingBag(ent)
        end
    end
end)