function gRust.SwapInventorySlots(inventory1, inventory2, index1, index2, quantity)
    local register = inventory1[index1]:GetRegister()
    net.Start("gRust.SwapInventorySlots")
        net.WriteUInt(inventory1:GetIndex(), 24)
        net.WriteUInt(inventory2:GetIndex(), 24)
        net.WriteUInt(index1, 7)
        net.WriteUInt(index2, 7)
        if (register.StackBits > 0) then
            net.WriteUInt(quantity, register.StackBits)
        end
    net.SendToServer()
end

function gRust.DropItem(inventory, index, quantity)
    local register = inventory[index]:GetRegister()
    quantity = quantity or inventory[index]:GetQuantity()
    net.Start("gRust.DropItem")
        net.WriteUInt(inventory:GetIndex(), 24)
        net.WriteUInt(index, 7)
        if (register.StackBits > 0) then
            net.WriteUInt(quantity, register.StackBits)
        end
    net.SendToServer()
end

net.Receive("gRust.SyncInventorySlot", function(len)
    local inventory = net.ReadUInt(24)
    local index = net.ReadUInt(7)
    local item = net.ReadItem()

    gRust.Inventories[inventory][index] = item
    gRust.Inventories[inventory]:OnUpdated()
end)

net.Receive("gRust.SyncInventorySlots", function(len)
    local inventory = net.ReadUInt(24)

    while (net.BytesLeft() > 0) do
        local index = net.ReadUInt(7)
        local item = net.ReadItem()

        gRust.Inventories[inventory][index] = item
        gRust.Inventories[inventory]:OnUpdated()
    end
end)

net.Receive("gRust.SyncInventory", function(len)
    local pl = LocalPlayer()
    local index = net.ReadUInt(24)
    local slots = net.ReadUInt(7)
    if (!gRust.Inventories[index]) then
        gRust.CreateInventory(slots, index)
    end

    if (gRust.Inventories[index]) then
        gRust.Inventories[index]:SetSlots(slots)
    end

    for i = 1, slots do
        local item = net.ReadItem()
        gRust.Inventories[index][i] = item
    end

    if (net.BytesLeft() > 0) then
        local entity = net.ReadEntity()

        gRust.Inventories[index]:SetEntity(entity)
    end

    gRust.Inventories[index]:OnUpdated()
end)

net.Receive("gRust.CreateInventory", function(len)
    local pl = LocalPlayer()
    local index = net.ReadUInt(24)
    local slots = net.ReadUInt(7)
    
    local ent
    if (net.BytesLeft() > 0) then
        ent = net.ReadEntity()
    end

    gRust.CreateInventory(slots, index, ent)
end)

net.Receive("gRust.DestroyInventory", function(len)
    local pl = LocalPlayer()
    local index = net.ReadUInt(24)

    gRust.DestroyInventory(index)
end)

net.Receive("gRust.SyncInventoryEntity", function(len)
    local pl = LocalPlayer()
    local index = net.ReadUInt(24)
    local entity = net.ReadEntity()

    gRust.Inventories[index]:SetEntity(entity)
end)