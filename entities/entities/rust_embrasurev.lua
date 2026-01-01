AddCSLuaFile()

ENT.Base = "rust_base"
ENT.Model = "models/deployable/vertical_embrasure.mdl"
ENT.MaxHP = 500
ENT.Decay = 3 * 60*60 -- 3 hours
ENT.Upkeep = {
    {
        Item = "metal_fragments",
        Amount = 25
    }
}

ENT.ShouldSave = true

ENT.BulletDamageScale = 0.0225
ENT.MeleeDamageScale = 0.005
ENT.ExplosiveDamageScale = 0.15

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRequireSocket(true)
    :SetRotate(180)
    :SetSound("deploy/reinforced_window_deploy.wav")
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 0, 0)
            :SetAngle(0, 0, 0)
            :AddMaleTag("window")
    )
    :SetOnDeployed(function(self, pl, ent)
        ent:DeleteOnRemove(self)
        ent.OccupiedEntity = self
        self:SetPos(self:LocalToWorld(Vector(0, 1, -6)))
    end)
    :SetPreviewCallback(function(self, ent)
        ent:SetPos(ent:LocalToWorld(Vector(0, 1, -6)))
    end)