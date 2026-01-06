ENT.Base = "rust_container"

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/darky_m/rust/shopfront.mdl"
ENT.MaxHP = 750
ENT.Slots = 12
ENT.CanRotate = true

ENT.ShouldSave = true

ENT.BulletDamageScale = 0.001
ENT.MeleeDamageScale = 0.001
ENT.ExplosiveDamageScale = 0.5

ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "metal_fragments",
        Amount = 83
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
            :AddMaleTag("doubledoor")
    )
    :SetOnDeployed(function(self, pl, ent)
        self:SetParent(ent)
    end)

function ENT:OnInventoryAttached(inv)
    self.Containers = self.Containers or {}
    
    if (self.Containers[1]) then
        self.Containers[2] = inv
    else
        self.Containers[1] = inv
    end
end