AddCSLuaFile()

ENT.Base = "rust_doubledoor"

ENT.PickupType = PickupType.Hammer
ENT.MaxHP = 250
ENT.Model = "models/deployable/metal_double_door.mdl"
ENT.LeftDoorModel = "models/darky_m/rust/metal_door_l.mdl"
ENT.RightDoorModel = "models/deployable/metal_door.mdl"
ENT.DoorSpacing = 50.7

ENT.BulletDamageScale = 0.0175
ENT.MeleeDamageScale = 0.005
ENT.ExplosiveDamageScale = 0.5

ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "metal_fragments",
        Amount = 100
    }
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    --:SetInitialRotation(180)
    :SetCenter(Vector(0, 0, 46))
    :SetSound("deploy/metal_door_deploy.wav")
    :SetRequireSocket(true)
    :SetRotate(180)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 0, 0)
            :SetAngle(0, 0, 0)
            :SetCustomCheck(function(ent, pos, ang, tr)
                return IsValid(tr.Entity) and #tr.Entity:GetChildren() == 0
            end)
            :AddMaleTag("doubledoor")
    )
    :SetOnDeployed(function(self, pl, ent)
        self:SetParent(ent)
    end)
    :SetPreviewCallback(function(self, ent)
        if (!ent.LeftDoor) then
            ent.LeftDoor = ent:AddModel("models/darky_m/rust/metal_door_l.mdl")
            ent.RightDoor = ent:AddModel("models/deployable/metal_door.mdl")
        end

        ent.LeftDoor:SetPos(ent:LocalToWorld(Vector(50.7, 0, 5)))
        ent.LeftDoor:SetAngles(ent:GetAngles() + Angle(0, 170, 0))

        ent.RightDoor:SetPos(ent:LocalToWorld(Vector(-50.7, 0, 5)))
        ent.RightDoor:SetAngles(ent:GetAngles() + Angle(0, 10, 0))
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