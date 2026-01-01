AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("gRust.RepairItem")
net.Receive("gRust.RepairItem", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) or ent:GetClass() != "rust_repairbench") then return end

    local container = ent.Containers[1]
    if (!container) then return end

    local item = container[1]
    if (!item) then return end

    local register = item:GetRegister()
    if (!register:GetCondition()) then return end
    if ((item:GetDamage() or 0) >= 0.8) then return end
    local cost = ent:GetRepairCost(item)
    if (!cost) then return end
    if (!pl:HasBlueprint(item:GetId())) then return end

    for k, v in ipairs(cost) do
        if (!pl:HasItem(v.Item, v.Quantity)) then return end
    end

    for k, v in ipairs(cost) do
        pl:RemoveItem(v.Item, v.Quantity, ITEM_GENERIC)
    end

    item:AddDamage(0.2)
    item:SetCondition(item:GetMaxCondition())

    container:SyncSlot(1)
end)