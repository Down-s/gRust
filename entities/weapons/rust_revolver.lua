AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_revolver.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_revolver.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-3.32, 0, 0.839)
SWEP.IronSightsAng = Vector(1.129, 0.035, 0)
SWEP.IronSightsFOV = 56

SWEP.Damage = 35
SWEP.RPM = 343
SWEP.AimCone = 0.75
SWEP.ClipSize = 8
SWEP.Range = 4096
SWEP.BulletVelocity = 4000

SWEP.ShootSound = "darky_rust.revolver-attack"
SWEP.ShootSoundSilenced = "darky_rust.revolver-attack-silenced"

SWEP.RecoilAmount = 1.25
SWEP.RecoilLerpTime = 0.05
SWEP.RecoilTable = {
	Angle(-2.5*10, 0.4*2, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "pistol_bullet",
		Projectile = ProjectileType.Normal,
		Icon = "pistolbullet",
	},
	{
		Item = "hv_pistol_ammo",
		Projectile = ProjectileType.HighVelocity,
		Icon = "pistolbullet",
	},
	{
		Item = "incendiary_pistol_bullet",
		Projectile = ProjectileType.Incendiary,
		Icon = "pistolbullet",
	}
}