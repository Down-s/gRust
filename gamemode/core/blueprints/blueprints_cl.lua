local PLAYER = FindMetaTable("Player")

net.Receive("gRust.BlueprintLearned", function(len)
    local item = net.ReadUInt(gRust.ItemIndexBits)
    local register = gRust.GetItemRegisterFromIndex(item)
    local pl = LocalPlayer()

    pl.Blueprints = pl.Blueprints or {}
    pl.Blueprints[register:GetId()] = true

    hook.Run("gRust.BlueprintLearned", pl, register:GetId())
end)

net.Receive("gRust.UnlearnBlueprint", function(len)
    local item = net.ReadUInt(gRust.ItemIndexBits)
    local register = gRust.GetItemRegisterFromIndex(item)
    local pl = LocalPlayer()

    pl.Blueprints = pl.Blueprints or {}
    pl.Blueprints[register:GetId()] = nil

    hook.Run("gRust.UnlearnBlueprint", pl, register:GetId())
end)

net.Receive("gRust.SyncBlueprints", function(len)
    local pl = LocalPlayer()
    pl.Blueprints = {}

    local bits = gRust.ItemIndexBits
    for i = 1, net.ReadUInt(bits) do
        local itemIndex = net.ReadUInt(bits)
        local register = gRust.GetItemRegisterFromIndex(itemIndex)
        if (register) then
            pl.Blueprints[register:GetId()] = true
        else
            ErrorNoHalt("gRust.SyncBlueprints: Invalid item index " .. itemIndex .. "\n")
        end
    end
end)