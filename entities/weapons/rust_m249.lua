AddCSLuaFile()

SWEP.Base = "rust_gun"

SWEP.ViewModel = "models/weapons/darky_m/rust/c_m249.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_m249.mdl"

SWEP.IronSightsPos = Vector(-3.631, 0, 3.359)
SWEP.IronSightsAng = Vector(-0.102, 0.045, 0)
SWEP.IronSightsFOV = 45

SWEP.Damage = 65
SWEP.RPM = 500
SWEP.AimCone = 0.2
SWEP.ClipSize = 100
SWEP.Range = 4096

SWEP.ShootSound = "darky_rust.m249-attack"
SWEP.ShootSoundSilenced = "darky_rust.m249-attack-silenced" 

SWEP.RecoilAmount = 3.0
SWEP.RecoilLerpTime = 0.02
SWEP.RecoilTable = {
	Angle(-6, 0, 0),
	Angle(-14, 0.25, 0),
	Angle(-14, 0.5, 0),
	Angle(-14, 0.75, 0),
	Angle(-14, 0.5, 0),
	Angle(-14, 0.25, 0),
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
			:SetBone("cover")
			:SetPosition(Vector(0.05+1.5, -1.05, -2))
			:SetAngle(Angle(180, 180, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-3.68, 0, 2.359))
			:SetIronSightsAng(Angle(-0.25, -0.02, 0))
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
			:SetBone("cover")
			:SetPosition(Vector(0.05+1.5, -1.1, -2))
			:SetAngle(Angle(180, 180, 0))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-3.605, 0, 2.4))
			:SetIronSightsAng(Angle(-0.25, -0.02, 0))
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
			:SetPosition(Vector(0, -1.85, 21+11))
			:SetAngle(Angle(0, 0, 180))
			:SetScale(0.8),
	["weapon_flashlight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
			:SetBone("main")
			:SetPosition(Vector(-0.1, 1.2, 8.1+11))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["8x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
			:SetBone("cover")
			:SetPosition(Vector(0.05+2, -0.78, -3))
			:SetAngle(Angle(0, -90, -90)),
	["16x_zoom_scope"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
			:SetBone("cover")
			:SetPosition(Vector(0.1, -1.01, -5))
			:SetAngle(Angle(180, -90, -90)),
	["weapon_lasersight"] =
		gRust.CreateAttachment(AttachmentType.Underbarrel)
			:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
			:SetBone("main")
			:SetPosition(Vector(0, 0.4, 7.18+12))
			:SetAngle(Angle(0, -90, 180))
			:SetScale(1.0),
	["muzzle_brake"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.1, -1.85, 18+11))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
	["muzzle_boost"] =
		gRust.CreateAttachment(AttachmentType.Barrel)
			:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.1, -1.85, 18+11))
			:SetAngle(Angle(0, 90, -90))
			:SetScale(1.8),
}