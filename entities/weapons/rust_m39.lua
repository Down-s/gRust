AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_m39emr.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_m39.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-3.94, -3.47, 1.98)
SWEP.IronSightsAng = Vector(1.218, 1.12, 0)
SWEP.IronSightsFOV = 65

SWEP.Damage = 35
SWEP.RPM = 343
SWEP.AimCone = 0.1
SWEP.ClipSize = 20
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.m39-attack"
SWEP.ShootSoundSilenced = "darky_rust.m39-attack-silenced"

SWEP.RecoilAmount = 5.0
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-2.5, 0, 0),
	Angle(-8, 0.25, 0),
	Angle(-8, 0, 0),
	Angle(-8, -0.25, 0),
	Angle(-8, -0.25, 0),
	Angle(-8, 0, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "556_rifle_ammo",
		Projectile = ProjectileType.Normal,
		Icon = "riflebullet",
	},
	{
		Item = "hv_556_rifle_ammo",
		Projectile = ProjectileType.HighVelocity,
		Icon = "riflebullet",
	},
	{
		Item = "incendiary_556_rifle_ammo",
		Projectile = ProjectileType.Incendiary,
		Icon = "riflebullet",
	},
	{
		Item = "explosive_556_rifle_ammo",
		Projectile = ProjectileType.Explosive,
		Icon = "riflebullet",
	}
}

local SIMPLESIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/xhair_highvis.png")
local HOLOSIGHT_MATERIAL = Material("models/darky_m/rust_weapons/mods/holosight.reticle.standard.png")
SWEP.Attachments = {
	["simple_handmade_sight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_ms_holosight.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.02, -3.6, 4.6))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-4.032+0.135, -3.47, 0.7))
			:SetIronSightsAng(Angle(0.4, 0.835, 0))
			:SetRectilePosition(Vector(0.519, 0, 0))
			:SetRectileAngle(Angle(-90, 0, 90))
			:SetRectileScale(0.01)
			:SetRectileDrawCallback(function()
				surface.SetDrawColor(0, 0, 0)
				surface.SetMaterial(SIMPLESIGHT_MATERIAL)
				surface.DrawTexturedRect(-70, -70, 140, 140)
			end),
	["holosight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_holo.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.07, -3.12, 4.62))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-3.99+0.133, -3.17, 1.225))
			:SetIronSightsAng(Angle(0.4, 1.25, 0))
			:SetRectilePosition(Vector(0.47, -0.08, 0.3))
			:SetRectileAngle(Angle(0, -90, 0))
			:SetRectileScale(0.01)
			:SetRectileDrawCallback(function()
				surface.SetDrawColor(255, 0, 0)
				surface.SetMaterial(HOLOSIGHT_MATERIAL)
				surface.DrawTexturedRect(-40, -40, 80, 80)
			end),
	["silencer"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_silencer.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.9, 42.2))
			:SetAngle(Angle(0, 0, 180)),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(2.25, -0.45, 22))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(1.1),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.24, -4.0, 5))
			:SetAngle(Angle(0, 0, -90)),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.05, -2.2, 6.2))
			:SetAngle(Angle(180, 0, -90)),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(1.7, -0.2, 23))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.8, 39.2))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(2.5),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.8, 39.2))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(2.5),
}