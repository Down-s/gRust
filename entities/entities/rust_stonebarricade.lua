AddCSLuaFile()

ENT.Base = "rust_base"
ENT.Model = "models/deployable/stone_barricade.mdl"
ENT.MaxHP = 100
ENT.Decay = 8 * 60*60 -- 8 hours

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRotate(90)
    :SetCustomCheck(function(ent, center, tr)
        return gRust.TracedGround(tr)
    end)