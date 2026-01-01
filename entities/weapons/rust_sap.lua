AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_semi_auto_pistol.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_sap.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-3.06, 0, 2.44)
SWEP.IronSightsAng = Vector(0.029, 0.039, 0)

SWEP.Damage = 40
SWEP.RPM = 400
SWEP.AimCone = 0.75
SWEP.ClipSize = 10
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.fire-alt"
SWEP.ShootSoundSilenced = "darky_rust.semi-pistol-attack-silenced"

SWEP.RecoilAmount = 3
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-2.5*5, 0.4*2, 0),
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
			:SetBone("slide")
			:SetPosition(Vector(-0.02, -1.4, -0.65+0.1))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-3.087, -6, 1.38))
			:SetIronSightsAng(Angle(0.029, 0.039, 0))
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
			:SetBone("slide")
			:SetPosition(Vector(-0.05, -1.4, -0.65+0.1))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.8)
			:SetIronSightsPos(Vector(-3.032, -3, 1.431))
			:SetIronSightsAng(Angle(0.029, 0.039, 0))
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
			:SetPosition(Vector(0, -1.31, 12.7))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(0.7),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.15, 5.25))
			:SetAngle(Angle(0, 90, 180))
			:SetScale(0.9),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("slide")
			:SetPosition(Vector(0.18, -2, -0.5))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(0.8),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("cover")
			:SetPosition(Vector(-0.01, -0.5, 2))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(0.8),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.1, 5.35))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.3, 10.0))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.3, 10.0))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
}