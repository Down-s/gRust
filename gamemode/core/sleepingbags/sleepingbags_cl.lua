net.Receive("gRust.AddSleepingBag", function(len)
    local pl = LocalPlayer()
    local ent = net.ReadUInt(16)

    pl.SleepingBags = pl.SleepingBags or {}
    pl.SleepingBags[#pl.SleepingBags + 1] = ent
end)

net.Receive("gRust.RemoveSleepingBag", function(len)
    local pl = LocalPlayer()
    local ent = net.ReadUInt(16)

    pl.SleepingBags = pl.SleepingBags or {}
    for k, v in ipairs(pl.SleepingBags) do
        if (v == ent) then
            table.remove(pl.SleepingBags, k)
            break
        end
    end
end)

net.Receive("gRust.SyncSleepingBags", function(len)
    local pl = LocalPlayer()
    pl.SleepingBags = {}

    for i = 1, net.ReadUInt(8) do
        local ent = net.ReadUInt(16)
        pl.SleepingBags[#pl.SleepingBags + 1] = ent
    end
end)