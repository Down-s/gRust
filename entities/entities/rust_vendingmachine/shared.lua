DEFINE_BASECLASS("rust_container")

ENT.Base = "rust_container"
ENT.Model = "models/deployable/vending_machine.mdl"
ENT.Slots = 30

ENT.ShouldSave = true

ENT.MaxHP = 1250

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetSound("farming/repair_bench_deploy.wav")
    :SetRotate(90)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, -25, -42)
            :SetAngle(0, 0, 0)
            :AddMaleTag("vending_machine")
    )
    
ENT.Decay = 4 * 60*60 -- 2 hours
ENT.Upkeep = {
    {
        Item = "hq_metal",
        Amount = 5
    }
}

function ENT:IsPlayerInFront(pl)
    local relPos = self:GetPos() - pl:GetPos()
    local dot = relPos:Dot(self:GetForward())
    if (dot > 0) then
        return true
    end

    return false
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "HP")
    self:NetworkVar("Bool", 0, "Broadcasting")
    self:NetworkVar("Bool", 1, "Vending")
end

function ENT:GetInventoryName()
    return "VENDING MACHINE STORAGE"
end

function ENT:CanBuyItem(pl, index, amount)
    local order = self.SellOrders[index]
    if (!order) then return false end

    local sellRegister = gRust.GetItemRegisterFromIndex(order.SellItem)
    if (!sellRegister) then return false end

    local buyRegister = gRust.GetItemRegisterFromIndex(order.BuyItem)
    if (!buyRegister) then return false end

    if (!pl:HasItem(buyRegister:GetId(), order.BuyAmount * amount)) then return false end
    if (!self:CreatedByMap() and !self:HasItem(sellRegister:GetId(), order.SellAmount * amount)) then return false end

    return true
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    self.Containers[1] = inv

    inv:SetName("CONTENTS")
    inv.OnUpdated = function(me)
        self:OnInventoryUpdated(me)
    end
    inv.CustomCheck = function(me, pl)
        return self:CanPlayerAccess(pl) and self:IsPlayerInFront(pl)
    end
end

function ENT:GetInteractable()
    return true
end

function ENT:GetInteractText()
	local relPos = self:GetPos() - LocalPlayer():GetPos()
    local dot = relPos:Dot(self:GetForward())
	if (dot > 0) then
		return "OPEN"
	end

	return "SHOP"
end

function ENT:GetInteractIcon()
	local relPos = self:GetPos() - LocalPlayer():GetPos()
    local dot = relPos:Dot(self:GetForward())
	if (dot > 0) then
		return "open"
	end

	return "store"
end

function ENT:Save(buffer)
    BaseClass.Save(self, buffer)

    local sellOrders = self.SellOrders or {}

    buffer:WriteUShort(#sellOrders)
    for k, v in pairs(sellOrders) do
        buffer:WriteUShort(v.SellItem)
        buffer:WriteUShort(v.SellAmount)
        buffer:WriteUShort(v.BuyItem)
        buffer:WriteUShort(v.BuyAmount)
    end

    buffer:WriteBool(self:GetBroadcasting())
end

function ENT:Load(buffer)
    BaseClass.Load(self, buffer)

    local sellOrders = {}
    local sellOrderCount = buffer:ReadUShort()
    for i = 1, sellOrderCount do
        local sellItem = buffer:ReadUShort()
        local sellAmount = buffer:ReadUShort()
        local buyItem = buffer:ReadUShort()
        local buyAmount = buffer:ReadUShort()

        table.insert(sellOrders, {
            SellItem = sellItem,
            SellAmount = sellAmount,
            BuyItem = buyItem,
            BuyAmount = buyAmount
        })
    end

    self.SellOrders = sellOrders
    self:SetBroadcasting(buffer:ReadBool())
end