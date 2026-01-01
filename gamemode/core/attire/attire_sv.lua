util.AddNetworkString("gRust.Attire.Sync")
util.AddNetworkString("gRust.Attire.Add")
util.AddNetworkString("gRust.Attire.Remove")
util.AddNetworkString("gRust.Attire.Clear")

local PLAYER = FindMetaTable("Player")
function PLAYER:IsWearingAttireType(attireType)
    local attire = self.Attire
    if (!attire) then return end

    local attireTypes = {}
    for i = 1, attire:GetSlots() do
        local item = attire[i]
        if (!item) then continue end

        local attire = item:GetRegister():GetAttire()
        if (!attire) then continue end
        
        attireTypes[attire:GetType()] = true
    end

    return attireTypes[attireType]
end

function PLAYER:IsWearingAttire()
    local attire = self.Attire
    if (!attire) then return end

    for i = 1, attire:GetSlots() do
        local item = attire[i]
        if (!item) then continue end
        return true
    end

    return false
end

hook.Add("OnPlayerAttireUpdated", "gRust.AttireUpdate", function(pl)
    local attire = pl.Attire
    if (!attire) then return end

    local attireTypes = {}
    for i = 1, attire:GetSlots() do
        local item = attire[i]
        if (!item) then continue end
        
        local attire = item:GetRegister():GetAttire()
        if (!attire) then continue end
        
        attire:PlayerEquip(pl, item)
        attireTypes[attire:GetType()] = item
    end

    if (pl.AttireTypes) then
        for k, v in pairs(pl.AttireTypes) do
            if (!attireTypes[k]) then
                local attire = v:GetRegister():GetAttire()
                if (!attire) then continue end

                if (pl.EquippedAttire and pl.EquippedAttire[attire.Type]) then
                    net.Start("gRust.Attire.Remove")
                        net.WritePlayer(pl)
                        net.WriteUInt(attire.Type, 4)
                    net.Broadcast()
                end
    
                attire:PlayerUnequip(pl)
            end
        end
    end

    pl.AttireTypes = attireTypes
end)

hook.Add("CanPlayerWearAttire", "gRust.CanPlayerWearAttire", function(pl, item)
    if (!item) then return end
    local attireItem = item:GetRegister():GetAttire()
    if (!attireItem) then return false end

    if (attireItem:GetType() == AttireType.Full) then
        return !pl:IsWearingAttire()
    end
    
    if (pl:IsWearingAttireType(attireItem:GetType())) then
        return false
    end

    if (pl:IsWearingAttireType(AttireType.Full)) then
        return false
    end

    return true
end)

local PLAYER = FindMetaTable("Player")
function PLAYER:SyncAttire()
    local attirePlayers = {}
    for _, pl in player.Iterator() do
        if (!pl.Attire) then continue end

        local attire = {}
        for i = 1, pl.Attire:GetSlots() do
            local item = pl.Attire[i]
            if (!item) then continue end

            local register = item:GetRegister()
            if (!register || !register:GetAttire()) then continue end

            attire[#attire + 1] = register:GetIndex()
        end

        attirePlayers[#attirePlayers + 1] = {
            pl = pl,
            attire = attire
        }
    end

    net.Start("gRust.Attire.Sync")
        net.WriteUInt(#attirePlayers, 7)
        for i = 1, #attirePlayers do
            local data = attirePlayers[i]
            local pl = data.pl
            local attire = data.attire

            net.WritePlayer(pl)
            net.WriteUInt(#attire, 3)
            for i = 1, #attire do
                net.WriteUInt(attire[i], gRust.ItemIndexBits)
            end
        end
    net.Send(self)
end

function PLAYER:ClearAttire()
    if (!self.Attire) then return end

    for i = 1, self.Attire:GetSlots() do
        local item = self.Attire[i]
        if (!item) then continue end

        local register = item:GetRegister()
        if (!register || !register:GetAttire()) then continue end

        register:GetAttire():PlayerUnequip(self)
    end

    net.Start("gRust.Attire.Clear")
        net.WritePlayer(self)
    net.Broadcast()

    self.AttireTypes = nil

    self:RecalculateAttireProtection()
end

hook.Add("PlayerNetworkReady", "gRust.SyncAttire", function(pl)
    pl:SyncAttire()
end)

hook.Add("PlayerDeath", "gRust.ClearAttire", function(pl)
    pl:ClearAttire()
end)