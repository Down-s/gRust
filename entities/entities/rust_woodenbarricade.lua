AddCSLuaFile()

ENT.Base = "rust_base"
ENT.Model = "models/deployable/wooden_barricade.mdl"
ENT.MaxHP = 120
ENT.Decay = 2 * 60*60 -- 2 hours

ENT.Deploy = gRust.CreateDeployable()
    :SetInitialRotation(180)
    :SetModel(ENT.Model)
    :SetRotate(90)
    :SetCustomCheck(function(ent, center, tr)
        return gRust.TracedGround(tr)
    end)