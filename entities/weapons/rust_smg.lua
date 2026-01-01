AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_customsmg.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_smg.mdl"

SWEP.IronSightsPos = Vector(-6.95, 0, 3.68)
SWEP.IronSightsAng = Vector(-0.35, -0.59, 0.4)
SWEP.IronSightsFOV = 45

SWEP.Damage = 30
SWEP.RPM = 600
SWEP.AimCone = 0.5
SWEP.ClipSize = 24
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.smg-attack"
SWEP.ShootSoundSilenced = "darky_rust.smg-attack-silenced"

SWEP.RecoilAmount = 7.5
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-2.5531914893617, -3, 0),
	Angle(-2.1276595744681,  1, 0),
	Angle(-2.3404255319149, 0.25, 0),
	Angle(-2.1276595744681, -0.75, 0),
	Angle(-2.1276595744681, -1, 0),
	Angle(-2.1276595744681, -0.5, 0),
	Angle(-2.5531914893617, -0.75, 0),
	Angle(-2.3404255319149, -0.5, 0),
	Angle(-2.5531914893617, -0.5, 0),
	Angle(-2.5531914893617, 0.25, 0),
	Angle(-2.3404255319149, 0.75, 0),
	Angle(-2.1276595744681, 1.5, 0),
	Angle(-2.1276595744681, 1.25, 0),
	Angle(-2.1276595744681, 1.25, 0),
	Angle(-2.3404255319149, 1.25, 0),
	Angle(-2.3404255319149, 0, 0),
	Angle(-2.1276595744681, -1, 0),
	Angle(-2.1276595744681, -1.5, 0),
	Angle(-1.9148936170213, -1.5, 0),
	Angle(-1.9148936170213, -2.25, 0),
	Angle(-2.1276595744681, -2.25, 0),
	Angle(-1.9148936170213, 1.5, 0),
	Angle(-1.4893617021277, 1.75, 0),
	Angle(2.7659574468085, 0.5, 0),	
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

local SIMPLESIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/xhair_highvis.png")
local HOLOSIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/holosight.reticle.standard.png")

SWEP.Attachments = {
	
}