AddCSLuaFile()

DEFINE_BASECLASS("rust_base")

ENT.Base = "base_anim"
ENT.Type = "anim"

AccessorFunc(ENT, "Damage", "Damage", FORCE_NUMBER)

function ENT:Initialize()
    if (CLIENT) then return end
    self:SetModel("models/weapons/darky_m/rust/rocket.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

	self:EmitSound( "darky_rust.rocket-engine-loop" )

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:Wake()
    end

    timer.Simple(15, function()
        if (IsValid(self)) then
            self:Remove()
        end
    end)
end

function ENT:OnRemove()
    self:StopSound("darky_rust.rocket-engine-loop")
end

function ENT:Think()
    ParticleEffect("generic_smoke", self:GetPos(), Angle(0,0,0))
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:PhysicsCollide(data, collider)
    local pos = data.HitPos

    self:Remove()
    ParticleEffect("rust_big_explosion", pos, Angle(0, 0, 0))

    local radius = 256
    util.ScreenShake(pos, 500, 25, 1, radius * 2)
    gRust.BlastDamage(pos, radius, self:GetDamage(), self:GetOwner(), self)
end