AddCSLuaFile()

DEFINE_BASECLASS( "rust_door" )
ENT.Base = "rust_door"

ENT.Model = "models/deployable/metal_door.mdl"
ENT.MaxHP = 250
ENT.ShouldSave = true

ENT.BulletDamageScale = 0.0225
ENT.MeleeDamageScale = 0.005
ENT.ExplosiveDamageScale = 0.445

ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "metal_fragments",
        Amount = 50
    }
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRequireSocket(true)
    :SetInitialRotation(0)
    :SetCenter(Vector(0, 0, 46))
    :SetRotate(0)
    :SetSound("deploy/metal_door_deploy.wav")
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 0, -44)
            :SetAngle(0, 0, 0)
            :AddMaleTag("door"),
        gRust.CreateSocket()
            :SetPosition(45, 1.2, 37.5)
            :SetAngle(0, 0, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(2) == 0
            end)
            :AddFemaleTag("lock")
    )
    :SetOnDeployed(function(self, pl, ent)
        self:SetParent(ent)
    end)
    :SetPreviewCallback(function(self, ent)
        ent:SetAngles(ent:GetAngles() + Angle(0, -10, 0))
    end)

function ENT:GetOpenSound()
    return "doors/door_metal_open.wav"
end

function ENT:GetCloseSound()
    return "doors/door_metal_close.wav"
end

function ENT:GetShutSound()
    return "doors/door_metal_shut.wav"
end

function ENT:GetKnockSound()
    return string.format("doors/door_knock_metal_%i.wav", math.random(1, 2))
end