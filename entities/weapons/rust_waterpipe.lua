AddCSLuaFile()

SWEP.Base = "rust_gun"
DEFINE_BASECLASS("rust_gun")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_waterpipe.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_waterpipe.mdl"

SWEP.ShootSound = "darky_rust.waterpipe-shotgun-attack"
SWEP.ShootSoundSilenced = "darky_rust.sawnoff-shotgun-attack-silenced" 

SWEP.IronSightsPos = Vector(-5.16, -2.421, 2.68)
SWEP.IronSightsAng = Angle(2.338, 0.975, 0)
SWEP.IronSightsFOV = 42.5

SWEP.Damage = 100
SWEP.ClipSize = 1
SWEP.Bullets = 10

SWEP.RecoilAmount = 1
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-140, -70, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "handmade_shell",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	}
}

SWEP.Attachments = {}