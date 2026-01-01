AddCSLuaFile()

SWEP.Base = "rust_explosive"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_beancan.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_beancan.mdl"

SWEP.Damage = 80
SWEP.Radius = 4.5
SWEP.Delay = 3.75
SWEP.Stick = false
SWEP.RaidEfficiency = 0.5

function SWEP:GetExplodeSound()
    return "darky_rust.beancan-grenade-explosion"
end