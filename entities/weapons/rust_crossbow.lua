AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_crossbow.mdl"

SWEP.IronSightsPos = Vector(-6.893, -1.732, 3.26)
SWEP.IronSightsAng = Vector(2.888, -3.25, 3.148)
SWEP.IronSightFOV = 50

SWEP.Damage = 40
SWEP.RPM = 500
SWEP.AimCone = 0.2
SWEP.ClipSize = 1
SWEP.Range = 512
SWEP.ReloadTime = 4.0

SWEP.ShootSound = "weapons/rust_mp3/crossbow-attack-1.mp3"
SWEP.ShootSoundSilenced = "darky_rust.lr300-attack-silenced"

SWEP.RecoilAmount = 2.5
SWEP.RecoilLerpTime = 0.1
SWEP.RecoilTable = {
	Angle(-15, 0.8, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "arrow",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	}
}

SWEP.Animations = {
	["Fire"] = ACT_VM_PRIMARYATTACK,
	["FireADS"] = ACT_VM_PRIMARYATTACK,
	["Draw"] = ACT_VM_DRAW,
	["Idle"] = ACT_VM_IDLE,
	["Reload"] = ACT_VM_RELOAD,
	["ReloadEmpty"] = ACT_VM_RELOAD,
}