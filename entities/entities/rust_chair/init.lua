AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

DEFINE_BASECLASS("rust_base")

function ENT:Initialize()
    BaseClass.Initialize(self)

    self:SetInteractable(true)
    self:SetInteractText("MOUNT")
    self:SetInteractIcon("drop")
end

local CHAIR_POS = Vector(-2, 0, 5)
local CHAIR_ANG = Angle(0, -90, 0)

function ENT:Interact(pl)
    if (pl:InVehicle()) then return end
    if (IsValid(self.Chair)) then return end
    if (!self:CanSit(pl)) then return end

    local chair = ents.Create("prop_vehicle_prisoner_pod")
    chair:SetModel("models/nova/chair_wood01.mdl")
    chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    chair:SetPos(self:LocalToWorld(CHAIR_POS))
    chair:SetAngles(self:LocalToWorldAngles(CHAIR_ANG))
    chair:Spawn()
    chair:Activate()
    chair:SetParent(self)
    chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    chair:SetMoveType(MOVETYPE_NONE)
    chair:SetSolid(SOLID_NONE)
    chair:SetOwner(pl)
    chair:SetNoDraw(true)

    pl:EnterVehicle(chair)

    pl:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    pl:CollisionRulesChanged()
    
    self.Chair = chair
    self:SetInteractable(false)
end

function ENT:CanSit(pl)
    local tr = {}
    tr.start = self:GetPos()
    tr.endpos = self:GetPos() + Vector(0, 0, 96)
    tr.filter = self
    return !util.TraceLine(tr).Hit
end

function ENT:Think()
    BaseClass.Think(self)

    if IsValid(self.Chair) then
        if (!IsValid(self.Chair:GetDriver())) then
            self.Chair:Remove()
            self.Chair = nil
            self:SetInteractable(true)
        end
    end
end