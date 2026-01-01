function gRust.CreateItemBag(item, pos, ang)
    local ent = ents.Create("rust_itembag")
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetItem(item)
    ent:Activate()
    ent:Spawn()

    return ent
end

function gRust.SwapInventorySlots(pl, inventory1, index1, inventory2, index2, quantity)
    local canAccess, reason = inventory1:CanPlayerAccess(pl)
    if (!canAccess) then
        pl:ChatPrint(reason)
        return
    end

    local canAccess, reason = inventory2:CanPlayerAccess(pl)
    if (!canAccess) then
        pl:ChatPrint(reason)
        return
    end
    
    inventory1:SwapSlot(index1, inventory2, index2, quantity)
end

net.Receive("gRust.SwapInventorySlots", function(len, pl)
    local invIndex1 = net.ReadUInt(24)
    local invIndex2 = net.ReadUInt(24)
    
    -- TODO: Maybe use ceil(log2(inventory:GetSlots()))
    local index1 = net.ReadUInt(7)
    local index2 = net.ReadUInt(7)
    
    if (invIndex1 == invIndex2 && index1 == index2) then return end
    
    local inventory1 = gRust.Inventories[invIndex1]
    local inventory2 = gRust.Inventories[invIndex2]
    if (!inventory1 || !inventory2) then return end
    if (!inventory1[index1] && !inventory2[index2]) then return end

    local register = inventory1[index1]:GetRegister()
    
    local quantity = register.StackBits > 0 and net.ReadUInt(register.StackBits) or 1
    quantity = math.min(quantity, register:GetStack())
    
    if (quantity <= 0) then return end
    
    gRust.SwapInventorySlots(pl, inventory1, index1, inventory2, index2, quantity)
end)

net.Receive("gRust.DropItem", function(len, pl)
    local invIndex = net.ReadUInt(24)
    local index = net.ReadUInt(7)

    local inventory = gRust.Inventories[invIndex]
    if (!inventory || !inventory:CanPlayerAccess(pl)) then return end

    local register = inventory[index]:GetRegister()

    local quantity = register.StackBits > 0 and net.ReadUInt(register.StackBits) or 1
    if (quantity <= 0) then return end
    if (quantity > inventory[index]:GetQuantity()) then return end

    local pos = pl:EyePos() + pl:GetAimVector() * 32
    local ang = pl:EyeAngles()

    local item = quantity == inventory[index]:GetQuantity() and inventory[index] or inventory[index]:Split(quantity)
    
    if (item.AmmoType) then
        item.AmmoType = inventory[index].AmmoType
    end

    local ent = gRust.CreateItemBag(item, pos, ang)
    timer.Simple(0, function()
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
            phys:SetVelocity(pl:GetAimVector() * 200)
        end
    end)

    inventory:Remove(index, quantity)
end)
