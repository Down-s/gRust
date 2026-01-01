AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_m92.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_m92.mdl"

SWEP.Primary.Automatic = false 

SWEP.IronSightsPos = Vector(-3.711, 0, 1.799)
SWEP.IronSightsAng = Vector(0.209, 0, 0)
SWEP.IronSightsFOV = 62.5

SWEP.Damage = 45
SWEP.RPM = 400
SWEP.AimCone = 1
SWEP.ClipSize = 15
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.m92-attack"
SWEP.ShootSoundSilenced = "darky_rust.m92-attack-silenced"

SWEP.HoldType = "pistol"

SWEP.RecoilAmount = 5
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-2.5*4, 0.4, 0),
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
			:SetPosition(Vector(-0.02, -1.4, -0.65+2.9))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-3.705, 0, 0.69))
			:SetIronSightsAng(Angle(0.209, 0, 0))
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
			:SetPosition(Vector(-0.09, -1.2, -0.5+2.9))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(0.8)
			:SetIronSightsPos(Vector(-3.695, -2.5, 0.945))
			:SetIronSightsAng(Angle(0.209, 0, 0))
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
			:SetPosition(Vector(0, -1.7, 13.5))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(0.8),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.1, 5.9))
			:SetAngle(Angle(0, 90, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("slide")
			:SetPosition(Vector(0.18, -1.9, -1+2.9))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(0.8),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("cover")
			:SetPosition(Vector(-0.01, -0.5, 3))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(0.8),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.1, 6.0))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(0.8),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.7, 10.5))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.7, 10.7))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
}