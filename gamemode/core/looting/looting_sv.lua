util.AddNetworkString("gRust.StartLooting")
util.AddNetworkString("gRust.StopLooting")
util.AddNetworkString("gRust.StartedLooting")
util.AddNetworkString("gRust.StoppedLooting")

function gRust.StartLooting(pl, ent)
    if (!IsValid(ent)) then return end
    if (ent:IsPlayer()) then return end
    if (!ent:IsLootable()) then return end
    if (!ent:CanPlayerAccess(pl)) then return end
    if (!ent.Containers) then return end
    if (IsValid(pl.LootingEntity)) then return end

    if (pl.LootingInventories) then
        gRust.StopLooting(pl)
    end

    pl.LootingInventories = {}
    for k, v in ipairs(ent.Containers) do
        v:AddReplicatedPlayer(pl, true)
        pl.LootingInventories[k] = v
    end

    ent:OnStartLooting(pl)
    pl.LootingEntity = ent

    ent.Looters = ent.Looters or {}
    ent.Looters[pl] = true

    local timerName = string.format("gRust.LootingCheck.%s.%s", pl:EntIndex(), ent:EntIndex())
    timer.Create(timerName, 1, 0, function()
        if (!IsValid(pl)) then
            ent:OnStopLooting()
            timer.Remove(timerName)

            return
        end

        if (!IsValid(ent)) then
            gRust.StopLooting(pl)
            timer.Remove(timerName)

            return
        end
        
        if (!ent:CanPlayerAccess(pl)) then
            gRust.StopLooting(pl)
            timer.Remove(timerName)

            return
        end
    end)

    net.Start("gRust.StartedLooting")
        net.WriteEntity(ent)
    net.Send(pl)
end

function gRust.StopLooting(pl)
    if (!pl.LootingInventories) then return end

    for k, v in ipairs(pl.LootingInventories) do
        v:RemoveReplicatedPlayer(pl)
    end

    pl.LootingInventories = nil
    
    if (IsValid(pl.LootingEntity)) then
        if (pl.LootingEntity.Looters) then
            pl.LootingEntity.Looters[pl] = nil
        end

        pl.LootingEntity:OnStopLooting(pl)
        pl.LootingEntity = nil
    end
    
    net.Start("gRust.StoppedLooting")
    net.Send(pl)
end

net.Receive("gRust.StartLooting", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent)) then return end

    gRust.StartLooting(pl, ent)
end)

net.Receive("gRust.StopLooting", function(len, pl)
    gRust.StopLooting(pl)
end)

hook.Add("PlayerDisconnected", "gRust.StopLooting", function(pl)
    gRust.StopLooting(pl)
end)

hook.Add("PlayerDeath", "gRust.StopLooting", function(pl)
    gRust.StopLooting(pl)
end)

--
-- Looting functions
--

function gRust.SelectLootFromTable(lootTable, amount)
    local selectedLoot = {}
    local selectedLootIndex = {}
    
    local i = 0
    while (#selectedLoot < amount) do
        i = i + 1
        if (i > 9999) then break end
    
        for _, v in ipairs(lootTable) do
            local randomChance = math.random()

            if (selectedLootIndex[v.itemid]) then continue end
            if (!gRust.GetItemRegister(v.itemid)) then continue end
            if (randomChance <= v.chance) then
                local quantity = v.amount
                if (istable(quantity)) then
                    quantity = math.random(quantity[1], quantity[2])
                end
    
                table.insert(selectedLoot, gRust.CreateItem(v.itemid, quantity))
                selectedLootIndex[v.itemid] = true
            end
    
            if (#selectedLoot == #lootTable) then
                break
            end
        end
    end

    return selectedLoot
end