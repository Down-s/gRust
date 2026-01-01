function gRust.StartLooting(ent)
    if (IsValid(gRust.LootingEntity)) then
        return
    end
    
    net.Start("gRust.StartLooting")
    net.WriteEntity(ent)
    net.SendToServer()
end

function gRust.StopLooting()
    if (IsValid(gRust.LootingEntity)) then
        net.Start("gRust.StopLooting")
        net.SendToServer()

        gRust.LootingEntity:OnStopLooting(LocalPlayer())
    end

    gRust.LootingEntity = nil
end

net.Receive("gRust.StartedLooting", function(len)
    local ent = net.ReadEntity()

    gRust.LootingEntity = ent
    ent:OnStartLooting(LocalPlayer())

    gRust.OpenInventory(ent:GetInventoryName(), function(...)
        if (ent.CreateLootingPanel) then
            ent:CreateLootingPanel(...)
        end
    end)
end)

net.Receive("gRust.StoppedLooting", function(len)
    gRust.CloseInventory()
end)

hook.Add("OnInventoryClosed", "gRust.InventoryStopLooting", function()
    gRust.StopLooting()
end)