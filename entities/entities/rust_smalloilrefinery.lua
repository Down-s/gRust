AddCSLuaFile()

ENT.Base = "rust_furnace"

DEFINE_BASECLASS("rust_furnace")

ENT.Model = "models/deployable/refinery.mdl"

ENT.Furnace = {
    Fuel = {
        ["wood"] = true,
    },
    Cookables = {
    --  Input                       Output                  Time        Chance
        ["crude_oil"] =             {"low_grade_fuel",      3.33},
        ["empty_can_of_beans"] =    {"metal_fragments",     10},
        ["empty_tuna_can"] =        {"metal_fragments",     10},
        ["wood"] =                  {"charcoal",            2,          0.75}
    },
}

ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "wood",
        Amount = 20
    },
    {
        Item = "metal_fragments",
        Amount = 50
    }
}

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetSound("farming/refinery_deploy.wav")
    :SetRotate(90)

function ENT:GetInventoryName()
    return "REFINERY"
end