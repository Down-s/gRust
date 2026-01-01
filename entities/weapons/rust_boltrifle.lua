AddCSLuaFile()

SWEP.Base = "rust_shotgun"
DEFINE_BASECLASS("rust_shotgun")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_boltrifle.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_boltrifle.mdl"

SWEP.ShootSound = "darky_rust.bolt-rifle-attack"
SWEP.ShootSoundSilenced = "darky_rust.bolt-rifle-attack-silenced"

SWEP.IronSightsPos = Vector(-3.491, 0, 2.618)
SWEP.IronSightsAng = Vector(-0.401, 1.02, 0)
SWEP.IronSightsFOV = 42.5

SWEP.HoldType       = "ar2"

SWEP.Damage = 80
SWEP.RPM = 30
SWEP.ShellInsertTime = 0.4 -- time between shell inserts
SWEP.ClipSize = 4
SWEP.Bullets = 1
SWEP.BulletVelocity = 10000

SWEP.RecoilAmount = 500
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-0.1, -0.08, 0),
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

local SIMPLESIGHT_MATERIAL = Material( "models/darky_m/rust_weapons/mods/xhair_highvis.png" )
local HOLOSIGHT_MATERIAL = Material( "models/darky_m/rust_weapons/mods/holosight.reticle.standard.png" )
SWEP.Attachments = {
	["simple_handmade_sight"] =
		gRust.CreateAttachment(AttachmentType.Sight)
			:SetModel("models/weapons/darky_m/rust/mod_ms_holosight.mdl")
			:SetBone("main")
			:SetPosition(Vector(0.01, -4.5, 10.0))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-3.41, 0, 1.33))
			:SetIronSightsAng(Vector(-0.85, 1.15, 0))
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
				:SetPosition(Vector(-0.125, -4.0, 10.0))
				:SetAngle(Angle(180, -90, 0))
				:SetIronSightsPos(Vector(-3.405, 0, 2.118))
				:SetIronSightsAng(Vector(-1.458, 1.197, 0))
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
				:SetPosition(Vector(-0.05, -2.32, 41.0))
				:SetAngle(Angle(0, 0, 180))
				:SetScale(0.85),
		["weapon_flashlight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 0.9-2, 15+10))
				:SetAngle(Angle(0, -90, 180))
				:SetScale(1.1),
		["8x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.25, -4.8, 8.8))
				:SetAngle(Angle(0, 0, -90)),
		["16x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, -3.0, 11.7))
				:SetAngle(Angle(180, 0, -90)),
		["weapon_lasersight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, 0.268-2, 14+10))
				:SetAngle(Angle(0, -90, 180))
				:SetScale(1.1),
		["muzzle_brake"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, -2.4, 38.2))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.0),
		["muzzle_boost"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
				:SetBone("main")
				:SetPosition(Vector(0, -2.4, 38.2))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.0),
}