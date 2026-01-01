AddCSLuaFile()

DEFINE_BASECLASS( "rust_door" )
ENT.Base = "rust_door"

ENT.Model = "models/deployable/armored_door.mdl"
ENT.MaxHP = 1000
ENT.ShouldSave = true

ENT.BulletDamageScale = 0.0225
ENT.MeleeDamageScale = 0.015
ENT.ExplosiveDamageScale = 0.675

ENT.Decay = 10 * 60*60 -- 10 hours
ENT.Upkeep = {
    {
        Item = "hq_metal",
        Amount = 7
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
        ent:DeleteOnRemove(self)
        ent.OccupiedEntity = self
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