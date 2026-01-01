AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_container")

gRust.CreateConfigValue("farming/research.time", 10)

function ENT:FinishResearch()
    local item = self.Containers[1][1]
    if (!item) then return end
    
    local scrap = self.Containers[2][1]
    if (!scrap) then return end
    
    local register = item:GetRegister()
    if (!register) then return end
    local cost = register:GetResearchCost()
    if (!cost) then return end

    local id = item:GetId()
    self.Containers[2]:Remove(1, cost)

    local newItem = gRust.CreateItem(id .. "_blueprint")
    self.Containers[1]:Set(1, newItem)

    self:EmitSound("research.success")
    self:SetResearchFinish(0)
end

function ENT:Think()
    BaseClass.Think(self)
    if (self:GetResearchFinish() > 0 and self:GetResearchFinish() <= CurTime()) then
        self:FinishResearch()
    end
end

util.AddNetworkString("gRust.ResearchItem")
net.Receive("gRust.ResearchItem", function(len, pl)
    local ent = net.ReadEntity()
    if (!IsValid(ent) or ent:GetClass() != "rust_researchtable") then return end
    if (ent:GetResearchFinish() != 0) then return end

    local container = ent.Containers[1]
    if (!container) then return end

    local item = container[1]
    if (!item) then return end

    local register = item:GetRegister()
    local cost = register:GetResearchCost(item)
    if (!cost) then return end
    if (!ent:CanResearchItem(pl)) then return end

    ent:EmitSound("research.start")
    ent:SetResearchFinish(CurTime() + gRust.GetConfigValue("farming/research.time", 10))
end)