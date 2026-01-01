gRust.QuickSwapQueue = {}

function gRust.AddToQuickSwapQueue(inventory, slot)
    local last = gRust.QuickSwapQueue[#gRust.QuickSwapQueue]
    local startTime = last and last.EndTime or CurTime()
    local endTime = startTime + gRust.GetConfigValue("farming/quickswap.time", 0.2)

    local quickSwapData = {
        Inventory = inventory,
        Slot = slot,
        StartTime = startTime,
        EndTime = endTime
    }

    table.insert(gRust.QuickSwapQueue, quickSwapData)

    return quickSwapData
end

function gRust.QuickSwap(inventory, slot)
    net.Start("gRust.QuickSwap")
        net.WriteUInt(inventory:GetIndex(), 24)
        net.WriteUInt(slot, 7)
    net.SendToServer()
end

hook.Add("Think", "gRust.QuickSwapQueue", function()
    local curTime = CurTime()
    local queue = gRust.QuickSwapQueue

    for i = #queue, 1, -1 do
        local item = queue[i]

        if item.EndTime < curTime then
            local inventory = item.Inventory
            local slot = item.Slot

            if (inventory and slot) then
                gRust.QuickSwap(inventory, slot)
            end

            table.remove(queue, i)
        end
    end
end)