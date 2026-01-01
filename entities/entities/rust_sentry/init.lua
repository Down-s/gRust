DEFINE_BASECLASS("rust_turret")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetModel(self.BaseModel)

    self:SetPeacekeeper(true)

    self:SetInteractable(false)
    
    self.Authorized = {}

    self.IdleOffset = self:EntIndex()
    self.RangeSqr = self.Range * self.Range

    self.WeaponData = {
        RPM = 500,
        Damage = 5,
        ShootSound = "darky_rust.m249-attack",
    }
end

function ENT:CreateContainers()
end

function ENT:GetMuzzlePos()
    return self:LocalToWorld(self.YawPos + self.PitchPos + self.GunPos + Vector(-10, 0, 5))
end

function ENT:CanTargetPlayer(pl)
    if (!pl:Alive()) then return false end
    if (pl:Health() <= 0) then return false end
    if (pl:GetPos():DistToSqr(self:GetPos()) > self.RangeSqr) then return false end
    if (!pl:IsCombatBlocked()) then return false end
    if (!pl:IsInSafeZone()) then return false end
    
    local tr = {}
    tr.start = self:GetMuzzlePos()
    tr.endpos = pl:EyePos()
    tr.filter = {self, pl}
    tr = util.TraceLine(tr)

    if (tr.Hit and tr.Entity != pl) then return false end
    
    return true
end