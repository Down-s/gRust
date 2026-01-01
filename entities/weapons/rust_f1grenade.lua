AddCSLuaFile()

SWEP.Base = "rust_explosive"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_f1.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_f1.mdl"

SWEP.Damage = 95
SWEP.Radius = 6
SWEP.Delay = 2.5
SWEP.Stick = false
SWEP.RaidEfficiency = 0.5

function SWEP:GetExplodeSound()
    return "darky_rust.beancan-grenade-explosion"
end