AddCSLuaFile()

SWEP.Base = "rust_gun"
DEFINE_BASECLASS("rust_gun")

SWEP.ViewModel = "models/weapons/darky_m/rust/c_doublebarrel.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_doublebarrel.mdl"

SWEP.Primary.Automatic = false

SWEP.ShootSound = "darky_rust.double-shotgun-attack"
SWEP.ShootSoundSilenced = "darky_rust.double-shotgun-attack" 

SWEP.IronSightsPos = Vector(-4.49, 0.019, 3.95)
SWEP.IronSightsAng = Angle(0, 0, 0)
SWEP.IronSightsFOV = 42.5

SWEP.Damage = 100
SWEP.ClipSize = 2
SWEP.Bullets = 10
SWEP.AimCone = 0.25

SWEP.RecoilAmount = 0.5
SWEP.RecoilLerpTime = 0.075
SWEP.RecoilTable = {
	Angle(-140, -70, 0),
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
			:SetBone("barrel")
			:SetPosition(Vector(-0.02-3.5, -1.4+1.63, -0.65-2.9))
			:SetAngle(Angle(180, 0, -90))
			:SetScale(0.9)
			:SetIronSightsPos(Vector(-4.487, 0, 2.97))
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
				:SetBone("barrel")
				:SetPosition(Vector(-0.09-3.5, -1.2+1.52, -0.5-2.9))
				:SetAngle(Angle(180, 0, 0))
				:SetScale(0.8)
				:SetIronSightsPos(Vector(-4.494, 0, 2.96))
				:SetIronSightsAng(Angle(0.209, 0, 0))
				:SetRectilePosition(Vector(0.47, -0.083, 0.3))
				:SetRectileAngle(Angle(0, -90, 0))
				:SetRectileScale(0.01)
				:SetRectileDrawCallback(function()
					surface.SetDrawColor(255, 0, 0)
					surface.SetMaterial(HOLOSIGHT_MATERIAL)
					surface.DrawTexturedRect(-40, -40, 80, 80)
				end),
		["weapon_flashlight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/mod_flash.mdl")
				:SetBone("barrel")
				:SetPosition(Vector(2, 0.1, 11))
				:SetAngle(Angle(0, 0, 180))
				:SetScale(0.8),
		["8x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_reddot.mdl")
				:SetBone("barrel")
				:SetPosition(Vector(0.18-4.5, -1.9+2-0.1, -1.9))
				:SetAngle(Angle(0, 90, -90)),
		["16x_zoom_scope"] =
			gRust.CreateAttachment(AttachmentType.Sight)
				:SetModel("models/weapons/darky_m/rust/mod_8xScope.mdl")
				:SetBone("barrel")
				:SetPosition(Vector(-2.01, 0.1, 1))
				:SetAngle(Angle(180, 90, -90)),
		["weapon_lasersight"] =
			gRust.CreateAttachment(AttachmentType.Underbarrel)
				:SetModel("models/weapons/darky_m/rust/w_mod_laser.mdl")
				:SetBone("barrel")
				:SetPosition(Vector(2, 0.1, 11))
				:SetAngle(Angle(0, 0, 180))
				:SetScale(0.8),
}