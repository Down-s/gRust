AddCSLuaFile()

ENT.Base = "rust_base"

ENT.Model = "models/darky_m/rust/woodenbars.mdl"
ENT.PickupType = PickupType.Hammer
ENT.MaxHP = 250
ENT.Decay = 3 * 60*60 -- 3 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 17
    }
}

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRequireSocket(true)
    :SetRotate(180)
    :SetSound("deploy/wood_bars_deploy.wav")
    :AddSocket(
        gRust.CreateSocket()
            :SetPosition(0, 0, 0)
            :SetAngle(0, 0, 0)
            :AddMaleTag("window")
    )
    -- Workaround as the origin of the window frames is not centered
    :SetOnDeployed(function(self, pl, ent)
        ent:DeleteOnRemove(self)
        ent.OccupiedEntity = self
        self:SetPos(self:GetPos() - Vector(0, 0, 47.5))
    end)
    :SetPreviewCallback(function(self, ent)
        ent:SetPos(ent:GetPos() - Vector(0, 0, 47.5))
    end)