AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_sar.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_sar.mdl"

SWEP.Primary.Automatic = false

SWEP.IronSightsPos = Vector(-5.18, -2.985, 2.519)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Damage = 40
SWEP.RPM = 400
SWEP.AimCone = 0.25
SWEP.ClipSize = 16
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.sar-attack"
SWEP.ShootSoundSilenced = "darky_rust.sar-attack-silenced"

SWEP.RecoilAmount = 3
SWEP.RecoilLerpTime = 0.05
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
			:SetPosition(Vector(0.02, -3.5, 4.2))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.0)
			:SetIronSightsPos(Vector(-5.146, -10.516, 1.4))
			:SetIronSightsAng(Angle(0, 0, 0))
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
			:SetPosition(Vector(-0.07, -3.4, 4.3))
			:SetAngle(Angle(180, -90, 0))
			:SetScale(1.0)
			:SetIronSightsPos(Vector(-5.114, -10.516, 1.548))
			:SetIronSightsAng(Angle(0, 0, 0))
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
			:SetPosition(Vector(0, -1.4, 31.5))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(1.0),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.1, 0.4, 8.1+14))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.25, -4.0, 5-1))
			:SetAngle(Angle(0, 0, -90))
			:SetScale(1.0),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.005, -2.2, 6.2-1))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(1.0),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -0.2, 7.18+14))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.4, 27.5))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(2.5),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, -1.4, 27.5))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(2.5),
}