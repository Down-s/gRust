AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_container")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self.MapCreated = self:CreatedByMap()

    if (self.MaxHP and !self.MapCreated) then
        self:SetMaxHealth(self.MaxHP)
        self:SetHealth(self.MaxHP)
    end

    self:SetBroadcasting(true)
    
    self.Containers = {}
    self:CreateContainers()
end

function ENT:KeyValue(key, value)
    if (string.IsNullOrEmpty(value)) then return end

    local t = string.sub(key, 1, 4) -- item1 -> item
    local index = tonumber(string.sub(key, 5)) -- item1 -> 1
    local values = string.Split(value, ";")
    local item = values[1]
    local amount = tonumber(values[2])

    local register = gRust.GetItemRegister(item)

    if (t == "item") then
        self.SellingItemKeys = self.SellingItemKeys or {}
        self.SellingItemKeys[index] = {
            Item = item,
            Amount = amount
        }
    elseif (t == "cost") then
        if (self.SellingItemKeys and self.SellingItemKeys[index]) then
            local sellingItem = self.SellingItemKeys[index]
            local sellRegister = gRust.GetItemRegister(sellingItem.Item)
            local buyRegister = gRust.GetItemRegister(item)

            if (!sellRegister) then
                gRust.LogError("Item register for '" .. sellingItem.Item .. "' not found.")
                return
            end

            if (!buyRegister) then
                gRust.LogError("Item register for '" .. item .. "' not found.")
                return
            end

            self:AddSellOrder(sellRegister:GetIndex(), sellingItem.Amount, buyRegister:GetIndex(), amount)
        end
    end
end

util.AddNetworkString("gRust.AddSellOrder")
function ENT:AddSellOrder(sellItem, sellAmount, buyItem, buyAmount)
    if (self.MapCreated) then return end

    self.SellOrders = self.SellOrders or {}
    if (#self.SellOrders >= 8) then return end

    sellAmount = math.Clamp(sellAmount, 1, 1000)
    buyAmount = math.Clamp(buyAmount, 1, 1000)

    self.SellOrders[#self.SellOrders + 1] = {
        SellItem = sellItem,
        SellAmount = sellAmount,
        BuyItem = buyItem,
        BuyAmount = buyAmount
    }

    net.Start("gRust.AddSellOrder")
        net.WriteEntity(self)
        net.WriteUInt(sellItem, gRust.ItemIndexBits)
        net.WriteUInt(sellAmount, 16)
        net.WriteUInt(buyItem, gRust.ItemIndexBits)
        net.WriteUInt(buyAmount, 16)
    net.Broadcast()
end

util.AddNetworkString("gRust.RemoveSellOrder")
function ENT:RemoveSellOrder(index)
    if (self.MapCreated) then return end

    table.remove(self.SellOrders, index)

    net.Start("gRust.RemoveSellOrder")
        net.WriteEntity(self)
        net.WriteUInt(index, 4)
    net.Broadcast()
end

util.AddNetworkString("gRust.VendingMachineBuy")
function ENT:BuyItem(pl, index, amount)
    local order = self.SellOrders[index]
    if (!order) then return end
    if (!self:CanBuyItem(pl, index, amount)) then return end
    if (self:GetVending()) then return end
    
    self:SetVending(true)
    self:EmitSound("vendingmachine.purchase")

    timer.Simple(2, function()
        self:SetVending(false)

        if (!IsValid(pl)) then return end
        if (!self:CanBuyItem(pl, index, amount)) then return end

        local sellRegister = gRust.GetItemRegisterFromIndex(order.SellItem)
        local buyRegister = gRust.GetItemRegisterFromIndex(order.BuyItem)

        local plBuyingRemaining = order.BuyAmount * amount
        local vmSellingRemaining = order.SellAmount * amount

        local iters = 0
        while (true) do
            local plBuying = math.min(plBuyingRemaining, buyRegister:GetStack())
            local vmSelling = math.min(vmSellingRemaining, sellRegister:GetStack())

            pl:RemoveItem(buyRegister:GetId(), plBuying)
            pl:AddItem(gRust.CreateItem(sellRegister:GetId(), vmSelling))

            if (!self:CreatedByMap()) then
                self.Containers[1]:RemoveItem(sellRegister:GetId(), vmSelling)
                self.Containers[1]:InsertItem(gRust.CreateItem(buyRegister:GetId(), plBuying))
            end

            plBuyingRemaining = plBuyingRemaining - plBuying
            vmSellingRemaining = vmSellingRemaining - vmSelling

            iters = iters + 1
            if (iters > 256) then
                gRust.LogError("Infinite loop detected in vending machine buy.")
                break
            end

            if (plBuyingRemaining <= 0 and vmSellingRemaining <= 0) then
                break
            end
        end
    end)
end

util.AddNetworkString("gRust.SyncVendingMachine")
net.Receive("gRust.SyncVendingMachine", function(len, pl)
    local ent = net.ReadEntity()

    if (!IsValid(ent) or ent:GetClass() ~= "rust_vendingmachine") then return end

    ent.SellOrders = ent.SellOrders or {}

    net.Start("gRust.SyncVendingMachine")
        net.WriteEntity(ent)
        net.WriteBool(ent:GetBroadcasting())
        net.WriteUInt(#ent.SellOrders, 4)
        for k, v in ipairs(ent.SellOrders) do
            net.WriteUInt(v.SellItem, gRust.ItemIndexBits)
            net.WriteUInt(v.SellAmount, 16)
            net.WriteUInt(v.BuyItem, gRust.ItemIndexBits)
            net.WriteUInt(v.BuyAmount, 16)
        end
    net.Send(pl)
end)

util.AddNetworkString("gRust.ToggleVendingMachineBroadcast")
net.Receive("gRust.ToggleVendingMachineBroadcast", function(len, pl)
    local ent = net.ReadEntity()

    if (!IsValid(ent) or ent:GetClass() ~= "rust_vendingmachine") then return end
    if (!ent:CanPlayerAccess(pl)) then return end
    if (!ent:IsPlayerInFront(pl)) then return end

    ent:SetBroadcasting(!ent:GetBroadcasting())
end)

net.Receive("gRust.AddSellOrder", function(len, pl)
    local ent = net.ReadEntity()
    local sellId = net.ReadUInt(gRust.ItemIndexBits)
    local sellAmount = net.ReadUInt(16)
    local buyId = net.ReadUInt(gRust.ItemIndexBits)
    local buyAmount = net.ReadUInt(16)

    if (!IsValid(ent) or ent:GetClass() ~= "rust_vendingmachine") then return end
    if (!ent:CanPlayerAccess(pl)) then return end
    if (!ent:IsPlayerInFront(pl)) then return end

    ent:AddSellOrder(sellId, sellAmount, buyId, buyAmount)
end)

net.Receive("gRust.RemoveSellOrder", function(len, pl)
    local ent = net.ReadEntity()
    local index = net.ReadUInt(4)

    if (!IsValid(ent) or ent:GetClass() ~= "rust_vendingmachine") then return end
    if (!ent:CanPlayerAccess(pl)) then return end
    if (!ent:IsPlayerInFront(pl)) then return end

    ent:RemoveSellOrder(index)
end)

net.Receive("gRust.VendingMachineBuy", function(len, pl)
    local ent = net.ReadEntity()
    local index = net.ReadUInt(4)
    local amount = net.ReadUInt(10)
    amount = math.Clamp(amount, 1, 1000)

    if (!IsValid(ent) or ent:GetClass() ~= "rust_vendingmachine") then return end
    if (!ent:CanPlayerAccess(pl)) then return end

    ent:BuyItem(pl, index, amount)
end)