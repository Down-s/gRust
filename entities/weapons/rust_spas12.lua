AddCSLuaFile()

SWEP.Base = "rust_shotgun"
DEFINE_BASECLASS("rust_shotgun")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_spas12.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_spas12.mdl"

SWEP.ShootSound = "darky_rust.spas12-attack"
SWEP.ShootSoundSilenced = "darky_rust.spas12-attack-silenced"

SWEP.IronSightsPos = Vector(-4.41, -1.5, 3.177)
SWEP.IronSightsAng = Vector(0.714, 0, 0)
SWEP.IronSightsFOV = 42.5

SWEP.HoldType       = "ar2"

SWEP.Damage = 175
SWEP.RPM = 240
SWEP.ShellInsertTime = 0.2 -- time between shell inserts
SWEP.ClipSize = 6
SWEP.Bullets = 16
SWEP.BulletVelocity = 10000

SWEP.RecoilAmount = 750
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-0.1, -0.08, 0),
}

SWEP.AmmoTypes = {
	{
		Item = "handmade_shell",
		Projectile = ProjectileType.Normal,
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
			:SetPosition(Vector(0.05, -4, 4.0))
			:SetAngle(Angle(180, -90, -90))
			:SetScale(1.15)
			:SetIronSightsPos(Vector(-4.395, -1.5, 2.02))
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
				:SetPosition(Vector(-0.125+0.05, -3.5, 4.0))
				:SetAngle(Angle(180, -90, 0))
				:SetScale(0.9)
				:SetIronSightsPos(Vector(-4.393, -1.5, 2.58))
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
				:SetPosition(Vector(0.1, -1.8, 24.5+7))
				:SetAngle(Angle(0, 0, 180))
				:SetScale(0.85),
		["8x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.3, -4.3, 4.0))
				:SetAngle(Angle(0, 0, -90)),
		["16x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.05, -2.4, 6.7))
				:SetAngle(Angle(180, 0, -90)),
		["muzzle_brake"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzlebrake.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.15, -1.8, 21.7+7))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.0),
		["muzzle_boost"] =
			gRust.CreateAttachment(AttachmentType.Barrel)
				:SetModel("models/weapons/darky_m/rust/mod_muzzleboost.mdl")
				:SetBone("main")
				:SetPosition(Vector(0.15, -1.8, 21.7+7))
				:SetAngle(Angle(0, 90, -90))
				:SetScale(2.0),
}