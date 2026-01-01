AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_nailgun.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_nailgun.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-4.441, -7.068, 1.6)
SWEP.IronSightsAng = Vector(0.6, 0, 0)
SWEP.IronSightsFOV = 61

SWEP.Damage = 18
SWEP.RPM = 400
SWEP.AimCone = 0.75
SWEP.ClipSize = 16
SWEP.Range = 4096
SWEP.BulletVelocity = 2500

SWEP.ShellEffect = ""
SWEP.MuzzleEffect = ""

SWEP.ShootSound = "darky_rust.nailgun-attack"
SWEP.ShootSoundSilenced = "darky_rust.nailgun-attack-silenced"

SWEP.RecoilAmount = 3.0
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-2.5*6, 0.4, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "nailgun_nails",
		Projectile = ProjectileType.Normal,
		Icon = "pistolbullet",
	}
}