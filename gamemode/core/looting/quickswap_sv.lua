gRust.CreateConfigValue("farming/quickswap.time", 0.2, true)

-- If we can stack or wear the item, force quick swap to use that inventory
local function ShouldForceInventory(inventory, pl, fromItem, toItem)
    if (fromItem and inventory == pl.Attire and fromItem:GetRegister():GetAttire()) then
        return true
    end

    if (toItem and toItem:GetRegister() == fromItem:GetRegister()) then
        return true
    end

    return false
end

util.AddNetworkString("gRust.QuickSwap")
net.Receive("gRust.QuickSwap", function(len, pl)
    local fromInventory = gRust.Inventories[net.ReadUInt(24)]
    if (!fromInventory) then return end

    local slot = net.ReadUInt(7)

    local newInventory
    local item = fromInventory[slot]
    if (!item) then return end
    
    if (IsValid(pl.LootingEntity)) then
        if (fromInventory:GetEntity() == pl) then -- Player -> Looting Entity
            for k, v in ipairs(pl.LootingEntity.Containers) do
                local viableSlot = v:GetViableSlot(item, fromInventory)
                if (viableSlot) then
                    newInventory = v
                    break
                end
            end
        else -- Looting Entity -> Player
            for _, inv in ipairs({pl.Attire, pl.Inventory, pl.Belt}) do
                local viableSlot = inv:GetViableSlot(item, fromInventory)
                if (viableSlot) then
                    newInventory = inv

                    if (ShouldForceInventory(inv, pl, item, inv[viableSlot])) then
                        break
                    end
                end
            end
        end
    else -- Player -> Player
        for _, inv in ipairs({pl.Attire, pl.Inventory, pl.Belt}) do
            if (inv == fromInventory) then continue end

            local viableSlot = inv:GetViableSlot(item, fromInventory)
            if (viableSlot) then
                newInventory = inv

                if (ShouldForceInventory(inv, pl, item, inv[viableSlot])) then
                    break
                end
            end
        end
    end

    if (!newInventory) then return end
    if (!newInventory:CanPlayerAccess(pl)) then return end
    
    local newSlot = newInventory:GetViableSlot(item, fromInventory)
    if (!newSlot) then return end

    local quantity = math.min(item:GetQuantity(), item:GetRegister():GetStack())
    gRust.SwapInventorySlots(pl, fromInventory, slot, newInventory, newSlot, quantity)
end)