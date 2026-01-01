AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

gRust.CreateConfigValue("farming/harvest.hemp", 1)
local HEMP_HARVEST = gRust.GetConfigValue("farming/harvest.hemp")

function ENT:Initialize()
    self:SetModel("models/environment/plants/hemp.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetInteractable(true)
    self:SetInteractText("HEMP FIBERS")
    self:SetInteractIcon("pickup")

    self:SetModelScale(0.75)
    
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    self.Stage = 3
    self:SetBodygroup(1, self.Stage)
end

function ENT:Interact(pl)
    local Item = gRust.CreateItem("cloth", math.floor(self.Stage * 3.5) * HEMP_HARVEST)
    pl:AddItem(Item, ITEM_HARVEST)

    pl:EmitSound("farming.pick")

    if (math.random(1, 100) == 1) then
        pl:AddItem("hemp_hat", 1, ITEM_HARVEST)
    end

    self:Remove()
end