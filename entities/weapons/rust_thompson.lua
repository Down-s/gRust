AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_thompson.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_thompson.mdl"

SWEP.IronSightsPos = Vector(-4.975, -4, 3.05)
SWEP.IronSightsAng = Vector(-0.35, 0.365, 0)
SWEP.IronSightsFOV = 50

SWEP.Damage = 37
SWEP.RPM = 462
SWEP.AimCone = 0.5
SWEP.ClipSize = 20
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.thompson-attack"
SWEP.ShootSoundSilenced = "darky_rust.thompson-attack-silenced"

SWEP.RecoilAmount = 3.5
SWEP.RecoilLerpTime = 0.1
SWEP.RecoilTable = {
	Angle(-2.5531914893617, 3, 0),
	Angle(-3.6170212765957, -1.25, 0),
	Angle(-3.8297872340426, 1, 0),
	Angle(-3.1914893617021, 2.5, 0),
	Angle(-2.7659574468085, 1.25, 0),
	Angle(-2.1276595744681, 2.75, 0),
	Angle(-3.4042553191489, 0.5, 0),
	Angle(-2.3404255319149, -2, 0),
	Angle(-2.1276595744681, -3, 0),
	Angle(-1.7021276595745, -2.75, 0),
	Angle(-1.2765957446809, -3.25, 0),
	Angle(-1.7021276595745, -2.25, 0),
	Angle(-2.3404255319149, -0.75, 0),
	Angle(-2.3404255319149, 0.5, 0),
	Angle(-1.063829787234, 2.25, 0),
	Angle(-1.7021276595745, 2.25, 0),
	Angle(-1.7021276595745, 2.5, 0),
	Angle(-0.85106382978723, 2, 0),
	Angle(-1.063829787234, 2.25, 0),
	Angle(-2.1276595744681, -1, 0),	
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
	["simple_handmade_sight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_ms_holosight.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.9-0.5, -0.65))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-5.016, -6, 1.63))
			:SetIronSightsAng(Angle(-0.071, 0.46, 0))
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
			:SetPosition(Vector(-0.07, -1.5-0.5, -0.8))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-4.963, -6, 2.078))
			:SetIronSightsAng(Angle(-0.15, 0.375, 0))
			:SetRectilePosition(Vector(0.47, -0.095, 0.3))
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
			:SetPosition(Vector(0, -0.8, 23))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(0.8),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.8, 0.2, 14))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.28, -2.3-0.5, -1))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(1.0),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.04, -0.4-0.5, 1.9))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(1.0),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.5, 0.3, 14))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.8, 20))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(0.8),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.8, 20))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
}