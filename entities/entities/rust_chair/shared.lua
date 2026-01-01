ENT.Base = "rust_base"

ENT.Model = "models/deployable/chair.mdl"
ENT.PickupType = PickupType.Hammer
ENT.MaxHP = 100

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetInitialRotation(180)
    :SetSound("farming/furnace_deploy.wav")
    :SetRotate(90)