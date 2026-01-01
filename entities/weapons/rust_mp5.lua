AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_mp5.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_mp5.mdl"

SWEP.IronSightsPos = Vector(-6.47, 0, 2.9)
SWEP.IronSightsAng = Vector(0.349, -1.38, 0)
SWEP.IronSightsFOV = 40

SWEP.Damage = 35
SWEP.RPM = 600
SWEP.AimCone = 0.5
SWEP.ClipSize = 30
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.mp5-attack"
SWEP.ShootSoundSilenced = "darky_rust.mp5-attack-silenced" 

SWEP.RecoilAmount = 5.0
SWEP.RecoilLerpTime = 0.05
SWEP.RecoilTable = {
	Angle(-2.5531914893617, 3, 0),
	Angle(-2.5531914893617, 1.25, 0),
	Angle(-3.6170212765957, -1.75, 0),
	Angle(-2.9787234042553, -0, 0),
	Angle(-2.5531914893617, 2, 0),
	Angle(-1.7021276595745, 2.75, 0),
	Angle(-0.63829787234043, 2.75, 0),
	Angle(-2.1276595744681, 1.75, 0),
	Angle(-1.7021276595745, -1, 0),
	Angle(-0.21276595744681, -2, 0),
	Angle(-0.42553191489362, -2, 0),
	Angle(-0.42553191489362, -2, 0),
	Angle(-0.85106382978723, -1.25, 0),
	Angle(-1.2765957446809, 0.75, 0),
	Angle(-0.85106382978723, 2.25, 0),
	Angle(-0.21276595744681, 1.75, 0),
	Angle(-0.42553191489362, 1.5, 0),
	Angle(-0.21276595744681, 1.75, 0),
	Angle(-1.2765957446809, 0.75, 0),
	Angle(-0.85106382978723, -1.5, 0),
	Angle(-0.42553191489362, -1.75, 0),
	Angle(-0.21276595744681, -1.5, 0),
	Angle(-0.42553191489362, -1.5, 0),
	Angle(-0.21276595744681, -1.5, 0),
	Angle(-0.85106382978723, 0.25, 0),
	Angle(-0.21276595744681, 1.75, 0),
	Angle(1.063829787234, 1.25, 0),
	Angle(-1.063829787234, 1.5, 0),
	Angle(0, -2.5, 0),
	Angle(0.21276595744681, -1.75, 0),
	Angle(0.42553191489362, 1.75, 0),
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
			:SetPosition(Vector(0, -1.9-2.3, -0.65+5))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-6.45, 0, 2.125))
			:SetIronSightsAng(Angle(-0.18, -1.36, 0))
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
			:SetPosition(Vector(-0.09, -1.5-2.3, -0.8+5))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-6.43, 0, 3))
			:SetIronSightsAng(Angle(-1.18, -1.38, 0))
			:SetRectilePosition(Vector(0.47, -0.123, 0.3))
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
			:SetPosition(Vector(0, -1.4, 21))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(0.8),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.1, 0.2, 8.1+5))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.25, -2.3-2.3, -1+5))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(1.0),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.03, -0.4-2.3, 1.9+5))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(1.0),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.4, 7.18+5.5))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.35, 18))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.35, 18))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
}