AddCSLuaFile()

ENT.Base = "rust_container"
DEFINE_BASECLASS("rust_container")

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/wooden_box.mdl"
ENT.LockBodygroup = 1
ENT.MaxHP = 150
ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("deploy/small_wooden_box_deploy.wav")
    :SetRotate(90)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(12, 0, 14)
            :SetAngle(0, 90, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(1) == 0
            end)
            :AddFemaleTag("lock")
    )

function ENT:CreateContainers()
    local container = gRust.CreateInventory(18)
    container:SetEntity(self)
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    self.Containers[1] = inv
end