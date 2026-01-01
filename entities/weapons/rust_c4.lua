AddCSLuaFile()

SWEP.Base = "rust_explosive"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_c4.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_c4.mdl"

SWEP.Damage = 550
SWEP.Radius = 4
SWEP.Delay = 10
SWEP.BeepSound = "darky_rust.c4-beep-loop"
SWEP.Stick = true

function SWEP:GetExplodeSound()
    return "darky_rust.c4-explosion-" .. math.random(1, 4)
end