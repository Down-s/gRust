local ENTITY = FindMetaTable("Entity")

if (SERVER) then
    util.AddNetworkString("gRust.CreateInventory")
    util.AddNetworkString("gRust.DestroyInventory")
    util.AddNetworkString("gRust.SyncInventory")
    util.AddNetworkString("gRust.SyncInventorySlot")
    util.AddNetworkString("gRust.SyncInventorySlots")
    util.AddNetworkString("gRust.SyncInventoryEntity")
    util.AddNetworkString("gRust.SwapInventorySlots")
    util.AddNetworkString("gRust.DropItem")
end

-- Setup

function ENTITY:HasInventory()
    return self.Inventory != nil
end

function ENTITY:GetInventory()
    return self.Inventory
end

function ENTITY:GetInventorySlots()
    return self.Inventory.Slots
end

-- Functions

local INVENTORY = {}
INVENTORY.__index = INVENTORY
INVENTORY.__tostring = function(self)
    if (IsValid(self.Entity)) then
        return "Inventory[" .. self:GetIndex() .. "](" .. self.Entity:GetClass() .. ")"
    else
        return "Inventory[" .. self:GetIndex() .. "]"
    end
end

-- Overridable

function INVENTORY:OnUpdated()
end

function INVENTORY:CanAcceptItem(item, inventory)
    return true
end

function INVENTORY:CanRemoveItem(item, inventory)
    return true
end

-- Methods

function INVENTORY:Destroy()
    gRust.DestroyInventory(self.Index)
end

function INVENTORY:Copy()
    local inventory = gRust.CreateInventory(self.Slots)
    for i = 1, self.Slots do
        if (!IsValid(self[i])) then continue end
        inventory[i] = self[i]:Copy()
    end

    return inventory
end

function INVENTORY:GetIndex()
    return self.Index
end

function INVENTORY:GetSize()
    return self.Slots
end

function INVENTORY:GetSlots()
    return self.Slots
end

function INVENTORY:SetSlots(slots)
    self.Slots = slots
end

function INVENTORY:CustomCheck(pl)
    return true
end

function INVENTORY:CanPlayerAccess(pl)
    if (!self:CustomCheck(pl)) then return false, "You are not authorized to access this container" end
    if (!pl:Alive()) then return false, "You are not authorized to access this container" end
    
    -- TODO: Consider storing in an index table for faster lookup
    local ent = self:GetEntity()
    local players = self.RF:GetPlayers()
    for i = 1, #players do
        if (players[i] == pl) then
            if (IsValid(ent) and ent ~= pl) then
                if (ent:GetPos():DistToSqr(pl:GetPos()) > 20000) then
                    return false, "Too far away"
                end

                local tr = util.TraceLine({
                    start = pl:EyePos(),
                    endpos = ent:LocalToWorld(ent:OBBCenter()),
                    filter = pl
                })
                
                if (IsValid(tr.Entity) and tr.Entity != ent) then
                    return false, "Line of sight blocked"
                end
            end

            return true
        end
    end

    return false, "You are not authorized to access this container"
end

function INVENTORY:HasItem(item, quantity)
    quantity = quantity or 1
    
    for i = 1, self.Slots do
        if (self[i]:GetId() == item:GetId()) then
            return true
        end
    end

    return false
end

function INVENTORY:Get(i)
    return self[i]
end

function INVENTORY:Set(i, item)
    self[i] = item

    self:OnUpdated()

    if (SERVER) then
        self:SyncSlot(i)
    end
end

function INVENTORY:Remove(i, quantity)
    if (i < 1 or i > self.Slots) then return end
    
    local item = self[i]
    if (!quantity or (quantity >= item:GetQuantity())) then
        self[i] = nil
    else
        item:SetQuantity(item:GetQuantity() - quantity)
    end

    self:OnUpdated()

    if (SERVER) then
        self:SyncSlot(i)
    end
end

function INVENTORY:RemoveItem(id, quantity)
    quantity = quantity or 1

    for i = 1, self.Slots do
        local item = self[i]
        if (item and item:GetId() == id) then
            if (quantity >= item:GetQuantity()) then
                quantity = quantity - item:GetQuantity()
                self[i] = nil
            else
                item:SetQuantity(item:GetQuantity() - quantity)
                quantity = 0
            end

            self:OnUpdated()

            if (SERVER) then
                self:SyncSlot(i)
            end
        end

        if (quantity <= 0) then
            break
        end
    end
    
    return quantity <= 0
end

function INVENTORY:RemoveItemLast(id, quantity)
    quantity = quantity or 1

    for i = self.Slots, 1, -1 do
        local item = self[i]
        if (item and item:GetId() == id) then
            if (quantity >= item:GetQuantity()) then
                self[i] = nil
            else
                item:SetQuantity(item:GetQuantity() - quantity)
            end

            self:OnUpdated()

            if (SERVER) then
                self:SyncSlot(i)
            end

            return true
        end
    end

    return false
end

function INVENTORY:Clear()
    for i = 1, self.Slots do
        self[i] = nil
    end

    self:OnUpdated()

    -- TODO: Make this a separate net message
    if (SERVER) then
        self:SyncAll()
    end
end

function INVENTORY:SwapSlot(index, other, otherIndex, quantity)
    if (!other) then return end
    if (index < 1 or index > self.Slots) then return end
    if (otherIndex < 1 or otherIndex > other:GetSize()) then return end

    local item = self[index]
    local otherItem = other[otherIndex]

    local itemRegister = item and item:GetRegister()
    local otherItemRegister = otherItem and otherItem:GetRegister()

    if (!IsValid(item) and !IsValid(otherItem)) then return end
    if ((index == otherIndex and self == other) and self:GetIndex() == other:GetIndex()) then return end
    if (IsValid(otherItem) and item:GetId() ~= otherItem:GetId() and quantity ~= item:GetQuantity()) then return end
    if (quantity == 0 || quantity > item:GetQuantity()) then return end
    local combineable = !otherItem or (item:GetId() == otherItem:GetId() and (item:GetQuantity() + otherItem:GetQuantity()) <= itemRegister:GetStack())
    if (IsValid(otherItem) and !combineable and !self:CanAcceptItem(otherItem, other)) then return end
    if (!other:CanAcceptItem(item, self)) then return end
    if (!self:CanRemoveItem(item, other)) then return end

    if (IsValid(otherItem)) then
        if (otherItemRegister:IsWeapon()) then
            local wep = otherItemRegister:GetWeapon()
            local data = weapons.Get(wep)
            if (data and data.Attachments and data.Attachments[item:GetId()]) then
                for i = 1, (otherItemRegister:GetSlots() or 0) do
                    local slot = otherItem.Inventory[i]
                    if (!IsValid(slot)) then continue end
                    if (!data.Attachments[slot:GetId()]) then continue end

                    if (data.Attachments[item:GetId()].Type == data.Attachments[slot:GetId()].Type) then
                        return
                    end
                end

                for i = 1, (otherItemRegister:GetSlots() or 0) do
                    local slot = otherItem.Inventory[i]
                    if (!IsValid(slot)) then
                        otherItem.Inventory[i] = item
                        self[index] = nil
                        
                        self:OnUpdated()
                        otherItem.Inventory:OnUpdated()

                        self:SyncSlot(index)
                        otherItem.Inventory:SyncSlot(i)
                        other:SyncSlot(otherIndex)

                        return
                    end
                end

                return
            end
        end
            
        if (item:GetId() == otherItem:GetId()) then
            local givenQuantity = math.min(quantity, item:GetRegister():GetStack() - otherItem:GetQuantity())
            otherItem:SetQuantity(otherItem:GetQuantity() + givenQuantity)
            item:SetQuantity(item:GetQuantity() - givenQuantity)

            if (item:GetQuantity() <= 0) then
                self[index] = nil
            end

            self:OnUpdated()
            other:OnUpdated()

            self:SyncSlot(index)
            other:SyncSlot(otherIndex)
        else
            self[index] = otherItem
            other[otherIndex] = item

            self:OnUpdated()
            other:OnUpdated()

            self:SyncSlot(index)
            other:SyncSlot(otherIndex)
        end
    else
        if (quantity == item:GetQuantity()) then
            self[index] = nil
            other[otherIndex] = item

            self:OnUpdated()
            other:OnUpdated()

            self:SyncSlot(index)
            other:SyncSlot(otherIndex)
        else
            local newQuantity = item:GetQuantity() - quantity
            local newItem = item:Copy()
            newItem:SetQuantity(quantity)

            item:SetQuantity(newQuantity)

            other[otherIndex] = newItem

            self:OnUpdated()
            other:OnUpdated()

            self:SyncSlot(index)
            other:SyncSlot(otherIndex)
        end
    end
end

function INVENTORY:ItemCount(item)
    local count = 0

    for i = 1, self.Slots do
        if (!IsValid(self[i])) then continue end
        local slot = self[i]
        if (!item or (slot:GetId() == item)) then
            count = count + slot:GetQuantity()
        end
    end

    return count
end

function INVENTORY:FirstEmpty()
    for i = 1, self.Slots do
        if (self[i] == nil) then
            return i
        end
    end

    return nil
end

function INVENTORY:IsEmpty()
    for i = 1, self.Slots do
        if (self[i]) then
            return false
        end
    end

    return true
end

function INVENTORY:GetViableSlot(item, container)
    if (!item) then return end
    
    local viableSlots = {}
    for i = 1, self:GetSize() do
        local slot = self[i]
        if (!self:CanAcceptItem(item, container)) then continue end
        
        if (!IsValid(slot)) then
            table.insert(viableSlots, i)
        elseif (IsValid(slot) and slot:GetId() == item:GetId()) then
            if (slot:GetQuantity() < slot:GetRegister():GetStack()) then
                table.insert(viableSlots, i)
            end
        end
    end

    if (#viableSlots == 0) then return end

    table.sort(viableSlots, function(a, b)
        local aSlot = self[a]
        local bSlot = self[b]

        if (aSlot == nil and bSlot == nil) then
            return a > b
        elseif (aSlot == nil) then
            return true
        elseif (bSlot == nil) then
            return false
        end

        return aSlot:GetQuantity() < bSlot:GetQuantity()
    end)

    return viableSlots[#viableSlots]
end

function INVENTORY:CanStackItem(item, container)
    if (!item) then return false end

    for i = 1, self:GetSize() do
        local slot = self[i]
        if (IsValid(slot) and slot:GetId() == item:GetId()) then
            if ((slot:GetQuantity() + item:GetQuantity()) <= slot:GetRegister():GetStack()) then
                return true
            end
        end
    end

    return false
end

-- Whether we can insert at least one quantity of the item into the inventory
function INVENTORY:CanInsertItem(item, container)
    if (!item) then return false end
    if (!self:CanAcceptItem(item, container)) then return false end

    local quantity = item:GetQuantity()
    local remaining = quantity

    for i = 1, self:GetSize() do
        local slot = self[i]
        if (slot == nil) then
            return true
        elseif (IsValid(slot) and slot:GetId() == item:GetId()) then
            if (slot:GetQuantity() < slot:GetRegister():GetStack()) then
                remaining = remaining - (slot:GetRegister():GetStack() - slot:GetQuantity())
            end
        end
    end

    return remaining < quantity
end

-- Looks through the inventory for a suitable slot to insert the item into
-- If there is still remaining quantity after inserting, it will return the new item
function INVENTORY:InsertItem(item, noempty)
    local quantity = item:GetQuantity()
    local remaining = quantity

    local useSlots = {}
    for i = 1, self:GetSize() do
        local slot = self[i]
        if (slot == nil and !noempty) then
            table.insert(useSlots, i)
        elseif (IsValid(slot) and slot:GetId() == item:GetId()) then
            if (slot:GetQuantity() < slot:GetRegister():GetStack()) then
                table.insert(useSlots, i)
            end
        end
    end

    -- Sort by non-empty slots first
    table.sort(useSlots, function(a, b)
        local aSlot = self[a]
        local bSlot = self[b]

        if (aSlot == nil && bSlot == nil) then
            return false
        elseif (aSlot == nil) then
            return false
        elseif (bSlot == nil) then
            return true
        end

        return false
    end)

    for i = 1, #useSlots do
        local slot = self[useSlots[i]]
        if (slot == nil) then
            item:SetQuantity(remaining)
            self[useSlots[i]] = item
            remaining = 0

            self:OnUpdated()
            self:SyncSlot(useSlots[i])

            break
        elseif (slot:GetId() == item:GetId()) then
            local stack = slot:GetRegister():GetStack()
            local quantity = slot:GetQuantity()
            local space = stack - quantity

            if (remaining <= space) then
                slot:SetQuantity(quantity + remaining)
                remaining = 0

                self:OnUpdated()
                self:SyncSlot(useSlots[i])
            else
                slot:SetQuantity(stack)
                remaining = remaining - space

                self:OnUpdated()
                self:SyncSlot(useSlots[i])
            end
        end

        if (remaining == 0) then
            break
        end
    end

    if (remaining > 0) then
        local newItem = item:Copy()
        newItem:SetQuantity(remaining)
        return newItem
    end
end

-- Replication

function INVENTORY:AddReplicatedPlayer(pl, sync)
    if (!self.ReplicatedPlayers[pl]) then
        self.RF:AddPlayer(pl)
        self.ReplicatedPlayers[pl] = true
    end

    if (SERVER) then
        if (sync) then
            net.Start("gRust.SyncInventory")
            net.WriteUInt(self.Index, 24)
            net.WriteUInt(self.Slots, 7)
            
            for i = 1, self.Slots do
                net.WriteItem(self[i])
            end
            
            if (IsValid(self.Entity)) then
                net.WriteEntity(self.Entity)
            end
            net.Send(pl)
        else
            net.Start("gRust.CreateInventory")
                net.WriteUInt(self:GetIndex(), 24)
                net.WriteUInt(self:GetSize(), 7)
                if (IsValid(self.Entity)) then
                    net.WriteEntity(self.Entity)
                end
            net.Send(pl)
        end
    end
end

function INVENTORY:RemoveReplicatedPlayer(pl)
    self.RF:RemovePlayer(pl)
    self.ReplicatedPlayers[pl] = nil
end

function INVENTORY:ClearReplicatedPlayers()
    self.RF:RemoveAllPlayers()
    self.ReplicatedPlayers = {}
end

function INVENTORY:SyncImmediate(pl)
    if (SERVER) then
        net.Start("gRust.SyncInventory")
            net.WriteUInt(self.Index, 24)
            net.WriteUInt(self.Slots, 7)
    
            for i = 1, self.Slots do
                net.WriteItem(self[i])
            end

            if (IsValid(self.Entity)) then
                net.WriteEntity(self.Entity)
            end
        net.Send(pl)
    end
end

function INVENTORY:SetEntity(ent)
    self.Entity = ent

    if (ent != nil) then
        if (ent.OnInventoryAttached) then
            ent:OnInventoryAttached(self)
        end
        
        if (SERVER) then
            net.Start("gRust.SyncInventoryEntity")
                net.WriteUInt(self.Index, 24)
                net.WriteEntity(ent)
            net.Send(self.RF)
        end
    end
end

function INVENTORY:GetEntity()
    return self.Entity
end

function INVENTORY:SetName(name)
    self.Name = name
end

function INVENTORY:GetName()
    return self.Name or "Loot"
end

function INVENTORY:SyncSlot(i)
    if (IsValid(self[i])) then
        self[i]:SetParentInventory(self)
        self[i]:SetParentSlot(i)
    end

    net.Start("gRust.SyncInventorySlot")
        net.WriteUInt(self.Index, 24)
        net.WriteUInt(i, 7)
        net.WriteItem(self[i])
    net.Send(self.RF)
end

function INVENTORY:SyncSlots(...)
    net.Start("gRust.SyncInventorySlots")
        net.WriteUInt(self.Index, 24)

        for i = 1, select("#", ...) do
            local i = select(i, ...)
            net.WriteUInt(i, 7)
            net.WriteItem(self[i])

            if (IsValid(self[i])) then
                self[i]:SetParentInventory(self)
                self[i]:SetParentSlot(i)
            end
        end
    net.Send(self.RF)
end

function INVENTORY:SyncAll(pl)
    net.Start("gRust.SyncInventory")
        net.WriteUInt(self.Index, 24)
        net.WriteUInt(self.Slots, 7)

        for i = 1, self.Slots do
            net.WriteItem(self[i])
        end

        if (self.Entity) then
            net.WriteEntity(self.Entity)
        end
    net.Send(pl or self.RF)
end

gRust.Inventories = gRust.Inventories or {}

function gRust.CreateInventory(slots, index, ent)
    index = index or #gRust.Inventories + 1

    local inventory = setmetatable({}, INVENTORY)
    inventory.Slots = slots
    inventory.Index = index
    if (IsValid(ent)) then
        inventory:SetEntity(ent)
    end

    gRust.Inventories[index] = inventory

    if (SERVER) then
        inventory.RF = RecipientFilter()
        inventory.ReplicatedPlayers = {}
    end

    return inventory
end

function gRust.DestroyInventory(i)
    -- TODO: Store removed inventory indices in a table and reuse them
    gRust.Inventories[i] = nil

    if (SERVER) then
        net.Start("gRust.DestroyInventory")
            net.WriteUInt(i, 24)
        net.Broadcast()
    end
end