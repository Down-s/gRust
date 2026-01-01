AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

AccessorFunc(ENT, "Fuse", "Fuse", FORCE_NUMBER)
AccessorFunc(ENT, "ExplodeSound", "ExplodeSound", FORCE_STRING)
AccessorFunc(ENT, "BeepSound", "BeepSound", FORCE_STRING)
AccessorFunc(ENT, "BeepDelay", "BeepDelay", FORCE_NUMBER)
AccessorFunc(ENT, "Radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "Damage", "Damage", FORCE_NUMBER)
AccessorFunc(ENT, "Impact", "Impact", FORCE_BOOL)
AccessorFunc(ENT, "Stick", "Stick", FORCE_BOOL)
AccessorFunc(ENT, "Owner", "Owner")

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    self.StartTime = CurTime()
    self.NextBeep = CurTime() + self.BeepDelay

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:SetDamping(0.75, 0)
    end
end

function ENT:Detonate()
    if (self.ExplodeSound) then
        self:EmitSound(self.ExplodeSound, 100, 100, 1, CHAN_AUTO)
    end

    local pos = self:GetPos() + self:GetUp() * 8
    ParticleEffect("rust_big_explosion", pos, angle_zero)

    local radius = self:GetRadius()
    util.ScreenShake(pos, 500, 25, 1, radius * 2)
    gRust.BlastDamage(pos, radius, self:GetDamage(), self:GetOwner(), self)
    
    self:Remove()
end

function ENT:Think()
    if (self:GetFuse() and self:GetFuse() < CurTime() - self.StartTime and !self.Detonated) then
        self:Detonate()
        self.Detonated = true
    end

    if (self.BeepSound and self.NextBeep < CurTime()) then
        self:EmitSound(self.BeepSound)
        self.NextBeep = CurTime() + self.BeepDelay
    end
end

local NORMAL_OFFSET = Angle(-90, 0, 0)
function ENT:PhysicsCollide(data, physobj)
    if (self:GetImpact()) then
        self:Detonate()
    elseif (self:GetStick() and !self.Stuck) then
        self.Stuck = true
        self:SetAngles(data.HitNormal:Angle() + NORMAL_OFFSET)
        self:SetPos(data.HitPos - data.HitNormal * 2)
    
        self:GetPhysicsObject():EnableMotion(false)
    end
end