AddCSLuaFile()

SWEP.Base = "rust_explosive"

SWEP.WorldModel = "models/weapons/darky_m/rust/w_satchel.mdl"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_satchel.mdl"

SWEP.Damage = 175
SWEP.Radius = 4
SWEP.Delay = 8
SWEP.Stick = true

function SWEP:GetExplodeSound()
    return "darky_rust.satchel-charge-explosion-00" .. math.random(1, 4)
end