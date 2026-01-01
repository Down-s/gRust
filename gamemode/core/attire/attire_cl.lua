net.Receive("gRust.Attire.Sync", function(len)
    local count = net.ReadUInt(7)
    for i = 1, count do
        local pl = net.ReadPlayer()
        local attireCount = net.ReadUInt(3)
        for i = 1, attireCount do
            local attireItem = net.ReadUInt(gRust.ItemIndexBits)
            local register = gRust.GetItemRegisterFromIndex(attireItem)
            if (!register) then continue end
            
            local attire = register:GetAttire()
            if (!attire) then continue end
            if (attire:GetType() == AttireType.Full) then continue end

            attire:AddToPlayer(pl)
        end
    end
end)

net.Receive("gRust.Attire.Add", function(len)
    local pl = net.ReadPlayer()
    if (!IsValid(pl)) then return end
    
    local attireItem = net.ReadUInt(gRust.ItemIndexBits)
    local register = gRust.GetItemRegisterFromIndex(attireItem)
    if (!register) then return end
    
    local attire = register:GetAttire()
    if (!attire) then return end

    attire:AddToPlayer(pl)

    hook.Run("PlayerAttireAdded", pl, attire)
end)

net.Receive("gRust.Attire.Remove", function(len)
    local pl = net.ReadPlayer()
    local attireType = net.ReadUInt(4)
    
    if (!pl.AttireEntities) then return end
    if (!pl.AttireEntities[attireType]) then return end

    pl.AttireEntities[attireType]:Remove()
    pl.AttireEntities[attireType] = nil

    hook.Run("PlayerAttireRemoved", pl, attireType)
end)

net.Receive("gRust.Attire.Clear", function(len)
    local pl = net.ReadPlayer()
    if (!pl.AttireEntities) then return end

    local entities = table.Copy(pl.AttireEntities)
    for k, v in pairs(entities) do
        v:Remove()
        pl.AttireEntities[k] = nil
    end
end)