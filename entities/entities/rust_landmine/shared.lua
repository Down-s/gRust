ENT.Base = "rust_base"

ENT.Model = "models/deployable/landmine.mdl"
ENT.MaxHP = 100
ENT.ShouldSave = true

ENT.ExplodeRadius = 192
ENT.ExplodeDamage = 120
ENT.RaidEfficiency = 0.1

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(0)
    :SetRotate(90)

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "HP")
    self:NetworkVar("Entity", 0, "SteppedPlayer")
end

function ENT:GetInteractable()
    local steppedPlayer = self:GetSteppedPlayer()
    return IsValid(steppedPlayer) and steppedPlayer != LocalPlayer()
end

function ENT:GetInteractIcon()
    return "gear"
end

function ENT:GetInteractText()
    return "Disarm"
end