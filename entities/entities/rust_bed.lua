AddCSLuaFile()

ENT.Base = "rust_sleepingbag"

ENT.Model = "models/deployable/bed.mdl"
ENT.MaxHP = 300
ENT.BagSpawnTime = 2 * 60
ENT.NoCollide = false

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetInitialRotation(-90)
    :SetModel(ENT.Model)
    :SetRotate(90)
    :SetOnDeployed(function(self, pl, ent)
        pl:AddSleepingBag(self)
    end)

function ENT:Initialize()
    baseclass.Get("rust_base").Initialize(self)
    self:SetBagName("Unnamed Bed")

    self:SetInteractable(true)
    self:SetInteractText("RENAME BED")
    self:SetInteractIcon("enter")

    self:SetRespawnTime(CurTime())
end