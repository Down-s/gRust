AddCSLuaFile()

ENT.Base = "rust_base"
ENT.Model = "models/darky_m/rust/hqbars.mdl"
ENT.MaxHP = 500
ENT.Decay = 12 * 60*60 -- 12 hours
ENT.Upkeep = {
    {
        Item = "hq_metal",
        Amount = 1
    }
}

ENT.ShouldSave = true

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
    -- Workaround as the origin of the window frames is not centered
    :SetOnDeployed(function(self, pl, ent)
        self:SetParent(ent)
        self:SetPos(self:GetPos() - Vector(0, 0, 47.5))
    end)
    :SetPreviewCallback(function(self, ent)
        ent:SetPos(ent:GetPos() - Vector(0, 0, 47.5))
    end)