AddCSLuaFile()

ENT.Base = "rust_container"

DEFINE_BASECLASS("rust_container")

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/large_wooden_box.mdl"
ENT.MaxHP = 300

ENT.BulletDamageScale = 0.0225
ENT.MeleeDamageScale = 0.005
ENT.ExplosiveDamageScale = 0.4
ENT.ShouldSave = true
    
ENT.LockBodygroup = 1

ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 10
    },
    {
        Item = "metal_fragments",
        Amount = 5
    }
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("deploy/small_wooden_box_deploy.wav")
    :SetRotate(90)
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(19, 0, 25)
            :SetAngle(0, 90, 0)
            :SetCustomCheck(function(ent, pos, ang)
                return ent:GetBodygroup(1) == 0
            end)
            :AddFemaleTag("lock")
    )

function ENT:CreateContainers()
    local container = gRust.CreateInventory(48)
    container:SetEntity(self)
end

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    self.Containers[1] = inv
end