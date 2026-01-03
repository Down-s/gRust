AddCSLuaFile()

ENT.Base = "rust_doubledoor"

ENT.PickupType = PickupType.Hammer
ENT.MaxHP = 200
ENT.Model = "models/deployable/wood_double_door.mdl"
ENT.LeftDoorModel = "models/darky_m/rust/wooden_door_l.mdl"
ENT.RightDoorModel = "models/deployable/wooden_door.mdl"

ENT.BulletDamageScale = 0.0175
ENT.MeleeDamageScale = 0.005
ENT.ExplosiveDamageScale = 0.6

ENT.Decay = 6 * 60*60 -- 6 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 200
    }
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    --:SetInitialRotation(180)
    :SetCenter(Vector(0, 0, 46))
    :SetSound("deploy/wood_door_deploy.wav")
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